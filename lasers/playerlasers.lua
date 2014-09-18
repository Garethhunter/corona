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


local playerlazers = {}

function playerlazers.new()
    playerlazers.displayGroup =display.newGroup()
    return playerlazers
 end

function playerlazers.initialise()
   playerlazers.displayGroup:toFront()  
end

-- fire the laser at position X , y 
--add Physics to the lazer
function playerlazers.fireLazer(x1,y1)
   local xpos= x1+12 
   local ypos= y1 
   local bullet= display.newImage( playerlazers.explosionSheet, 1)
   bullet.myName = "playerLazer"
   physics.addBody( bullet, "dynamic", {density=10, radius=5 , friction=0, bounce=0 } )
   bullet.x= xpos
   bullet.y= ypos
   bullet.power =  playerlazers.power 
   bullet.isBullet = true
   bullet.gravityScale = 0
   playerlazers.displayGroup:insert(bullet)
   bullet:applyForce( 80, 0, xpos, ypos)
   return true
end

function playerlazers:initialise(lazerinfoParams)
    playerlazers.imageSheet =  lazerinfoParams.imageSheet
    playerlazers.options = lazerinfoParams.options
    playerlazers.sequenceData = lazerinfoParams.sequenceData
    playerlazers.power = lazerinfoParams.power
    playerlazers.explosionSheet = graphics.newImageSheet(playerlazers.imageSheet, playerlazers.options )
end
  

return playerlazers



