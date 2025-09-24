local version = string.lower(Config.Version)
local PlayingAnim = false
local inventoryversion = string.lower(Config.Inventory)
if version == 'esx' then
    ESX = exports['es_extended']:getSharedObject()

    if ESX == nil then
        Citizen.CreateThread(function()
            while ESX == nil do
                ESX = exports['es_extended']:getSharedObject()
                Citizen.Wait(0)
            end
        end)
    end
elseif version == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
    if QBCore == nil then
        Citizen.CreateThread(function()
            while QBCore == nil do
                QBCore = exports['qb-core']:GetCoreObject()
                Citizen.Wait(0)
            end
        end)
    end
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
    local weaponHash = GetCurrentPedWeapon(player, true)

    if weaponHash == GetHashKey('WEAPON_UNARMED') then
        if version == 'esx' then
            ESX.ShowNotification("Necesitas tener un arma equipada para robar.")
        elseif version == 'qb' then
            QBCore.Functions.Notify("Necesitas tener un arma equipada para robar.", "error")
        end
        return
    end

    local closestPlayer, closestDistance
    if version == 'esx' then
        closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    elseif version == 'qb' then
        closestPlayer, closestDistance = QBCore.Functions.GetClosestPlayer()
    end

    if IsEntityDead(player) then
        if version == 'esx' then
            ESX.ShowNotification(Config.GetTranslation('cannot_steal_dead'))
        elseif version == 'qb' then
            QBCore.Functions.Notify(Config.GetTranslation('cannot_steal_dead'))
        end
        return
    end

    if closestPlayer ~= -1 and closestDistance <= 1.5 then
        local closestPlayerPed = GetPlayerPed(closestPlayer)

        --- INICIO DE LA MODIFICACIÓN ---
        -- Verifica la primera animación de manos arriba (la original)
        local hasHandsUpAnim1 = IsEntityPlayingAnim(closestPlayerPed, "random@mugging3", "handsup_standing_base", 3)
        -- Verifica la segunda animación de manos arriba (la nueva)
        -- NOTA: Si usas un diccionario de animación diferente a "misscommon@response@hands_up", cámbialo aquí.
        local hasHandsUpAnim2 = IsEntityPlayingAnim(closestPlayerPed, "misscommon@response@hands_up", "handsup_enter", 3)
        local closestPlayerHasHandsUp = hasHandsUpAnim1 or hasHandsUpAnim2
        --- FIN DE LA MODIFICACIÓN ---

        local isTargetDead = IsEntityDead(closestPlayerPed)

        LoadAnimDict("mini@repair")
        if (closestPlayerHasHandsUp and (Config.StealMode == "HandsUp" or Config.StealMode == "Both")) or (isTargetDead and (Config.StealMode == "Dead" or Config.StealMode == "Both")) then
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
            if version == 'esx' then
                ESX.ShowNotification(Config.GetTranslation('player_hands_up'))
            elseif version == 'qb' then
                QBCore.Functions.Notify(Config.GetTranslation('player_hands_up'))
            end
        end
    else
        PlayingAnim = false
        if version == 'esx' then
            ESX.ShowNotification(Config.GetTranslation('no_player_nearby'))
        elseif version == 'qb' then
            QBCore.Functions.Notify(Config.GetTranslation('no_player_nearby'))
        end
    end
end, false)

function openNearbyInventory(closestPlayer)
    if (PlayingAnim == true) then
        if inventoryversion == 'ox' then
            --- OX Version
            --- exports.ox_inventory:openInventory(invType, data)

            exports.ox_inventory:openInventory('player', GetPlayerServerId(closestPlayer))
        elseif inventoryversion == 'esx' then
            --- ESX Version
            OpenBodySearchMenu(closestPlayer)
        elseif inventoryversion == 'qb' then
            --- QB Version
            local playerId = GetPlayerServerId(closestPlayer)
            TriggerServerEvent('ox_thief:openPlayerInventory', playerId)
        end
    end
end

--- ESX Version
function OpenBodySearchMenu(closestPlayer)
    local targetPlayerId = GetPlayerServerId(closestPlayer)
    ESX.TriggerServerCallback('ox_thief:getPlayerData', function(data)
        local elements = {
            { unselectable = true, icon = "fas fa-user", title = 'Robando' }
        }

        for i = 1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                table.insert(elements, {
                    icon = "fas fa-money",
                    title = 'Dinero Sucio: ' .. ESX.Math.Round(data.accounts[i].money),
                    value = 'black_money',
                    itemType = 'item_account',
                    amount = data.accounts[i].money
                })
            end
        end

        if #data.weapons > 0 then
            table.insert(elements, { label = 'Armas' })
            for i = 1, #data.weapons, 1 do
                table.insert(elements, {
                    icon = "fas fa-gun",
                    title = ESX.GetWeaponLabel(data.weapons[i].name) .. ' (' .. data.weapons[i].ammo .. ')',
                    value = data.weapons[i].name,
                    itemType = 'item_weapon',
                    amount = data.weapons[i].ammo
                })
            end
        end

        if #data.inventory > 0 then
            table.insert(elements, { title = 'Inventario' })
            for i = 1, #data.inventory, 1 do
                if data.inventory[i].count > 0 then
                    table.insert(elements, {
                        icon = "fas fa-box",
                        title = data.inventory[i].label .. ' (x' .. data.inventory[i].count .. ')',
                        value = data.inventory[i].name,
                        itemType = 'item_standard',
                        amount = data.inventory[i].count
                    })
                end
            end
        end

        ESX.OpenContext("right", elements, function(menu, element)
            if element.value then
                TriggerServerEvent('ox_thief:confiscatePlayerItem', targetPlayerId, element.itemType, element.value, element.amount)
                OpenBodySearchMenu(closestPlayer)
            end
        end)
    end, targetPlayerId)
end

--- Key Mapping
RegisterKeyMapping(Config.Command, Config.CommandName, 'keyboard', Config.StealKeyMapping) -- CONFIG Command
