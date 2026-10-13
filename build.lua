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

-- Builds the ROM with s2build, which runs macro-inliner, asm68k, rasm and
-- saxman: it generates the music data, assembles the 68k and Z80 code, patches
-- the sound driver size and fixes the header.
local function build_rom()
	local tools = common.find_tools("build tool bundle", "build_tools/source_code/", repository, "s2build", "asm68k", "rasm", "saxman")

	if tools == nil then
		common.show_flashy_message("Build failed. See above for more details.")
		os.exit(false)
	end

	-- Backup the most recent ROM.
	os.remove("s2built.prev.bin")
	os.rename("s2built.bin", "s2built.prev.bin")

	local result = os.execute(tools.s2build .. " --root . -o s2built.bin" ..
		" --asm68k " .. tools.asm68k .. " --rasm " .. tools.rasm .. " --saxman " .. tools.saxman ..
		" --music-buffer-address " .. music_buffer_address .. " --music-buffer-size " .. music_buffer_size ..
		(improved_sound_driver_compression and " --improved-sound-driver-compression" or ""))

	if result ~= true and result ~= 0 then
		common.show_flashy_message("Build failed. See above for more details.")
		os.exit(false)
	end
end

----------------------
-- End of utilities --
----------------------

-------------------------------------
-- Actual build script begins here --
-------------------------------------

-- Produce PCM and DPCM data.
common.convert_pcm_files_in_directory("sound/PCM")
common.convert_dpcm_files_in_directory("sound/DAC")

-- Build the ROM.
build_rom()

-- A successful build; we can quit now.
common.exit()
