local craftingLocation = vector3(1752.0, 2534.45, 45.55)
local inUI = false
local cam = nil

-- 🧱 SPAWN TABLE + PROPS
Citizen.CreateThread(function()
    local benchModel = GetHashKey("prop_tool_bench02")
    local toolbox = GetHashKey("prop_tool_box_04")

    RequestModel(benchModel)
    RequestModel(toolbox)

    while not HasModelLoaded(benchModel) do Wait(1) end
    while not HasModelLoaded(toolbox) do Wait(1) end

    local bench = CreateObject(benchModel, 1752.0, 2534.45, 44.55, false, false, false)
    SetEntityHeading(bench, 215.43)
    FreezeEntityPosition(bench, true)

    local box = CreateObject(toolbox, 1752.4, 2534.2, 45.0, false, false, false)
    FreezeEntityPosition(box, true)
end)

-- 🎮 MAIN LOOP
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if #(coords - craftingLocation) < 2.0 then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Shtyp ~INPUT_CONTEXT~ për Landi Crafting")
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsControlJustPressed(0, 38) then
                inUI = true
                SetNuiFocus(true, true)

                -- 🎭 ANIMACION
                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

                -- 🎬 CAMERA
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                SetCamCoord(cam, coords.x+1.5, coords.y+1.5, coords.z+1.0)
                PointCamAtCoord(cam, coords.x, coords.y, coords.z)
                SetCamActive(cam, true)
                RenderScriptCams(true, true, 500, true, true)

                -- 💡 LIGHT EFFECT
                Citizen.CreateThread(function()
                    while inUI do
                        DrawLightWithRange(coords.x, coords.y, coords.z+1, 255, 200, 100, 5.0, 10.0)
                        Citizen.Wait(0)
                    end
                end)

                SendNUIMessage({type="open"})
                TriggerServerEvent("craft:getData")
            end
        end
    end
end)

-- disable controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inUI then
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
        end
    end
end)

RegisterNUICallback("close", function(_, cb)
    inUI = false

    ClearPedTasks(PlayerPedId())

    RenderScriptCams(false, true, 500, true, true)
    DestroyCam(cam, false)

    SetNuiFocus(false, false)
    cb("ok")
end)

RegisterNUICallback("craft", function(data, cb)
    TriggerServerEvent("craft:weapon", data.weapon)
    cb("ok")
end)

RegisterNetEvent("craft:refresh")
AddEventHandler("craft:refresh", function()
    TriggerServerEvent("craft:getData")
end)

RegisterNetEvent("craft:sendData")
AddEventHandler("craft:sendData", function(data)
    SendNUIMessage({
        type = "data",
        weapons = data
    })
end)