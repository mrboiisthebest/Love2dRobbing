local UIHandler = require("Handlers.UIHandler")

local UIElement = {}

UIElement.__index = UIElement

function UIElement.new(x, y, width, height)
    local self = setmetatable({}, UIElement)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.visable = true
    self.active = true
    self.layer = 0
    self.isHovered = false

    UIHandler.Add(self)
    return self
end

function UIElement:containsPoint(px, py)
    return px >= self.x and px <= self.x + self.width and
           py >= self.y and py <= self.y + self.height
end

function UIElement:Update(dt)
    if not self.active or not self.visable then
        return
    end

    local mx, my = love.mouse.getPosition()
    self.isHovered = self:containsPoint(mx, my)

end

function UIElement:draw()
    if not self.visable then
        return
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end





return UIElement