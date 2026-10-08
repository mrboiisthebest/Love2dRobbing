local UiHandler = {}

UiHandler.elements = {}


function UiHandler.AddUiElement(element)
    table.insert(UiHandler.elements, element)
end


function UiHandler.Draw()
    for _, v in ipairs(UiHandler.elements) do
        v:draw()
    end
end

function UiHandler.Update(dt)
    for _, v in ipairs(UiHandler.elements) do
        v:update(dt)
    end
end

function UiHandler.MousePressed(x, y, button)
    for _, v in ipairs(UiHandler.elements) do
        if v.MousePressed then
            v:MousePressed(x, y, button)
        end
    end
end

function UiHandler.RemoveUiElement(element)
    for i, v in ipairs(UiHandler.elements) do
        if v == element then
            print("Removed", element.name)
            table.remove(UiHandler.elements, i)
            return
        end
    end

    print("Could Not Properly Destroy UIElement:", element.name)
end




return UiHandler