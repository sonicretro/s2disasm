#!/usr/bin/env lua

--------------
-- Settings --
--------------

-- Set this to true to use a better compression algorithm for the sound driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_sound_driver_compression = false

---------------------
-- End of settings --
---------------------

local common = require "build_tools.lua.common"

-- Obtain the paths to the native build tools for the current platform.
local tools, platform_directory = common.find_tools("s2p2bin", "fixpointer", "saxman")

-- Present an error message to the user if the build tools for their platform do not exist.
if not tools then
	print(string.format("\z
		Sorry, the build tools for your platform are outdated and need recompiling.\n\z
		\n\z
		You can find the source code in 'build_tools/source_code'.\n\z
		Once compiled, copy the executables to '%s'.\n\z
		\n\z
		We'd appreciate it if you could send us your executables in a pull request at\n\z
		https://github.com/sonicretro/s2disasm, so that other users don't have this\n\z
		problem in the future.", platform_directory))

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

-- Compress the songs.
-- The songs to compress are listed in 'list of compressed songs.txt'.
for song_name in io.lines("sound/music/compressed/list of compressed songs.txt") do
	-- Determine the hash of the current song.
	local current_hash = clownmd5.HashFile("sound/music/" .. song_name .. ".asm")

	-- Finally, check if the hash matches the one in 'hashes.lua'.
	-- If it doesn't match, then the song has been modified and needs to be reassembled.
	-- Alternatively, the song will need reassembling if the user has changed the compression.
	-- Or reassemble the song if the assembled version is missing.
	if current_hash ~= previous_hashes[song_name] or improved_sound_driver_compression ~= previous_hashes.improved_sound_driver_compression or not common.file_exists("sound/music/compressed/" .. song_name .. ".bin") then
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

SonicDriverVer = 2
	include "sound/_smps2asm_inc.asm"

	phase $1380
	include "sound/music/%s.asm"
	dephase

	if *>$7C0
		error "This song is too big and will overflow the decompression buffer! It should be uncompressed instead!"
	endif]], song_name))

		song_file:close()

		-- Assemble the song to an uncompressed binary.
		local assemble_result = common.assemble_file("song.asm", "song.bin", tools.as, "", tools.s2p2bin, improved_sound_driver_compression and "" or "-a", false)

		-- We can get rid of this wrapper ASM file now.
		os.remove("song.asm")

		if assemble_result == "crash" then
			print "\n\z
				**********************************************************************\n\z
				*                                                                    *\n\z
				*         The assembler crashed. See above for more details.         *\n\z
				*                                                                    *\n\z
				**********************************************************************\n\z"

			os.exit(false)
		elseif assemble_result == "error" then
			for line in io.lines("song.log") do
				print(line)
			end

			print "\n\z
				**********************************************************************\n\z
				*                                                                    *\n\z
				*       There were build errors. See song.log for more details.      *\n\z
				*                                                                    *\n\z
				**********************************************************************\n\z"

			os.exit(false)
		elseif assemble_result == "warning" then
			for line in io.lines("song.log") do
				print(line)
			end

			print "\n\z
				**********************************************************************\n\z
				*                                                                    *\n\z
				*      There were build warnings. See song.log for more details.     *\n\z
				*                                                                    *\n\z
				**********************************************************************\n\z"
		end

		-- Now that we have an assembled song binary, compress it.
		os.execute(tools.saxman .. " " .. (improved_sound_driver_compression and "" or "-a") .. " song.bin \"sound/music/compressed/" .. song_name .. ".bin\"")

		-- Remove junk files from the assembly process.
		os.remove("song.lst")
		os.remove("song.bin")
	end

	-- Write this hash to 'hashes.lua'.
	hashes_file:write("['" .. song_name .. "'] = '")

	local function hash_string_iterator()
		local position = 1

		return function()
				if position > current_hash:len() then
					return nil
				end

				local byte
				byte, position = string.unpack("I1", current_hash, position)

				return byte
			end
	end

	for byte in hash_string_iterator() do
		hashes_file:write(string.format("\\x%02X", byte))
	end

	hashes_file:write("',\n")
end

-- We've written the last part of the 'hashes.lua' file, so we can close it now.
hashes_file:close()

-- Huzzah: we are done with assembling and compressing the music.
-- We can move onto building the rest of the ROM.

-- Delete old ROM.
os.remove("s2built.prev.bin")

-- Backup the most recent ROM.
os.rename("s2built.bin", "s2built.prev.bin")

-- Assemble the ROM.
local assemble_result = common.assemble_file("s2.asm", "s2built.bin", tools.as, "", tools.s2p2bin, improved_sound_driver_compression and "" or "-a", true)

if assemble_result == "crash" then
	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*         The assembler crashed. See above for more details.         *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
elseif assemble_result == "error" then
	for line in io.lines("s2.log") do
		print(line)
	end

	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*        There were build errors. See s2.log for more details.       *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
end

-- Correct some pointers and other data that we couldn't until after the ROM had been assembled.
os.execute(tools.fixpointer .. " s2.h s2built.bin   off_3A294 MapRUnc_Sonic 0x2D 0 4   word_728C_user Obj5F_MapUnc_7240 2 2 1")

-- Remove the header file, since we no longer need it.
os.remove("s2.h")

-- Correct the ROM's header with a proper checksum and end-of-ROM value.
common.fix_header("s2built.bin")

if assemble_result == "warning" then
	for line in io.lines("s2.log") do
		print(line)
	end

	print "\n\z
		**********************************************************************\n\z
		*                                                                    *\n\z
		*       There were build warnings. See s2.log for more details.      *\n\z
		*                                                                    *\n\z
		**********************************************************************\n\z"

	os.exit(false)
end

-- A successful build; we can quit now.
