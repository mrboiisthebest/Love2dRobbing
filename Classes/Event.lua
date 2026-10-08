local Event = {}

Event.__index = Event



function Event.New(name)
    local self = setmetatable({}, Event)
    self.Listeners = {}
    self.Name = name

    return self
end

function Event:Fire(data)
    for _, v in ipairs(self.Listeners) do 
        if type(v) == "function" then
            v(data)
        end
    end
end

function Event:RemoveListener(callback)
    for i, v in ipairs(self.Listeners) do 
        if v == callback then
            table.remove(self.Listeners, i)
            return
        end
    end
end

function Event:AddListener(callback)
        for i, v in ipairs(self.Listeners) do 
        if v == callback then
            print("Already Listening!")
            return
        end
    end

    table.insert(self.Listeners, callback)
end


return Event