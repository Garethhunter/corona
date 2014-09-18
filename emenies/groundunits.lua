--[[
----------------------------------------------------------------
GROUND EMENYS MODULE FOR CORONA SDK
----------------------------------------------------------------
PRODUCT  :            MOBILE DEVELOPMENT ASSIGMENT
----------------------------------------------------------------
USAGE:
----------------------------------------------------------------
1.  INCLUDE THE MODULE:
        ememies = require("emenies.ground2")
 
2.  CREATE A emem  
      local groundE = groundEmemys.new()

3.  init
    function groundE:initialise(params)
    params
      maxEmemys = [params.maxEmemys ]
      fileName  = 
    
       
 
3.  TO update  OBJECTS:  
         groundE:update(event , x , y )
        
4.  REMOVE dead object 
        groundE:Remove()
5.  REMOVE  all objects
        groundE:free()
        groundE = nil
 
----------------------------------------------------------------
]]--

local tablex = require ("tools.tablex")
local core = require('core.core')
local vector = require('math.vector')
local radians = 180/math.pi  --> precalculate radians


local groundEmemys = {}

function groundEmemys.new()
    groundEmemys.displayGroup = display.newGroup()
    groundEmemys.AllgroundEmemys = {}
    groundEmemys.lastfireTime = 0 
    return groundEmemys
end


function groundEmemys:initialise(params)
    local groundImage = params.groundImage
    local health = params.health
    local points = params.points
    local collisionpower = params.collisionpower
    local rotate = params.rotate
    local maxUnits = params.maxUnits
    local xLoc = params.x
    local spacing = params.spacing
    local yLoc = params.y
    local ememies = self.AllgroundEmemys
    local displayGroup = self.displayGroup
    --self.power = params.power
    self.lazerInfo = params.lazerinfo
   
    for s = 1, maxUnits do
        local cannon = display.newImage( displayGroup , groundImage)
        cannon.myName= "cannon"       cannon.myName = "enemy"
        cannon.points = points       cannon.x =xLoc + (spacing * s)
        cannon.y= yLoc 
        cannon:rotate(rotate)
        cannon.health = health
        cannon.collisionpower = collisionpower
        physics.addBody(cannon , "static", {friction = 0, bounce = 0, density = 1, filter = { categoryBits = 1, maskBits = 3 } })
        table.insert(ememies, cannon)
    end
    self.mineCount = tablex.icount(ememies)
 end

function groundEmemys:GetCount()
    return #self.AllgroundEmemys
end

function groundEmemys:fireRamdomBullets(plocationx, plocationy, sec)
    local ememies = self.AllgroundEmemys
    local mineCount = tablex.icount(ememies)
    --local powerB = self.power
    local lazerinfoParams=self.lazerInfo
    
    if (mineCount > 0) then 
        local cannonToFire =  math.random(1,  mineCount )    
        local object = ememies[cannonToFire]
           if (object.x) then
               
                local Sheet = graphics.newImageSheet(lazerinfoParams.imageSheet, lazerinfoParams.options )
                local ebullet= display.newImage(Sheet, 1)
                ebullet.x = object.x 
                ebullet.y = object.y
             
                ebullet.x = object.x   ebullet.y = object.y   ebullet.myName = "enemyb" ebullet.health = 10
                ebullet.collisionpower = 5
                
                physics.addBody(ebullet , "dynamic", {isSensor = true ,friction = 0, bounce = 0, density = 0,})
                local distance = 300
                local distanceX = plocationx - object.x
                local distanceY = plocationy - object.y
                local distanceTotal = core.distanceBetweenCoords (plocationx , plocationy , object.x ,object.y )
                local moveDistanceX =  distanceX / distanceTotal;
                local moveDistanceY =  distanceY / distanceTotal;
                local px = plocationx + moveDistanceX * (distanceTotal + distance)
                local py = plocationy + moveDistanceY * (distanceTotal + distance)
                local pos = vector.newVec(px,py)
                transition.moveTo( ebullet, { x=pos.x, y=pos.y, time=4000 , } )
        end
 end
end   

--[[simple Trig Get the X axsis and Y between the 2 objects then get angle ]]
function groundEmemys:doRotate(plocationx,plocationy,angle)
    local tempx = plocationx
    local tempy = plocationy  
    local turnAngle = angle or 90
    local ememies = self.AllgroundEmemys
    local atancal = math.atan2
    for i = #ememies , 1, -1   do
        local object = ememies[i]
        if (object.health >= 0 and object.x) then
                 local distanceX =  tempx - object.x
                 local distanceY =  tempy - object.y 
                 object.rotation = (atancal(distanceY ,distanceX )*radians)+ turnAngle ;
        else    
            table.remove(object, i)
        end
    end     
end

function groundEmemys:update(event , plocationx , plocationy )
   self:doRotate(plocationx , plocationy )
   --only fire bullets every sec or so from this update
   local time = system.getTimer()
   local dt = time - self.lastfireTime
   if dt > 1000 then
         self:fireRamdomBullets(plocationx , plocationy ) 
         self.lastfireTime = time
   end
   self:Remove() -- clear out old tables
  
end

function groundEmemys:free()
    --em gotta go backwards in the loop and pop of the last otherwise we can remove
    -- them this is odd frees up memory
   local ememies = self.AllgroundEmemys
   for i = #ememies , 1, -1 do
         local object = table.remove(ememies, i)
         if object ~= nil then 
                 if object ~= nil then 
                    object:removeSelf() 
                    object = nil
                end
                object = nil
            end  
   end   
end

function groundEmemys:Remove()
    local ememies = self.AllgroundEmemys
    for i = #ememies , 1, -1 
       do
        local object = ememies[i]
           if (object.health <= 0 ) then
              table.remove(ememies, i)
        end
    end   
end


return groundEmemys
