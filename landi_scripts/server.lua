local playerXP = {}

local blueprints = {
    ["WEAPON_PISTOL"] = {label="Pistol", needXP=0},
    ["WEAPON_SMG"] = {label="SMG", needXP=10},
    ["WEAPON_ASSAULTRIFLE"] = {label="AK47", needXP=20}
}

local isESX = GetResourceState("es_extended") == "started"
local isQB = GetResourceState("qb-core") == "started"

if isESX then ESX = exports["es_extended"]:getSharedObject() end
if isQB then QBCore = exports['qb-core']:GetCoreObject() end

RegisterNetEvent("craft:getData")
AddEventHandler("craft:getData", function()
    local src = source

    if not playerXP[src] then playerXP[src] = 0 end

    local data = {}

    for weapon, info in pairs(blueprints) do
        local unlocked = playerXP[src] >= info.needXP

        table.insert(data, {
            weapon = weapon,
            label = info.label,
            xp = playerXP[src],
            needXP = info.needXP,
            unlocked = unlocked
        })
    end

    TriggerClientEvent("craft:sendData", src, data)
end)

RegisterNetEvent("craft:weapon")
AddEventHandler("craft:weapon", function(weapon)
    local src = source

    if not playerXP[src] then playerXP[src] = 0 end

    local r = blueprints[weapon]
    if not r then return end

    if playerXP[src] < r.needXP then
        TriggerClientEvent("esx:showNotification", src, "E bllokuar ❌")
        return
    end

    local time = 5

    SetTimeout(time * 1000, function()

        if isESX then
            local xPlayer = ESX.GetPlayerFromId(src)

            if GetResourceState("ox_inventory") == "started" then
                xPlayer.addInventoryItem(string.lower(weapon), 1)
            else
                xPlayer.addWeapon(weapon, 100)
            end

        elseif isQB then
            local Player = QBCore.Functions.GetPlayer(src)
            Player.Functions.AddItem(string.lower(weapon), 1)
        end

        playerXP[src] = playerXP[src] + 1

        TriggerClientEvent("craft:refresh", src)

    end)
end)