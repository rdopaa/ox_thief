ESX = exports['es_extended']:getSharedObject()
if Config.DiscordWebhooks.Steal == "YOUR_GENERAL_WEBHOOK_URL" then
	print("Please set your webhook URL in config.lua from FX THIEF")
end

-- Log Webhook
function SendDiscordLog(webhookUrl, embedMessage, color, title)
	local data = {
		embeds = {
			{
				title = title or "FX THIEF LOGS",
				description = embedMessage,
				color = color or 7506394, -- Default grey color
			}
		}
	}

	PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode(data),
		{ ['Content-Type'] = 'application/json' })
end

-- ESX
RegisterNetEvent('ox_thief:confiscatePlayerItem')
AddEventHandler('ox_thief:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local source = source
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if targetXPlayer == nil or sourceXPlayer == nil or -1 then
		return
	end
	if amount == nil or amount == 0 then return end
	if itemName == nil then return end

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then
			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem(itemName, amount)
				SendDiscordLog(Config.DiscordWebhooks.Steal,
					string.format("%s (ID: %s) stole %d %s from %s (ID: %s)", sourceXPlayer.getName(),
						sourceXPlayer.getId(), amount, itemName, targetXPlayer.getName(), targetXPlayer.getId()), 65280,
					"Player Steal")                                                                                                                                                                                                                  -- Green color
			end
		end
	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)
		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount, "Confiscated")
			sourceXPlayer.addAccountMoney(itemName, amount, "Confiscated")
			SendDiscordLog(Config.DiscordWebhooks.Steal,
				string.format("%s (ID: %s) stole %d %s from %s (ID: %s)", sourceXPlayer.getName(), sourceXPlayer.getId(),
					amount, itemName, targetXPlayer.getName(), targetXPlayer.getId()), 65280, "Player Steal")                                                                                                                                       -- Green color
		end
	elseif itemType == 'item_weapon' then
		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName)
			sourceXPlayer.addWeapon(itemName, amount)
			SendDiscordLog(Config.DiscordWebhooks.Steal,
				string.format("%s (ID: %s) stole %s from %s (ID: %s)", sourceXPlayer.getName(), sourceXPlayer.getId(),
					itemName, targetXPlayer.getName(), targetXPlayer.getId()), 65280, "Player Steal")                                                                                                                                    -- Green color	
		end
	end
end)

ESX.RegisterServerCallback('ox_thief:getPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)
	if target == -1 then return end
	if xPlayer then
		local data = {
			name = xPlayer.getName(),
			job = xPlayer.job.label,
			grade = xPlayer.job.grade_label,
			inventory = xPlayer.getInventory(),
			accounts = xPlayer.getAccounts(),
			weapons = xPlayer.getLoadout()
		}
		cb(data)
	end
end)

-- QB
RegisterServerEvent('ox_thief:openPlayerInventory')
AddEventHandler('ox_thief:openPlayerInventory', function(playerId)
	local source = source
	if playerId == -1 or playerId == nil then return end
	exports['qb-inventory']:OpenInventoryById(source, playerId)
	SendDiscordLog(Config.DiscordWebhooks.Steal,
		string.format("%s (ID: %s) stole from %s (ID: %s)", GetPlayerName(source), source, GetPlayerName(playerId),
			playerId), 65280, "Player Steal")                                                                                                                                               -- Green color
end)
