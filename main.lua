
 
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

local image = display.newImage( "assests/backdrop.png" )
local text = display.newText( "Press to Start Game",150 ,150 ,font, 20 )
image.anchorX = 0; image.anchorY = -1
text.anchorX = 0; text.anchorY = -1
local game ={}

local backgroundMusic = audio.loadStream( "assests/tgfcoderfrozenjam.mp3" )


local function start_pressed()
    text:removeSelf() -- remove the text object no longer needed could also remove the eventlistener, but gets destroyed anyhow
    text = nil
    audio.stop()
    game = require ("gamemain")
    return true  -- stop propergation
end



text:addEventListener( "touch", start_pressed )
local backgroundMusicChannel = audio.play( backgroundMusic, { channel=1, loops=-1, fadein=5000 } )
