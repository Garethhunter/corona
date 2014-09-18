
Game design
There are many different display objects in this game including sprites, imagesheets, images, animation, displaygroups, layers and moving content on-off-screen when needed. Firstly, animation can be shown for any of the explosions. There are two types of explosion a mini explosion and a full explosion taken from the explosion23.png imagesheet located in “assests” folder.  One animation sequence is played for a minimum explosion if an enemy missile is destroyed.  The full explosion is played when the object is completely destroyed. Looking in the assets folder we can see that there is actually very little content contained within the game. 
The mine image, ground canon and missile are all simple images that apply the corona displayobject: rotate function and as a result an effective animation is displayed as shown in the game for just the images shown in the following table.  Most images contain some form of movement, either by manipulating the X and Y values of the displayobject or by using the transition.to function or even the physics:applyforce function.
Missiles that are launched by various enemies and these are rotated depending upon the player’s location given a sense of animation. 

 		   

Turret rotates	  Mines rotates and move in a sine wave movement

 	Worm.png is a small image sheet containing 12 tiny sprites, combined with physics creates a big powerful enemy the level boss, the enemy has a fluid like movement that is completely programmed.

The tile engine module “simpletileengine.lua” also utilises sprites that are contained within an image sheet. Each tile can be loaded and displayed on the screen and swapped in and out of view when needed, described in more detail later. 
The player object also contains an example of animation. This jet and flame effect is a corona display group containing the player image redJet.png and the exhausts animation thrustyellow.png.  Both of these are applied together in the one display group and moved with the transition.to function
 

 
There are also another two examples of imagesheet that is animated sprites from Rob1.png, Rob2.png. 
 

A scrolling parallax space background contains different layers of images, with different alpha parameters moving at different speeds. Gives a sense of depth to the game implemented in “spaceparallax.Lua” discussed later in detail. 
Player laser and enemy lasers are also an example of animation and movements that is, lasers move from one end of the screen to the other. 
There are also five different enemies within the game and each contains their own movement abilities. Some move along the ground and others move throughout space, either on a random circular path or random sine wave paths. Please see actual game for each enemy’s particular movement.
 

Design of Application
This application is designed in a completely modular way, that is all features are broken down into modular components called objects in this document, there is very little code repeat, any code repeat that did appear was simply re-factored away.  The application also utilises a bridge pattern, a factory pattern and the MVC pattern. Although not in the strict terms defined by computer scientist’s purists but powerful enough to decouple each part of the application.
There are lots of examples of code reuse within this application. That is any function that can be used use more than once are. Examples of function reuse can be seen within most modules, especially core functions such as distanceBetweenObjects( objectA , objectB ) and fireEnemyBullets(pFromLocX, pFromLocY , ptoLocX , ptoLocY) are good examples. The DRY (don’t repeat yourself) principle was used when building this game.
Each enemy is defined as a standard interface, and all controlled the exact same way. The statemachine “statemachine.lua” object is properly the most interesting utilising both a module factory and a bridge pattern, that is all enemies have been defined to conform to an interface, this means that the control can be switched between enemies without having add in any new code, that is, a new enemy can be created with the standard interface and added simply to the statemachine. All enemies are defined as follows
local groundEmemys = {}

function groundEmemys.new()
    return groundEmemys
end

function groundEmemys:initialise(params)

function groundEmemys:GetCount()
    return #self.AllgroundEmemys
end

function groundEmemys:update(event , plocationx , plocationy )
end

function groundEmemys:free()
end

function groundEmemys:Remove()
end

return groundEmemys

Above is the standard interface used by all enemies. By using a lua table for a module all functions are stored within the table in a sense providing encapsulation.   It may be noted here that some function signatures are using (.) and others are using (:) the only difference between these two is that self is passed in automatically when the colon operator (:) is used. This makes the function parameter list neater that is,  function Object:Remove() , is the same as Object.Remove(Object)  or Object:Remove()  is the same as Object.Remove(Object) . 

The interface/module contains the following functions 

new(); Although not related to object orientated programming , is just simply to set up the backup parameters for the new table , this function returns the lua table, 

initialise(params) , this function setup all the initialisation parameters for the module , that is from imagesheets  parameters to waypoints how the module moves etc. every module that has parameters in this design has this initialise function. This initialise function is used for the data driven content.

getcount() ,  this returns an count of active objects , that is enemies
remove() ,  this function is called to remove any objects from the internal table that may have been destroyed by the player .
free() , when called completely destroys and frees all memory for this particular enemy.
update() .  Called during enter-frame if any updates are to be performed, but no intense processing

The application is so modular that even new levels can be added with no change to the game engine.
     if(statemachine.currentirration == 5) then
          statemachine.CurrentObject = wormunits:new()
          statemachine.CurrentObject:initialise({max = 10})
        end

or 
 statemachine.CurrentObject = Robotunits:new()
 statemachine.CurrentObject:initialise(robotinfoParams)

The statemachine controls the objects to be displayed and controlled, it doesn’t matter what type of object that is as long as it complies the interface set out earlier. This enables a modular design in the application.  At different stages in the game the statemachines current object can be changed to a new object, this can be done with two lines of code as shown.  This kind of implements a bridge pattern and a factory pattern in corona and combined with the MVC pattern discussed later make the game design very modular.
Head-up Display
The application contains a separate module called HUD; this is a completely separate module containing its own displaygroup and is required from the main application code. The module contains the usual function signatures that are implemented throughout this assignment. Like all other modules It is completely data driven by the initialise function signature 
HUD: Example usage
local hud = require('hud.hud') -- the hud that contains the head up display
local hudObject = hud.new() –set up the display group

hudObject:initialise(hudinfoParams)

--to update the shield
hudObject:updateSheild(power)

--to update the score
hudObject:updateScore(enemy.points)

HUD JSON file:
{"GetWaveTxt":"Wave","GetLivesTxt":"Lifes","GetScoreTxt":"Points"} – hud JSON

This data driven JSON file allows complete control of any of the words display on the head-up-display as shown. This allows easy localisation of the game, that is simply changing the strings in the JSON file, will result with different strings displayed on screen. In addition if no input data is specified; defaults are loaded as shown. 
function hud:initialise(params)
    
    if (params==nil) then --error no parameters use default
        params={}
        params.GetScoreTxt = "Score"  -- for localization if needed if not default to English
        params.GetWaveTxt  = "Wave"  -- for localization if needed if not default to English
        params.GetLivesTxt = "Lifes" -- for localization if needed if not default to English
        params.GetMaxTxt  = "Max Score" 
    end

 
Figure 1 HUD


A screenshot of the HUD module is shown in Figure 2 HUD.  Shown here is the wave that is the current location in the game where the player is. The players shield strength is represented by the white bar with the red colour inside. This bar colour changes to green when over 75% full, yellow if shields are between 25% to 75% and red if under 25% as shown here.  The next element in the HUD module is the maximum score to date. The score is the current score in the game. Also shown is a blue shield around the player‘s spaceship. When this shield is activated the player cannot receive any damage i.e. the player is invulnerable. An enemy power/life bar indicator is placed on top of the current enemy as shown in Figure 2. When an enemy is hit by the player’s lazer this bar colour changes, from green to yellow, to red which indicates critical damage caused to the enemy. This bar indicator pops up on all enemies when they are hit with the player’s laser. Although only one enemy at a time is shown and the indicator simply moves onto the next enemy. This ensures the gamer does not get overloaded with information from the HUD module.

 
Figure 3 HUD enemy power


The bar is simply 2 rectangles with width the same as that of the enemy and displayed on top of the enemy. One rectangle is 100% width of the enemy and filled with a white background. The second rectangle is a few pixels smaller than the first. This gives it the outline, and the width of this rectangle is calculated by finding the percentile of the current shield value.
function hud:updateSheild(value)
    local percentile = (value / 100) * 100
    self.Shield.width = percentile;
end

Also, the HUD pops up display can be attached to any display object in the application. The following code enables this; this also shows how and when the object changes colour i.e., that is, if it’s less than 25% red is the fill colour, between 25 and 75% the colour yellow, and greater than 75% the colour green
function hud:trackObject(object)
        
        local displayObject =  self.objectShield
        local objectShield2 =  self.objectShield2  
        self.isupdate = true
        self.emenyPowerGroup.isVisible = false
        self.trackingObject = object
        
        local percent =  displayObject.width/100 
        local percentile = (object.health / displayObject.width ) * 100
        
        if(percentile < (percent *25)) then  -- less than 25% change color
              self.objectShield2:setFillColor( 155,0, 0 )
        elseif (percentile > (percent *25) and percentile  < (percent *75) ) then
             objectShield2:setFillColor( 80,150, 0 )  -- yelllow
        else
              objectShield2:setFillColor( 0,128, 0 ) -- green
        end
        
        objectShield2.width = percentile

end

Also note in the head-up display HUD, around the player’s ship in this above example is blue. This shows that the players Shield are active, and is invulnerable to any hits at this when active. Although this only happens when they have been hit with a missile; it gives them one second of invulnerability. In addition, when the user is killed the HUD displays a “game over” message as shown next
 


Design and implementation of appropriate touch controls.
When this application was being designed, there was a need for a joystick type input, that is a joystick was created that worked great in the simulator, but when tested on the actual device (android Nexus seven). It was noticed that multi-touch would not work correctly, that is the player could not touch both the fire button and the joystick at the same time. If the player touched the joystick by keeping his finger upon it and then touched the fire button, the event will be released from the joystick. In other words, focus was either on the joystick or the fire button but not both simultaneously. 
--active
local stage = display.getCurrentStage()
stage:setFocus(target)
							
--deavivate 
local stage = display.getCurrentStage()
stage:setFocus(nil)					

This was only noticed at the very end of development and a new approach implemented that probably is a lot more user friendly. Ideally I would like to have several users testing different controls to see which ones suited the end-user best. At the moment the application is driven by a multi touch event, as shown next:
system.activate("multitouch") --also using multitouch
local bounds = display.contentWidth * .75

local function multitouchListener( event )
  if (event.x > bounds ) then
      if (event.phase == "ended") then  -- only fire the lazer when event ended
            lazerObject.fireLazer( playerObject:GetPositionX(),playerObject:GetPositionY())
      end
  else
       if (event.phase == "ended") then --move the player only on the end event
             playerObject:move(event.x , event.y)
       end
         if (event.phase == "cancled") then --move the player to the start location
             playerObject:move(event.startX , event.startY)
       end
   end
   return true -- event handled stop further dispatch
end



If the user taps the left-hand side the screen, the spaceship will move to that location, if the user taps the last quarter of the right-hand side of the screen indicated by bounds above the laser will be fired.
The player object moves to this position at a constant speed no matter how far away the distances are as shown next
function playership:move(x1 , y1)
    currX = newX  currY = newY
    newX = x1  newY = y1
    return transition.to(playership.displayGroup, {time = 2 *(math.sqrt((currX-newX)^2 + (currY-newY)^2 )), x=newX, y = newY })
    --return transition.to( playership.displayGroup,{time=200,x=x1,y=y1})  -- move to touch positio  
end

 


In addition, a tap event is added to a display object to start the game as shown next: in main.lua
local text = display.newText( "Press to Start Game",150 ,150 ,font, 20 )
image.anchorX = 0; image.anchorY = -1
text.anchorX = 0; text.anchorY = -1
local  game ={}
local backgroundMusic = audio.loadStream( "assests/tgfcoderfrozenjam.mp3" )
local backgroundMusic2 = audio.loadStream( "assests/villeseppanen.mp3" )

local function start_pressed()
    text:removeSelf()
    text = nil
    game = require ("gamemain")
    return true  -- stop propagation
end

text:addEventListener( "touch", start_pressed )

In this game all event listeners “return true” to stop further despatching of the event to other corona objects.

Design and implementation of appropriate content navigation:
Content navigation is implemented and controlled by the statemachine module this module completely controls the timing and updating of each enemy on the screen. It could be defined as an enemy factory; each enemy in the application has the exact same interface, so they can be swapped in and out of the statemachine easily. This statemachine object is able to create and destroy these enemies when required.  Moving the player to the next content, that is the next wave of enemies. The statemachine detects how many enemies exist at that time. If all enemies are destroyed the statemachine removes the module and loads the next enemy. When the user completes one level the next level can be reinitialised with faster or more enemies, i.e. the power of the enemies can be doubled as shown next. 
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

There is very little readable content in this game, If there was more time I would develop a story around the player which could be navigated by using the content navigation as described in class this term by using the source code from the lab.
Use of data driven content
Particular interest has been taken in the design of data driven content and state data for this application. The application design has been completely modular and all modules are completely data driven discussed next enabling developers and designers to work together.
Application State data
Implementing state data, saving and restoring for this application was quite simple. Each module/Object state that was needed to be persisted between sessions a function getstate() ,  that returns a lua table, was added. The statemachine module contains the user’s location. The player module contains the player’s XY coordinates, the current laser power and current shield levels. The HUD module contains the current score and the maximum score. The source code to load the state and save the state is shown next:

local function save_state()
   local stateMachineData=statemachineObject:getState()
   local playerStateData = playerObject:getState()
   local scoreStateData = hud:getState()
   local StateTable = {
         scoreState = scoreStateData ,
         playerState = playerStateData,
         stateMachine = stateMachineData ,
    }
    paramsHandler.saveTable(StateTable, "state.json")
end
local function load_saved_state()
    local paramTable = paramsHandler.loadTable("state.json")
    --if player has sheilds live ect save the state -- if not do nothing
   if( paramTable ~=nil ) then 
       if( paramTable.playerState.sheild > 0) then -- if the user had shield and power before app closed load state , will also set the current wave
            statemachineObject:setState(paramTable.stateMachine)
            playerObject:setState(paramTable.playerState)
            hud:updateSheild(paramTable.playerState.sheild)
       else
            paramTable.scoreState.score = 0  -- reset the score just keep the higest score to date
     end
      --load the high score
      --show the players high score
      hud:setState(paramTable.scoreState)
      
    end
end
local function onSystemEvent( event )
   if ( event.type == "applicationExit" ) then
      save_state()  -- save the state
   elseif ( event.type == "applicationOpen" ) then
      load_saved_state() -- load the state
   elseif (event.type == "applicationSuspend") then
      pause_game() -- pause the gfame
   end
end

If the user exits the application the game produces a state file in JSON as 
{"playerState":{"sheild":70,"playerX":83,"playerY":270,"power":1},"stateMachine":{"location":4},"scoreState":{"score":0,"MaxScore":0}}

As shown here, this file contains the power, player’s shield, the players, X and Y location, the current score, the Max Score to date, and the stateMachines location.
When the application is reloaded the state is read into the appropriate objects and initialised, A few logic checks are executed on this data to make sure it is valid and in turn the player object, statemachine object and HUD object are updated with the saved data. If the data is not in a valid state only the high score value is read from the disk and the HUD object initialised. The saving of states has been tested on the device and works correctly.
Data driven content
This application is completely decoupled from the model that is all information is defined in various JSON files. Various JSON files were chosen to keep the explanation easier although a production version would more likely contain most of the JSON parameters in one file.  All modules in the application are driven by initialisation table that is loaded via a JSON file. Each module has a function initialise that takes one of these table to use. Example let’s say the explosion modules, when it is loaded on the JSON function loadTable and saveTable in filehandler module inside core. Implementing the system in this way enables a MVC architecture.
Explosions JSON file:
{"imageSheet":"assests/explosion43fr.png","options":{"height":100,"numFrames":40,"width":93},"sequenceData":[{"name":"ex1","start":1,"loopCount":1,"time":5000,"count":40},{"name":"ex2","start":10,"loopCount":1,"time":1200,"count":10},{"name":"ex3","start":20,"loopCount":1,"time":300,"count":10}]}

Loads into memory, as the following table
local explosioninfoParams1 = {
        imageSheet = "assests/explosion43fr.png" , 
        options = { width = 93,    height = 100,   numFrames = 40,} , 
        sequenceData = {{name="ex1", start=1, count=40 , time=5000 , loopCount = 1,},  
                        { name="ex2", start=10, count=10 , time=1200 , loopCount = 1,},
                        { name="ex3", start=20, count=10, time=300 , loopCount = 1,}
        }

This table is then used to initialise the corresponding explosion module
function explosion:initialise(explosionParams)
    explosion.explosionSheet = graphics.newImageSheet(explosionParams.imageSheet, explosionParams.options )
    explosion.sequenceData = explosionParams.sequenceData
end

As shown in the above tables. The JSON file contains all information required for the explosion object that is all the parameters that is used by the corona object; note that these parameters and/or images can be easily changed by the designer. Every display object in the game is driven in the same way.
The application is designed in such a manner to enable new assets and new parameters to be initialised via data driven content rather than modification of source code. Including the onscreen movement of enemies can be data driven, the parallax background of the application. The tile engine in fact, every module is completely data driven by this initialisation function. 
These lua tables are then loaded or saved to disk as JSON, via the filehandler.lua, module that is a copy taken from one of the labs in class this term. This module converts the lua tables to/from JSON. There is also another important module called parameter.lua , this sets up the default parameters for each object if the corresponding files do not exist in the application. The application will simply create defaults JSON files on installation as shown
   --load tbale returns nil if fails to load the file, therefore use the default.
    params.tileinfoParams =  filehandler.loadTable("tileinfoparams.json") or params.tileinfoParamsDefault()
   params.hudinfoparams = filehandler.loadTable("hudinfoparams.json") or params.hudinfoparamsDefault()
    params.playerinfoParams=   filehandler.loadTable( "playerinfoparams.json") or params.playerinfoparamsDefault()
    params.explosioninfoParams=  filehandler.loadTable("explosioninfoparams.json") or params.explosioninfoparamsDefault()
    params.explosioninfoParams1 = filehandler.loadTable("explosioninfoparams1.json") or params.explosioninfoparams1Default()
    params.lazerinfoParams =  filehandler.loadTable("lazerinfoParams.json") or params.lazerinfoParamsDefault()
    params.parralaxInfoParams = filehandler.loadTable("parralaxinfoparams.json") or params.parralaxInfoParamsDefault()    
    params.stateMachine = filehandler.loadTable("statemachineinfoparams.json") or params.stateMachineDefault()

Example: looking at the movement of enemies in the ships module is also completely data driven Ships.lua:
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

As shown here the lua table shipInfoParams contains all the parameters to define the ship object. Firstly its imagesheet and all the options to define that imagesheet from the number of frames contained in the imagesheet, the collision power, its objects health and most interestingly is its visible path.  Defined here as startPointXY, yScale, xScale, degreesStart, degreesEnd and the speed maxSpeed. These are then fed into the makePath function in module core and some values randomly calculated; please see individual enemy’s modules for further details. Even the amount of enemies to display on the screen via maxseqShips can be controlled.
function Ships:initialise(shipinfoParams)
…………………………………..
    Ships.waypoints = makePath(  path.startPointXY,  path.endPointXY,  path.degreesStart, path.degreesEnd , path.yScale, path.xScale ,path.value )
…………………………………………..
end

All enemies are similar, except some move along the ground and others move with random sine wave pattern like the mine enemies. All these modules can be changed to define whatever kind of input that is required that is from its visual appearance, to its movements and movement speeds, too. The power of its lasers and the power of its collision with the player and almost every module can be controlled via the data driven content. 
mine.lua
  local minesinfoParams = {
                        minesImage ="assests/mine.png",
                        health = 10,
	   points = 5,
                        shield = 0,
                        collisionpower = 1,
                        sspeed_max = 8 ,
                        sspeed_min = 1,
                        amplitude_min = 20,
                        amplitude_max =100,
                        angle_min = 20 ,
                        angle_max = 100, 
                        maxMines = 10,
    }

As shown even the points that the user can score is data driven from each module, its health , its shield and collision power, including Max speed, and the Max objects to be displayed.
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
                                    sequenceData = { name="lazer", start=1, count=3,  time=2500 , loopCount = 0,} ,
                                    power =10 ,
                        } 
                        
                        
            }

Also, statemachine.lua controls every aspect of which enemies are displayed and when, and this module is completely data driven as well. That is, if we initialise this module with location=0 -4, the game will be brought to that wave.
The simple tile engine is also a good example of data driven content; this module is explained in detail later.
Also within the application, HUD module text that is displayed on the screen is read from the JSON file, therefore allowing the content to be localised into different languages without having to rewrite code. As shown in the following table
{"GetWaveTxt":"Wave","GetLivesTxt":"Lifes","GetScoreTxt":"Points"}

As the complete game is data driven there are too modules to fully include in the document.

Use of imagesheets
There are plenty of examples of imagesheets within this game. The following table shows the majority of them. All graphics in this game have come from OpenSource and lostgarden.com and are fully licensed for use in non-commercial products.
 	Ships sequence 1 to 10, used
 	Tile Background   tile images, tiles 1,2,3,4,5,69 70,71 72,73 are used in the game 

 	The moving robot only frames 20 -29 used. 
 	The Worm enemy , when combined with physics creates the level boss as discussed later
 	Explosion , “fast” frames 1-5 used  and “full” by using all frames played over so many seconds completely controllable by data driven content
 	Flames used by the players exhaust system

Use of physics
Physics is widespread in the application from basic rotational direction force used by ground unit’s enemies, collisions of players, lasers, missiles, and enemies to advanced physics, including pivot joins defined by the Worm enemy. Some physics are handled by Coronas box 2-D physics engine and others by simple mathematics  helped by the vector module. 
In the ground unit module the Canon turret rotates to follow the user as shown by the following code snippet but this is more a definition of mathematics rather than physics.
--[[simple Trig Get the X axsis and Y between the 2 objects then get angle ]]
function groundEmemys:doRotate(plocationx,plocationy,angle)
    local tempx = plocationx
    local tempy = plocationy  
    local turnAngle = angle or 90
    local ememies = self.AllgroundEmemys
    local atancal = math.atan2
    for i = #ememies , 1, -1   do
        local object = ememies[i]
           if (object.x) then
                 local distanceX =  tempx - object.x
                 local distanceY =  tempy - object.y 
                 object.rotation = (atancal(distanceY ,distanceX )*radians)+ turnAngle ;
           end
    end     
end

The player’s spaceship location X and Y are passing to this function. The angle is just an offset that can be used to align to other images if needed, allowing complete reusability. However, it is not used in our game at the moment and is set to 90° as default. The Corona image is then rotated to the calculated angle, therefore giving the effect of a player being followed.

 


As shown the cannons rotate to the player’s current position and the projectile is also fired along the path as shown by the red dot
function groundEmemys:fireRamdomBullets(plocationx, plocationy, sec)
    local ememies = self.AllgroundEmemys
    local mineCount = tablex.icount(ememies)
    --local powerB = self.power
    local lazerinfoParams=self.lazerInfo
    
    if (mineCount > 0) then 
        local cannonToFire =  math.random(1,  mineCount )    
        local object = ememies[cannonToFire]
           if (object.x) then

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

Firstly, there is no need to have a projectile launching out of each cannon at the same time, as this would make the game too hard for the user. Instead a random canon is selected at a particular time interval and the projectile launched. The module loads the desired image to display as is driven by the initialisation table and using Pythagoras theorem and vector maths to move the projectile. This image is added to Coronas box 2-D physics engine so it can be used in collision detection later.
The Worm module (the Worm is the level boss) uses the same kind of technique to fire a missile at the player, but the missile follows the player, although after a particular amount of time the missile expires and deletes itself. This gives the user the advantage of not having too many missiles to evade. 
Enemies and projectiles are added to Coronas physics engine, and the collision event is registered. If any these objects collide in corona the following code is called although greatly reduced here 
         if  ((event.object1.myName == "enemy"  and event.object2.myName =="playerLazer") or
            (event.object2.myName == "enemy"  and event.object1.myName =="playerLazer") ) then
               -- print("Collision enemy + lazer  x = ".. event.object1.x .. " y = " .. event.object1.y)
                 --find the objects
                local enemy , lazer

                    if(event.object1.myName == "enemy") then 
                         enemy = event.object1
                         lazer = event.object2
                    else
                         enemy = event.object2
                         lazer = event.object1
                    end

                if(isEnemyDestroyed(enemy , lazer)) then
                        hudObject:updateScore(enemy.points)
                        explosionObject:PlayExplosion( enemy.x ,  enemy.y , "Explosion") 
                         --remove the objects
                        enemy:removeSelf()
                        enemy=nil
                        hud:removeTracker()  -- removetracking from hud
                else
                    explosionObject:PlayExplosion( enemy.x ,  enemy.y , "MiniExplosion") 
                    --update emeny hud .. 
                    hud:trackObject(enemy) -- add tracking of this object to the hud
                end
               --remove lazer
               lazer:removeSelf()
               lazer=nil

The above table shows a collision between an enemy and the player’s detected by using a name this will be re-factored in the final version to use category bits and masks that is a more elegant solution of detecting collisions between various objects.
Firstly both objects involved in the collision that is the laser and the enemy. Then a function is called to see if the enemy is destroyed or not, if destroyed the HUD module will be updated to update the score and the explosion sprite played. Finally these objects are then removed from memory as to not waste system resources.
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

Looking at the players laser fireLaser, function it can be seen that a force is applied to the laser to move it in the desired direction is the example of physics applyforce.
The use of advanced physics can be seen in the Worm enemy (The Boss Figure 4). Firstly this enemy is composed from a very simple spritesheet as shown in Figure 6 that contains around 12 simple red dots.  Firstly, the head is created that contains the worms eye, the head is then added to Corona box 2D physics engine, as a static body.  Each part of the tail is then constructed and attached to the previous tail or to head if it is the first link. These link objects are added to the physics bodies as a pivot joint to give a snake like movement.  The worm started out as an experiment to see what could be done with simple sprite sheets and physics and the results turned out to be very impressive. This Worm is then moved around the screen and the physics bodies react with one and other as shown in Figure 5, giving a fish like movement that in my opinion is very effective. Of course, like all other modules the Worm module is highly modular that is by just changing a few simple parameters, we can change the length of the tails add more tails etc. 

 
Figure 6
 
Figure 7 Worm Sprite Sheet

 
Figure 8 Coronas physics debug details  of worm squash and up against pressing against ground



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
                physics.addBody( link, "dynamic" )    
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

Use of modules for the reuse of code and/or content, 
Firstly there are lots of examples of code reuse and modularisation in the application as previously discussed. In addition, there is also plenty of content reuse, e.g. explosions are the same, simpletile engine and the parallax background scroller and some emery’s use a repeating sequence and these objects are simply swapped on-off-stage when needed.  In the simple tile engine, like all other modules is driven by a table. This table contents is then use to drive LoadPlaceTile(no ,y1) function . 
Example of simpletile JSON is shown below
{"numFrames":416,"filename":"assests/caveplatformer.png","sequence":[[1,"bottom"],[2,"bottom"],[3,"bottom"],[4,"bottom"],[5,"bottom"],[1,"bottom"],[2,"bottom"],[3,"bottom"],[4,"bottom"],[5,"bottom"],[1,"bottom"],[2,"bottom"],[3,"bottom"],[4,"bottom"],[5,"bottom"],[1,"bottom"],[2,"bottom"],[3,"bottom"],[4,"bottom"],[5,"bottom"],[165,"bottom"],[166,"bottom"],[167,"bottom"],[168,"bottom"],[169,"bottom"],[165,"bottom"],[166,"bottom"],[167,"bottom"],[168,"bottom"],[169,"bottom"]],"sheetContentWidth":832,"sheetContentHeight":512,"tileHeight":32,"tileWidth":32}
This JSON example simply states the imagesheet name “filename” , the number of frames contained in that image sheet “numFrames” the “sheetContentWidth” , “sheetContentHeight” ,  “tileHeight” and “tileWidth “ these are the standard imagesheet parameters used in Corona SDK, the sequence data table controls which frame sequence is to be displayed on screen. The JSON example above simply states that frame number one [1,"bottom"] of the image sheet “assests/caveplatformer.png" is to be displayed on the bottom of the screen and all sub sequential images are loaded to the display group for the next possible tile position. The speed parameter defines how fast the tiles moves in the right to left X direction 

OFSCREEN  X <0	ONSCREEN	X> Content width
1,"bottom	2"bottom"]	[3"bottom"]	[4"bottom"]	[5"bottom"]	[166"bottom"]	167  bottom	168"bottom"	169"bottom	1,"bottom



As the display is constantly moving from right to left as are the tiles. The images are always recycled from off-screen to on-screen. When the sequence runs out it is re-initialised with the first tile in the sequence that is moved in the tile engine. There are two display groups that each individual tile is added to this makes manipulation of each tile much easier as we only have to deal with the display group. As can be seen in the following code listing if the display group x position is less than minus the content width, display group moved to the other side of the screen else the display group is moved to the left position defined by the speed in the input table.
function SimpletileEngine:update(event)
    
    if (self.displayGroup1.x < -contentWidth) then  -- less than length of this seq
         self.displayGroup1.x = contentWidth -- sway
    else
         self.displayGroup1.x = self.displayGroup1.x - self.displayGroup1.sspeed
    end
    
    if (self.displayGroup2.x < -contentWidth) then
          self.displayGroup2.x= contentWidth
    else
        self.displayGroup2.x = self.displayGroup2.x - self.displayGroup2.sspeed
    end
end

SpaceParalax.lua. is also another great example of the painter’s model and content reuse. Like all other content in this application it is controlled by a table during the initialise function. The content of the table in JSON is as follows. 
[{"y":0,"x":0,"filename":"assests/backdrop.png","speed":0.5,"transparency":0.7},{"y":0,"x":480,"filename":"assests/backdrop.png","speed":0.5,"transparency":0.7},{"y":0,"x":480,"filename":"assests/parallax80.png","speed":1,"transparency":0.2},{"y":0,"x":0,"filename":"assests/parallax80.png","speed":1,"transparency":0.2},{"y":0,"x":480,"filename":"assests/parallax100.png","speed":1.2,"transparency":0.8},{"y":0,"x":0,"filename":"assests/parallax100.png","speed":1.2,"transparency":0.8}]
This module gives the effects of the star field simulation. The images that have been used have been supplied by deviant art. It also implements the same kind of technique as the tile engine described earlier in that when an image falls off-screen in the X direction it is swapped to the other side of the screen ready for redisplay, simply loading one set of each image to the display screen and the other set of images to an off-screen buffer and keep swapping them, as described in class earlier this term.
This technique uses the painter’s model and transparency to give the effect of distance (parallax). Each layer in is moving at different speeds and all layers are visible, when one layer simply falls off-screen. It is swapped with the off-screen buffer and now this buffer is made visible. This module is driven by the JSON above in which the X and Y parameters define where the images to be placed on screen. Loading the same image backdrop twice one onscreen defined by its coordinates X and Y (0,0) and the other off-screen X (480, 0).  Of course this is assuming that the screen width is 480 units this would need to be calculated in production code. Different layers of these images blend together and moving at different speeds provides a sense of depth and distance. 

The reason why one image is loaded on screen and the other one off-screen is to reduce flicker in the game.
Mines are further examples of content reuse, that is when a mine x value is less than zero, i.e it is off-screen, the mine module is reinitialised, with a different amplitude and speed. This is shown in the following snippet from mines.lua
    for i = #emenies , 1, -1  do
        local object = emenies[i]
           if (object.x) then
               if object.x <= -10 then  -- if it has gone offscreen
                    object.x= display.contentWidth + 30
                    
                    object.sspeed =Random(sspeed_min,sspeed_max)
                    object.amp =Random(amplitude_min,amplitude_max)
                    object.angle = Random(angle_min,angle_max)
                    
                    --bottom bounds
                   -- local maxh = object.amp * math.sin( object.angle);
                    local y =  (display.contentHeight /Random(1,4))


Installing on a device
This application has been successfully executed on an android device. However under the simulator, it did not seem to matter which case the filenames were written in when installed on the device. The case did seem to matter to correct this all filenames were renamed to lowercase.  To find these errors, the android debugger had to be attached to a physical android device, after some modification the application work perfectly on the device the footprint size of the game is less than 22 MB.  
However, it was not tested on an Apple iOS device but the simulator was execute with as many different display configurations as possible and after tweaking config.lua and build.lua these displays worked correctly.
Conclusion
For this assignment a game has been completed, the game has been completed in a highly modular way, which means that different levels and enhancements can easily be added. In addition, all content is completely data driven and can be modified by designers without needing to modify any code. This data driven content can even control the movements of the enemy. Therefore, a designer can completely design a complete level of this game with little or no code modifications. At the moment all JSON files are located in the documents directory however research will need to be done to find out what the best directory is to store these data driven files, so they will work optimally on all devices.
The application was also transferred to device it was found that the touch events in the simulator worked much different than that of the real device. So the advice would be to move your application to device and test as quick as possible.
Developing this application also shows that simple Spritesheets combined with complex physics joins and code construction can create interesting display effects. This application also shows that very few assets are actually required to make a game and in addition by swapping images on and off-screen keeps memory and on the device to minimum and assets required to a minimal, the colour of these assets can also be changed to change the look and feel of these images completely.  
Implementing data driven content from the start also enabled the application to be easily adapted to save the program state. That is if the user is receiving a phone call the game should resume from where it left off, and this application provides those requirements.
With a little more work and polishing this game could be released in the App store or Google play. To do so there would need to add a storyboard module to control the current scene. In addition a user interaction story to engage the user in game plays. Some sounds and music would also need to be added to create a fully-fledged published application. 
The controls of the player object would need to be tested by different gamers to see what people preferred the most. 
All graphics in this game have come from OpenSource ART, lostgarden.com and deviant art and are fully licensed for use in non-commercial products. Two functions in the module core have been taken from Corona’s website, for details, please see core.lua, sounds used in this game are also open source and free to use in non-commercial applications.
Corona also proved that it is an easy language to operate although personally, I did notice the garbage collection can be a bit slow and is better, sometimes to remove objects and null out their handles physically keeping memory consumption to a minimum as after all, Corona is a mobile development platform.
