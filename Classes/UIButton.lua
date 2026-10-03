local UIElement = require("Classes.UIElement")


local UIButton = {}

UIButton.__index = UIButton

setmetatable(UIButton, {__index = UIElement})


function UIButton.new(x, y, width, height, onClick)
    local self = UIElement.new(x, y, width, height)
    setmetatable(self, UIButton)

    self.onClick = onClick

    return self
end


function UIButton:update(dt)
    UIElement.Update(self, dt)

    if not self.active or not self.visable then
        return
    end
end

function UIButton:MousePressed(x, y, button)
    if button == 1 and self.onClick and self.isHovered then
        self.onClick()
    end
    
end


function UIButton:draw()
    if not self.visable or not self.active then
        return
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end





return UIButton