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

local md5 = require "build_tools.Lua.md5"

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
local os_name, arch_name = require "build_tools.Lua.get_os_name".get_os_name()

local platform_directory, as_path, p2bin_path, fixpointer_path

platform_directory = "build_tools"

if os_name == "Windows" and (arch_name == "x86" or arch_name == "x86_64") then
	platform_directory = platform_directory .. "\\Win32"
	as_path = platform_directory .. "\\asw.exe"
	p2bin_path = platform_directory .. "\\s2p2bin.exe"
	fixpointer_path = platform_directory .. "\\fixpointer.exe"
	saxman_path = platform_directory .. "\\saxman.exe"
elseif os_name == "Mac" then
	platform_directory = platform_directory .. "/Osx"
	as_path = platform_directory .. "/asl"
	p2bin_path = platform_directory .. "/s2p2bin"
	fixpointer_path = platform_directory .. "/fixpointer"
	saxman_path = platform_directory .. "/saxman"
elseif os_name == "Linux" then
	if arch_name == "x86" then
		platform_directory = platform_directory .. "/Linux32"
	elseif arch_name == "x86_64" then
		platform_directory = platform_directory .. "/Linux"
	end

	as_path = platform_directory .. "/asl"
	p2bin_path = platform_directory .. "/s2p2bin"
	fixpointer_path = platform_directory .. "/fixpointer"
	saxman_path = platform_directory .. "/saxman"
else
	print "Build failed: Your OS is unsupported."
	os.exit(false)
end

if arch_name ~= "x86" and arch_name ~= "x86_64" then
	print "Build failed: Your CPU architecture is unsupported."
	os.exit(false)
end

if not file_exists(p2bin_path) or not file_exists(fixpointer_path) or not file_exists(saxman_path) then
	print(string.format("\z
		Sorry, the build tools for your platform is outdated and needs recompiling.\n\z
		\n\z
		You can find the source code in 'build_tools/source_code'.\n\z
		Once compiled, copy the executables to '%s'.\n\z
		\n\z
		We'd appreciate it if you could send us your executables in a pull request at\n\z
		https://github.com/sonicretro/s2disasm, so other users don't have this problem\n\z
		in the future.", platform_directory))

	os.exit(false)
end

-- Begin the insane task of assembling and compressing Sonic 2's music...

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
	previous_hashes = assert(load("return {" .. hashes_file:read("a") .. "}"))()

	hashes_file:close()
end

-- Now that that's done, we can begin re-writing 'hashes.lua' with the new hashes that we compute in the next step.
hashes_file = io.open("sound/music/compressed/hashes.lua", "w")

-- Compress the songs.
-- The songs to compress are listed in 'list of compressed songs.txt'.
for song_name in io.lines("sound/music/compressed/list of compressed songs.txt") do
	-- Determine the hash of the current song.
	local current_hash = md5.HashFile("sound/music/" .. song_name .. ".asm")

	-- Write this hash to 'hashes.lua'.
	hashes_file:write("['" .. song_name .. "'] = '" .. current_hash .. "',\n")

	-- Finally, check if the hash matches the one in 'hashes.lua'.
	if current_hash ~= previous_hashes[song_name] then
		-- The file has been modified, so reassemble it.
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
	dephase]], song_name))

		song_file:close()

		-- Now assemble this ASM file to assemble the song.
		os.execute(as_path .. " -xx -n -q -A -L -U -E -i . song.asm")

		-- We can get rid of this wrapper ASM file now.
		os.remove("song.asm")

		-- If the assembler encountered an error, then the object file will not exist.
		if not file_exists("song.p") then
			if not file_exists("song.log") then
				print "\n\z
					**********************************************************************\n\z
					*                                                                    *\n\z
					*         The assembler crashed. See above for more details.         *\n\z
					*                                                                    *\n\z
					**********************************************************************\n\z"
			else
				for line in io.lines("song.log") do
					print(line)
				end

				print "\n\z
					**********************************************************************\n\z
					*                                                                    *\n\z
					*       There were build errors. See song.log for more details.      *\n\z
					*                                                                    *\n\z
					**********************************************************************\n\z"
			end

			os.exit(false)
		end

		-- Produce the raw song binary from the object file.
		os.execute(p2bin_path .. " song.p song.bin")

		-- Now that we have an assembled song binary, compress it.
		local saxman_args = improved_sound_driver_compression and "" or "-a"

		os.execute(saxman_path .. " " .. saxman_args .. " song.bin \"sound/music/compressed/" .. song_name .. ".bin\"")

		-- Remove junk files from the assembly process.
		os.remove("song.p")
		os.remove("song.lst")
		os.remove("song.bin")
	end
end

-- We've written the last part of the 'hashes.lua' file, so we can close it now.
hashes_file:close()

-- Huzzah: we are done with assembling and compressing the music.
-- We can move onto building the rest of the ROM.

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
		for line in io.lines("s2.log") do
			print(line)
		end

		print "\n\z
			**********************************************************************\n\z
			*                                                                    *\n\z
			*        There were build errors. See s2.log for more details.       *\n\z
			*                                                                    *\n\z
			**********************************************************************\n\z"
	end

	os.exit(false)
end

-- Convert the object file into a ROM.
local p2bin_args = improved_sound_driver_compression and "" or "-a"

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
