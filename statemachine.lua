
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






local mines = require ('emenies.mines')
local groundunits = require ('emenies.groundunits')
local wormunits = require ('emenies.worms')
local Robotunits = require ('emenies.robot')
local seqshipunits = require ('emenies.ships')
local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local statemachine = {}




function statemachine.new()
    statemachine.displayGroup =display.newGroup()
    statemachine.isLoaded =false
    statemachine.isnotchanging = false
    statemachine.CurrentObjects = false
    statemachine.currentirration = 0
    return statemachine
end
--get the current position
function statemachine:getSeq()
    return statemachine.currentirration
end

function statemachine:initialise(params)
    statemachine.currentirration = params.location
    self.timerid = timer.performWithDelay( 5000, statemachine , -1 ) -- call every 20 seconds
    statemachine.Message = display.newText( "<---- tap screen to move --------><-fire tap here->", contentWidth /2  , contentHeight/2, native.systemFont,22 )
 end
--called per frame
function statemachine:update(event , x , y)
  local  CurrentObject = statemachine.CurrentObject
  if((statemachine.isnotchanging == true) and (statemachine.CurrentObjects == true) and CurrentObject~=nil) then 
       CurrentObject:update(event ,x , y)
  end
end
--a timer to change the state when ememys are destroyed
function statemachine:timer( event )
       print ( " changing state" .. statemachine.currentirration )  -- if there is no more emeneys)
       if(statemachine.CurrentObjects == true) then
            statemachine.CurrentObject:Remove()
                if statemachine.CurrentObject:GetCount() > 0 then
                    return false
                end
       end
    
     statemachine.isnotchanging = false
     statemachine.Message.isVisible = false;
     statemachine.CurrentObjects = false
 
    if(statemachine.currentirration < 0) then
        statemachine.currentirration = 0   -- just incase it
    end

    statemachine.currentirration = statemachine.currentirration +1
    
  
    if(statemachine.currentirration == 1) then
         --   print ( " creating state" )  -- if there is no more emeneys)
            local groundinfoParams = {
                        groundImage ="assests/groundcannon.png",
                        points = 50,
                        health = 10,
	                collisionpower = 10,
                        rotate = -90,
                        maxUnits = 5,
                        spacing = 65 ,
                        power = 10 ,
                        x = 50 ,
                        y = 305,
                        
                        lazerinfo = { 
                                    imageSheet = "assests/redfire.png",
                                    options = { width = 30,    height = 30,   numFrames = 3,}  ,
                                    sequenceData = { name="Explosion", start=1, count=3,  time=2500 , loopCount = 0,} ,
                                    power =10 ,
                        } 
                        
                        
            }
            
            statemachine.CurrentObject = groundunits.new()
            statemachine.CurrentObject:initialise(groundinfoParams)
        end
      if(statemachine.currentirration == 2) then
         -- statemachine.CurrentObject = nil
          local minesinfoParams = {
                        minesImage ="assests/mine.png",
                        health = 10,
			points = 5,
                        shield = 0,
                        collisionpower = 20,
                        sspeed_max = 8 ,
                        sspeed_min = 1,
                        amplitude_min = 20,
                        amplitude_max =100,
                        angle_min = 20 ,
                        angle_max = 100, 
                        maxMines = 10,
    }
          
          statemachine.CurrentObject = mines.new()
          statemachine.CurrentObject:initialise(minesinfoParams)
   
        end
       if(statemachine.currentirration == 3) then
           
                     
            local robotinfoParams = {
                        Image ="assests/rob2.png",
                        points = 50,
                        health = 10,
	                collisionpower = 10,
                        rotate = -90,
                        maxUnits = 5,
                        spacing = 65 ,
                        power = 10 ,
                        x = 50 ,
                        y = 305,
                        options = { width = 55, height = 52,numFrames = 30, } , 
                        sequenceData = {    {  frames = {20,21,22,23,24,25,26 ,27,28,29},   time = 3500,   loopCount = 0 } ,
                         
            },
            }
         
          statemachine.CurrentObject = Robotunits:new()
          statemachine.CurrentObject:initialise(robotinfoParams)
         end

         if(statemachine.currentirration == 4) then
          local shipinfoParams = {
                    imageSheet = "assests/rob1.png", 
                    xScale = -1, 
                    points = 50, 
                    health = 10,  
                    startX = 100, 
                    collisionpower = 5 ,
                    maxseqShips = 3 , 
                    options = { width = 74,    height = 47,   numFrames = 10,} , 
                    path = { startPointXY = {50,100}, 
                        endPointXY= {300,150}, 
                        degreesStart=0, 
                        degreesEnd = 360 ,
                        yScale= .5 ,
                        xScale=.3, 
                        maxSpeed = 10 ,
                        value=  1 } ,

                    sequenceData =  { name="Movement", start=1, count=10,  time=1250 , loopCount = 0,},
        }
           statemachine.CurrentObject = seqshipunits:new()
           statemachine.CurrentObject:initialise(shipinfoParams)

        end

       if(statemachine.currentirration == 5) then
           statemachine.CurrentObject = wormunits:new()
           statemachine.CurrentObject:initialise({maxMines = maxMines})
        end


    if (statemachine.currentirration > 5) then
        statemachine.currentirration = 0
    end
    statemachine.CurrentObjects = true
    statemachine.isnotchanging = true
end

function statemachine:PrintMessageAndRemove(message)
    statemachine.Message.text = message
end

function statemachine:getState()
    local stateTable = {}
    stateTable.location = self.currentirration -1 -- ask starts at 0 based
    return stateTable
end
function statemachine:setState(stateTable)
   self.isnotchanging =false
   self.currentirration =  stateTable.location 
end
function statemachine:free()
    if(self.CurrentObject ~=nil ) then
        statemachine.isnotchanging = false
         statemachine.Message.isVisible = false;
         statemachine.CurrentObjects = false
         self.isnotchanging =false
         timer.cancel(self.timerid)
         self.CurrentObject:free()
         self.CurrentObject = nil
    end
end

return statemachine