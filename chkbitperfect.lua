#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
local _, _, abort = assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

if not abort then
	-- Hash the ROM.
	local hash = clownmd5.HashFile("s2built.bin")

	-- Verify the hash against known builds.
	print "-------------------------------------------------------------"

	if hash == "\xB4\xE7\x6E\x41\x6B\x88\x7F\x4E\x74\x13\xBA\x76\xFA\x73\x5F\x16" then
		print "ROM is bit-perfect."
	else
		print "ROM is not bit-perfect."
	end
end
