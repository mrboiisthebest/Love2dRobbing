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


return GameData