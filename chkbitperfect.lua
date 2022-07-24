#!/usr/bin/env lua

local md5 = require "build_tools.Lua.md5"

-- Prevent build.lua's calls to os.exit from terminating the program.
local os_exit = os.exit
os.exit = coroutine.yield

-- Build the ROM.
local co = coroutine.create(function() dofile("build.lua") end)
coroutine.resume(co)

-- Hash the ROM.
local hash = md5.HashFile("s2built.bin")

-- Verify the hash against known builds.
print "-------------------------------------------------------------"

if hash == "8E2C29A1E65111FE2078359E685E7943" then
	print "ROM is bit-perfect with REV00."
elseif hash == "9FEEB724052C39982D432A7851C98D3E" then
	print "ROM is bit-perfect with REV01."
elseif hash == "11D8D0D1D119D9C731BBF1F3032FF032" then
	print "ROM is bit-perfect with REV02 (speculative)."
else
	print "ROM is not bit-perfect with REV00, REV01, or REV02."
end
