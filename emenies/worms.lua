

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
local core = require ("core.core") -- has gogal core functions

local makePath = core.makeCircle
local dofollow = core.doFollow
local Worms = {}


function Worms.new()
    Worms.int = 1
    Worms.displayGroup = display.newGroup()
    Worms.allWormsTable = {} -- create a table to store the mines
    Worms.allMissilesTable ={}
    Worms.maxWorms = 5 --set the max mines to 10
    Worms.maxTails = 15 --set the max mines to 10
    Worms.lastfireTime = 0
    return Worms
end
function Worms:update(event, playerX,playerY)
     --use the timer to udate the worm as too complex for the game loop , missile ok as not complex
    self.int = self.int + 1
    --update the missile can use physics as this missile seeks the target
    for i = #self.allMissilesTable , 1, -1  do
        local object = self.allMissilesTable[i]
        if (object.x) then
            --function core.doFollow(followerObject, targetObject, missileSpeed, turnRate, doRotate, runAway)
              local targetObject = {}
                    targetObject.object ={}
                    targetObject.object.x = playerX
                    targetObject.object.y = playerY
                    targetObject.moveX=0
                    targetObject.moveY=0
           -- local playerPoints = { x = playerX , y=playerY , moveX=10 , moveY=10}
            dofollow(object, targetObject ,5, 5, true, false)
        else
          --  self.mineCount = tablex.icount(self.allMissilesTable)
         --   table.remove(self.allMissilesTable, i)
        end
    end         
 end

function Worms:timer( event )
    print ( " On Worm timer")
    local time = system.getTimer()
    local dt = time - self.lastfireTime
    self:move()
    if dt > 2000 then
          Worms:fireRamdomMissiles(time) 
    end   
    self:RemoveOldMissiles()
end

function Worms:move()
     
     local wormtable = self.allWormsTable
     local waypoint = self.waypoints
     local int = self.int
     local mrandom =  math.random
     
     for i = #wormtable , 1, -1 
       do
        local object = wormtable[i].object
           if (object.health > 0) then
                  object:toFront()                          
                   if self.int <= #waypoint then
                        transition.moveTo( object, { x=waypoint[int][1], y=waypoint[int][2], time=1000 } )
                    else 
                        local speed= mrandom(10,20) / 10
                        local am1= mrandom(1,5) / 10
                        local am2= mrandom(1,5) / 10
                        local x1 = mrandom(100,420)
                        local x2 = mrandom(100,420)
                        Worms.waypoints = makePath(  {x1,100}, {x2,150}, 0, 360 , am1, am2 , speed )
                        self.int = 1
                    end
            else
          --      self.mineCount = tablex.icount(wormtable)
                table.remove(wormtable, i)
         end
    end         
                
      
 end
 function Worms:GetCount()
    return #self.allWormsTable
end

 
function Worms:make_tail( x, y, w, h, c )
  
    local allWormsTable = self.allWormsTable
    local maxWorms =self.maxWorms  
    local maxTails =self.maxTails  
    local displayGroup = self.displayGroup
    
    local options = {
         width = 24,
         height = 25,
         numFrames =12,
    }
    local wormSheet = graphics.newImageSheet("assests/worm.png", options )
    local link , linkh
    linkh = display.newImage( wormSheet, 12 )
    linkh.myName = "enemy"       linkh.points = 50    linkh.health = 5    linkh.collisionpower = 5
    physics.addBody( linkh, "static" ) 
    local wormInfo = {object = linkh,}
    table.insert(allWormsTable, wormInfo)
    
    for s = 1, maxTails do
        local prev_link
        for i = 1, c do 
            if i == 1 then 
                 link = linkh
            else 
                link = display.newImage( wormSheet, (c-i)+1 )
                physics.addBody( link, "dynamic" , { friction = 0, bounce = 0, density = 0,})    
                link.linearDamping = 0
                link.angularDamping = 0
                link.myName = "enemy"
                link.points = 50
                link.health = 5
                link.collisionpower = 5
            end 
                 link.x = x ;  link.y= y+(i*(h+1))
            if i > 1 then 
                print( i )
                physics.newJoint( "pivot", prev_link, link, x, prev_link.y + (h*0.5) )
            end 
            prev_link = link
        end
    end    
end 



function Worms:initialise(params)
    Worms.waypoints = makePath(  {50,100}, {300,150}, 0, 360 , .5, .3 , 1 )
    self.timerid =timer.performWithDelay( 1000, Worms , 0) -- call every 1 seconds
    self:make_tail( 0, 0, 0, 10, 9 )
 end
 
 
function Worms:count()
    self.wormCount = tablex.icount(self.allWormsTable)
    return self.wormCount
end

function Worms:free()
--em gotta go backwards in the loop and pop of the last otherwise we can remove
-- them this is odd frees up memory
    self.mineCount = tablex.icount(self.allWormsTable)
    for i = #self.allWormsTable , 1, -1 do

         local object = table.remove(self.allWormsTable, i)
         if object ~= nil then 
                 if object.object ~= nil then 
                    object.object:removeSelf() 
                    object.object = nil
                end
            end  

    end  
    
       for i = #self.allMissilesTable , 1, -1 do
        local object = self.allMissilesTable[i]
               table.remove(object, i)
                if object ~= nil then 
                    object:removeSelf()
                    object=nil
                end
        end
end

function Worms:fireRamdomMissiles()
  --  print("fireRamdomMissiles")
   self.wormsCount = tablex.icount(self.allWormsTable)
    if(self.wormsCount > 0) then
        local cannonToFire =  math.random(1,  self.wormsCount )    
        local object = self.allWormsTable[cannonToFire].object
        if (object.health > 0) then
                        local MissileG = display.newImage("assests/rocket.png")
                        MissileG.timestarted = system.getTimer()
                        MissileG.x = object.x
                        MissileG.y = object.y
                        MissileG.moveX = 0
                        MissileG.moveY = 0
                        MissileG.myName = "enemyb" MissileG.collisionpower = 20    MissileG.points = 0  MissileG.health = 1  
                        physics.addBody(MissileG , "dynamic", {isSensor = true ,friction = 0, bounce = 0, density = 0,})
               -- physics.addBody(MissileG , "dynamic", {isBullet=true, isSensor =true, friction = 0, bounce = 0, density = 0,})
               table.insert(self.allMissilesTable, MissileG)
       end
    end
end   
function Worms:Remove()
    local ememies = self.allWormsTable
    for i = #ememies , 1, -1 do
        local object = ememies[i].object
           if (object.health <= 0 ) then
              table.remove(ememies, i)
        end
    end   
end
--- kill off missiles older than 5 sec
function Worms:RemoveOldMissiles()
          local timeNow = system.getTimer()
      for i = #self.allMissilesTable , 1, -1 do
        local object = self.allMissilesTable[i]
           if (object.timestarted + 5000 < timeNow)  then
               table.remove(object, i)
            --   if(object) then
           --    object:removeSelf()
          --     object=nil
            --   end
            end
      end    
end

function Worms:free()
    local ememies = self.allWormsTable
    for i = #ememies , 1, -1 do
         local object = ememies[i].object
         object:removeSelf()
         object=nil
         table.remove(ememies, i)
    end
    timer.cancel(self.timerid)
  
end

return Worms


