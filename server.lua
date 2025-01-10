ESX = exports['es_extended']:getSharedObject()

-- ESX
RegisterNetEvent('ox_thief:confiscatePlayerItem')
AddEventHandler('ox_thief:confiscatePlayerItem', function(target, itemType, itemName, amount)
	local source = source
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if itemType == 'item_standard' then
		local targetItem = targetXPlayer.getInventoryItem(itemName)
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)

		if targetItem.count > 0 and targetItem.count <= amount then

			if sourceXPlayer.canCarryItem(itemName, sourceItem.count) then
				targetXPlayer.removeInventoryItem(itemName, amount)
				sourceXPlayer.addInventoryItem   (itemName, amount)
			end
		end

	elseif itemType == 'item_account' then
		local targetAccount = targetXPlayer.getAccount(itemName)

		if targetAccount.money >= amount then
			targetXPlayer.removeAccountMoney(itemName, amount, "Confiscated")
			sourceXPlayer.addAccountMoney   (itemName, amount, "Confiscated")
		end

	elseif itemType == 'item_weapon' then
		if amount == nil then amount = 0 end

		if targetXPlayer.hasWeapon(itemName) then
			targetXPlayer.removeWeapon(itemName)
			sourceXPlayer.addWeapon   (itemName, amount)
		end
	end
end)

ESX.RegisterServerCallback('ox_thief:getPlayerData', function(source, cb, target, notify)
	local xPlayer = ESX.GetPlayerFromId(target)

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
    exports['qb-inventory']:OpenInventoryById(source, playerId)
end)
