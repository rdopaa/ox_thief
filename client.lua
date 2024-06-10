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
        if (closestPlayerHasHandsUp and (string.lower(Config.StealMode) == "HandsUp" or string.lower(Config.StealMode) == "Both")) or (IsPlayerDead(closestPlayer) and (string.lower(Config.StealMode) == "Dead" or string.lower(Config.StealMode) == "Both")) then
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
        if string.lower(Config.Version) == 'ox' then
            exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
        elseif string.lower(Config.Version) == 'esx' then
            OpenBodySearchMenu(closestPlayer)
        end
    end
end

function OpenBodySearchMenu(closestPlayer)
	ESX.TriggerServerCallback('ox_thief:getPlayerData', function(data)
		local elements = {
			{unselectable = true, icon = "fas fa-user", title = 'Stealing'}
		}

		for i=1, #data.accounts, 1 do
			if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
				elements[#elements+1] = {
					icon = "fas fa-money",
					title    =  'Dirty Money',ESX.Math.Round(data.accounts[i].money),
					value    = 'black_money',
					itemType = 'item_account',
					amount   = data.accounts[i].money
				}
				break
			end
		end

		table.insert(elements, {label = 'Guns'})

		for i=1, #data.weapons, 1 do
			elements[#elements+1] = {
				icon = "fas fa-gun",
				title    = 'Confiscated Weapon', ESX.GetWeaponLabel(data.weapons[i].name), data.weapons[i].ammo,
				value    = data.weapons[i].name,
				itemType = 'item_weapon',
				amount   = data.weapons[i].ammo
			}
		end

		elements[#elements+1] = {title = 'Inventory'}

		for i=1, #data.inventory, 1 do
			if data.inventory[i].count > 0 then
				elements[#elements+1] = {
					icon = "fas fa-box",
					title    = 'Confiscated Inventory', data.inventory[i].count, data.inventory[i].label,
					value    = data.inventory[i].name,
					itemType = 'item_standard',
					amount   = data.inventory[i].count
				}
			end
		end

		ESX.OpenContext("right", elements, function(menu,element)
			local data = {current = element}
			if data.current.value then
				TriggerServerEvent('ox_thief:confiscatePlayerItem', GetPlayerServerId(player), data.current.itemType, data.current.value, data.current.amount)
				OpenBodySearchMenu(player)
			end
		end)
	end, GetPlayerServerId(player))
end


RegisterKeyMapping(Config.Command, 'Robar a un jugador cercano', 'keyboard', 'X') -- CONFIG Command

