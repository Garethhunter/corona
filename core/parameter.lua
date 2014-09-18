

-- if the files param do not exist use defaults else 
-- load the defaults
-- to set up the data driven context
local filehandler = require("core.filehandler")
local params = {}


function params.new()
    params.parralaxInfoParams = {}
    params.loadParams()
    return params
end
-- check to see if the files exist if they do .. then read the files , if they do not create default
-- and save the default contents
--try load the param file if fails set the values to the default for each of our
--object settings
function params.loadParams()
    print("loading Params file")
    --load tbale returns nil if fails to load the file, therefore use the default.
    params.tileinfoParams =  filehandler.loadTable("tileinfoparams.json") or params.tileinfoparamsDefault()
    params.hudinfoparams = filehandler.loadTable("hudinfoparams.json") or params.hudinfoparamsDefault()
    params.playerinfoParams=   filehandler.loadTable( "playerinfoparams.json") or params.playerinfoparamsDefault()
    params.explosioninfoParams=  filehandler.loadTable("explosioninfoparams.json") or params.explosioninfoparamsDefault()
    params.explosioninfoParams1 = filehandler.loadTable("explosioninfoparams1.json") or params.explosioninfoparams1Default()
    params.lazerinfoParams =  filehandler.loadTable("lazerinfoparams.json") or params.lazerinfoparamsDefault()
    params.parralaxInfoParams = filehandler.loadTable("parralaxinfoparams.json") or params.parralaxinfoparamsDefault()    
    params.stateMachine = filehandler.loadTable("statemachineinfoparams.json") or params.statemachineDefault()
end

-- no need to save as modified by designer , but added just incase needed , can delete...
--helpful to see the syntax of the JSON data
function params.saveParams()
    print("saving files")
    filehandler.saveTable(params.tileinfoParams, "tileinfoparams.json")
    filehandler.saveTable(params.hudinfoParams, "hudinfoparams.json")
    filehandler.saveTable(params.playerinfoParams, "playerinfoparams.json")
    filehandler.saveTable(params.explosioninfoParams, "explosioninfoparams.json")
    filehandler.saveTable(params.explosioninfoParams1, "explosioninfoparams1.json")
    filehandler.saveTable(params.lazerinfoParams, "lazerinfoParams.json")
    filehandler.saveTable(params.parralaxInfoParams, "parralaxInfoParams.json")    
end
--getters get the table data
function params.GetParralaxInfoParams()
    local tablepar = params.parralaxInfoParams
    return tablepar
end
function params.GettileinfoParams()
    return params.tileinfoParams
end
function params.GethudinfoParams()
    return params.hudinfoParams
end
function params.GetplayerinfoParams()
    return params.playerinfoParams
end
function params.GetexplosioninfoParams()
    return params.explosioninfoParams
end
function params.GetexplosioninfoParams1()
    return params.explosioninfoParams1
end
function params.GetlazerinfoParams()
    return params.lazerinfoParams
end
function params.GetstateMachine()
    return params.stateMachine
end


--sets up default parameters values
function params.parralaxinfoparamsDefault()
    params.parralaxInfoParams = {
        { filename = "assests/backdrop.png" ,   x=0 , y=0 , speed = .5 , transparency = .7 , },
        { filename = "assests/backdrop.png" ,   x=display.contentWidth , y=0 , speed = .5 , transparency = .7, },
        { filename = "assests/parallax80.png" , x=display.contentWidth , y=0 , speed = 1, transparency = .2 , },
        { filename = "assests/parallax80.png" , x=0, y=0 , speed = 1, transparency = .2, }, 
        { filename = "assests/parallax100.png" ,x=display.contentWidth , y=0 , speed = 1.2 , transparency =.8 , },
        { filename = "assests/parallax100.png" ,x=0 , y=0 , speed = 1.2 , transparency = .8 , },
    }
    return params.parralaxInfoParams
end
function params.tileinfoparamsDefault()
    params.tileinfoParams = { 
              tileHeight = 32 ,
              tileWidth = 32,
              numFrames =416,
              sheetContentWidth = 832,
              sheetContentHeight = 512,
              filename = "assests/caveplatformer.png" , 

              sequence = {  {1, "bottom"} , {2,"bottom"} , {3,"bottom"} , {4, "bottom"}  , {5 ,"bottom"},
                            {1, "bottom"} , {2,"bottom"} , {3,"bottom"} , {4, "bottom"}  , {5, "bottom"},
                            {1, "bottom"} , {2,"bottom"} , {3,"bottom"} , {4, "bottom"}  , {5, "bottom"},

                            {1, "bottom"} , {2,"bottom"} , {3,"bottom"} , {4, "bottom"}  , {5, "bottom"},
                            {165, "bottom"} , {166,"bottom"} , {167,"bottom"} , {168, "bottom"}  , {169, "bottom"},
                            {165, "bottom"} , {166,"bottom"} , {167,"bottom"} , {168, "bottom"}  , {169, "bottom"},
              }
    }
    return params.tileinfoParams
end
function params.hudinfoparamsDefault()
        
    params.hudinfoParams ={  
            GetScoreTxt = "Points" , -- for localization if needed if not default to English
            GetWaveTxt  = "Wave" , -- for localization if needed if not default to English
            GetLivesTxt = "Lifes" ,-- for localization if needed if not default to English}
            GetMaxTxt  = "Max Score" 
    
    }
     return params.hudinfoParams
 end
function params.playerinfoparamsDefault()
         params.playerinfoParams = {
                                playerImage ="assests/redjet.png",
                                radius = 10,
                                maxSpeed = 5,
                                shield = 100,
                                power = 1,
                                exhaust = {exhaustfile ="assests/thrustyellow.png" , size=128, numFrames=24 ,                          
                                            rotate = -270,
                                            scalex =.2, 
                                            scaley=.4 ,
                                            time= 800,
                                            size = 128,
                                            },
       }
       return params.playerinfoParams
end
function params.explosioninfoparamsDefault()
    params.explosioninfoParams = {
            imageSheet = "assests/explosion0023.png", 
            options = { width = 192,    height = 192,   numFrames = 40,} , 
            sequenceData = {
                            { name="MiniExplosion", frames={ 1,2,3,4,5},time = 250,loopCount = 0},
                            { name="Explosion", start=1, count=40,  time=1000 , loopCount = 0,},
                            }
            }
    return params.explosioninfoParams
end
function params.explosioninfoparams1Default()

    params.explosioninfoParams1 = {
            imageSheet = "assests/explosion43fr.png" , 
            options = { width = 93,    height = 100,   numFrames = 40,} , 
            sequenceData = {{name="ex1", start=1, count=40 , time=5000 , loopCount = 1,},  
                            { name="ex2", start=10, count=10 , time=1200 , loopCount = 1,},
                            { name="ex3", start=20, count=10, time=300 , loopCount = 1,}
            }

        }
    return params.explosioninfoParams1
end
function params.lazerinfoparamsDefault()
    params.lazerinfoParams = { 
                imageSheet = "assests/greenlazers.png",
                options = { width = 20,    height = 14,   numFrames = 3,}  ,
                sequenceData = { name="Explosion", start=1, count=3,  time=1500 , loopCount = 0,} ,
                power =5 ,
       }
       return params.lazerinfoParams
end
function params.statemachineDefault()
--changing this wave jumps to the sublevel 0 - 4
    params.stateMachine= {
           location = 0,
     } 
    return params.stateMachine
end
--just pass into the json file
function params.saveTable(StateTable , filename)
    filehandler.saveTable(StateTable, filename)
end
--just read from the json file
function params.loadTable(filename)
   
   return  filehandler.loadTable(filename)
   
end


return params


