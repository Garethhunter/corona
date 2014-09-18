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
local Mines = {}


function Mines.new()
    Mines.displayGroup = display.newGroup()
    Mines.allMinesTable = {} -- create a table to store the mines
    Mines.maxMines = 10 --set the max mines to 10
    return Mines
end
--move the mines on screen
--if mine falls off edge of screen
--recycle it  ie put it back at other end of screen
function Mines:GetCount()
    return #self.allMinesTable
end

function Mines:update(event , x , y)
         
    local sspeed_max = self.sspeed_max
    local sspeed_min = self.sspeed_min
    local amplitude_min = self.amplitude_min
    local amplitude_max =self.amplitude_max
    local angle_max = self.angle_max
    local angle_min = self.angle_min
    local Random = math.random
    local emenies = self.allMinesTable
        
    for i = #emenies , 1, -1  do
        local object = emenies[i]
           if (object.health > 0 ) then
            --if (object.health <= 0 ) then
            --    table.remove(object, i)
              if object.x <= -50 then  -- if it has gone offscreen
                   object.x= display.contentWidth + 100
                    
                    object.sspeed =Random(sspeed_min,sspeed_max)
                    object.amp =Random(amplitude_min,amplitude_max)
                    object.angle = Random(angle_min,angle_max)
                    
                    --bottom bounds
                   -- local maxh = object.amp * math.sin( object.angle);
                    local y =  (display.contentHeight /Random(1,4))
               
                    local amp = object.amp * math.sin(20) + y
                    if(amp > display.contentHeight ) then
                         print (amp)
                           object.initY = y - (amp - display.contentHeight) -50
                         end
                   
                    if(amp < 60 ) then
                         print (amp)
                          object.initY = y + 60
                    end
                else
                    object.x = object.x - (object.sspeed)
                    object.angle = object.angle + .1
                    object.y = object.amp * math.sin(object.angle) + object.initY
                    object:rotate( object.angle )
                end
            else
                self.mineCount = tablex.icount(emenies)
                table.remove(emenies, i)
         end
    end         
                
    --self:Remove() -- clear out old tables
    
end
function Mines:initialise(params)
    local minesImage = params.minesImage
    local health = params.health
    local points = params.points
    local collisionpower = params.collisionpower
    self.sspeed_max = params.sspeed_max
    self.sspeed_min = params.sspeed_min
    self.amplitude_min = params.amplitude_min
    self.amplitude_max =params.amplitude_max
    self.angle_max = params.angle_max
    self.angle_min = params.angle_min
 
    local allMinesTable = self.allMinesTable
    local maxMines = params.maxMines or self.maxMines  
    local displayGroup = self.displayGroup
    local Ramdom = math.random
    local sspeed_min = self.sspeed_min
    local sspeed_max = self.sspeed_max
     
 	
    for s = 1, maxMines do
        local mineObject = display.newImage(displayGroup, minesImage)
        mineObject.x=500
        mineObject.y=100
        mineObject.initY = 100
        mineObject.sspeed = Ramdom(sspeed_min,sspeed_max)
        mineObject.amp = Ramdom(self.amplitude_min,self.amplitude_max)
        mineObject.angle = Ramdom(self.angle_min,self.angle_max)
        mineObject.myName = "enemy"
        mineObject.points = points
        mineObject.health = health
        mineObject.collisionpower = collisionpower
        self:AddPhysics(mineObject)
        table.insert(allMinesTable, mineObject)
    end
    self.mineCount = tablex.icount(allMinesTable)
    print ("No of mines" .. self.mineCount) 
end
function Mines:AddPhysics(mineInfo)
    physics.addBody(mineInfo , "dynamic", {density=10 , bounce=5, friction=5, radius=20})
    mineInfo.isActive = true
    mineInfo.gravityScale = 0
end

function Mines:GetCount()
    local ememies = self.allMinesTable
    self.mineCount = tablex.icount(ememies)
    return self.mineCount
end
function Mines:free()
--em gotta go backwards in the loop and pop of the last otherwise we can remove
-- them this is odd frees up memory
    local ememies = self.allMinesTable
    self.mineCount = tablex.icount(ememies)
    for i = #self.allMinesTable , 1, -1 do
     local object = table.remove(ememies, i)
            if object ~= nil then 
                object:removeSelf() 
                object = nil
            end
    end   
end

function Mines:Remove()
    local ememies = self.allMinesTable
    for i = #ememies , 1, -1   do
        local object = ememies[i]
           if (object.health <= 0 ) then
              table.remove(ememies, i)
           end
    end   
end
return Mines
