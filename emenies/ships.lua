
--[[
----------------------------------------------------------------
MODULE FOR CORONA SDK
----------------------------------------------------------------
PRODUCT  :              MOBILE DEVELOPMENT 
----------------------------------------------------------------
USAGE:
----------------------------------------------------------------

 
----------------------------------------------------------------
]]--


local tablex = require ("tools.tablex")
local core = require ("core.core") -- has  core functions

local makePath = core.makeCircle
local coreFireRamdomEnemyBullets = core.fireEnemyBullets
local Ships = {}


function Ships.new()
    Ships.displayGroup = display.newGroup()
    Ships.allseqShipsTable = {} -- create a table to store the ships
    Ships.maxseqShips = 2 --set the max ships to 2
    Ships.lastfireTime = 0
    Ships.int = 0
    return Ships
end

function Ships:loadShip()
     local ImageSheet = graphics.newImageSheet(self.imageSheet, self.options )
     local animation = display.newSprite( ImageSheet, self.sequenceData )
     animation.x = -10 animation.y = 0
     animation.xScale = -1  
     animation.myName = "enemy"
     animation.points = self.points 
     animation.health = self.health 
     animation.collisionpower = self.collisionpower
     return animation   
end

function Ships:GetCount()
    return #self.allseqShipsTable
end

function Ships:move(x , y)
   
    local waypoint = self.waypoints
    local mrandom =  math.random
    local ememies =  self.allseqShipsTable
    
    local path = self.path
    
    --create a random waypath base upon the input parameters path that is read from a json
    --  ie path = { startPointXY = {50,100}, 
    --        endPointXY= {300,150}, 
  --          degreesStart=0, 
      --      degreesEnd = 360 ,
     --       yScale= .5 ,
     --       xScale=.3, 
       --      maxSpeed = 10
      --      value=  1 } ,
    
    local startxy = path.startPointXY
    local endxy = path.endPointXY  
    local degree = path.degreesStart
    local degreeend = path.degreesEnd  
    local yScale = path.yScale 
    local xScale = path.xScale 
    local value = path.value 
    local maxSpeed = path.maxSpeed
    
    for i = #ememies , 1, -1 
       do
        local object = ememies[i]
           if (object.health > 0) then
               if self.int <= #waypoint then
                    local int = self.int
                    local x1=waypoint[int][1] + i*60
                    local y2=waypoint[int][2]
                    transition.moveTo( object, { x=x1, y=y2, time=1000 } )
                else 
                    local speed= mrandom(5,maxSpeed) / 10
                    local am1= mrandom(1,xScale*10) / 10
                    local am2= mrandom(1,yScale*10) / 10
                    local degs= mrandom(290,degreeend)
                    local coords= mrandom(0,startxy[1]) 
                    self.waypoints = makePath(  {coords,coords}, {startxy[2],coords+60}, 0, degs , am1, am2 , speed )
                    self.int = 1
                end
            else  -- clean up object already removed but just remove it from this table
                object=nil
                table.remove(ememies, i)
         end
    end  
    local time = system.getTimer()
    local dt = time - self.lastfireTime
    if (dt > 1000 and #ememies > 0) then
          self:fireRamdomBullets(x , y ) 
          self.lastfireTime = time
    end            
     
end
function Ships:update(event,x,y)
     --use the timer to udate the worm as too complex for the game loop , missile ok as not complex
     self.x = x
     self.y =y 
     self.int = self.int + 1
 end

function Ships:fireRamdomBullets(plocationx, plocationy)
    local ememies = self.allseqShipsTable
    local emeniesCount = tablex.icount(ememies)
    if (emeniesCount~= 0) then 
         local cannonToFire =  math.random(1,  emeniesCount )    
         local object = ememies[cannonToFire]
         coreFireRamdomEnemyBullets(object.x , object.y , plocationx , plocationy )
    end
end   

function Ships:timer( event )
    self:move(self.x , self.y)
end


function Ships:initialise(shipinfoParams)
    self.options = shipinfoParams.options
    self.sequenceData = shipinfoParams.sequenceData
    self.imageSheet = shipinfoParams.imageSheet
    self.path = shipinfoParams.path
   
    self.points  = shipinfoParams.points
    self.health  = shipinfoParams.health
    self.collisionpower  = shipinfoParams.collisionpower


    
    
    local path = self.path
    
    local allseqShipsTable = self.allseqShipsTable
    local maxseqShips = shipinfoParams.maxseqShips
    local width = shipinfoParams.options.width
    for s = 1, maxseqShips do
        local ship = self:loadShip()
        ship.x=shipinfoParams.startX + (width*s)
        ship.y= display.contentHeight - 23
        ship:play()
        self:AddPhysics(ship)
        table.insert(allseqShipsTable, ship)
    end
    Ships.waypoints = makePath(  path.startPointXY,  path.endPointXY,  path.degreesStart, path.degreesEnd , path.yScale, path.xScale ,path.value )
    timer.performWithDelay( 1000, Ships , 0) -- call move 1 seconds
end

function Ships:AddPhysics(mineInfo)
    physics.addBody(mineInfo , "static", {density=.1 , bounce=2, friction=.2, radius=20})
    mineInfo.isActive = true
    mineInfo.gravityScale = 1
end

function Ships:free()
--em gotta go backwards in the loop and pop of the last otherwise we can remove
-- them this is odd frees up memory
  local emenies = self.allseqShipsTable
   for i = #emenies , 1, -1 do
         local object = table.remove(emenies, i)
         if object ~= nil then 
                 if object.object ~= nil then 
                    object.object:removeSelf() 
                    object.object = nil
                end
            end  

    end   
end
function Ships:Remove()
    local ememies = self.allseqShipsTable
    for i = #ememies , 1, -1 
       do
        local object = ememies[i]
           if (object.health <= 0 ) then
              table.remove(ememies, i)
        end
    end   
end


return Ships



