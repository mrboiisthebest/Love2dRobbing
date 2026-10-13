local GameData = {}

GameData.Data = {
    ["playerData"] = {
        ["Stats"] = {
            ["Health"] = {baseValue = 100, modifiers = {}},
            ["Speed"] = {baseValue = 16, modifiers = {}},
            ["BagSize"] = {baseValue = 4, modifiers = {}},
        },
        ["Money"] = 0,
        ["SecondsPlayed"] = 0,
        ["Items"] = {} 
    },
    ["generalData"] = {
        -- Game Bool Values
    },
    ["NextID"] = 0,
}

--["Health"] = {baseValue = 100, modifiers = {["ModName"] = {type = 1, value = 2}}, ...},
local function ApplyModifier(baseNumber, modData)
    
    local Opp = modData.type
    local value = modData.value

    if Opp == 1 then
        return baseNumber + value
    end
    if Opp == 2 then
        return baseNumber - value
    end
    if Opp == 3 then
        return baseNumber * value
    end
    if Opp == 4 then
        return baseNumber / value
    end

    print("Invalid mod type!")
    return baseNumber
end


local function getModsInOrder(Stat)
    local Mods = Stat.modifiers

    local Ordered = {}
    local Highest = 0

    local cachedNum = 0

    -- Finds Highest
    for i, v in pairs(Mods) do
        if v.type > Highest then
            Highest = v.type
        end
    end

    for ii = 1, Highest, 1 do 
        for i, v in pairs(Mods) do
            if v.type == ii then
                cachedNum = cachedNum + 1
                Ordered[cachedNum] = v
            end
        end
    end

    return Ordered

end

function GameData.GetStat(StatName)
    local Stat = GameData.Data["playerData"]["Stats"][StatName]

    if not Stat then
        return
    end

    local ModifiedBase = Stat.baseValue

    local mods = getModsInOrder(Stat)

    for i, modData in ipairs(mods) do
        ModifiedBase = ApplyModifier(ModifiedBase, modData)
    end

    return ModifiedBase

end

function GameData.AddStatMod(Statname,ModName, ModData)
    local Stat = GameData.Data["playerData"]["Stats"][Statname]

    if not Stat then
        return
    end

    local AlreadyExsisting = Stat.modifiers[ModName]

    if AlreadyExsisting then
        print('Already Exsists! Mod Overwirting... ')
        Stat.modifiers[ModName] = ModData
        return
    end

    Stat.modifiers[ModName] = ModData

end

function GameData.RemoveStatMod(Statname, ModName)
    
    local Stat = GameData.Data["playerData"]["Stats"][Statname]

    if not Stat then
        return
    end

    local TargetMod = Stat.modifiers[ModName]

    if TargetMod then
        Stat.modifiers[ModName] = nil
    end

end


function GameData.AddItem(Item)
    if not Item or not Item.Name or not Item.ID then
        print("Invalid Item!")
        return
    end

    local FoundItem = GameData.Data["playerData"]["Items"][Item.Name .. "-" .. Item.ID]
    if FoundItem then
        print("Item Already In Players inv!")
        return
    end

    GameData.Data["playerData"]["Items"][Item.Name .. "-" .. Item.ID] = {Name = Item.Name, ID = Item.ID, Used = Item.Used}
end

function GameData.RemoveItem(Item)
    if not Item or not Item.Name or not Item.ID then
        print("Invalid Item!")
        return
    end

    local FoundItem = GameData.Data["playerData"]["Items"][Item.Name .. "-" .. Item.ID]
    if FoundItem then
        GameData.Data["playerData"]["Items"][Item.Name .. "-" .. Item.ID] = nil
    end
end

-- Used Just To Update The Values. Is Called ByThe Main Use Function
function GameData.UseItem(Item)
    if not Item or not Item.Name or not Item.ID then
        print("Invalid Item!")
        return
    end

    local FoundItem = GameData.Data["playerData"]["Items"][Item.Name .. "-" .. Item.ID]
    if FoundItem and not FoundItem.Used then
       FoundItem.Used = true
    end
end


return GameData