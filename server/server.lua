ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

RegisterServerEvent('bixbi_gather:Collect')
AddEventHandler('bixbi_gather:Collect', function(pos, itemZone)
    local zone = Config.CircleZones[itemZone]
    local distance = #(pos - zone.coords)
    if (distance < zone.radius) then
        TriggerClientEvent('bixbi_gather:StartCollect', source, pos, itemZone)
    end
end)

RegisterServerEvent('bixbi_gather:SetupTargets')
AddEventHandler('bixbi_gather:SetupTargets', function()
    local zones = Config.CircleZones
    TriggerClientEvent('bixbi_gather:SetupTargetsClient', source, zones)
end)

RegisterServerEvent('bixbi_gather:Success')
AddEventHandler('bixbi_gather:Success', function(pos, field, item, count)
    local field = Config.CircleZones[field]
    if (#(pos - field.coords) < field.radius) then
        exports.bixbi_core:addItem(source, item, count)

        TriggerClientEvent('bixbi_core:Notify', source, '', 'You have collected ' .. count .. 'x ' .. item)
    else
        TriggerClientEvent('bixbi_core:Notify', source, 'error', 'You were too far away from the item zone')
    end
end)

ESX.RegisterServerCallback('bixbi_gather:LegalJobs', function(source, cb)
    local zones = {}
    for k, v in pairs(Config.CircleZones) do
        if (v.blipInfo ~= nil) then table.insert(zones, {label = v.blipInfo.label, location = v.coords, tool = v.tool, locname = k}) end
    end
	cb(zones)
end)

AddEventHandler('onResourceStart', function(resourceName)
	if (GetResourceState('bixbi_core') ~= 'started' ) then
        print('bixbi_gather - ERROR: Bixbi_Core hasn\'t been found! This could cause errors!')
    end
end)