
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



local contentWidth = display.contentWidth
local contentHeight = display.contentHeight
local halfcontentWidth = display.contentWidth /2

local hud = {}

function hud.new()
    hud.displayGroup =display.newGroup()
    hud.emenyPowerGroup =display.newGroup()
    hud.sheildG =display.newGroup()
    hud.score = 0;
    return hud
 end

function hud:initialise(params)
    
    if (params==nil) then --error no parameters use default
        params={}
        params.GetScoreTxt = "Score"  -- for localization if needed if not default to English
        params.GetWaveTxt  = "Wave"  -- for localization if needed if not default to English
        params.GetLivesTxt = "Lifes" -- for localization if needed if not default to English
        params.GetMaxTxt  = "Max Score" 
    end
    
    local emenyPowerGroup = self.emenyPowerGroup
    local displayGroup = self.displayGroup
    local sheildG =  self.sheildG
    
    self.MaxScore = 0
   
    self.textScore = params.GetScoreTxt   -- for localization if needed if not default to English
    self.textWave =  params.GetWaveTxt  -- for localization if needed if not default to English
    self.textLifes = params.GetLivesTxt  -- for localization if needed if not default to English
    self.textMax =   params.GetMaxTxt
    
    self.myScore = display.newText( params.GetScoreTxt, contentWidth - 95 , 10, native.systemFont, 16 )
    self.myScore:setFillColor( 1, 0, 0 )
    self.myLifes = display.newText( "", contentWidth -  halfcontentWidth/4, contentHeight -20, native.systemFont, 16 )
    self.Wave = display.newText(  params.GetWaveTxt ,  halfcontentWidth/8, 10, native.systemFont, 16 )
    
    self.maxScore = display.newText(  self.textMax, contentWidth - contentWidth/2 + 20, 10, native.systemFont, 16 )
    
    displayGroup:insert(self.myScore)
    displayGroup:insert(self.myLifes)
    displayGroup:insert(self.Wave)
    
    self.Shield = display.newRect( 100 , 10, contentWidth/5 , 10 )
    self.Shield2 = display.newRect(101 , 10, contentWidth/5 , 8 )  -- otline of the sheild
  
      
    self.Shield.anchorX = 0
    self.Shield2.anchorX = 0
    
    self.Shield2:setFillColor( 0,128, 0 )
  
    sheildG:insert(self.Shield)
    sheildG:insert(self.Shield2)
    sheildG.anchorX = .5
    sheildG.anchory = .5
    
    
        
    self.objectShield =  display.newRect(20,10,30,4)
    self.objectShield2 = display.newRect(20,10,30,3) 
    self.objectShield.anchorX = 0
    self.objectShield2.anchorX = 0
    
  
    
    self.objectShield2:setFillColor( 80,150, 0 )
    
    emenyPowerGroup:insert(self.objectShield)
    emenyPowerGroup:insert(self.objectShield2)
    emenyPowerGroup.anchorX = .5
    emenyPowerGroup.anchory = .5
    
    self.trackingObject = {}
    self.isupdate = false
  --  displayGroup:insert(self.Shield)
    
 
end

function hud:getScore()
       return self.score
end

function hud:updateScore(value)
       self.score = self.score + value
       self.myScore.text= self.textScore .. self.score
       if self.score > self.MaxScore then
           self.MaxScore = self.score
          self.maxScore.text =  self.textMax ..  self.MaxScore 
       end
end
function hud:updateWave(value)
    self.Wave.text= self.textWave .. value     
end
function hud:getState(value)
    local hudState = { }
    hudState.score =  self.score
    hudState.MaxScore = self.MaxScore
    return hudState
end

function hud:setState(hudState)
    self.score = hudState.score
    self.MaxScore = hudState.MaxScore
    self.myScore.text= self.textScore .. self.score
    self.maxScore.text =  self.textMax ..  self.MaxScore 
end

function hud:updateLifes(value)
       self.myLifes.text= self.textLifes .. value
end
function hud:updateSheild(value)
    local percent =  self.Shield.width/100 
    local percentile = (value / self.Shield.width ) * 100
    if(percentile < (percent *25)) then  -- less than 25% change color
          self.Shield2:setFillColor( 155,0, 0 )
    elseif (percentile > (percent *25) and percentile  < (percent *75) ) then
         self.Shield2:setFillColor( 80,150, 0 )  -- yelllow
    else
         self.Shield2:setFillColor( 0,128, 0 ) -- green
    end

    self.Shield2.width = percentile
  
end
function hud:removeTracker()
    self.trackingObject = nil
    self.isupdate = false
end
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
function hud:update(event)
    local  emenyPowerGroup = self.emenyPowerGroup
    if (self.isupdate == true and self.trackingObject ~=nil) then
         local bounds = self.trackingObject.contentBounds 
         if(bounds ~=nil) then
            emenyPowerGroup.isVisible = true
            emenyPowerGroup.y=self.trackingObject.y - (self.trackingObject.height)  --   bounds.xMin 
            emenyPowerGroup.x=bounds.xMin 
           end
    else
       self.isupdate = false
       emenyPowerGroup.isVisible = false
    end
 
end

return hud









