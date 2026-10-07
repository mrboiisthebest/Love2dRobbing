-- Dependencies
local EventClass = require("Classes.Event")
local InputHandler = require("Handlers.InputHandler")


local EventHanlder = {}

EventHanlder.StartUpEvents = {
    {"KeyboardInputEvent", InputHandler.KeyboardEventTriggered},
    {"MouseInputEvent", InputHandler.MouseEventTriggered},
}
EventHanlder.Events = {}

local function GetEventByName(name)
    for _, v in ipairs(EventHanlder.Events) do
        if v.Name == name then
            return v
        end
    end
    return nil
end

local function AlreadyExsists(name)
        for _, v in ipairs(EventHanlder.Events) do
        if v.Name == name then
            return true
        end
    end
    return false
end

function EventHanlder.Init()
    for _, v in ipairs(EventHanlder.StartUpEvents) do
        if AlreadyExsists(v[1]) then
            goto continue
        end

        local event = EventClass.New(v[1])
        table.insert(EventHanlder.Events, event)
        if v[2] then
            event:AddListener(v[2])
        end

        ::continue::
    end
end

function  EventHanlder.CreateEvent(name)
    local event = EventClass.New(name)
    if event then
        table.insert(EventHanlder.Events, event)
    end

    return event
end

function EventHanlder.FireEvent(name, data)
    local event = GetEventByName(name)
    if event then
        event:Fire(data)
    end
end

function EventHanlder.RemoveEvent(name)
    for i, v in ipairs(EventHanlder.Events) do
        if v.Name == name then
            table.remove(EventHanlder.Events, i)
        end
    end
end

function EventHanlder.ListenToEvent(name, callback)
    local event = GetEventByName(name)
    if event then
        event:AddListener(callback)
    end
end


function EventHanlder.StopListenToEvent(name, callback)
    local event = GetEventByName(name)
    if event then
        event:RemoveListener(callback)
    end
end



return EventHanlder