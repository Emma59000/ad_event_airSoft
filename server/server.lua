ESX              = nil

local admins = {
    'license:dbcef169823f61b28b2b6eb2a625c973408ee111', -- Peter
    'license:fcf3ed924d3ae6df3591dd908f95b89c901201d9', -- Jenny
}
local Player = {}
local ScoreTeamGreen = 0
local ScoreTeamRed = 0

TriggerEvent('esx:getSh4587poiaredObj4587poiect', function(obj) ESX = obj end)

function isAllowedToChange(player)
    local allowed = false
    for i,id in ipairs(admins) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if debugprint then print('admin id: ' .. id .. '\nplayer id:' .. pid) end
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

RegisterCommand("StartEvent", function(source, args, rawCommand)
    if (source > 0) then
        if isAllowedToChange(source) then
            TriggerClientEvent("ad_event:StartLaunchJoin", -1)
        else
            TriggerClientEvent("chat:addMessage", -1, {
                args = {
                    GetPlayerName(source),
                    "Accès refusé à cette commande !"
                },
                color = { 255, 0, 0 }
            })
        end
    end
end)

RegisterCommand("StopEvent", function(source, args, rawCommand)
    if (source > 0) then
        if isAllowedToChange(source) then
            Player = {}
            TriggerClientEvent("ad_event:StopLaunchJoinAndGame", -1)
            ScoreTeamGreen = 0
            ScoreTeamRed = 0
        else
            TriggerClientEvent("chat:addMessage", -1, {
                args = {
                    GetPlayerName(source),
                    "Accès refusé à cette commande !"
                },
                color = { 255, 0, 0 }
            })
        end
    end
end)

RegisterCommand("StartGame", function(source, args, rawCommand)
    if (source > 0) then
        if isAllowedToChange(source) then
            ScoreTeamGreen = 0
            ScoreTeamRed = 0
            TriggerClientEvent("ad_event:StartGameForAllTeam", -1, ScoreTeamGreen, ScoreTeamRed)
            TriggerClientEvent("ad_event:StopLaunchJoin", -1)
        else
            TriggerClientEvent("chat:addMessage", -1, {
                args = {
                    GetPlayerName(source),
                    "Accès refusé à cette commande !"
                },
                color = { 255, 0, 0 }
            })
        end
    end
end)

RegisterCommand("EventPlayerList", function(source, args, rawCommand)
    if (source > 0) then
        if isAllowedToChange(source) then
            print(json.encode(Player))
        else
            TriggerClientEvent("chat:addMessage", -1, {
                args = {
                    GetPlayerName(source),
                    "Accès refusé à cette commande !"
                },
                color = { 255, 0, 0 }
            })
        end
    end
end)

RegisterServerEvent('ad_event:AddPlayer')
AddEventHandler('ad_event:AddPlayer', function (_team)
    table.insert(Player, {PlayerID = source, Team = _team})
end)

RegisterServerEvent('ad_event:GiveWeapon')
AddEventHandler('ad_event:GiveWeapon', function(weapon, Team)
    TriggerClientEvent("ad_event:RemoveWeapon", -1, weapon, Team)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.addWeapon(weapon, 250)
end)

isplayerActive = function(id)
    local playerTable = GetPlayers()
    for k, v in pairs(playerTable) do
        if tonumber(v) == id then
            return true
        end
    end
    return false
end

RegisterServerEvent('ad_event:kill')
AddEventHandler('ad_event:kill', function(killed, Team)
    local src = source
    local killedPlaying = false
    local killedPlayingTeam = nil
    if isplayerActive(killed) then
        for k,v in pairs(Player) do
            if v.PlayerID == killed then
                TriggerClientEvent('ad_event:died', v.PlayerID, src)
                killedPlaying = true
                killedPlayingTeam = v.Team
            end
        end
    end
    if killedPlaying then
        if killedPlayingTeam ~= Team then
            for k,v in pairs(Player) do
                if v.PlayerID == src then
                    if Team == "Green" then 
                        ScoreTeamGreen = ScoreTeamGreen + 1
                    elseif Team == "Red" then
                        ScoreTeamRed = ScoreTeamRed + 1
                    end
                    print("--------------------------")
                    print("Score de la Team Green : "..ScoreTeamGreen)
                    print("Score de la Team Red : "..ScoreTeamRed)
                    print("--------------------------")
                    TriggerClientEvent("ad_event:UpdateScore", -1, ScoreTeamGreen, ScoreTeamRed)
                    TriggerClientEvent('esx:showAdvancedStreamedNotification', v.PlayerID, '~b~A~w~D Event', '~c~Air Soft', 'Tu à tué : ~r~' .. GetPlayerName(killed), 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
                elseif v.PlayerID == killed then
                    TriggerClientEvent('esx:showAdvancedStreamedNotification', v.PlayerID, '~b~A~w~D Event', '~c~Air Soft', 'Tu à été tué par : ~r~' .. GetPlayerName(src), 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
                else
                    TriggerClientEvent('esx:showAdvancedStreamedNotification', v.PlayerID, '~b~A~w~D Event', '~c~Air Soft', GetPlayerName(killed) .. ' à été tué par ' .. GetPlayerName(src), 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
                end
            end
        else
            for k,v in pairs(Player) do
                if v.PlayerID == src then
                    TriggerClientEvent('esx:showAdvancedStreamedNotification', v.PlayerID, '~b~A~w~D Event', '~c~Air Soft', '~r~Tu à tué une personne de ton équipe', 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
                elseif v.PlayerID == killed then
                    TriggerClientEvent('esx:showAdvancedStreamedNotification', v.PlayerID, '~b~A~w~D Event', '~c~Air Soft', '~r~Tu à été tué par une personne de ton équipe', 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
                end
            end
        end
    end
end)