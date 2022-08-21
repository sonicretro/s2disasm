#!/usr/bin/env lua

local clownmd5 = require "build_tools.lua.clownmd5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
assert(coroutine.resume(co))

-- Restore os.exit back to normal.
os.exit = os_exit

-- Hash the ROM.
local hash = clownmd5.HashFile("s2built.bin")

-- Verify the hash against known builds.
print "-------------------------------------------------------------"

if hash == "\x8E\x2C\x29\xA1\xE6\x51\x11\xFE\x20\x78\x35\x9E\x68\x5E\x79\x43" then
	print "ROM is bit-perfect with REV00."
elseif hash == "\x9F\xEE\xB7\x24\x05\x2C\x39\x98\x2D\x43\x2A\x78\x51\xC9\x8D\x3E" then
	print "ROM is bit-perfect with REV01."
elseif hash == "\x11\xD8\xD0\xD1\xD1\x19\xD9\xC7\x31\xBB\xF1\xF3\x03\x2F\xF0\x32" then
	print "ROM is bit-perfect with REV02 (speculative)."
else
	print "ROM is not bit-perfect with REV00, REV01, or REV02."
end
