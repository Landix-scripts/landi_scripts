local playerXP = {}

local blueprints = {
    ["WEAPON_PISTOL"] = {
        label="Pistol",
        needXP=0,
        materials = {iron=10, copper=5, gun_body=1, gun_trigger=1}
    },
    ["WEAPON_SMG"] = {
        label="SMG",
        needXP=10,
        materials = {iron=20, copper=10, gun_body=2, gun_trigger=2, gun_barrel=1}
    },
    ["WEAPON_ASSAULTRIFLE"] = {
        label="AK47",
        needXP=20,
        materials = {iron=30, copper=15, gun_body=3, gun_trigger=2, gun_barrel=2}
    }
}

-- 🔍 CHECK MATERIALS
function hasMaterials(src, materials)
    for item, count in pairs(materials) do
        local has = exports.ox_inventory:Search(src, 'count', item)
        if has < count then
            return false, item
        end
    end
    return true
end

RegisterNetEvent("craft:getData", function()
    local src = source
    if not playerXP[src] then playerXP[src] = 0 end

    local data = {}

    for weapon, info in pairs(blueprints) do
        table.insert(data, {
            weapon = weapon,
            label = info.label,
            xp = playerXP[src],
            needXP = info.needXP,
            unlocked = playerXP[src] >= info.needXP,
            materials = info.materials
        })
    end

    TriggerClientEvent("craft:sendData", src, data)
end)

RegisterNetEvent("craft:weapon", function(weapon)
    local src = source

    if not playerXP[src] then playerXP[src] = 0 end

    local r = blueprints[weapon]
    if not r then return end

    if playerXP[src] < r.needXP then
        TriggerClientEvent("ox_lib:notify", src, {description="Locked ❌"})
        return
    end

    local has, missing = hasMaterials(src, r.materials)

    if not has then
        TriggerClientEvent("ox_lib:notify", src, {description="Missing: "..missing})
        return
    end

    SetTimeout(5000, function()

        for item, count in pairs(r.materials) do
            exports.ox_inventory:RemoveItem(src, item, count)
        end

        exports.ox_inventory:AddItem(src, string.lower(weapon), 1)

        playerXP[src] = playerXP[src] + 1

        TriggerClientEvent("ox_lib:notify", src, {description="Craft done 🔥"})
        TriggerClientEvent("craft:refresh", src)

    end)
end)