-- Dependencies

local UIHandler = require("Handlers.UIHandler")
local UIButton = require("Classes.UIButton")
local GameHandler = require("Handlers.GameHandler")
local GameData = require("Handlers.GameData")

-- Libraries
shove = require("libraries.shove")


function love.load()
    -- Bootup Debug
    print("Running Main")

    GameHandler.ChangeState("Loading")

    local major, minor, revision, codename = love.getVersion()
    print(string.format("Version: %d.%d.%d - %s", major, minor, revision, codename))

    -- Shove Library Configs (For Drawing)
    shove.setResolution(1280, 720, {fitMethod = "aspect"})
    shove.setWindowMode(1280, 720, {resizable = true})

    local function onClick()
        print("CLICKED!!")
    end

    local myButon = UIButton.new("TestButton", 300, 300, 100, 100, onClick)
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
    local valid, sx, sy = shove.screenToViewport(x, y)
    if valid then
        UIHandler.MousePressed(sx, sy, button)
    end
    
end