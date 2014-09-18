--[[
----------------------------------------------------------------
MODULE FOR CORONA SDK
----------------------------------------------------------------
PRODUCT  :              MOBILE DEVELOPMENT ASSIGMENT
----------------------------------------------------------------
USAGE:
----------------------------------------------------------------

 
----------------------------------------------------------------
]]--


module(..., package.seeall)

local sqrt = math.sqrt
local strfmt = string.format

function newVec(x, y)
	return {
		x = x,
		y = y,
	}
end

function length(v)
	return sqrt((v.x * v.x) + (v.y * v.y))
end

function subtract(a, b)
	return {
		x = b.x - a.x,
		y = b.y - a.y,
	}
end

function add(a, b)
	return {
		x = a.x + b.x,
		y = a.y + b.y,
	}
end

function addTo(a, b)
	a.x = a.x + b.x
	a.y = a.y + b.y
end

function normalise(v)
	local length = sqrt((v.x * v.x) + (v.y * v.y))
	return {
		x = v.x / length,
		y = v.y / length,
	}
end

function multiply(a, size)
	return {
		x = a.x * size,
		y = a.y * size,
	}
end

function rotate(point, angle)
    
    return {
		x = point.x  * cos(angle) - point.y * sin(angle),
		y = point.x  * sin(angle) + point.y * cos(angle),
	}
           
end

function debugPrint(text, v)
	print(strfmt('%s: %.2f, %.2f', text, v.x, v.y))
end