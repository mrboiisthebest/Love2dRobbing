-- Imports
local UIHandler = require("Handlers.UIHandler")

local GameHandler = {}

GameHandler.CurrentState = ""
GameHandler.States = {
    "Loading",
    "Playing",
    "Idle",
}


function GameHandler.Update(dt)
    UIHandler.Update(dt)
end

function GameHandler.Draw()
    UIHandler.Draw()
end


local function isValidState(targetState)
    for _, v in pairs(GameHandler.States) do
        if v == targetState then
            return true
        end
    end

    return false
end

function GameHandler.ChangeState(targetState)
    if GameHandler.CurrentState == targetState then
        return
    end

    local valid = isValidState(targetState)

    if valid then
        GameHandler.CurrentState = targetState
    end
end


return GameHandler