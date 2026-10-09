-- Dependencies
local GameData = require("Handlers.GameData")

local Item = {}

Item.__index = Item


local function isValidStat(statName)

    if GameData.Data["playerData"]["Stats"][statName] then
        return true
    else
        return false
    end
end

Item.Types = {
    ["Template"] = function (item)
        -- default behavior is nothing
        print("This Item type Cant Be Used! Item:", item.Name)
    end,
    ["Upgrade"] = function (item)
        -- default behavior is permanenly updating stats
        local upgradeData = item.TypeData

        if not upgradeData then
            return
        end

        if not upgradeData.Stats then
            print("No Stats To Upgrade!")
            return
        end

        for statName, incrementData in pairs(upgradeData.Stats) do
            if not isValidStat(statName) then
                print("Inavlid Stat! Cant add Modifiers!")
                goto continue
            end

            local oppType = incrementData.type or 1
            local incrementValue = incrementData.value

            GameData.AddStatMod(statName, item.Name, {type = oppType, value = incrementValue})
            ::continue::
        end

    end,
    ["Consumable"] = function (item)
        -- default behavior is Temporary updating stats
    end,
    ["Collectable"] = function (item)
        -- sells the collectable
    end,
}

Item.Items = {}


local function isValidType(targetType)
    for itemType, _ in pairs(Item.Types) do
        if itemType == targetType then
            return true
        end
    end
    return false
end

local function getCallback(targetType)
        for type, callback in pairs(Item.Types) do
        if type == targetType then
            return callback
        end
    end
end

function Item.new(name, value, itemType, typeData, callback)
    local self = setmetatable({}, Item)
    self.Name = name
    self.Value = value
    self.TypeData = typeData -- is a table that has stat changes (used for the default behaviours) {}
    self.Type = "Template" -- in case an invalid type is given

    if isValidType(itemType) then
        self.Type = itemType
    else
        print("Invalid Item type of:", itemType)
    end

    if not callback then
        local foundCallback = getCallback(self.Type)

        self.callback = Item.Types["Template"]

        if foundCallback then
            self.callback = foundCallback
        end

        else
            self.callback = callback
    end
    
    table.insert(Item.Items, self)

    return self
end


function Item:Destroy()
    for i, v in ipairs(Item.Items) do
        if v == self then
            table.remove(Item.Items, i)

            local typeData = self.TypeData

            if not typeData or not typeData.Stats then
                goto jumptoend
            end

            for statName, _ in pairs(typeData.Stats) do
                if not isValidStat(statName) then
                    print("Inavlid Stat! Cant Remove Modifiers!")
                    goto continue
                end

                GameData.RemoveStatMod(statName, self.Name)

                ::continue::
            end

            ::jumptoend::

            print("Destroyed Item:", self.Name)
            return
        end
    end
end

function Item:Use()
    self.callback(self)
end


return Item