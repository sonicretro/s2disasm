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
	common.handle_failure(message_printed, abort)
end

local function generate_music_data()
	-- Obtain the paths to the native build tools for the current platform.
	local tools, platform_directory = common.find_tools("build tool bundle", "build_tools/source_code/", repository, "saxman")

	-- Present an error message to the user if the build tools for their platform do not exist.
	if tools == nil then
		common.show_flashy_message("Build failed. See above for more details.")
		os.exit(false)
	end

	local compressed_song_list_filename = "sound/music/list of compressed songs.txt"

	-- Detemine which songs are going to be compressed.
	local compressed_songs = {}
	for song_name in io.lines(compressed_song_list_filename) do
		compressed_songs[song_name] = true
	end

	local custom_hashes = {
		improved_sound_driver_compression = improved_sound_driver_compression,
		music_buffer_address = music_buffer_address,
		music_buffer_size = music_buffer_size,
		compressed_song_list = common.clownmd5.HashFile(compressed_song_list_filename),
		smps2asm = common.clownmd5.HashFile("sound/_smps2asm_inc.asm")
	}

	for _, filename_stem in ipairs(common.get_directory_contents_changed("sound/music", ".asm", {".sax", ".inc"}, custom_hashes)) do
		local is_compressed = compressed_songs[filename_stem] == true

		local inc_file_path = "sound/music/generated/" .. filename_stem .. ".inc"

		-- Generate an '.inc' file for the song, which communicates to the assembler the song's file path as well as whether it is compressed or not.

		local include_file = io.open(inc_file_path, "w")

		if is_compressed then
			include_file:write(string.format(
[[
.is_compressed = TRUE
	binclude "sound/music/generated/%s.sax"
]], filename_stem))
		else
			include_file:write(string.format(
[[
.is_compressed = FALSE
	include "sound/music/%s.asm"
]], filename_stem))
		end

		include_file:close()

		-- If the song is compressed then compress it!
		if is_compressed then
			local asm_file_path = "sound/music/" .. filename_stem .. ".asm"
			local sax_file_path = "sound/music/generated/" .. filename_stem .. ".sax"

			print("Reassembling song '" .. filename_stem .. ".asm'...")

			-- To begin with, we'll create a wrapper ASM file to set the environment
			-- in which to assemble the lone song file. Notably, this environment
			-- includes SMPS2ASM and begins the song at address 0x1380 (the address
			-- of the Saxman decompression buffer in Z80 RAM).
			local song_file = io.open("song.asm", "w")

			song_file:write(string.format(
[[
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
	endif
]], music_buffer_address, filename_stem, music_buffer_size))

			song_file:close()

			-- Assemble the song to an uncompressed binary.
			local message_printed, abort = common.assemble_file("song.asm", "song.bin", "", "", false, repository)

			-- We can get rid of this wrapper ASM file now.
			os.remove("song.asm")

			common.handle_failure(message_printed, abort)

			-- Now that we have an assembled song binary, compress it.
			os.execute(tools.saxman .. " " .. (improved_sound_driver_compression and "" or "-a") .. " song.bin \"" .. sax_file_path .. "\"")

			-- Remove junk files from the assembly process.
			os.remove("song.lst")
			os.remove("song.bin")
		end
	end
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

----------------------
-- End of utilities --
----------------------

-------------------------------------
-- Actual build script begins here --
-------------------------------------

-- Compress music data and generate music-related assembler input.
generate_music_data()

-- Produce PCM and DPCM data.
common.convert_pcm_files_in_directory("sound/PCM")
common.convert_dpcm_files_in_directory("sound/DAC")

-- Build the ROM.
local compression = improved_sound_driver_compression and "saxman-optimised" or "saxman-bugged"
common.build_rom_and_handle_failure("s2", "s2built", "", "-p=FF -z=0," .. compression .. ",Size_of_Snd_driver_guess,after", true, repository)

-- Patch the ROM with the correct sound driver size.
amend_sound_driver_size()

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
-- KiS2: Commented-out because KiS2 doesn't have a ROM header.
--common.fix_header("s2built.bin")

-- A successful build; we can quit now.
common.exit()
