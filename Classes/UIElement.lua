local UIHandler = require("Handlers.UIHandler")

local UIElement = {}

UIElement.__index = UIElement

function UIElement.new(name, x, y, width, height)
    local self = setmetatable({}, UIElement)
    self.name = name
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.visible = true
    self.active = true
    self.layer = 0
    self.isHovered = false

    UIHandler.AddUiElement(self)
    return self
end

function UIElement:containsPoint(px, py)
    return px >= self.x and px <= self.x + self.width and
           py >= self.y and py <= self.y + self.height
end

function UIElement:Update(dt)
    if not self.active or not self.visible then
        return
    end

    local mx, my = love.mouse.getPosition()
    local valid, sx, sy = shove.screenToViewport(mx, my)
    

    if sx and sy and valid then
        self.isHovered = self:containsPoint(sx, sy)
    else
        self.isHovered = false
    end

end

function UIElement:draw()
    if not self.visible then
        return
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function UIElement:Destroy()
    UIHandler.RemoveUiElement(self)
end





return UIElement