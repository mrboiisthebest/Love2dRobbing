local Handler = {}

Handler.elements = {}


function Handler.Add(element)
    table.insert(Handler.elements, element)
end


function Handler.Draw()
    for _, v in ipairs(Handler.elements) do
        v:draw()
    end
end

function Handler.Update(dt)
    for _, v in ipairs(Handler.elements) do
        v:update(dt)
    end
end

function Handler.MousePressed(x, y, button)
    for _, v in ipairs(Handler.elements) do
        if v.MousePressed then
            v:MousePressed(x, y, button)
        end
    end
end



return Handler