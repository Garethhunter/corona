
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

local tablex = require ("tools.tablex")
local core = require ("core.core") -- has gogal core functions
local distancebetween = core.distanceBetweenCoords
local vector = require('math.vector')
local Robot = {}

function Robot.new()
    Robot.displayGroup = display.newGroup()
    Robot.allRobotTable = {} -- create a table to store the mines
    Robot.maxShips = 5 --set the max mines to 10
    Robot.maxShips = 5
    Robot.lastfireTime = 0
    return Robot
end
--move the mines on screen
--if mine falls off edge of screen
--recycle it  ie put it back at other end of screen
function Robot:loadRobot(x,y)
    local animation = display.newSprite( self.Sheet, self.sequenceData )
    animation.x = x animation.y = y
    animation.xScale = -1  
    animation.myName = "enemy"
    animation.points = self.points
    animation.health = self.health
    animation.collisionpower = self.collisionpower
    return animation   
end

function Robot:update(event , x , y)
    local ememies = self.allRobotTable
    
    for i = #ememies , 1, -1 
       do
        local object = ememies[i]
           if (object.health > 0) then
               if(object.x < 0) then
                    object.xScale = 1
                    object.direction=1
               elseif (object.x > display.contentWidth) then
                    object.xScale = -1
                    object.direction=0
               end
                if(object.direction == 0) then
                    object.x = object.x-2
                else
                    object.x=object.x+1
                end
            else
                -- self.mineCount = tablex.icount(self.allShipsTable)
                table.remove(ememies, i)
         end
    end         
   local time = system.getTimer()
   local Count = tablex.icount(self.allRobotTable)
   local dt = time - self.lastfireTime
   if dt > 1000 and Count then
         self:fireRamdomBullets(x , y ) 
         self.lastfireTime = time
    end            
        
    
end

function Robot:fireRamdomBullets(plocationx, plocationy, sec)
   -- print("fireRamdomBullets")
    local ememies = self.allRobotTable
    local emeniesCount = tablex.icount(ememies)
    if (emeniesCount~= 0) then 
        local cannonToFire =  math.random(1,  emeniesCount )    
        local object = ememies[cannonToFire]
               if (object~=nil) then
                    local ebullet = display.newCircle( 1, 1, 5 )
                    ebullet.x = object.x      ebullet.y = object.y   ebullet.myName = "enemyb"
                    physics.addBody(ebullet , "dynamic", {isSensor = true ,friction = 0, bounce = 0, density = 0,})
                    local distance = 300
                    local distanceX = plocationx - object.x
                    local distanceY = plocationy - object.y
                    local distanceTotal = distancebetween(plocationx , plocationy , object.x ,object.y )
                    local moveDistanceX =  distanceX / distanceTotal;
                    local moveDistanceY =  distanceY / distanceTotal;
                    local px = plocationx + moveDistanceX * (distanceTotal + distance)
                    local py = plocationy + moveDistanceY * (distanceTotal + distance)
                    local pos = vector.newVec(px,py)
                    --      ebullet.AnchorX = 0      ebullet.AnchorY = .5
                    ebullet.myName = "enemyb" ebullet.collisionpower = 20    ebullet.points = 0  ebullet.health = 1  
                    transition.moveTo( ebullet, { x=pos.x, y=pos.y, time=4000 , } )
            end
        end

end  

function Robot:GetCount()
    return #self.allRobotTable
end

function Robot:initialise(params)
    
    local allRobotTable = self.allRobotTable
    local maxShips = params.maxShips or self.maxShips  
    self.options = params.options
    self.Sheet = params.Sheet
    self.sequenceData = params.sequenceData
    self.points = params.points
    self.health = params.health
    self.collisionpower = params.collisionpower
    self.spacing = params.spacing
    self.power = params.power
    self.Sheet = graphics.newImageSheet(params.Image,  params.options )
    
    for s = 1, maxShips do
        local robot = self:loadRobot()
        robot.x=display.contentWidth +(self.spacing*s)
        robot.y= display.contentHeight -25
        robot.direction = 1
        robot:play()
        self:AddPhysics(robot)
        table.insert(allRobotTable, robot)
    end

   
end
function Robot:AddPhysics(mineInfo)
    physics.addBody(mineInfo , "static", {density=.1 , bounce=2, friction=.2, radius=20})
    mineInfo.isActive = true
    mineInfo.gravityScale = 1
end


function Robot:free()
    --em gotta go backwards in the loop and pop of the last otherwise we can remove
    -- them this is odd frees up memory
    for i = #self.allRobotTable , 1, -1 do
        local object = table.remove(self.allRobotTable, i)
         if object ~= nil then 
                 if object.object ~= nil then 
                    object.object:removeSelf() 
                    object.object = nil
                end
            end  
    end   
end
function Robot:Remove()
    local ememies = self.allRobotTable
    for i = #ememies , 1, -1 do
        local object = ememies[i]
           if (object.health <= 0 ) then
              table.remove(ememies, i)
        end
    end   
end
return Robot


