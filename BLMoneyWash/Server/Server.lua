ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('BLMoneyWash:getBlackMoneyAmount', function(source, cb)
	local sourcePlayer = ESX.GetPlayerFromId(source)
	local amount = sourcePlayer.getAccount('black_money').money

	if amount ~= nil then cb(amount) end
end)

RegisterNetEvent('BLMoneyWash:removeBlackMoney')
AddEventHandler('BLMoneyWash:removeBlackMoney', function(amount)
	local sourcePlayer = ESX.GetPlayerFromId(source)

	sourcePlayer.removeAccountMoney('black_money', amount)
end)

RegisterNetEvent('BLMoneyWash:giveCleanMoney')
AddEventHandler('BLMoneyWash:giveCleanMoney', function(amount)
	local sourcePlayer = ESX.GetPlayerFromId(source)
	local total = 0
	if Config.TakePercentage then
		total = amount * Config.WashPercentage
	else
		total = amount
	end
	if total ~= 0 then
		sourcePlayer.addMoney(total)
		TriggerClientEvent('esx:showNotification', source, 'You washed ~y~€' .. total .. '~s~.')
	else
		TriggerClientEvent('esx:showNotification', source, 'Something went wrong with GiveCleanMoney, please let your dev know!')
	end
end)

ESX.RegisterServerCallback('BLMoneyWash:HasKey', function(source, cb)
	local sourcePlayer = ESX.GetPlayerFromId(source)

	if sourcePlayer.getInventoryItem(Config.WashKey) and sourcePlayer.getInventoryItem(Config.WashKey).count > 0 then
		cb(true)
	else
		cb(false)
	end
end)
