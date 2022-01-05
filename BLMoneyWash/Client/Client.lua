local ESX
local playerData
math.randomseed(GetGameTimer())
local unProcessedMoneySheets = unProcessedMoneySheets or 0
local moneySheets = moneySheets or 0
local cuttedMoney = cuttedMoney or 0
local isProducingSheets = false
local isCountingMoney = false
local producingTime = math.random(Config.ProducingTime.min, Config.ProducingTime.max)
local countingTime = math.random(Config.CountingTime.min, Config.CountingTime.max)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(j)
	playerData.job = j
	removeEntryway()
	Citizen.Wait(1000)
	setupEntryway()
end)

setupEsx = function()
	while not ESX do
		TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
		Wait(100)
	end
	while not ESX.IsPlayerLoaded() do Wait(1000) end
	playerData = ESX.GetPlayerData()
end

removeEntryway = function()
	for i = 1, #Config.Locations do
		exports['fivem-target']:RemoveTargetPoint(Config.Locations[i].name .. '.enter')
		exports['fivem-target']:RemoveTargetPoint(Config.Locations[i].name .. '.exit')
	end
end

setupEntryway = function()
	for i = 1, #Config.Locations do
		if not Config.Locations[i].JobRequired or Config.Locations[i].JobRequired[playerData.job.name] then
			exports["fivem-target"]:AddTargetPoint({
				name = Config.Locations[i].name .. '.enter',
				label = Config.Locations[i].label,
				icon = "fas fa-door-open",
				point = Config.Locations[i].enter,
				interactDist = 2.5,
				onInteract = EnterLeave,
				options = {
					{
						name = 'enter_location',
						label = "Enter",
					},
				},
				vars = {
					loc = Config.Locations[i].exit,
				},
			})
			exports["fivem-target"]:AddTargetPoint({
				name = Config.Locations[i].name .. '.exit',
				label = Config.Locations[i].label,
				icon = "fas fa-door-closed",
				point = Config.Locations[i].exit,
				interactDist = 2.5,
				onInteract = EnterLeave,
				options = {
					{
						name = 'exit_location',
						label = "Exit",
					},
				},
				vars = {
					loc = Config.Locations[i].enter,
				},
			})
		end
	end
end

setupProcessing = function()
	for i = 1, #Config.Locations do
		for k, v in pairs(Config.Locations[i].process) do
			if k ~= 'timer' and k ~= 'output' then
				exports["fivem-target"]:AddTargetPoint({
					name = Config.Locations[i].name .. ' | ' .. k,
					label = Config.Locations[i].label,
					icon = "fas fa-map-marker",
					point = v.pos,
					interactDist = 2.5,
					onInteract = processingInteract,
					options = {
						{
							name = k,
							label = "Open",
						},
					},
				})
			end
		end
	end
end

EnterLeave = function(targetName, optionName, vars, entityHit)
	if Config.RequireKey then
		ESX.TriggerServerCallback('BLMoneyWash:HasKey', function(haskey)
			if haskey then
				local entity = GetPlayerPed(-1)
				DoScreenFadeOut(200)
				Citizen.Wait(200)
				SetEntityCoords(entity, vars.loc, 0, 0, 0, false)
				PlaceObjectOnGroundProperly(entity)
				Citizen.Wait(1500)
				DoScreenFadeIn(200)
			else
				ESX.ShowNotification('Missing the required item to enter')
			end
		end)
	else
		local entity = GetPlayerPed(-1)
		DoScreenFadeOut(200)
		Citizen.Wait(200)
		SetEntityCoords(entity, vars.loc, 0, 0, 0, false)
		PlaceObjectOnGroundProperly(entity)
		Citizen.Wait(1500)
		DoScreenFadeIn(200)
	end
end

processingInteract = function(targetName, optionName, vars, entityHit)
	local playerPed = GetPlayerPed(-1)
	if optionName == 'start' then
		ESX.TriggerServerCallback('BLMoneyWash:getBlackMoneyAmount', function(amount)
			if amount > (10000 - unProcessedMoneySheets) then amount = (10000 - unProcessedMoneySheets) end
			if amount <= 0 then
				if unProcessedMoneySheets < 10000 and moneySheets < 10000 then
					TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
					print('start')
					exports.rprogress:Start("Loading up machine...", Config.WaitingTime)
					print('end')
					unProcessedMoneySheets = unProcessedMoneySheets + amount
					TriggerServerEvent('BLMoneyWash:removeBlackMoney', amount)
					startProducingTimer(amount)
					ClearPedTasksImmediately(playerPed)
				else
					ESX.ShowNotification('The machine is fully loaded...')
				end
			else
				ESX.ShowNotification("This machine can't hold anymore money! It's already over $10,000")
			end
		end)
	elseif optionName == 'counter' then
		if cuttedMoney > 0 then
			startCountingTimer(cuttedMoney)
		else
			ESX.ShowNotification('There is no money left to count...')
		end
	elseif optionName == 'cutter' then
		if moneySheets >= 50 then
			TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
			exports.rprogress:Start("Cutting...", Config.WaitingTime)
			moneySheets = moneySheets - 100
			cuttedMoney = cuttedMoney + 100
			ClearPedTasksImmediately(playerPed)
		else
			ESX.ShowNotification('There are not enough sheets...')
		end
	end
end

startProducingTimer = function(amount)
	if not isProducingSheets then
		isProducingSheets = true
		Citizen.CreateThread(function()
			while isProducingSheets do
				producingTime = producingTime - 1
				if producingTime <= 0 then
					producingTime = 0
					moneySheets = moneySheets + amount
					producingTime = producingTime + math.random(Config.ProducingTime.min, Config.ProducingTime.max)
					isProducingSheets = false
				end
				Citizen.Wait(1000)
			end
		end)
	else
		ESX.ShowNotification("This machine is already being used! Wait until it's done.")
	end
end

startCountingTimer = function(amount)
 if not isCountingMoney then
  isCountingMoney = true
  Citizen.CreateThread(function()
   while isCountingMoney do
    countingTime = countingTime - 1
    if countingTime <= 0 then
     countingTime = 0
     cuttedMoney = cuttedMoney - amount
     TriggerServerEvent('BLMoneyWash:giveCleanMoney', amount)
     countingTime = countingTime + math.random(Config.CountingTime.min, Config.CountingTime.max)
     isCountingMoney = false
    end
    Citizen.Wait(1000)
   end
  end)
 else
  ESX.ShowNotification("Counting already under way! Wait until it's done.")
 end
end

function getClosestProcess(pos)
	local closest, dist, posi

	for i = 1, #Config.Locations do
		for k, v in pairs(Config.Locations[i].process) do
			local d = #(v.pos - pos)
			if not dist or d < dist then
				posi = v.pos
				closest = k
				dist = d
			end
		end
	end

	return closest, dist, posi
end

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

Citizen.CreateThread(function()
	setupEsx()
	setupProcessing()
	while true do
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local closestProc, ProcDist, MarkerPos = getClosestProcess(pos)

		if ProcDist <= 6 then Text3D[closestProc](MarkerPos) end
		Wait(ProcDist < 10 and 0 or 750)
	end
end)

Text3D = {
	start = function(POS) DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Load Machine') end,
	timer = function(POS)
		if isProducingSheets and producingTime > 0 then
			DrawText3D(POS.x, POS.y, POS.z + 0.28, 'Amount: ~g~$' .. unProcessedMoneySheets .. '~w~')
			DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Production Process: ~y~' .. producingTime .. ' seconds~w~')
		end
	end,
	output = function(POS) DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Output: ~y~$' .. moneySheets .. '~w~ worth of sheets') end,
	cutter = function(POS)
		DrawText3D(POS.x, POS.y, POS.z + 0.25, 'Sheets: ~y~' .. moneySheets .. '~w~')
		DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Start Cutting')
	end,
	counter = function(POS)
		DrawText3D(POS.x, POS.y, POS.z + 0.25, 'Cutted Amount: ~y~$' .. cuttedMoney .. '~w~')
		if isCountingMoney and countingTime > 0 then
			DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Counting Process: ~y~' .. countingTime .. ' seconds~w~')
		else
			DrawText3D(POS.x, POS.y, POS.z + 0.15, 'Count Money')
		end
	end,
}
