 
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





local physics = require ('physics') -- using physics in game
system.activate("multitouch") --also using multitouch
--physics.setDrawMode("hybrid") -- for debug
physics.start() --start the physics
physics.setGravity(0, 0) -- pull down by 0 and across 0 
local lastUpdateTime = 0 -- used to calcaulte the delta speed of the player so it moved at a constant speed
-- the star field , load up images one onscreen another off , then swap them around
-- 3 differnt layers , and moving at different speeds giving a parralax effect
local paramsHandler = require("core.parameter") -- the data handler handles all our data driven context
--get the parameters from file or form defaults
paramsHandler.new() -- create the default data or read it from files

local parralax = require ('spaceparalax')  --require the starfield
local playership = require('playership.playership') -- the player ship
local simpletileengine = require ('tilesets.simpletileengine') -- our tile engine
local hud = require('hud.hud') -- the hud that contains the head up display
local lazers = require ('lasers.playerlasers') -- the players lazers
local explosion = require ('explosion.explosions') -- the explosion infomation
local statemachine = require ('statemachine') -- the game controlller , controls the emenys


local parralaxInfoParams = paramsHandler.GetParralaxInfoParams() -- get the data for the parrakax object
local tileinfoParams = paramsHandler.GettileinfoParams()  -- get the data for the tile engine
local hudinfoParams = paramsHandler.GethudinfoParams()--  get the data for the HUD display
local playerinfoParams =  paramsHandler.GetplayerinfoParams() --  get the data for the player info 
local explosioninfoParams =  paramsHandler.GetexplosioninfoParams() --  get the data for the explosion object
local explosioninfoParams1 = paramsHandler.GetexplosioninfoParams1() --  get the data for the explosion1 object
local lazerinfoParams =  paramsHandler.GetlazerinfoParams() --  get the data for the player lazer object
--changing this locations jumps to the sublevel 0 - 4
local stateMachine=  paramsHandler.GetstateMachine() --  get the data for the statemachine object

--create the different display objects
local parralaxObject = parralax.new() --start 
parralaxObject:initialise(parralaxInfoParams)
local tileObject = simpletileengine.new()
local playerObject = playership.new()
local hudObject = hud.new()  --setup the display group
local lazerObject = lazers.new()
local explosionObject = explosion.new()
local statemachineObject = statemachine.new()

--initialise all objects with the data driven context
tileObject:initialise(tileinfoParams)
hudObject:initialise(hudinfoParams)
playerObject:initialise(playerinfoParams)
lazerObject:initialise(lazerinfoParams) --to get position of the bullet starting point
explosionObject:	initialise(explosioninfoParams)
statemachineObject:initialise(stateMachine)
                
                  
-- create a body on bottom of screen to have physics collide the ground..
local ground = display.newRect( 0, display.contentHeight +10, display.contentWidth * 2, 10 )
print (display.contentWidth)
physics.addBody( ground, "static" )



local backgroundMusic = audio.loadStream( "assests/tgfcoderfrozenjam.mp3" )
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )
local playMusic = false
local pausegame =false


--checks if the emeny is destroyed , takes a lazer and ememy as parameters checks decrements the ememys health with
-- the power of the current lazer , returns true if the ememy is destroyed else a false

local function isEnemyDestroyed(enemy , lazer)
    local destroyed =false
    enemy.health = enemy.health - lazer.power
    if(enemy.health <= 0) then
        destroyed = true
    end
    return destroyed
end
--disable collesions for a few seconds gives hero invunerbility for few seconds
-- something hit the player "hero" , calcualte the damange 
local function calculatePlayersHealth(ememy , player)
     --get strength of emeny
     --get sheild strength of player
     local power= playerObject:ShieldPower(ememy.collisionpower)
     if( power <= 0) then
         explosionObject:PlayExplosion( player.x  ,  player.y  , "Explosion") 
         playership:GetObject().isVisible = false
         local text = display.newText( "Game Over" ,display.contentWidth/2 ,display.contentHeight/2 ,font, 60 )
         --game over
     end
     explosionObject:PlayExplosion( player.x  ,  player.y  , "MiniExplosion") 
     hudObject:updateSheild(power)
end

    
--explained in detail in the report , something collied in the box 2d physics engine

local function processCollision(event)
       
       if  ((event.object1.myName == "enemy"  and event.object2.myName =="playerLazer") or
            (event.object2.myName == "enemy"  and event.object1.myName =="playerLazer") ) then
            --    print("Collision enemy + playerLazer  x = ".. event.object1.x .. " y = " .. event.object1.y)
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
                        if( playMusic == false ) then
                         
                                end
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
    
     -- we have player collision --reduce palyers sheilds           
    elseif ((event.object1.myName == "enemy"  and event.object2.myName =="player") or
            (event.object2.myName == "enemy"  and event.object1.myName =="player") ) then
                 print("Collision with enemy and Player x = ".. event.object1.x .. " y = " .. event.object1.y)
                 local enemy , jet

                    if(event.object1.myName == "enemy") then 
                         enemy = event.object1
                         jet = event.object2
                    else
                         enemy = event.object2
                         jet = event.object1
                    end
         
            calculatePlayersHealth(enemy , jet)
     
     
      elseif ((event.object1.myName == "enemyb"  and event.object2.myName =="player") or
              (event.object2.myName == "enemyb"  and event.object1.myName =="player") ) then
        --         print("Collision with enemyb and Player x = ".. event.object1.x .. " y = " .. event.object1.y)
                 local enemy , jet

                    if(event.object1.myName == "enemyb") then 
                         enemy = event.object1
                         jet = event.object2
                    else
                         enemy = event.object2
                         jet = event.object1
                    end
         
          calculatePlayersHealth(enemy , jet)
          enemy:removeSelf()
          enemy=nil
     
     
        -- we have player collision --reduce palyers sheilds   
        
        
        elseif  ((event.object1.myName == "enemyb"  and event.object2.myName =="playerLazer") or
                 (event.object2.myName == "enemyb"  and event.object1.myName =="playerLazer") ) then
                  print("Collision enemyb + playerLazer  x = ".. event.object1.x .. " y = " .. event.object1.y)
                 --find the objects
                   local enemy , lazer

                    if(event.object1.myName == "enemyb") then 
                         enemy = event.object1
                         lazer = event.object2
                    else
                         enemy = event.object2
                         lazer = event.object1
                    end

                if(isEnemyDestroyed(enemy , lazer)) then
                        --hudObject:updateScore(enemy.points)
                      --  explosionObject2:PlayExplosion( enemy.x ,  enemy.y , "ex1") 
                       explosionObject:PlayExplosion( enemy.x ,  enemy.y , "MiniExplosion") 
                         --remove the objects
                           if( playMusic == false ) then
                         
                            end
                        enemy:removeSelf()
                        enemy=nil
                  else
                    explosionObject:PlayExplosion( enemy.x ,  enemy.y , "MiniExplosion") 
                    --update emeny hud .. 
                end
               --remove lazer
               lazer:removeSelf()
               lazer=nil
    end
   -- inupdate =false        
    return true  
 end
                
                
local function onCollision(event)
  --  print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
    --inupdate =true
    if ( event.phase == "began" and pausegame == false ) then
          processCollision(event)
    elseif ( event.phase == "ended" and pausegame == false) then
     --   print( "ended: " .. event.object1.myName .. " & " .. event.object2.myName )
    end
    return true -- collision handled 
 end


local lastseq=0
-- the gameloop , processing to be kept to minium here ,
local function Update(event)
    if(pausegame == true) then
        return true
    end
    
    local time = event.time
    statemachineObject:update(event , playerObject:GetPositionX(), playerObject:GetPositionY())
    local seq =statemachineObject:getSeq()
    if (lastseq ~= seq ) then
           hud:updateWave(seq)
           lastseq = seq
    end
    if(seq==5) then
     
         -- dont move tiles        
    else
        tileObject:update(event)
    end
    parralax:update(event)
    hud:update(event)
    lastUpdateTime = time
    return true -- update handled
end


local function unloadGame()
    physics.stop()
end

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


local function pause_game()
    
    physics.stop()
    pausegame = true
    
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
--chek the memory of the system
--used this to check for memory leaks ect
local monitorMem = function()
    collectgarbage()
    print( "MemUsage: " .. collectgarbage("count") )
    local textMem = system.getInfo( "textureMemoryUsed" ) / 1000000
    print( "TexMem: " .. textMem )
end


local trans 
local bounds = display.contentWidth * .75
local topbounds = 30 
-- our multitouch event handler
-- only accept the ended in each event , like the tap
-- I added this as was looking to expand as stated in the report
local function multitouchListener( event )
  if (event.x > bounds and pausegame == false) then
      if (event.phase == "ended") then  -- only fire the lazer when event ended
           -- if( playMusic == false ) then audio.play( lazerAudio ) end
            lazerObject.fireLazer( playerObject:GetPositionX(),playerObject:GetPositionY())
     
      end
  else
       if (event.y > topbounds and pausegame == false )  then
             if (event.phase == "ended") then --move the player only on the end event
                playerObject:move(event.x , event.y)
             end
                 if (event.phase == "cancled") then --move the player to the start location
                playerObject:move(event.startX , event.startY)
                end
        end
   end
   return true -- event handled stop further dispatch
end

--move into hud object when finished
--to do move to hud..

local pause = display.newImage("assests/pause.png")
pause.x = display.contentWidth - 10
pause.y = 10

local stopmusic = display.newImage("assests/sound_on.png")
stopmusic.x = display.contentWidth - 35
stopmusic.y = 10

function pause:tap(event)
    if(pausegame == false) then
        pause = display.newImage("assests/play.png")
        pause.x = display.contentWidth - 10 pause.y = 10
        pausegame =true
        physics.pause()
    else
        pause = display.newImage("assests/pause.png")
        pause.x = display.contentWidth - 10 pause.y = 10
        pausegame =false
        physics.start()
    end
    return true  -- stop propergation
end
function stopmusic:tap()
   if( playMusic == false) then
        stopmusic = display.newImage("assests/sound_off.png")
        stopmusic.x = display.contentWidth - 35    stopmusic.y = 10
        playMusic = true
        audio.stop()
   else
        stopmusic = display.newImage("assests/sound_on.png")
        stopmusic.x = display.contentWidth - 35   stopmusic.y = 10        
        playMusic = false
        backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )
    end
    return true  -- stop propergation
end

pause:addEventListener( "tap", pause )
stopmusic:addEventListener("tap" , stopmusic)
Runtime:addEventListener( "touch", multitouchListener )
Runtime:addEventListener( "system", onSystemEvent )
timer.performWithDelay(10000, monitorMem, 0)
Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("enterFrame", Update)    

-- only loads if the users has shields left else just loads the max score
load_saved_state()  -- load the score the players location , the current wave , the players shield , max score ect , ie the state load it to resume


