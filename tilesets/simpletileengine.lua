
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


--break bottom screen into 15X 32 pixels rectangle
--load tiles from our image sheet-- 
--load our 15 tiles onscreen
--load 15 tiles offscreen
--swap between on screen and off screen
--put tiles into a display group
--put othe tiles into another display group
-- image sheet is 26 x 16
-- load into image sgeet 32 X 32

 local contentWidth = display.contentWidth
 local contentHeight = display.contentHeight

local SimpletileEngine = {}

function SimpletileEngine.new()
        --create new display group to display
        SimpletileEngine.displayGroup1 =display.newGroup()
        SimpletileEngine.displayGroup2 =display.newGroup()
        return SimpletileEngine
 end
 
 function SimpletileEngine:initialise(params)
        -- local params = inputParams["tileinfo"]
        SimpletileEngine.tileHeight = params.tileHeight
        SimpletileEngine.tileWidth = params.tileWidth
        local tileframes = params.numFrames or 416
        local tilesheetContentWidth = params.sheetContentWidth
        local tilesheetContentHeight = params.sheetContentHeight
        local imageSheetFile =  params.filename
        local speed = params.speed or 1
        local sequence = params["sequence"]  -- get the sequence to display tiles
        SimpletileEngine.options =
        {
             width = SimpletileEngine.tileHeight,
             height =  SimpletileEngine.tileWidth,
             numFrames = tileframes,
             sheetContentWidth = tilesheetContentWidth,  -- width of original 1x size of entire sheet
             sheetContentHeight = tilesheetContentHeight, -- height of original 1x size of entire sheet
        }
        SimpletileEngine.pos=0
        SimpletileEngine.imageSheet = graphics.newImageSheet(imageSheetFile, SimpletileEngine.options)
        SimpletileEngine.displayGroup1.sspeed=speed
        SimpletileEngine.displayGroup2.sspeed=speed 
        self:loadSequence(sequence)
   end
   
 function SimpletileEngine:loadSequence(mySequence)
        --get the table data
     for key,value in pairs(mySequence) do 
                 local positiony;
                   if (value[2]== "bottom") then positiony=contentHeight - SimpletileEngine.tileWidth   else positiony=value[2] end
                      self:LoadPlaceTile(value[1] ,  positiony )
     end    
 end
  function SimpletileEngine:setTileColor()
      
    
      
  end
 
 
function SimpletileEngine:LoadPlaceTile(no ,y1)
    --local x = x1 or 0
    local y = y1 or 0
    
    local tile= display.newImage( SimpletileEngine.imageSheet, no)
    tile.anchorX = 0 tile.anchorY = -1
    self.pos=self.pos + SimpletileEngine.tileWidth 
    tile.x = self.pos   tile.y = y1   tile.sspeed = 1
        if (self.pos >= contentWidth) then
            tile.x = self.pos -contentWidth  tile.y = y   tile.sspeed = 1
            self.displayGroup2.x = contentWidth
            self.displayGroup2:insert( tile )
    else
        self.displayGroup1:insert( tile ) 
    end

end

function SimpletileEngine:update(event)
    
    if (self.displayGroup1.x < -contentWidth) then  -- lessthan length of this seq
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


return SimpletileEngine

