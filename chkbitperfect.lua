#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
local _, exit_code = assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

if exit_code ~= false then
	-- Hash the ROM.
	local hash = clownmd5.HashFile("s2built.bin")

	-- Verify the hash against known builds.
	print "-------------------------------------------------------------"

	if hash == "\x3E\x5E\x4B\x18\xD0\x35\x77\x5B\x91\x6A\x06\xF2\xB3\xDC\x50\x31" then
		print "ROM is bit-perfect."
	else
		print "ROM is not bit-perfect."
	end
end
