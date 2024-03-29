ESX = nil
local PlayingAnim = false

Citizen.CreateThread(function()
    while ESX == nil do
        ESX = exports['es_extended']:getSharedObject()
        Citizen.Wait(0)
    end

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

RegisterCommand(Config.Command, function()
    local player = PlayerPedId()
    if IsPedArmed(player, 4) then
        local closestDistance = ESX.Game.GetClosestPlayer()
        if closestDistance <= 1.5 then
            local closestPlayer = ESX.Game.GetClosestPlayer()
            local closestPlayerPed = GetPlayerPed(closestPlayer)
            local closestPlayerHasHandsUp = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)
            LoadAnimDict("mini@repair")
            if closestPlayerHasHandsUp or IsPlayerDead(closestPlayer) then
                ExecuteCommand('me lo cachea')
                TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0, -1.0, -1, 49, 0, false, false, false)
                PlayingAnim = true
                openNearbyInventory(closestPlayer)
                Citizen.Wait(3000)

                ClearPedTasks(player)
                ClearPedSecondaryTask(player)
            else
                PlayingAnim = false
                ESX.ShowNotification('El jugador no tiene las manos levantadas') -- CAN CHANGE
            end
        else
            PlayingAnim = false
            ESX.ShowNotification('No hay jugadores cercanos para robar') -- CAN CHANGE
        end
    else
        PlayingAnim = false
        ESX.ShowNotification('Debes tener un arma de fuego para robar a otra persona') -- CAN CHANGE
    end
end)

function openNearbyInventory(closestPlayer)
    local closestPlayer = ESX.Game.GetClosestPlayer()
    if (PlayingAnim == true) then
        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
    end
end

RegisterKeyMapping('robar', 'Robar a un jugador cercano', 'keyboard', 'X')

