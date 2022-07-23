#!/usr/bin/env lua

local md5 = require "build_tools.Lua.md5"

-- Build the ROM.
dofile("build.lua")

-- Create MD5 hasher.
local md5_hasher = md5.new()

-- Hash the ROM.
local rom = io.open("s2built.bin", "rb")

local hash

repeat
	local block_string = rom:read(64)

	if block_string == nil then
		bytes = 0
	else
		bytes = block_string:len()
	end

	if bytes == 64 then
		md5_hasher.PushData(block_string) -- All 64 bytes
	else
		hash = md5_hasher.PushFinalData(block_string, bytes * 8) -- 63 or fewer bytes
	end
until bytes ~= 64

rom:close()

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
