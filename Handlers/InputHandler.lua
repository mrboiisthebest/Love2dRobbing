-- Dependencies
local UIHandler = require("Handlers.UIHandler")


local InputHandler = {}


-- Gets Triggered On Keyboard Input
function InputHandler.KeyboardEventTriggered(key)

end

function InputHandler.MouseEventTriggered(data)
   local x = data[1]
   local y = data[2]
   local button = data[3]

       local valid, sx, sy = shove.screenToViewport(x, y)
    if valid then
        UIHandler.MousePressed(sx, sy, button)
    end
end

return InputHandler