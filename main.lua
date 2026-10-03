local UIHandler = require("Handlers.UIHandler")
local UIElement = require("Classes.UIElement")
local UIButton = require("Classes.UIButton")
local GameHandler = require("Handlers.GameHandler")


function love.load()
    print("Running Main")

    local function onClick()
        print("CLICKED!!")
    end

    local myButon = UIButton.new(300, 300, 100, 100, onClick)


end

function love.update(dt)
    GameHandler.Update(dt)
end

function love.draw()
    GameHandler.Draw()
end

function love.mousepressed(x, y, button, isTouch, presses)
    UIHandler.MousePressed(x, y, button)
end