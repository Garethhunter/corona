
local SpaceParalax = {}

function SpaceParalax:LoadImages(name , x , y , s , alpha)
    print(name .. " " .. x .. " "  ..  y .. " " .. s .. " " ..  alpha )
    local stars= display.newImage(name)
    stars.anchorX = 0; stars.anchorY = -1
    stars.x = x;  stars.y = y ;  stars.sspeed = s;
    stars.alpha = alpha
    table.insert(self.imageArray, stars)
end

function SpaceParalax:initialise(parralaxInfoParams)
    for i = #parralaxInfoParams , 1, -1 do
        local value = parralaxInfoParams[i]
        SpaceParalax:LoadImages(value.filename , value.x , value.y , value.speed , value.transparency)
    end
end

function SpaceParalax:new()
     SpaceParalax.imageArray = {}
     return SpaceParalax
end
function SpaceParalax:update(event)
    local imageArray = self.imageArray
    for i =1 ,#imageArray, 1 do
        local object = imageArray[i]
           if (object.x) then
                if object.x <= - (display.contentWidth) then
                    object.x =  display.contentWidth
                else
                    object.x = object.x - object.sspeed
                end
            end
        end
end
return SpaceParalax

