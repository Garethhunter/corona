--calculate the aspect ratio of the device:
local aspectRatio = display.pixelHeight / display.pixelWidth

application = {
   content = {
      width = 320,
      height = 480 ,
      scale = "zoom",
      fps = 30,

      imageSuffix = {
         ["@2x"] = 1.5,
         ["@4x"] = 3.0,
      },
      
      iphone = {
        plist = {
            UIApplicationExitsOnSuspend = false,
            }
            }
            
      
   },
}