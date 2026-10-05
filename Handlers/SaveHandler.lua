-- Dependencies
local json = require("libraries.json")
local GameData = require("Handlers.GameData")


local SaveHandler = {}

SaveHandler.fileName = "rapio_save.json"

SaveHandler.DefaultData = {
    GameData.Data
}

local function copyTable(target)
    local targetType = type(target)
    local copy
    if targetType == "table" then
        copy = {}
        
        for i, v in pairs(table) do
            copy[i] = copyTable(v)
        end

        else
            copy = target
    end
    return copy
end

function SaveHandler.Save()
    local data = GameData.Data
    local sucsess, encodedString = pcall(json.encode, data)
    
    if not sucsess then
        warn("DATA COULD NOT BE ENCODED DID NOT SAVE!")
        return
    end

    local writeSucsess, err = love.filesystem.write(SaveHandler.fileName, encodedString)
    if writeSucsess then
        print("Data Saved!")
        return true
    else
        print("Failed To Write Save!")
        return
    end
end


function SaveHandler.Load()
    local info = love.filesystem.getInfo(SaveHandler.fileName)

    local function useDefaults()
        print("Loading Defaul Data")
        GameData.Data = copyTable(SaveHandler.DefaultData)
        SaveHandler.Save()
    end

    if not info then
        print("No Data To Load!")
        useDefaults()
        return
    end

    local contents, size = love.filesystem.read(SaveHandler.fileName)

    if not contents then
        print("No Contents! Cant load")
        useDefaults()
        return
    end

    local succ, decodedData = pcall(json.decode, contents)
    if succ and type(decodedData) == "table" then
        print("Save File Loaded!")
        print("Loaded From:", love.filesystem.getRealDirectory(SaveHandler.fileName))
        print(contents)
        GameData.Data = decodedData
    end


end





return SaveHandler