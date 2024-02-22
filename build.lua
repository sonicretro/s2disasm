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

local common = require "build_tools.lua.common"

local exit_code
local repository = "https://github.com/sonicretro/s2disasm"

local function message_abort_wrapper(message, abort)
	if message then
		exit_code = false
	end

	if abort then
		os.exit(exit_code, true)
	end
end

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

hashes_file = io.open("sound/music/compressed/hashes.lua", "r")

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
hashes_file = io.open("sound/music/compressed/hashes.lua", "w")

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

local smps2asm_hash = record_file_hash("sound/_smps2asm_inc.asm", "smps2asm")

-- Compress the songs.
-- The songs to compress are listed in 'list of compressed songs.txt'.
for song_name in io.lines("sound/music/list of compressed songs.txt") do
	-- Determine the hash of the current song.
	local current_hash = record_file_hash("sound/music/" .. song_name .. ".asm", "['" .. song_name .. "']")

	-- Finally, check if the hash matches the one in 'hashes.lua'.
	-- If it doesn't match, then the song has been modified and needs to be reassembled.
	-- Alternatively, the song will need reassembling if the user has changed the compression.
	-- Or reassemble the song if the assembled version is missing.
	if current_hash ~= previous_hashes[song_name]
		or smps2asm_hash ~= previous_hashes.smps2asm
		or improved_sound_driver_compression ~= previous_hashes.improved_sound_driver_compression
		or music_buffer_address ~= previous_hashes.music_buffer_address
		or music_buffer_size ~= previous_hashes.music_buffer_size
		or not common.file_exists("sound/music/compressed/" .. song_name .. ".sax") then
		print("Reassembling song '" .. song_name .. ".asm'...")

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
	endif]], music_buffer_address, song_name, music_buffer_size))

		song_file:close()

		-- Assemble the song to an uncompressed binary.
		local message, abort = common.assemble_file("song.asm", "song.bin", "", "", false, repository)

		-- We can get rid of this wrapper ASM file now.
		os.remove("song.asm")

		message_abort_wrapper(message, abort)

		-- Now that we have an assembled song binary, compress it.
		os.execute(tools.saxman .. " " .. (improved_sound_driver_compression and "" or "-a") .. " song.bin \"sound/music/compressed/" .. song_name .. ".sax\"")

		-- Remove junk files from the assembly process.
		os.remove("song.lst")
		os.remove("song.bin")
	end
end

-- We've written the last part of the 'hashes.lua' file, so we can close it now.
hashes_file:close()

-- Huzzah: we are done with assembling and compressing the music.
-- We can move onto building the rest of the ROM.

message_abort_wrapper(common.build_rom("s2", "s2built", "", "-p=0 -z=0," .. (improved_sound_driver_compression and "saxman-optimised" or "saxman-bugged") .. ",Size_of_Snd_driver_guess,after", true, repository))

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

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s2built.bin")

-- A successful build; we can quit now.
os.exit(exit_code, false)
