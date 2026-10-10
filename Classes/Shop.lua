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

local function ContainsItem(itemName, shopObject)
    for _, v in ipairs(shopObject.Items) do
        if v.Name == itemName then
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
        print("No Item Provided!")
        return
    end

    if ContainsItem(item.Name, self) then
        print("Cant Add Item! Already In Shop:", item.Name)
        return
    end

    table.insert(self.Items, item)
end

function Shop:RemoveItem(item)
    if item == nil then
        print("No Item Provided!")
        return
    end

    for i, v in ipairs(self.Items) do
        if v.Name == item.Name then
            print("Removed Item!")
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