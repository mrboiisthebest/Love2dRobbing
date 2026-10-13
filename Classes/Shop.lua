local Shop = {}

Shop.__index = Shop
Shop.Shops = {}


local function ShopExists(shopName)
    if Shop.Shops[shopName] then
        return true
    else
        return false
    end
end

local function ContainsItem(itemID, shopObject)
    for _, v in ipairs(shopObject.Items) do
        if v.ID == itemID then
            return true
        end
    end

    return false
end

function Shop.new(name, items)
    if name == "" or name == nil then
        print("Invalid shop name!")
        return
    end

    if ShopExists(name) then
        print("Shop Already Exists, Cant Make Another Shop Of:", name)
        return
    end

    local self = setmetatable({}, Shop)

    self.Name = name 
    self.Items = items or {}
    

    Shop.Shops[self.Name] = self

    return self
end

function Shop:AddItem(item)
    if item == nil then
        print("No Item Item Provided!")
        return
    end

    if ContainsItem(item, self) then
        print("Cant Add Item! Already In Shop:", item.Name)
        return 
    end

    local Cloneditem = item:Clone()
    table.insert(self.Items, Cloneditem)
    print("added item to shop:", self.Name)
    return Cloneditem -- optional way to get new item
end

function Shop:RemoveItem(itemID)
    if itemID == nil or type(itemID) ~= "number" then
        print("No Item ID Provided!")
        return
    end


    for i, v in ipairs(self.Items) do
        if v.ID == itemID then
            print("Removed item from shop:", self.Name)
            table.remove(self.Items, i) 
            return
        end
    end
end

function Shop:Destroy()
    if Shop.Shops[self.Name] == self then
        Shop.Shops[self.Name] = nil
    end
end

return Shop