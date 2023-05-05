local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX                           = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--- SCRIPT PARA CACHEAR CON TECLA

function LoadAnimDict(dict)
	if not HasAnimDictLoaded(dict) then
		RequestAnimDict(dict)

		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local player = PlayerPedId()
        if IsControlJustReleased(0, Keys['X']) then
            if IsPedArmed(PlayerPedId(), 4) then -- Verifica si el jugador está armado con un arma de fuego
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer ~= -1 and closestDistance <= 2.0 then
                    local closestPlayerPed = GetPlayerPed(closestPlayer)
                    local closestPlayerHasHandsUp = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)
                    LoadAnimDict("mini@repair")
                    if closestPlayerHasHandsUp or IsEntityDead(closestPlayer) then
                        openNearbyInventory(closestPlayer)
                        ExecuteCommand('me lo cachea')
                        Citizen.Wait(50)
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(player)
                    else
                        ESX.ShowNotification('El jugador no tiene las Manos levantadas')
                    end

                    Citizen.Wait(1000)
                    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0, -1.0, -1, 49, 0, false, false, false)
                    Citizen.Wait(3000)
                    ClearPedTasks(PlayerPedId())
                    ClearPedSecondaryTask(player)
                    
                else
                    ESX.ShowNotification('No hay jugadores cercanos para robar')
                end
            else
                ESX.ShowNotification('Debes tener un arma de fuego para robar a otra persona') -- Notificación si el jugador no está armado
            end
        end
    end
end)


function openNearbyInventory(closestPlayer)
    local player = PlayerPedId()
    local ox_inventory = ESX.GetConfig().OxInventory
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
        
    else
        ESX.ShowNotification('Debes estar cerca del jugador para cachearlo')
    end
end

exports('ox_inventory', openNearbyInventory)

