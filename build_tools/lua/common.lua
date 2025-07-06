local common = {}

local os_name, arch_name = require "build_tools.lua.get_os_name".get_os_name()

-----------------------
-- General Utilities --
-----------------------

local function is_windows()
	return os_name == "Windows"
end

local function exit(release)
	os.exit(common.exit_code, release)
end

local function get_split_filename(filename)
	local index = filename:find(".", 1, true)

	if index == nil then
		return filename
	end

	return filename:sub(1, index - 1), filename:sub(index)
end

-- Determine if a file exists.
local function file_exists(path)
	local file = io.open(path, "rb")

	if file then
		file:close()
		return true
	else
		return false
	end
end

local function get_directory_contents(path)
	local listing

	if is_windows() then
		listing = io.popen("dir /b \"" .. path .. "\"", "r")
	else
		-- Assumes POSIX.
		listing = io.popen("ls -w1 -N " .. path, "r")
	end

	local contents = {}
	for entry in listing:lines() do
		contents[1 + #contents] = entry
	end

	return contents
end

local function iterate_directory(path, extension)
	local contents = get_directory_contents(path)

	if extension == nil then
		return ipairs(contents)
	end

	-- Collect the entries that match the given file extension.
	local filtered_contents = {}

	for key, filename in ipairs(contents) do
		local filename_stem, filename_extension = get_split_filename(filename)

		if filename_extension == extension then
			filtered_contents[1 + #filtered_contents] = filename_stem
		end
	end

	return ipairs(filtered_contents)
end

local function show_flashy_message(message)
	local width = 70

	local function do_full_line()
		local line = ""

		for _ = 1, width do
			line = line .. "*"
		end

		return line .. "\n"
	end

	local function do_empty_line()
		local line = "*"

		for _ = 1 + 1, width - 1 do
			line = line .. " "
		end

		return line .. "*\n"
	end

	local function do_message_line()
		local left_padding = (width - 2 - #message) // 2
		local right_padding = width - 2 - #message - left_padding

		if left_padding < 0 then
			left_padding = 0
		end

		if right_padding < 0 then
			right_padding = 0
		end

		local line = "*"

		for _ = 1, left_padding do
			line = line .. " "
		end

		line = line .. message

		for _ = 1, right_padding do
			line = line .. " "
		end

		return line .. "*\n"
	end

	print("\n" .. do_full_line() .. do_empty_line() .. do_message_line() .. do_empty_line() .. do_full_line())
end

-----------
-- Tools --
-----------

local function get_platform_specific_info()
	local path_separator, executable_suffix, as_filename, executable_arch

	if is_windows() then
		-- 64-bit x86 Windows can run 32-bit x86 executables.
		executable_arch = arch_name == "x86_64" and "x86" or arch_name
		path_separator = "\\"
		executable_suffix = ".exe"
		as_filename = "asw"
	else
		executable_arch = arch_name
		path_separator = "/"
		executable_suffix = ""
		as_filename = "asl"
	end

	-- Determine the platform directory.
	local platform_directory = "build_tools" .. path_separator .. os_name .. "-" .. executable_arch .. path_separator

	-- Return the list of tools.
	return platform_directory, executable_suffix, as_filename
end

local platform_directory_cached, executable_suffix_cached, as_filename_cached

local function get_platform_specific_info_memoised()
	if platform_directory_cached ~= nil then
		return platform_directory_cached, executable_suffix_cached, as_filename_cached
	end

	platform_directory_cached, executable_suffix_cached, as_filename_cached = get_platform_specific_info()

	return platform_directory_cached, executable_suffix_cached, as_filename_cached
end

local tools_cached = {}

-- Returns a table containing paths to the specified native tools.
-- Returns nil if the tools could not be found for the current platform.
local function find_tools(name, source_repo, pull_repo, ...)
	local platform_directory, executable_suffix = get_platform_specific_info_memoised()

	local tools = {}
	local tools_missing = false

	-- Create the paths to the specified tools.
	for _, tool_name in ipairs{...} do
		if tools_cached[tool_name] == nil then
			local tool_path = platform_directory .. tool_name .. executable_suffix

			if not file_exists(tool_path) then
				-- Tool could not be found.
				print("Could not find '" .. tool_path .. "'.")
				tools_missing = true
			else
				tools_cached[tool_name] = tool_path
			end
		end

		tools[tool_name] = tools_cached[tool_name]
	end

	if tools_missing then
		print("\n\z
			Sorry, the " .. name .. " for your platform is outdated and needs recompiling.\n\z
			\n\z
			You can find the source code at '" .. source_repo .. "'.\n\z
			Once compiled, copy the executable(s) to '" .. platform_directory .. "'.\n\z
			\n\z
			We'd appreciate it if you could send us your executables in a pull request at\n\z
			'" .. pull_repo .. "', so that other users don't have this\n\z
			problem in the future.")

		return nil
	end

	-- Return the list of tools.
	return tools
end

local function find_assembler(repository)
	local _, _, as_filename = get_platform_specific_info_memoised()
	local tools = find_tools("assembler", "https://github.com/flamewing/asl-releases", repository, as_filename)

	if tools == nil then
		return nil
	end

	return tools[as_filename]
end

--------------------
-- PCM Processing --
--------------------

local function read_wrapper(file, format, bytes)
	local data = file:read(bytes)

	if data then
		return string.unpack(format, data)
	end
end

local function read_s8(file)
	return read_wrapper(file, "i1", 1)
end

local function read_s16le(file)
	return read_wrapper(file, "<i2", 2)
end

local function read_s32le(file)
	return read_wrapper(file, "<i4", 4)
end

local function read_u8(file)
	return read_wrapper(file, "I1", 1)
end

local function read_u16le(file)
	return read_wrapper(file, "<I2", 2)
end

local function read_u32le(file)
	return read_wrapper(file, "<I4", 4)
end

local function process_wav_file(input_file_path, callback)
	local message

	local input_file = io.open(input_file_path, "rb")

	if input_file == nil then
		message = "Could not open input file '" .. input_file_path .. "'!"
	else
		local function read_chunk_header(file)
			local id = input_file:read(4)
			local size = read_u32le(input_file)

			if id and size then
				return id, size
			end
		end

		local fourcc, file_size = read_chunk_header(input_file)
		local format = input_file:read(4)

		if fourcc ~= "RIFF" then
			message = "FOURCC check failed; this is not a WAV file!"
		elseif format ~= "WAVE" then
			message = "RIFF format check failed; this is not a WAV file!"
		else
			local function chunk_size_check(name, size, expected_size)
				if size < expected_size then
					message = name .. " chunk was smaller than expected (" .. size .. " instead of " .. expected_size .. ")!"
				else
					return true
				end
			end

			local channels = 1

			for chunk_id, chunk_size in function() return read_chunk_header(input_file) end do
				local starting_position = input_file:seek()

				if chunk_id == "fmt " then
					if chunk_size_check("Format", chunk_size, 16) then
						local format = read_u16le(input_file)
						channels = read_u16le(input_file)
						local sample_rate = read_u32le(input_file)
						local bytes_per_second = read_u32le(input_file)
						local bytes_per_block = read_u16le(input_file)
						local bits_per_sample = read_u16le(input_file)

						if format ~= 1 then
							message = "Unsupported sample format '" .. format .. "' (only '1' is supported)!"
						end

						-- TODO: We can downsample!
						if bits_per_sample ~= 8 then
							message = "Unsupported bit depth '" .. bits_per_sample .. "' (only '8' is supported)!"
						end
					end
				elseif chunk_id == "data" then
					for _ = 1, chunk_size, channels do
						-- Downsample to mono by averaging the samples.
						local accumulator = 0
						for _ = 1, channels do
							accumulator = accumulator + read_u8(input_file)
						end
						accumulator = accumulator // channels

						-- Output the mono sample.
						callback(accumulator)
					end
				end

				-- Advance past the chunk.
				input_file:seek("set", starting_position + chunk_size)
			end
		end

		input_file:close()
	end

	return message
end

local function convert_pcm_file(input_file_path, output_file_path)
	local message

	local output_file = io.open(output_file_path, "wb")

	if output_file == nil then
		message = "Could not open output file '" .. output_file_path .. "'!"
	else
		local function callback(sample)
			output_file:write(string.pack("I1", sample))
		end

		message = process_wav_file(input_file_path, callback)
		output_file:close()
	end

	return message
end

local function convert_dpcm_file(input_file_path, output_file_path)
	local message

	local deltas = {
		0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40,
		0x80, 0xFF, 0xFE, 0xFC, 0xF8, 0xF0, 0xE0, 0xC0
	}

	local function find_closet_delta(value)
		local best_error = math.huge
		local best_index

		for delta_index, delta in ipairs(deltas) do
			local error = math.abs(delta - value)
			if best_error > error then
				best_error = error
				best_index = delta_index
			end
		end

		return best_index
	end

	local previous_sample = 0x80

	local output_file = io.open(output_file_path, "wb")

	if output_file == nil then
		message = "Could not open output file '" .. output_file_path .. "'!"
	else
		local accumulator = 0
		local flip_flip = false

		local function callback(sample)
			local index = find_closet_delta((sample - previous_sample) & 0xFF)

			previous_sample = previous_sample + deltas[index]

			accumulator = accumulator & 0xF
			accumulator = accumulator << 4
			accumulator = accumulator | (index - 1)

			if flip_flip == true then
				output_file:write(string.pack("I1", accumulator))
			end

			flip_flip = not flip_flip
		end

		message = process_wav_file(input_file_path, callback)
		output_file:close()
	end

	return message
end

------------------
-- ROM Patching --
------------------

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
local function fix_header(filename)
	local rom = io.open(filename, "r+b")

	-- Obtain the end-of-ROM value.
	local rom_end = rom:seek("end", 0) - 1

	-- Write the end-of-ROM value to the ROM header.
	rom:seek("set", 0x1A4)
	rom:write(string.pack(">I4", rom_end))

	-- Calculate the checksum.
	local checksum = 0
	rom:seek("set", 0x200)
	for bytes in function() return rom:read(2) end do
		if bytes:len() == 2 then
			checksum = checksum + string.unpack(">I2", bytes)
		else
			checksum = checksum + (string.unpack("I1", bytes) << 8)
		end
	end

	-- Write the checksum to the ROM header.
	rom:seek("set", 0x18E)
	rom:write(string.pack(">I2", checksum & 0xFFFF))

	-- We're done editing the ROM header.
	rom:close()
end

----------------
-- Assembling --
----------------

local function handle_assembler_failure(message_printed, abort)
	if message_printed then
		common.exit_code = false
	end

	if abort then
		exit(true)
	end
end

local function assemble_file_and_handle_failure(...)
	handle_assembler_failure(assemble_file(...))
end

-- Produce a binary from an assembly file.
-- Returns two booleans: the first indicating whether the build was entirely successful,
-- and the second indicating whether the build process should continue or not.
local function assemble_file(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
	local function assemble_file_inner(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
		-- Obtain the paths to the native build tools for the current platform.
		local tools = find_tools("'p2bin' tool", "https://github.com/Clownacy/p2bin", repository, "p2bin")

		if tools == nil then
			return "failure"
		end

		tools.as = find_assembler(repository)

		if tools.as == nil then
			return "failure"
		end

		-- As substitutes everything after the first period.
		local input_filename_before_first_period = string.match(input_filename, "(.-)%.")

		local object_filename = input_filename_before_first_period .. ".p"
		local header_filename = input_filename_before_first_period .. ".h"
		local log_filename = input_filename_before_first_period .. ".log"

		-- Delete the object file, so that we can use its presence to detect a successful build later on.
		os.remove(object_filename)

		-- Assemble the ROM, producing an object file.
		-- '-xx'  - shows the most detailed error output
		-- '-q'   - shuts up AS
		-- '-A'   - gives us a small speedup
		-- '-U'   - forces case-sensitivity
		-- '-E'   - output errors to a file (*.log)
		-- '-i .' - allows (b)include paths to be absolute
		-- '-c'   - outputs a shared file (*.h)
		os.execute(tools.as .. " -xx -n -q -A -L -U -E -i . " .. (create_header_file and "-c" or "") .. " " .. as_arguments .. " " .. input_filename)

		-- If the assembler encountered an error, then the object file will not exist.
		if not file_exists(object_filename) then
			if not file_exists(log_filename) then
				return "crash"
			else
				return "error", log_filename
			end
		end

		-- Convert the object file to a flat binary.
		os.execute(tools.p2bin .. " " .. p2bin_arguments .. " " .. object_filename .. " " .. output_filename .. " " .. (create_header_file and header_filename or ""))

		-- Remove the object file, since we no longer need it.
		os.remove(object_filename)

		if not file_exists(output_filename) then
			return "failure"
		elseif file_exists(log_filename) then
			return "warning", log_filename
		end
	end

	local result, log_filename = assemble_file_inner(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)

	if log_filename ~= nil then
		for line in io.lines(log_filename) do
			print(line)
		end
	end

	if result == "failure" then
		show_flashy_message("Build failed. See above for more details.")
		return true, true -- Error message, abort.
	elseif result == "crash" then
		show_flashy_message("The assembler crashed. See above for more details.")
		return true, true -- Error message, abort.
	elseif result == "error" then
		show_flashy_message("There were build errors. See " .. log_filename .. " for more details.")
		return true, true -- Error message, abort.
	elseif result == "warning" then
		show_flashy_message("There were build warnings. See " .. log_filename .. " for more details.")
		return true, false -- Warning message, continue.
	else
		return false, false -- No message, continue.
	end
end

local function build_rom(input_filename, output_filename, as_arguments, p2bin_arguments, create_header_file, repository)
	-- Delete old ROM.
	os.remove(output_filename .. ".prev.bin")

	-- Backup the most recent ROM.
	os.rename(output_filename .. ".bin", output_filename .. ".prev.bin")

	local log_filename = input_filename .. ".log"

	-- Assemble the ROM.
	return assemble_file(input_filename .. ".asm", output_filename .. ".bin", as_arguments, p2bin_arguments, create_header_file, repository)
end

local function build_rom_and_handle_failure(...)
	handle_assembler_failure(build_rom(...))
end

------------
-- Export --
------------

common.exit = exit
common.get_directory_contents = get_directory_contents
common.iterate_directory = iterate_directory
common.get_split_filename = get_split_filename
common.file_exists = file_exists
common.show_flashy_message = show_flashy_message
common.find_tools = find_tools
common.convert_pcm_file = convert_pcm_file
common.convert_dpcm_file = convert_dpcm_file
common.fix_header = fix_header
common.handle_assembler_failure = handle_assembler_failure
common.assemble_file = assemble_file
common.assemble_file_and_handle_failure = assemble_file_and_handle_failure
common.build_rom = build_rom
common.build_rom_and_handle_failure = build_rom_and_handle_failure
return common
