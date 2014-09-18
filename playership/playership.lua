
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

local playership = {}


function playership:new()
       --create new display group to add the jet and flames too
       playership.displayGroup =display.newGroup()
       return playership
 end

function playership:initialise(params)
        local xpos =0 -- params.xpos
	local ypos =0 -- params.ypos
        local displayGroup = self.displayGroup    	
        local playerImage=params.playerImage 
        local radius = params.radius
	local col = params.col
        displayGroup.sheild = params.shield
        local exhaust = params.exhaust
        playership.protection = display.newImage( self.displayGroup , "assests/projectile_bolt_blue_single.png" )
        playership.protection.x = 0
        playership.protection:rotate(-180)
        playership.player = display.newImage(displayGroup ,playerImage  )
        playership.player.power = params.power
        playership.player.x=xpos
        playership.player.y=ypos
        displayGroup.myName = "player"
        local am2=playership.flames(exhaust, xpos ,ypos)
         
        playership.xminClamp = radius + 30
	playership.xmaxClamp = display.contentWidth - (radius +5)
	playership.yminClamp = radius + 30
	playership.ymaxClamp = display.contentHeight - radius
        
	playership.maxSpeed = params.maxSpeed
	playership.velocity = vector.newVec(0, 0)
	playership.position = vector.newVec(xpos, ypos)
        
        playership.displayGroup.x=params.xpos
        playership.displayGroup.y=params.ypos    
        playership.displayGroup:toFront()
        displayGroup:insert(playership.protection)
        displayGroup:insert(playership.player)
        displayGroup:insert(am2)
          
        local triangleShape = { 0,-10, 10,10, -10,10  , -10,10}
         -- displayGroup.angularDamping = 10
        --displayGroup.gravityScale = 0
       -- displayGroup.isFixedRotation = true
        physics.addBody(displayGroup , "static", {shape=triangleShape , friction = 0, bounce = 0, density = 10})
      
        self.canGetHit = true
        am2:play()
end
function playership.flames(exhaustinfo , x , y )
    local lsize = exhaustinfo.size or 128
    local options = {
         width = lsize,
         height = lsize,
         numFrames = exhaustinfo.numFrames,
    }
    local sequenceData = {   
        {name="normalFlames", start=1, count=exhaustinfo.numFrames, time=exhaustinfo.time ,loopCount=0},
    }
    local Sheet = graphics.newImageSheet(exhaustinfo.exhaustfile, options )
    local animation = display.newSprite( Sheet, sequenceData )
    animation:rotate(exhaustinfo.rotate)
    animation:scale( exhaustinfo.scalex, exhaustinfo.scaley )
    animation.x = x -28
    animation.y = y 
    return animation   
end
local currX, currY
local newX, newY = 0,0
function playership:move(x1 , y1)
    currX = newX  currY = newY
    newX = x1  newY = y1
    return transition.to(playership.displayGroup, {time = 2 *(math.sqrt((currX-newX)^2 + (currY-newY)^2 )), x=newX, y = newY })
    --return transition.to( playership.displayGroup,{time=200,x=x1,y=y1})  -- move to touch positio  
end
function playership:GetObject()
        return self.displayGroup;
end
function playership:GetPositionX()
   return self.displayGroup.x
end
function playership:GetPositionY()
   return self.displayGroup.y
end
function playership:ShieldPower(collisionpower)
    -- give user 1 secon of invurbunterly
    if(self.canGetHit == true) then
        self.canGetHit=false
        playership.protection.isVisible = true -- show sheild around ship
        self.displayGroup.sheild = self.displayGroup.sheild - collisionpower
        --pause update for 2 second
        timer.performWithDelay( 2000, playership )
    end
    return self.displayGroup.sheild
end
function playership:SetShieldPower(value)
    self.displayGroup.sheild =  value
 end

function playership:timer( event )
   playership.canGetHit = true
   playership.protection.isVisible = false
end

function playership:shieldupGrade(value)
    local dg = self.displayGroup.sheild 
    dg=  dg + value
end

function playership:getState()
     local playerTable = {}
     playerTable.playerX = self.displayGroup.x
     playerTable.playerY = self.displayGroup.y
     playerTable.power = self.player.power 
     playerTable.maxSpeed = self.player.maxSpeed
     playerTable.sheild =  self.displayGroup.sheild 
     return playerTable
end
function playership:setState(playerTable)
    self.displayGroup.x = playerTable.playerX 
    self.displayGroup.y = playerTable.playerY 
    self.player.power = playerTable.power 
    self.player.maxSpeed = playerTable.maxSpeed 
    self.displayGroup.sheild = playerTable.sheild  
end

return playership