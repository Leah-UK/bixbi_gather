ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
end)

local spawnedItems = {}
local itemZones = {}
function CreateMapBlips(zones)
    for k, v in pairs(zones) do
        if (v.blipInfo ~= nil) then
            local blip = AddBlipForCoord(v.coords)
	
            SetBlipSprite (blip, v.blipInfo.blipSprite)
            SetBlipDisplay(blip, 6)
            SetBlipScale  (blip, 0.8)
            SetBlipColour (blip, v.blipInfo.blipColour)
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(v.blipInfo.label)
            EndTextCommandSetBlipName(blip)
        end
    end	
end

--[[--------------------------------------------------
Illegal Circle Zones
]]----------------------------------------------------
RegisterNetEvent('bixbi_gather:SetupTargetsClient')
AddEventHandler('bixbi_gather:SetupTargetsClient', function(zones)
    itemZones = zones
    CreateMapBlips(zones)
    Citizen.CreateThread(function()
        for l, z in pairs(itemZones) do
            for k, v in ipairs(z.info) do
                exports['qtarget']:AddTargetModel({v.target}, {
                    options = {
                        {
                            event = "bixbi_gather:TriggerCollect",
                            icon = "fas fa-hand-sparkles",
                            label = "Collect " .. v.label,
                            location = l,
                            item = z.tool,
                        },
                    },
                    distance = 1.5
                })
            end
        end
    end)
end)
-- RegisterNetEvent('bixbi_gather:TriggerCollect')
AddEventHandler('bixbi_gather:TriggerCollect', function(data)
    local source = GetPlayerServerId(PlayerId())
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('bixbi_gather:Collect', coords, data.location)
end)

function CreateProp(waitTime, ConfigItem)
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local toolInfo = itemZones[ConfigItem].toolInfo

        local itemModel = GetHashKey(toolInfo.toolModel)
        local x,y,z = table.unpack(GetEntityCoords(playerPed))
        local boneIndex = GetPedBoneIndex(playerPed, 28422)
        prop = CreateObject(itemModel, x, y, z, true, true, true)
        AttachEntityToEntity(prop, playerPed, boneIndex, toolInfo.xPos, toolInfo.yPos, toolInfo.zPos, toolInfo.xRot, toolInfo.yRot, toolInfo.zRot, true, true, false, true, 1, true)

        Citizen.Wait(waitTime)
        DeleteObject(prop)
    end)
end

RegisterNetEvent('bixbi_gather:StartCollect')
AddEventHandler('bixbi_gather:StartCollect', function(pos, ConfigItem)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local nearbyObject
    local nearbyID = -1

    for i=1, #spawnedItems[ConfigItem].locations, 1 do
        if (#(coords - GetEntityCoords(spawnedItems[ConfigItem].locations[i].object)) < 3.0) then
            nearbyObject, nearbyID = spawnedItems[ConfigItem].locations[i], i
        end
    end

    Citizen.Wait(100)
    if (nearbyID ~= -1) then
        local item = nearbyObject.item

        ESX.TriggerServerCallback('bixbi_core:canHoldItem', function(canHold)
            if (canHold) then
                local animInfo = itemZones[ConfigItem].animInfo
                if (itemZones[ConfigItem].tool ~= nil) then
                    local toolCount = exports['bixbi_core']:itemCount(itemZones[ConfigItem].tool)
                    if (toolCount > 0) then
                        if (animInfo.dict ~= nil) then
                            exports['bixbi_core']:playAnim(playerPed, animInfo.dict, animInfo.anim, -1)
                        else
                            TaskStartScenarioInPlace(playerPed, animInfo.anim, 0, false)	
                        end

                        FreezeEntityPosition(playerPed, true)

                        if (itemZones[ConfigItem].toolInfo ~= nil) then CreateProp(6000, ConfigItem) end
                        
                        exports['bixbi_core']:Loading(6000, 'Attempting to collect ' .. nearbyObject.label .. '(s)')
                        Citizen.Wait(6000)
                        ClearPedTasks(playerPed)
                        -- Citizen.Wait(1000)
                        FreezeEntityPosition(playerPed, false)

                        ESX.Game.DeleteObject(nearbyObject.object)
                        table.remove(spawnedItems[ConfigItem].locations, nearbyID)
                        spawnedItems[ConfigItem].count = spawnedItems[ConfigItem].count - 1

                        -- TriggerServerEvent('bixbi_gather:Success', coords, ConfigItem, item, nearbyObject.itemQty)
                        TriggerServerEvent('bixbi_gather:Success', coords, ConfigItem, item)
                    else
                        exports['bixbi_core']:Notify('error', 'You need a ' .. itemZones[ConfigItem].tool .. ' to do this.')
                    end
                else
                    if (animInfo.dict ~= nil) then
                        exports['bixbi_core']:playAnim(playerPed, animInfo.dict, animInfo.anim, -1)
                    else
                        TaskStartScenarioInPlace(playerPed, animInfo.anim, 0, false)	
                    end

                    if (itemZones[ConfigItem].toolInfo ~= nil) then CreateProp(6000, ConfigItem) end

                    exports['bixbi_core']:Loading(6000, 'Attempting to collect ' .. nearbyObject.label .. '(s)')
                    Citizen.Wait(6000)
                    ClearPedTasks(playerPed)
                    -- Citizen.Wait(1000)

                    ESX.Game.DeleteObject(nearbyObject.object)
                    table.remove(spawnedItems[ConfigItem].locations, nearbyID)
                    spawnedItems[ConfigItem].count = spawnedItems[ConfigItem].count - 1

                    TriggerServerEvent('bixbi_gather:Success', coords, ConfigItem, item, nearbyObject.itemQty)
                end
            else
                exports['bixbi_core']:Notify('error', 'You do not have enough room to store this item.')
            end
        end,  item, 1)
    else
        exports['bixbi_core']:Notify('error', 'You cannot see any resources, perhaps try again? Or maybe you\'re in the wrong area', 10000)
    end
end)

function SpawnItems(EntryName)
    local ConfigItem = itemZones[EntryName]
    local itemInfo = spawnedItems[EntryName]
    if (itemInfo == nil) then
        spawnedItems[EntryName] = {}
        spawnedItems[EntryName].count = 0
        spawnedItems[EntryName].locations = {}
        spawnedItems[EntryName].zone = ConfigItem

        itemInfo = spawnedItems[EntryName]
    end

    while (itemInfo.count < ConfigItem.maxCount + 1) do
        Citizen.Wait(1000)
        for _, v in pairs(ConfigItem.info) do
            if (spawnedItems[EntryName].count < ConfigItem.maxCount) then
                math.randomseed(GetGameTimer())
                local rarity = math.random(1, v.rarity)
                if (rarity == v.rarity) then
                    Citizen.Wait(500)
                    local itemCoords = GenerateItemCoords(ConfigItem, itemInfo)

                    ESX.Game.SpawnLocalObject(v.model, itemCoords, function(obj)
                        PlaceObjectOnGroundProperly(obj)
                        FreezeEntityPosition(obj, true)
                        
                        math.randomseed(GetGameTimer())
                        -- local itemQty = math.random(v.minQty, v.maxQty)
                        -- table.insert(spawnedItems[EntryName].locations, { object = obj, item = v.item, itemQty = itemQty, label = v.label })
                        table.insert(spawnedItems[EntryName].locations, { object = obj, item = v.item, label = v.label })
                        spawnedItems[EntryName].count = itemInfo.count + 1
                    end)
                end
            else
                break
            end
        end
    end
end

function GenerateItemCoords(ConfigItem, itemInfo)
	while (ESX.PlayerLoaded) do
		Citizen.Wait(1)
		math.randomseed(GetGameTimer())
		local modX = math.random(-ConfigItem.radius, ConfigItem.radius)

		Citizen.Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-ConfigItem.radius, ConfigItem.radius)
        
		local itemX = ConfigItem.coords.x + modX
		local itemY = ConfigItem.coords.y + modY

		local coordZ = GetCoordZ(itemX, itemY) or ConfigItem.coords.z
		local coord = vector3(itemX, itemY, coordZ)

		if ValidateItemCoords(ConfigItem, itemInfo, coord) then
            coord = vector3(coord.x, coord.y, coord.z --[[- 1.2]])
			return coord
		end
	end
end

function ValidateItemCoords(ConfigItem, itemInfo, itemCoord)
	if itemInfo.count > 0 then
		local validate = true

		for k, v in pairs(itemInfo.locations) do
			if #(itemCoord - GetEntityCoords(v.object)) < ConfigItem.spacing then
				validate = false
			end
		end
		if (#(itemCoord - ConfigItem.coords) > ConfigItem.radius) then validate = true end

		return validate
	else
		return true
	end
end

function GetCoordZ(x, y)
	-- local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }
	-- for i, height in ipairs(groundCheckHeights) do
	-- 	local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
	-- 	if foundGround then
	-- 		return z
	-- 	end
	-- end
	-- return 43.0
    for height = 1, 1000 do
        local foundGround, zPos = GetGroundZFor_3dCoord(x, y, height + 0.0)
        if foundGround then
            return zPos
        end

        -- Citizen.Wait(5)
    end
end

function LocationLoop()
    TriggerServerEvent('bixbi_gather:SetupTargets')
    Citizen.CreateThread(function()
        local locationLoopSleep = 1
        local lastSpawnedLocation = nil
        while ESX.PlayerLoaded do
            local closestDistance = 1000
            local areaSpawnRadius = 100
            local coords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(itemZones) do
                local distance = #(coords - v.coords)
                if (distance < closestDistance) then closestDistance = distance end
                if (closestDistance < v.radius) then
                    areaSpawnRadius = v.radius
                    SpawnItems(k)
                    lastSpawnedLocation = coords
                    Citizen.Wait(60000)
                end
            end

            if (closestDistance < (areaSpawnRadius * 1.5)) then
                locationLoopSleep = 1
            elseif (closestDistance > 1800) then
                locationLoopSleep = 60
            elseif (closestDistance > 500) then
                locationLoopSleep = 10
            elseif (closestDistance > 200) then
                locationLoopSleep = 5
            end

            if (lastSpawnedLocation ~= nil and #(coords - lastSpawnedLocation) > areaSpawnRadius + 50) then
                RemoveObjects()
                lastSpawnedLocation = nil
            end
            
            Citizen.Wait(locationLoopSleep * 1000) -- Seconds.
        end
    end)
end

--[[--------------------------------------------------
Setup
--]]--------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
	if (resourceName == GetCurrentResourceName() and Config.Debug) then
        while (ESX == nil) do Citizen.Wait(100) end
        Citizen.Wait(5000)
        ESX.PlayerLoaded = true
        LocationLoop()
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    while (ESX == nil) do Citizen.Wait(100) end
    ESX.PlayerData = xPlayer
 	ESX.PlayerLoaded = true
    
    ESX.TriggerServerCallback('bixbi_core:illegalTaskBlacklist', function(result) 
        if (not result) then
            LocationLoop()
        end
    end)
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

function RemoveObjects()
    for _, z in pairs(spawnedItems) do
        for k, v in pairs(z.locations) do
            ESX.Game.DeleteObject(v.object)
        end
    end
    spawnedItems = nil
    spawnedItems = {}
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        RemoveObjects()
	end
end)
