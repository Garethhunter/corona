
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



local vector = require('math.vector')

local mathmin = math.min
local mathmax = math.max
local radians = 180/math.pi 
local mPi = math.pi
local mS = math.sin
local mC = math.cos
local core = {}

function core.clamp1(v, min, max)
	return mathmax(mathmin(v, max), min)
end
function core.tprint1 (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
          print(formatting)
          core.tprint(v, indent+1)
        elseif type(v) == 'boolean' then
          print(formatting .. tostring(v))      
        else
          print(formatting .. v)
        end
  end
end

function core.printf(s,...)
    return io.write(s:format(...))
end -- function

function core.distanceBetweenPoints( pos1, pos2 )
    local sqrt = math.sqrt
    if not pos1 or not pos2 then
            return
    end
    if not pos1.x or not pos1.y or not pos2.x or not pos2.y then
            return
    end
    return core.distanceBetweenCoords( pos1.x , pos1.y ,  pos2.x , pos2.y   )
end

function core.distanceBetweenCoords( pos1x , pos1y, pos2x , pos2y )
    local sqrt = math.sqrt
    local factor = { x = pos2x - pos1x, y = pos2y - pos1y }
    return sqrt( ( factor.x * factor.x ) + ( factor.y * factor.y ) )
end

function core.distanceBetweenObjects( objectA , objectB )
    local sqrt = math.sqrt
    local factor = { x = objectB.x - objectA.x, y = objectB.y - objectA.y }
    return sqrt( ( factor.x * factor.x ) + ( factor.y * factor.y ) )
end

function core.fireEnemyBullets(pFromLocX, pFromLocY , ptoLocX , ptoLocY)
    local ebullet = display.newCircle( 1, 1, 5 )
    ebullet.x = pFromLocX      ebullet.y =pFromLocY 
    ebullet.myName = "enemyb" ebullet.collisionpower = 20    ebullet.points = 0  ebullet.health = 1  
    physics.addBody(ebullet , "dynamic", {isSensor = true ,friction = 0, bounce = 0, density = 0,})
    local distance = 300
    local distanceX = ptoLocX - pFromLocX
    local distanceY = ptoLocY - pFromLocY
    local distanceTotal = core.distanceBetweenCoords (pFromLocX , pFromLocY , ptoLocX , ptoLocY )
    local moveDistanceX =  distanceX / distanceTotal;
    local moveDistanceY =  distanceY / distanceTotal;
    local px = pFromLocX + moveDistanceX * (distanceTotal + distance)
    local py = pFromLocY + moveDistanceY * (distanceTotal + distance)
    local pos = vector.newVec(px,py)
    transition.moveTo( ebullet, { x=pos.x, y=pos.y, time=4000 , } )
end  
 
 --taken from http://developer.coronalabs.com/code/follow-object
function core.doFollow(follower, targetObject, missileSpeed, turnRate, doRotate, runAway)
 
      
        local missileSpeed = missileSpeed or 8
        local turnRate = turnRate or 0.8
        -- get distance between follower and target
        local target = targetObject
        local distanceX = target.object.x - follower.x;
        local distanceY = target.object.y - follower.y;
        -- get total distance as one number
        local distanceTotal = core.distanceBetweenObjects (follower, target.object)
           -- calculate how much to move
         local moveDistanceX = turnRate * distanceX / distanceTotal;
         local moveDistanceY = turnRate * distanceY / distanceTotal;
         -- increase current speed
        follower.moveX = follower.moveX + moveDistanceX; 
        follower.moveY = follower.moveY + moveDistanceY;
         -- get total move distance
        local totalmove = math.sqrt(follower.moveX * follower.moveX + follower.moveY * follower.moveY);
        -- apply easing
        follower.moveX = missileSpeed*follower.moveX/totalmove;
        follower.moveY = missileSpeed*follower.moveY/totalmove;
        -- move follower (or runner)
        if runAway then
                follower.object.x = follower.object.x - follower.moveX;
                follower.object.y = follower.object.y - follower.moveY;
                if doRotate == true then
                  follower.object.rotation = math.atan2(follower.moveY, follower.xMove) * radians;
                end
        else
                follower.x = follower.x + follower.moveX;
                follower.y = follower.y + follower.moveY;
                if doRotate == true then
                  follower.rotation = (math.atan2(follower.moveY, follower.moveX) * radians)+180;
                end
        end
 
        -- !!!!! you got to check if we hit the target - here or in main game logic !!!!!
end

--function taken from http://forums.coronalabs.com/topic/26588-moving-an-object-in-a-circular-and-along-a-curved-path/
function core.makeCircle( startPointXY, endPointXY, degreesStart, degreesEnd, yScale, xScale, value)
	local xy = {} --Holds the points we make.
	local distance = endPointXY[1] - startPointXY[1] --The radius

	--Sets the scales if needed.
	if yScale == nil then yScale = 1 end
	if xScale == nil then xScale = 1 end
	if value == nil then value = 2 end

	--Changes the direction of the path if needed.
	if degreesEnd < degreesStart then 
		value = -value 
	end

	--Now create the circlular path!
	local i 
	for i=degreesStart, degreesEnd, value do
		local radians = i*(mPi/180)
		local x = (endPointXY[1] + ( distance * mS( radians ) )*xScale) 
		local y = (endPointXY[2] + ( distance * mC( radians ) )*yScale) 
		xy[#xy+1] = {x, y}

		--Display a circle to show you the path your making.
		--local circle = display.newCircle(0,0,1)
		--circle.x = x; circle.y = y; circle:setFillColor(255,60,60)	
	end

	--Return the array.
	return xy
end

return core
