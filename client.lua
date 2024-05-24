ESX = exports['es_extended']:getSharedObject()
local PlayingAnim = false

if ESX == nil then
    Citizen.CreateThread(function()
        while ESX == nil do
            ESX = exports['es_extended']:getSharedObject()
            Citizen.Wait(0)
        end
    end)
end

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
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

    if IsEntityDead(player) then
        ESX.ShowNotification('No puedes robar estando muerto')
        return
    end

    if closestPlayer ~= -1 and closestDistance <= 1.5 then
        local closestPlayerPed = GetPlayerPed(closestPlayer)
        local closestPlayerHasHandsUp = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)
        LoadAnimDict("mini@repair")
        if closestPlayerHasHandsUp or IsPlayerDead(closestPlayer) then
            if Config.CommandChat then
            ExecuteCommand(Config.CommandText)
            end
            TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0, -1.0, -1, 49, 0, false, false, false)
            PlayingAnim = true
            openNearbyInventory(closestPlayer)
            Citizen.Wait(3000) -- DONT TOUCH THIS

            ClearPedTasks(player)
            ClearPedSecondaryTask(player)
        else
            PlayingAnim = false
            ESX.ShowNotification('El jugador no tiene las manos levantadas')
        end
    else
        PlayingAnim = false
        ESX.ShowNotification('No hay jugadores cercanos para robar')
    end
end)

function openNearbyInventory(closestPlayer)
    if (PlayingAnim == true) then
        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
    end
end

RegisterKeyMapping(Config.Command, 'Robar a un jugador cercano', 'keyboard', 'X') -- CONFIG Command

