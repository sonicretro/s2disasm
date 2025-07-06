#!/usr/bin/env lua

--------------
-- Settings --
--------------

-- Set this to true to use a better compression algorithm for the sound driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_sound_driver_compression = false

-- These describe the Saxman decompression buffer in the sound driver.
local music_buffer_address = 0x1380 -- Should always match zMusicData in s2.sounddriver.asm.
local music_buffer_size = 0x7C0     -- Should always be zStack minus 0x40.

---------------------
-- End of settings --
---------------------

---------------
-- Utilities --
---------------

local common = require "build_tools.lua.common"

local repository = "https://github.com/sonicretro/s2disasm"

-- Just a shim for backwards-compatibility with things like Vladikcomper's debugger.
-- TODO: Remove this when nothing uses it any more.
local function message_abort_wrapper(message_printed, abort)
	common.handle_assembler_failure(message_printed, abort)
end

local function generate_music_data()
	-- Obtain the paths to the native build tools for the current platform.
	local tools, platform_directory = common.find_tools("build tool bundle", "build_tools/source_code/", repository, "saxman")

	-- Present an error message to the user if the build tools for their platform do not exist.
	if tools == nil then
		common.show_flashy_message("Build failed. See above for more details.")
		os.exit(false)
	end

	-- Begin the insane task of assembling and compressing Sonic 2's music...
	local clownmd5 = require "build_tools.lua.clownmd5"

	-- 'hashes.lua' contains the hashes of every assembled song. If a song's hash
	-- matches the one recorded in this file, then there is no need to assemble it again.
	-- Our first task is to load the hashes contained in this file into a table.
	local hashes_file

	hashes_file = io.open("sound/music/generated/hashes.lua", "r")

	local previous_hashes

	if not hashes_file then
		-- 'hashes.lua' does not exist: create an empty table instead.
		previous_hashes = {}
	else
		-- 'hashes.lua' does exist: turn it into a valid Lua chunk and load its data into the table.
		local chunk = load("return {" .. hashes_file:read("a") .. "}")
		hashes_file:close()

		-- If `hash.lua` fails to compile, then ignore it and load an empty table instead.
		previous_hashes = chunk and chunk() or {}
	end

	-- Now that that's done, we can begin re-writing 'hashes.lua' with the new hashes that we compute in the next step.
	hashes_file = io.open("sound/music/generated/hashes.lua", "w")

	hashes_file:write("improved_sound_driver_compression = " .. tostring(improved_sound_driver_compression) .. ",\n")
	hashes_file:write("music_buffer_address = " .. tostring(music_buffer_address) .. ",\n")
	hashes_file:write("music_buffer_size = " .. tostring(music_buffer_size) .. ",\n")

	local function record_file_hash(filename, identifier)
		local hash = clownmd5.HashFile(filename)

		-- Write this hash to 'hashes.lua'.
		hashes_file:write(identifier .. " = '")

		local function hash_string_iterator()
			local position = 1

			return function()
					if position > hash:len() then
						return nil
					end

					local byte
					byte, position = string.unpack("I1", hash, position)

					return byte
				end
		end

		for byte in hash_string_iterator() do
			hashes_file:write(string.format("\\x%02X", byte))
		end

		hashes_file:write("',\n")

		return hash
	end

	local compressed_song_list_filename = "sound/music/list of compressed songs.txt"
	local compressed_song_list_hash = record_file_hash(compressed_song_list_filename, "compressed_song_list")

	local smps2asm_hash = record_file_hash("sound/_smps2asm_inc.asm", "smps2asm")

	-- Detemine which songs are going to be compressed.
	local compressed_songs = {}
	for song_name in io.lines("sound/music/list of compressed songs.txt") do
		compressed_songs[song_name] = true
	end

	-- Iterate over every song.
	for _, filename_stem in common.iterate_directory("sound/music", ".asm") do
		local is_compressed = compressed_songs[filename_stem] == true

		local inc_file_path = "sound/music/generated/" .. filename_stem .. ".inc"

		-- Generate an '.inc' file for the song, which communicates to the assembler the song's file path as well as whether it is compressed or not.
		if compressed_song_list_hash ~= previous_hashes.compressed_song_list or not common.file_exists(inc_file_path) then

			local include_file = io.open(inc_file_path, "w")

			if is_compressed then
				include_file:write(string.format([[
.is_compressed = TRUE
	binclude "sound/music/generated/%s.sax"
	]], filename_stem))
			else
				include_file:write(string.format([[
.is_compressed = FALSE
	include "sound/music/%s.asm"
	]], filename_stem))
			end

			include_file:close()
		end

		-- If the song is compressed then compress it!
		if is_compressed then
			local asm_file_path = "sound/music/" .. filename_stem .. ".asm"
			local sax_file_path = "sound/music/generated/" .. filename_stem .. ".sax"

			-- Determine the hash of the current song.
			local current_hash = record_file_hash(asm_file_path, "['" .. filename_stem .. "']")

			-- Check if the hash matches the one in 'hashes.lua'.
			-- If it doesn't match, then the song has been modified and needs to be reassembled.
			-- Alternatively, the song will need reassembling if the user has changed the compression.
			-- Or reassemble the song if the compressed version is missing.
			if current_hash ~= previous_hashes[filename_stem]
				or smps2asm_hash ~= previous_hashes.smps2asm
				or improved_sound_driver_compression ~= previous_hashes.improved_sound_driver_compression
				or music_buffer_address ~= previous_hashes.music_buffer_address
				or music_buffer_size ~= previous_hashes.music_buffer_size
				or not common.file_exists(sax_file_path)
			then
				print("Reassembling song '" .. filename_stem .. ".asm'...")

				-- To begin with, we'll create a wrapper ASM file to set the environment
				-- in which to assemble the lone song file. Notably, this environment
				-- includes SMPS2ASM and begins the song at address 0x1380 (the address
				-- of the Saxman decompression buffer in Z80 RAM).
				local song_file = io.open("song.asm", "w")

				song_file:write(string.format([[
	CPU 68000
	padding off

z80_ptr function x,(x)<<8&$FF00|(x)>>8&$00FF

FixMusicAndSFXDataBugs = 0
SonicDriverVer = 2
	include "sound/_smps2asm_inc.asm"

	phase $%X
	include "sound/music/%s.asm"
	dephase

	if *>$%X
		error "This song is too big and will overflow the decompression buffer! It should be uncompressed instead!"
	endif]], music_buffer_address, filename_stem, music_buffer_size))

				song_file:close()

				-- Assemble the song to an uncompressed binary.
				local message_printed, abort = common.assemble_file("song.asm", "song.bin", "", "", false, repository)

				-- We can get rid of this wrapper ASM file now.
				os.remove("song.asm")

				common.handle_assembler_failure(message_printed, abort)

				-- Now that we have an assembled song binary, compress it.
				os.execute(tools.saxman .. " " .. (improved_sound_driver_compression and "" or "-a") .. " song.bin \"" .. sax_file_path .. "\"")

				-- Remove junk files from the assembly process.
				os.remove("song.lst")
				os.remove("song.bin")
			end
		end
	end

	-- We've written the last part of the 'hashes.lua' file, so we can close it now.
	hashes_file:close()
end

local function amend_sound_driver_size()
	-- Correct the compressed sound driver size, which we couldn't do until p2bin had been ran.
	local comp_z80_size, movewZ80CompSize

	for line in io.lines("s2.h") do
		local match_begin, match_end = string.find(line, "comp_z80_size")

		if match_begin ~= nil then
			comp_z80_size = tonumber(line:match("0x%x+", match_end))
		end

		local match_begin, match_end = string.find(line, "movewZ80CompSize")

		if match_begin ~= nil then
			movewZ80CompSize = tonumber(line:match("0x%x+", match_end))
		end
	end

	if comp_z80_size ~= nil and movewZ80CompSize ~= nil then
		local rom = io.open("s2built.bin", "r+b")

		rom:seek("set", movewZ80CompSize + 2)
		rom:write(string.pack(">I2", comp_z80_size))

		rom:close()
	end

	-- Remove the header file, since we no longer need it.
	os.remove("s2.h")
end

local function convert_wav_files()
	local function do_directory(directory, extension, callback)
		for _, filename_stem in common.iterate_directory(directory, ".wav") do
			local input_file_path = directory .. "/" .. filename_stem .. ".wav"
			local output_file_path = directory .. "/generated/" .. filename_stem .. extension
			local message = callback(input_file_path, output_file_path)

			if message then
				print("Failed to convert '" .. input_file_path .. "' to ''" .. output_file_path .. "'. Error message was:\n\t" .. message)
			end
		end
	end

	do_directory("sound/PCM", ".pcm", common.convert_pcm_file)
	do_directory("sound/DAC", ".dpcm", common.convert_dpcm_file)
end

----------------------
-- End of utilities --
----------------------

-------------------------------------
-- Actual build script begins here --
-------------------------------------

-- Compress music data and generate music-related assembler input.
generate_music_data()

-- Produce PCM and DPCM data.
convert_wav_files()

-- Build the ROM.
local compression = improved_sound_driver_compression and "saxman-optimised" or "saxman-bugged"
common.build_rom_and_handle_failure("s2", "s2built", "", "-p=0 -z=0," .. compression .. ",Size_of_Snd_driver_guess,after", true, repository)

-- Patch the ROM with the correct sound driver size.
amend_sound_driver_size()

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s2built.bin")

-- A successful build; we can quit now.
common.exit()
