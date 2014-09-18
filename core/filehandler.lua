


local json = require("json")

local fileHandler = {}

function fileHandler.saveTable(jsonTable, filename, location)
    local path = location or system.DocumentsDirectory
    local filePath = system.pathForFile( filename, path)
    local fileHandle = io.open(filePath, "w")
    if fileHandle then
        local contents = json.encode(jsonTable)
        fileHandle:write( contents )
        io.close( fileHandle )
        return true
    else
        return false
    end
end
 
function fileHandler.loadTable(filename, location)
    local path = location or system.DocumentsDirectory
    local filePath = system.pathForFile( filename, path)
    local file = io.open( filePath, "r" )
    if file then
        local jsonTable = {}
        local fileContents = file:read( "*a" )
        jsonTable = json.decode(fileContents);
        io.close( file )
        return jsonTable
    end
    return nil
end

return fileHandler
