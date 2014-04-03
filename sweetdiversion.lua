--[[--------------------------------
-- "Sweet Diversion"
-- Copyright (c) 2014 Mark "Klowner" Riedesel
--]]--------------------------------

local sweetdiversion = {}
local _love_version
local _version_conditions = {}

function sweetdiversion.GetLoveVersion()
	local getVersion = love.getVersion
	local version = _love_version

	if version then
		return unpack(version)
	end

	if getVersion then
		version = {getVersion()}
	else
		version = {}
		for v, _ in string.gmatch(love._version, "(%d+)") do
			table.insert(version, tonumber(v))
		end
	end

	_love_version = version -- cache result
	return unpack(version)
end

function sweetdiversion.LoveVersionIs(expr)
	local cache = _version_conditions
	local match = cache[expr]

	if match ~= nil then
		return match
	end

	local curr_version_t = {sweetdiversion.GetLoveVersion()}
	local op = string.sub(expr, 0, 1)
	local comparitor

	if op == '>' or op == '<' then
		if op == '>' then
			comparitor = function (a,b) return a == b and 0 or a > b and 1 or -1 end
		else
			comparitor = function (a,b) return a == b and 0 or a < b and 1 or -1 end
		end
	else
		comparitor = function (a,b) return ('*' == b or a == b) and 1 or -16 end
	end

	-- split version from expression into numeric parts
	local expr_version_t = {}
	for v, _ in string.gmatch(expr, "([%d*x]+)") do
		table.insert(expr_version_t, tonumber(v) or '*')
	end

	local result = 0
	for i = 1, #expr_version_t do
		result = result + comparitor(curr_version_t[i], expr_version_t[i]) * (2^(#expr_version_t-i))
	end

	result = result > 0
	cache[expr] = result
	return result
end

-- syntactic sugar, so you can use `if sweetdiversion('0.9.*') then...'
setmetatable(sweetdiversion, {
	__call = function (cls, expr) return cls.LoveVersionIs(expr) end
})

return sweetdiversion
