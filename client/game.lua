ESX = nil
local LaunchJoin = false
local IsInGame = false
local Team = nil
local sexe = nil
local ScoreTeamGreen = 0
local ScoreTeamRed = 0
local startTime
local displayDoneMission = false
local CurrentWeapon = nil
local rt = RequestScaleformMovie("MP_BIG_MESSAGE_FREEMODE")

RMenu.Add('airSoft', 'main', RageUI.CreateMenu("Air Soft", " "))
RMenu:Get('airSoft', 'main'):SetSubtitle("~b~Choisissez votre arme")
RMenu:Get('airSoft', 'main').EnableMouse = false
RMenu:Get('airSoft', 'main').Closed = function()
end;

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSh4587poiaredObj4587poiect', function(obj)
            ESX = obj
        end)
        Wait(0)
    end
end)

RegisterNetEvent("ad_event:StartLaunchJoin")
AddEventHandler("ad_event:StartLaunchJoin", function()
    LaunchJoin = true
    startPoint()
end)

RegisterNetEvent("ad_event:StopLaunchJoin")
AddEventHandler("ad_event:StopLaunchJoin", function()
    LaunchJoin = false
end)

RegisterNetEvent("ad_event:StopLaunchJoinAndGame")
AddEventHandler("ad_event:StopLaunchJoinAndGame", function()
    local PlayerPed = GetPlayerPed(-1)
    SetEntityInvincible(PlayerPedId(), false)
    SetPlayerInvincible(PlayerId(), false)
    if IsInGame then
        if Team == "Green" then
            SetEntityCoords(PlayerPed, Config.StartPointGreen)
            SetEntityHeading(PlayerPed, Config.StartPointGreenHeading)
        elseif Team == "Red" then
            SetEntityCoords(PlayerPed, Config.StartPointRed)
            SetEntityHeading(PlayerPed, Config.StartPointRedHeading)
        end
        displayDoneMission = true
        RemoveWeaponFromPed(PlayerPedId(), GetHashKey(CurrentWeapon))
        TriggerEvent("esx:removeWeapon", CurrentWeapon)
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    end
    for k,v in pairs(Config.Weapon) do
        v.Green = true
        v.Red = true
    end
    LaunchJoin = false
    IsInGame = false
    Team = nil
end)

function startPoint()
    while LaunchJoin == true and IsInGame == false do
        local _Wait = 500
        if LaunchJoin == true and IsInGame == false then
            local PlayerPed = GetPlayerPed(-1)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            local dst = GetDistanceBetweenCoords( Config.StartPointGreen, PlayerCoords)
            if dst < 20.0 then
                DrawMarker(1, Config.StartPointGreen.x, Config.StartPointGreen.y, Config.StartPointGreen.z - 1.5, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 0, 255, 0, 180, 0, 0, 0,0)
                _Wait = 1
                if dst < 10.0 then
                    Draw3DText( Config.StartPointGreen.x, Config.StartPointGreen.y, Config.StartPointGreen.z -.500, "~b~A~w~D Event",4,0.3,0.2)
                    Draw3DText( Config.StartPointGreen.x, Config.StartPointGreen.y, Config.StartPointGreen.z  -.900, "Rejoindre l'équipe ~g~verte",4,0.3,0.2)
                    if dst < 2.0 then
                        Draw3DText( Config.StartPointGreen.x, Config.StartPointGreen.y, Config.StartPointGreen.z  -1.400, "Appuyez sur E pour rejoindre",4,0.15,0.1)
                        if (IsControlJustReleased(1, 38)) then
                            if IsInGame == false then
                                TriggerEvent('ad_event:StartTeamGreen')
                            else
                                return
                            end
                        end
                    end
                end
            end
            
            local dst2 = GetDistanceBetweenCoords(Config.StartPointRed, PlayerCoords)
            if dst2 < 20.0 then
                DrawMarker(1, Config.StartPointRed.x, Config.StartPointRed.y, Config.StartPointRed.z - 1.5, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 0, 0, 180, 0, 0, 0,0)
                _Wait = 1
                if dst2 < 10.0 then
                    Draw3DText(Config.StartPointRed.x, Config.StartPointRed.y, Config.StartPointRed.z -.500, "~b~A~w~D Event",4,0.3,0.2)
                    Draw3DText(Config.StartPointRed.x, Config.StartPointRed.y, Config.StartPointRed.z  -.900, "Rejoindre l'équipe ~r~rouge",4,0.3,0.2)
                    if dst2 < 2.0 then
                        Draw3DText(Config.StartPointRed.x, Config.StartPointRed.y, Config.StartPointRed.z  -1.400, "Appuyez sur E pour rejoindre",4,0.15,0.1)
                        if (IsControlJustReleased(1, 38)) then
                            if IsInGame == false then
                                TriggerEvent('ad_event:StartTeamRed')
                            else
                                return
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(_Wait)
    end
end

RegisterNetEvent("ad_event:StartTeamGreen")
AddEventHandler("ad_event:StartTeamGreen", function()
    IsInGame = true
    Team = "Green"
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            sexe = "Male"
            local Male = {
                ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                ['torso_1'] = 222,   ['torso_2'] = 17,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 26,
                ['pants_1'] = 86,    ['pants_2'] = 17,
                ['shoes_1'] = 59,   ['shoes_2'] = 17,
                ['helmet_1'] = 103,  ['helmet_2'] = 17,
                ['chain_1'] = 1,    ['chain_2'] = 2,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = 15,  ['glasses_2'] = 1,
                ['bags_1'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, Male)
        else
            sexe = "Female"
            local Female = {
                ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                ['torso_1'] = 231,   ['torso_2'] = 17,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 20,
                ['pants_1'] = 89,    ['pants_2'] = 17,
                ['shoes_1'] = 62,   ['shoes_2'] = 17,
                ['helmet_1'] = 102,  ['helmet_2'] = 17,
                ['chain_1'] = 1,    ['chain_2'] = 2,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = 25,  ['glasses_2'] = 1,
                ['bags_1'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, Female)
        end
    end)
    TriggerServerEvent("ad_event:AddPlayer", Team)
    RageUI.Visible(RMenu:Get('airSoft', 'main'), not RageUI.Visible(RMenu:Get('airSoft', 'main')))
end)

RegisterNetEvent("ad_event:StartTeamRed")
AddEventHandler("ad_event:StartTeamRed", function()
    IsInGame = true
    Team = "Red"
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            sexe = "Male"
            local Male = {
                ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
                ['torso_1'] = 222,   ['torso_2'] = 5,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 26,
                ['pants_1'] = 86,    ['pants_2'] = 5,
                ['shoes_1'] = 59,   ['shoes_2'] = 5,
                ['helmet_1'] = 103,  ['helmet_2'] = 5,
                ['chain_1'] = 1,    ['chain_2'] = 2,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = 15,  ['glasses_2'] = 1,
                ['bags_1'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, Male)
        else
            sexe = "Female"
            local Female = {
                ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
                ['torso_1'] = 231,   ['torso_2'] = 5,
                ['decals_1'] = 0,   ['decals_2'] = 0,
                ['arms'] = 20,
                ['pants_1'] = 89,    ['pants_2'] = 5,
                ['shoes_1'] = 62,   ['shoes_2'] = 5,
                ['helmet_1'] = 102,  ['helmet_2'] = 5,
                ['chain_1'] = 1,    ['chain_2'] = 2,
                ['ears_1'] = -1,     ['ears_2'] = 0,
                ['glasses_1'] = 25,  ['glasses_2'] = 1,
                ['bags_1'] = 0,
                ['mask_1'] = -1, ['mask_2'] = 0,
            }
            TriggerEvent('skinchanger:loadClothes', skin, Female)
        end
    end)
    TriggerServerEvent("ad_event:AddPlayer", Team)
    RageUI.Visible(RMenu:Get('airSoft', 'main'), not RageUI.Visible(RMenu:Get('airSoft', 'main')))
end)

RageUI.CreateWhile(1.0, RMenu:Get('airSoft', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('airSoft', 'main'), true, true, true, function()
        for k,v in pairs(Config.Weapon) do
            if v[Team] then
                RageUI.Button(v.label, nil, {}, true, function(Hovered, Active, Selected)
                    if Selected then
                        v[Team] = false
                        CurrentWeapon = v.name
                        TriggerServerEvent("ad_event:GiveWeapon", v.name, Team)
                        RageUI.Visible(RMenu:Get('airSoft', 'main'), not RageUI.Visible(RMenu:Get('airSoft', 'main')))
                    end
                end)
            else
                RageUI.Button(v.label, "~r~Cette arme est déjà prise par votre équipe", { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)
                end)
            end
        end
    end, function()
    end)
end)

RegisterNetEvent("ad_event:RemoveWeapon")
AddEventHandler("ad_event:RemoveWeapon", function(weapon, _Team)
    for k,v in pairs(Config.Weapon) do
        if v.name == weapon then
            v[_Team] = false
        end
    end
end)

RegisterNetEvent("ad_event:StartGameForAllTeam")
AddEventHandler("ad_event:StartGameForAllTeam", function(_ScoreTeamGreen, _ScoreTeamRed)
    if IsInGame then
        local PlayerPed = GetPlayerPed(-1)
        ScoreTeamGreen = _ScoreTeamGreen
        ScoreTeamRed = _ScoreTeamRed
        startTime = GetGameTimer()
        if Team == "Green" then
            SetEntityCoords(PlayerPed, Config.SpawnPointGreen.c)
            SetEntityHeading(PlayerPed, Config.SpawnPointGreen.h)
        elseif Team == "Red" then
            SetEntityCoords(PlayerPed, Config.SpawnPointRed.c)
            SetEntityHeading(PlayerPed, Config.SpawnPointRed.h)
        end
        SetEntityHealth(PlayerPed, GetEntityMaxHealth(PlayerPed))
        TriggerEvent("ad_event:StartHUDTimer")
        TriggerEvent("ad_event:StartPointWeapon")
        TriggerEvent('esx:showAdvancedStreamedNotification', '~b~A~w~D Event', '~c~Air Soft', "Partie lancée ! Vous êtes immunisé pendant 10 secondes.", 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
        SetEntityInvincible(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)
        Citizen.Wait(10000)
        TriggerEvent('esx:showAdvancedStreamedNotification', '~b~A~w~D Event', '~c~Air Soft', "Vous n'êtes plus immunisé !", 'CHAR_SOCIAL_CLUB', 'newstartlogo', 8)
        TriggerEvent("ad_event:GetDomage")
    end
end)

RegisterNetEvent("ad_event:UpdateScore")
AddEventHandler("ad_event:UpdateScore", function(_ScoreTeamGreen, _ScoreTeamRed)
    ScoreTeamGreen = _ScoreTeamGreen
    ScoreTeamRed = _ScoreTeamRed
end)

RegisterNetEvent("ad_event:StartHUDTimer")
AddEventHandler("ad_event:StartHUDTimer", function()
    while IsInGame do
        local time = formatTimer(startTime, GetGameTimer())
        if Team == "Green" then
            SendNUIMessage({HUD = "Green", Time = time, Score = ScoreTeamGreen})
        elseif Team == "Red" then
            SendNUIMessage({HUD = "Red", Time = time, Score = ScoreTeamRed})
        end
        Citizen.Wait(1)
    end
    SendNUIMessage({HUD = false, Time = time, Score = ScoreTeamRed})
end)

RegisterNetEvent("ad_event:GetDomage")
AddEventHandler("ad_event:GetDomage", function()
    while IsInGame do
        SetEntityInvincible(PlayerPedId(), true)
        SetPlayerInvincible(PlayerId(), true)
        if IsPedShooting(PlayerPedId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey(CurrentWeapon) then
            local coords = GetEntityCoords(PlayerPedId())
            local coords = GetPedBoneCoords(PlayerPedId(), GetHashKey('SKEL_R_Hand'), 0.0, 0.0, 0.0)
            local x, bulletCoord = GetPedLastWeaponImpactCoord(PlayerPedId())
            if x then
                local rayHandle = StartShapeTestRay(coords.x, coords.y, coords.z, bulletCoord.x, bulletCoord.y, bulletCoord.z, 10, PlayerPedId(), 0)
                local _, _, _, _, ped = GetShapeTestResult(rayHandle)
                if GetEntityType(ped) == 1 then
                    for k, v in pairs(GetActivePlayers()) do
                        if GetPlayerPed(v) == ped then
                            PlaySoundFrontend(-1, "Checkpoint_Hit", "GTAO_FM_Events_Soundset", 1)
                            PlaySoundFrontend(-1, "Checkpoint_Hit", "GTAO_FM_Events_Soundset", 1)
                            TriggerServerEvent('ad_event:kill', GetPlayerServerId(v), Team)
                            Citizen.Wait(500)
                            break
                        end
                    end
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('ad_event:died')
AddEventHandler('ad_event:died', function(killedBy)
    local timer = GetGameTimer() + 2000
    StartAudioScene("DEATH_SCENE")
    SetTimecycleModifier("BlackOut")
    SetEntityHasGravity(PlayerPedId(), false)

    local coordsFrom = GetEntityCoords(PlayerPedId())

    local cam = CreateCam("DEFAULT_SCRIPTED_Camera", 1)
    SetCamCoord(cam, coordsFrom.x, coordsFrom.y, coordsFrom.z)
    RenderScriptCams(1, 0, 0, 1, 1)

    exports["ad_c"]:SetEntityCoords2(PlayerPedId(), GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z+5.0)
    Citizen.CreateThread(function()
        while timer >= GetGameTimer() and IsInGame do
            SetCamFov(cam, GetCamFov(cam) - 0.1)
            Citizen.Wait(50)
        end
    end)
    while timer >= GetGameTimer() and IsInGame do
        Citizen.Wait(0)
        PointCamAtEntity(cam, GetPlayerPed(GetPlayerFromServerId(killedBy)), 0.0, 0.0, 0.0, true)
        SetEntityVisible(PlayerPedId(), false, false)
        for i = 0, 31 do
            DisableAllControlActions(i)
        end
    end
    if IsInGame then
        StopAudioScene("DEATH_SCENE")
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam)
        exports["ad_c"]:SetEntityCoords2(PlayerPedId(), Config.SpawnPoints[math.random(1, #Config.SpawnPoints)])
        PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        SetAmmoInClip(PlayerPedId(), GetHashKey(CurrentWeapon), 255)
    end
    StopAudioScene("DEATH_SCENE")
    SetEntityVisible(PlayerPedId(), true, false)
    SetEntityHasGravity(PlayerPedId(), true)
    ClearTimecycleModifier()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
end)

RegisterNetEvent("ad_event:StartPointWeapon")
AddEventHandler("ad_event:StartPointWeapon", function()
    while IsInGame do
        for k,v in pairs(Config.StartPointWeapon) do
            local PlayerPed = GetPlayerPed(-1)
            local PlayerCoords = GetEntityCoords(PlayerPed)
            DrawMarker(32, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 0, 170, 0, 0, 2, 1, nil, nil, 0)
            if GetDistanceBetweenCoords(v, PlayerCoords) < 2.0 then
                ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour récupérer des munitions")
                if (IsControlJustReleased(1, 38)) then
                    GiveWeaponToPed(PlayerPed, GetHashKey(CurrentWeapon), 250)
                end
            end
        end
        Citizen.Wait(1)
    end
end)


-----------------------
-- Utils
-----------------------

ShowHelpNotification = function(msg)
	AddTextEntry('MissionHelpNotif', msg)
	DisplayHelpTextThisFrame('MissionHelpNotif', false)
end

function formatTimer(startTime, currTime)
    local newTime = currTime - startTime
    local floor = math.floor
    local ms = floor(newTime % 1000)
    local hundredths = floor(ms / 10)
    local seconds = floor(newTime / 1000)
    local minutes = floor(seconds / 60);   seconds = floor(seconds % 60)
    if minutes >= 5 then
        TriggerEvent("ad_event:StopLaunchJoinAndGame")
    end
    local formattedTime = string.format("%02d:%02d.%02d", minutes, seconds, hundredths)
    return formattedTime
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 250)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawHudText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(coordsx,coordsy)
end

Citizen.CreateThread(function()
	while true do
		if displayDoneMission then
			StartScreenEffect("SuccessTrevor",  2500,  false)
			curMsg = "SHOW_MISSION_PASSED_MESSAGE"
			SetAudioFlag("AvoidMissionCompleteDelay", true)
			PlayMissionCompleteAudio("FRANKLIN_BIG_01")
			Citizen.Wait(8000)
			StopScreenEffect()
			curMsg = "TRANSITION_OUT"
			PushScaleformMovieFunction(rt, "TRANSITION_OUT")
			PopScaleformMovieFunction()
			Citizen.Wait(2000)
			displayDoneMission = false
		end
		Citizen.Wait(1)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if (HasScaleformMovieLoaded(rt) and displayDoneMission) then
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(19)
			HideHudAndRadarThisFrame()

			if (curMsg == "SHOW_MISSION_PASSED_MESSAGE") then
                PushScaleformMovieFunction(rt, curMsg)
    
                PushScaleformMovieMethodParameterString("Fin de la partie !")
                PushScaleformMovieMethodParameterString("L'équipe VERTE finit avec un score de : ~g~"..ScoreTeamGreen.." ~w~et l'équipe ROUGE finit avec un score de : ~r~"..ScoreTeamRed)
                EndScaleformMovieMethod()

                PushScaleformMovieFunctionParameterInt(145)
                PushScaleformMovieFunctionParameterBool(false)
                PushScaleformMovieFunctionParameterInt(1)
                PushScaleformMovieFunctionParameterBool(true)
                PushScaleformMovieFunctionParameterInt(69)

                PopScaleformMovieFunctionVoid()

                Citizen.InvokeNative(0x61bb1d9b3a95d802, 1)
			end

			DrawScaleformMovieFullscreen(rt, 255, 255, 255, 255)
		end
    end
end)

--create blip
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Blip.x, Config.Blip.y, Config.Blip.z)
    SetBlipSprite(blip, Config.Blip.id)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, Config.Blip.colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.title)
    EndTextCommandSetBlipName(blip)
end)