ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end

    Citizen.Wait(0)

    ESX.PlayerData = ESX.GetPlayerData()
end)

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)

        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(1)
        end
    end
end

RegisterCommand('robar', function() -- You can change the name of the command here.
    local player = PlayerPedId()
    if IsPedArmed(player, 4) then
        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
        if closestPlayer ~= -1 and closestDistance <= 2.0 then
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local closestPlayerHasHandsUp = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)
            LoadAnimDict("mini@repair")
            if closestPlayerHasHandsUp or IsPlayerDead(closestPlayer) then
                openNearbyInventory(closestPlayer)
                ExecuteCommand('me lo cachea')
                TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0, -1.0, -1, 49, 0, false, false, false)
                Citizen.Wait(3000)

                ClearPedTasks(player)
                ClearPedSecondaryTask(player)
            else
                ESX.ShowNotification('El jugador no tiene las manos levantadas')
            end
        else
            ESX.ShowNotification('No hay jugadores cercanos para robar')
        end
    else
        ESX.ShowNotification('Debes tener un arma de fuego para robar a otra persona')
    end
end)

function openNearbyInventory(closestPlayer)
    local ox_inventory = ESX.GetConfig().OxInventory
    local closestPlayer = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 then
        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
    end
end

RegisterKeyMapping('robar', 'Robar a un jugador cercano', 'keyboard', 'X') -- You can Change the Key Binding Here.
