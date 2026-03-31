local craftingLocation = vector3(1752.0, 2534.45, 45.55)
local inUI = false
local cam = nil

Citizen.CreateThread(function()
    local model = GetHashKey("prop_tool_bench02")
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end

    local obj = CreateObject(model, 1752.0, 2534.45, 44.55, false, false, false)
    SetEntityHeading(obj, 215.43)
    FreezeEntityPosition(obj, true)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        if #(coords - craftingLocation) < 2.0 then
            BeginTextCommandDisplayHelp("STRING")
            AddTextComponentSubstringPlayerName("Press ~INPUT_CONTEXT~ to craft")
            EndTextCommandDisplayHelp(0, false, true, -1)

            if IsControlJustPressed(0, 38) then
                inUI = true
                SetNuiFocus(true, true)

                TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)

                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                SetCamCoord(cam, coords.x+1.5, coords.y+1.5, coords.z+1.0)
                PointCamAtCoord(cam, coords.x, coords.y, coords.z)
                SetCamActive(cam, true)
                RenderScriptCams(true, true, 500, true, true)

                SendNUIMessage({type="open"})
                TriggerServerEvent("craft:getData")
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if inUI then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)

            if IsControlJustPressed(0, 322) then
                inUI = false

                local ped = PlayerPedId()
                ClearPedTasks(ped)

                RenderScriptCams(false, true, 500, true, true)
                if cam then
                    DestroyCam(cam, false)
                    cam = nil
                end

                SetNuiFocus(false, false)

                SendNUIMessage({type="close"})
            end
        end
    end
end)

RegisterNUICallback("close", function(_, cb)
    inUI = false

    local ped = PlayerPedId()
    ClearPedTasks(ped)

    RenderScriptCams(false, true, 500, true, true)
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end

    SetNuiFocus(false, false)

    cb("ok")
end)

RegisterNUICallback("craft", function(data, cb)
    TriggerServerEvent("craft:weapon", data.weapon)
    cb("ok")
end)

RegisterNetEvent("craft:refresh", function()
    TriggerServerEvent("craft:getData")
end)

RegisterNetEvent("craft:sendData", function(data)
    SendNUIMessage({
        type = "data",
        weapons = data
    })
end)