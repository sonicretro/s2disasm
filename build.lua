#!/usr/bin/env lua

-- Set this to true to use a better compression algorithm for the sound driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_sound_driver_compression = false

local function file_exists(path)
	local file = io.open(path, "rb")
	
	if file then
		file:close()
		return true
	else
		return false
	end
end

-- Before we begin, let's detect our OS and set up our paths.
local os_name, arch_name = require "build_source.lua.get_os_name".get_os_name()

local platform_directory, as_path, p2bin_path, fixpointer_path

if os_name == "Windows" and (arch_name ~= "x86" or arch_name ~= "x86_64") then
	platform_directory = "win32"
	as_path = platform_directory .. "\\as\\asw.exe"
	p2bin_path = platform_directory .. "\\s2p2bin.exe"
	fixpointer_path = platform_directory .. "\\fixpointer.exe"
else
	platform_directory = "bin"
	as_path = "asl" -- Relies on AS being installled...
	p2bin_path = platform_directory .. "/s2p2bin"
	fixpointer_path = platform_directory .. "/fixpointer"

	if not file_exists(p2bin_path) or not file_exists(fixpointer_path) then
		-- Create the directory for the tools to go in.
		os.execute("mkdir " .. platform_directory)

		-- On non-Windows platforms, we compile our own tools.
		if not file_exists(p2bin_path) then
			print "Compiling s2p2bin..."
			os.execute("gcc -std=c99 -O2 -s -fno-ident -flto -o bin/s2p2bin build_source/s2p2bin/s2p2bin.c build_source/s2p2bin/lz_comp2/LZSS.c build_source/s2p2bin/clownlzss/common.c build_source/s2p2bin/clownlzss/memory_stream.c build_source/s2p2bin/clownlzss/saxman.c")

			if not file_exists(p2bin_path) then
				print "Failed to compile s2p2bin."
				return
			end
		end

		if not file_exists(fixpointer_path) then
			print "Compiling fixpointer..."
			os.execute("gcc -std=c99 -O2 -s -fno-ident -flto -o bin/fixpointer build_source/fixpointer.c")

			if not file_exists(fixpointer_path) then
				print "Failed to compile fixpointer."
				return
			end
		end
	end
end

-- Delete old ROM.
os.remove("s2built.prev.bin")

-- Backup the most recent ROM.
os.rename("s2built.bin", "s2built.prev.bin")

-- Delete object file, so that we can use its presence to detect a successful build.
os.remove("s2.p")

-- Remove this while we're at it.
os.remove("s2.h")

-- Assemble the ROM, producing an object file.
-- '-xx'  - shows the most detailed error output
-- '-c'   - outputs a shared file (s2.h)
-- '-q'   - shuts up AS
-- '-A'   - gives us a small speedup
-- '-U'   - forces case-sensitivity
-- '-E'   - output errors to a file (s2.log)
-- '-i .' - allows (b)include paths to be absolute
os.execute(as_path .. " -xx -c -n -q -A -L -U -E -i . s2.asm")

-- If the assembler encountered an error, then the object file will not exist.
if not file_exists("s2.p") then
	if not file_exists("s2.log") then
		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*         The assembler crashed. See above for more details.         *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
	else
		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*        There were build errors. See s2.log for more details.       *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
	end
else
	-- Convert the object file into a ROM.
	local p2bin_args = "-a"

	if improved_sound_driver_compression then
		p2bin_args = ""
	end

	os.execute(p2bin_path .. " " .. p2bin_args .. " s2.p s2built.bin s2.h")

	os.execute(fixpointer_path .. " s2.h s2built.bin   off_3A294 MapRUnc_Sonic $2D 0 4   word_728C_user Obj5F_MapUnc_7240 2 2 1")

	-- Correct the ROM's header with a proper checksum and end-of-ROM value.
	local rom = io.open("s2built.bin", "r+b")

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
			checksum = checksum + (string.unpack("I1", byte) << 8)
		end
	end

	-- Write the checksum to the ROM header.
	rom:seek("set", 0x18E)
	rom:write(string.pack(">I2", checksum & 0xFFFF))

	-- We're done editing the ROM header.
	rom:close()

	-- If we've gotten this far but a log file exists, then there must have been build warnings.
	if file_exists("s2.log") then
		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*       There were build warnings. See s2.log for more details.      *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
	else
		-- A successful build; we can quit now.
		return
	end
end

-- If we're on Windows, then keep the console window open so that the user can read the message that we're trying to show them.
if os_name == "Windows" then
	os.execute("pause")
end
