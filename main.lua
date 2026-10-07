-- Dependencies

local UIButton = require("Classes.UIButton")
local GameHandler = require("Handlers.GameHandler")
local GameData = require("Handlers.GameData")
local SaveHandler = require("Handlers.SaveHandler")
local EventHandler = require("Handlers.EventHandler")

-- Libraries
shove = require("libraries.shove")


function love.load()
    -- Bootup Debug
    print("Running Main")

    GameHandler.ChangeState("Loading")

    local major, minor, revision, codename = love.getVersion()
    print(string.format("Version: %d.%d.%d - %s", major, minor, revision, codename))

    SaveHandler.Load()
    EventHandler.Init()


    -- Shove Library Configs (For Drawing)
    shove.setResolution(1280, 720, {fitMethod = "aspect"})
    shove.setWindowMode(1280, 720, {resizable = true})

    local function onClick()
        GameData.Data.playerData.Money = GameData.Data.playerData.Money + 1
        SaveHandler.Save()
        
    end

    local myButon = UIButton.new("TestButton", 300, 300, 100, 100, onClick)

end

function love.quit()
    SaveHandler.Save()
end

function love.update(dt)
    GameHandler.Update(dt)
end


function love.draw()
    shove.beginDraw()

    GameHandler.Draw()
    shove.endDraw()
end

function love.resize(w, h)
   shove.resize(w, h)
end

function love.mousepressed(x, y, button, isTouch, presses)
     EventHandler.FireEvent("MouseInputEvent", {x, y, button})
end

function love.keypressed(key)
    EventHandler.FireEvent("KeyboardInputEvent", {key})
end