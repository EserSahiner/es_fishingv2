----------------
-- E  D  I  T --
----------------

local StartFishing_KEY = 38 -- E 
local Caught_KEY = 201 -- ENTER
local SuccessLimit = 0.09 -- Maxim 0.1 (high value, low success chances)
local AnimationSpeed = 0.0015
local ShowChatMSG = true -- or false

--------------------------------EDITS--------------------------------
function LocalPed()
	return GetPlayerPed(-1)
end

local showBlip = true

local fishstore = {
  {name="Fish Store", id=356, colour=75, x=-1845.090, y=-1197.110, z=19.186},
}

local fishingzoneblips = {
  {name="Fishing Zone", id=68, colour=3, x=-1614.893, y=5260.193, z=3.974},
  --{name="Fishing Zone", id=68, colour=3, x=3867.511, y=4463.621, z=2.724},
}

local lang = 'en'

local txt = {
    ['YourLanguage'] = {
		['sellFish'] = 'EDIT',
		['zoneFish'] = 'EDIT',
		['catchFish'] = 'EDIT'
    },

	['en'] = {
		['sellFish'] = 'Press ~g~E~s~ to sell your fishes !',
		['zoneFish'] = 'Press ~g~E~s~ to fishing !',
		['catchFish'] = 'Press ~g~ENTER~s~ to catch fish !'
		
	}
}
--------------------------------EDITS--------------------------------


--------------------------------BLIPS--------------------------------
Citizen.CreateThread(function()
 if (showBlip == true) then
    for _, item in pairs(fishstore) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
 end
end)

Citizen.CreateThread(function()
 if (showBlip == true) then
    for _, item in pairs(fishingzoneblips) do
      item.blip = AddBlipForCoord(item.x, item.y, item.z)
      SetBlipSprite(item.blip, item.id)
      SetBlipColour(item.blip, item.colour)
      SetBlipAsShortRange(item.blip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(item.name)
      EndTextCommandSetBlipName(item.blip)
    end
 end
end)
--------------------------------BLIPS--------------------------------



----------------
-- C  O  D  E --
----------------

-- V A R S
local IsFishing = false
local CFish = false
local BarAnimation = 0
local Faketimer = 0
local RunCodeOnly1Time = true
local PosX = 0.5
local PosY = 0.1
local TimerAnimation = 0.1


-- T H R E A D
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(1)
	if GetDistanceBetweenCoords(-1614.893, 5260.193, 3.974, GetEntityCoords(LocalPed())) < 2.0 then
	DrawMarker(1, -1614.893, 5260.193, 3.974 - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5001, 155, 255, 0,165, 0, 0, 0,0)
	DisplayHelpText(txt[lang]['zoneFish'])
	--elseif GetDistanceBetweenCoords(3867.511, 4463.621, 2.724, GetEntityCoords(LocalPed())) < 2.0 then -------- green colored lines don't work for now
	--DrawMarker(1, 3867.511, 4463.621, 2.724 - 1, 0, 0, 0, 0, 0, 0, 2.0001, 2.0001, 0.5001, 255, 165, 0,165, 0, 0, 0,0) --------
	--DisplayHelpText(txt[lang]['zoneFish']) --------
		if IsControlJustPressed(1, StartFishing_KEY) then
		DisplayHelpText(txt[lang]['catchFish'])
			if not IsPedInAnyVehicle(GetPed(), false) then
				if not IsPedSwimming(GetPed()) then
						IsFishing = true
						if ShowChatMSG then Chat(msg[1]) end
						RunCodeOnly1Time = true
						BarAnimation = 0
					else
						if ShowChatMSG then Chat('^1'..msg[6]) end
					end
				end
			end
		end
		while IsFishing do
			local time = 4*3000
			TaskStandStill(GetPed(), time+7000)
			FishRod = AttachEntityToPed('prop_fishing_rod_01',60309, 0,0,0, 0,0,0)
			PlayAnim(GetPed(),'amb@world_human_stand_fishing@base','base',4,3000)
			Citizen.Wait(time)
			CFish = true
			IsFishing = false
		end
		while CFish do
			Citizen.Wait(1)
			FishGUI(true)
			if RunCodeOnly1Time then
				Faketimer = 1
				PlayAnim(GetPed(),'amb@world_human_stand_fishing@idle_a','idle_c',1,0) -- 10sec
				RunCodeOnly1Time = false
			end
			if TimerAnimation <= 0 then
				CFish = false
				TimerAnimation = 0.1
				StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
				Citizen.Wait(200)
				DeleteEntity(FishRod)
				if ShowChatMSG then Chat('^1'..msg[2]) end
				
			end
			if IsControlJustPressed(1, Caught_KEY) then
				if BarAnimation >= SuccessLimit then
					CFish = false
					TimerAnimation = 0.1
					TriggerEvent('player:receiveItem', math.random(15,20), 1)
					if ShowChatMSG then Chat('^2'..msg[3]) end
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
				else
					CFish = false
					TimerAnimation = 0.1
					StopAnimTask(GetPed(), 'amb@world_human_stand_fishing@idle_a','idle_c',2.0)
					Citizen.Wait(200)
					DeleteEntity(FishRod)
					if ShowChatMSG then Chat('^1'..msg[4]) end
				end
			end
		end
	end
end)

Citizen.CreateThread(function() -- Thread for  timer
	while true do 
		Citizen.Wait(1000)
		Faketimer = Faketimer + 1 
	end 
end)

-- F  U  N  C  T  I  O  N  S 
function GetCar() return GetVehiclePedIsIn(GetPlayerPed(-1),false) end
function GetPed() return GetPlayerPed(-1) end

function text(x,y,scale,text)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(0,0,0,0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
function FishGUI(bool)
	if not bool then return end
	DrawRect(PosX,PosY+0.005,TimerAnimation,0.005,255,255,0,255)
	DrawRect(PosX,PosY,0.1,0.01,0,0,0,255)
	TimerAnimation = TimerAnimation - 0.0001025
	if BarAnimation >= SuccessLimit then
		DrawRect(PosX,PosY,BarAnimation,0.01,102,255,102,150)
	else
		DrawRect(PosX,PosY,BarAnimation,0.01,255,51,51,150)
	end
	if BarAnimation <= 0 then
		up = true
	end
	if BarAnimation >= PosY then
		up = false
	end
	if not up then
		BarAnimation = BarAnimation - AnimationSpeed
	else
		BarAnimation = BarAnimation + AnimationSpeed
	end
	text(0.4,0.05,0.35, msg[5])
end
function PlayAnim(ped,base,sub,nr,time) 
	Citizen.CreateThread(function() 
		RequestAnimDict(base) 
		while not HasAnimDictLoaded(base) do 
			Citizen.Wait(1) 
		end
		if IsEntityPlayingAnim(ped, base, sub, 3) then
			ClearPedSecondaryTask(ped) 
		else 
			for i = 1,nr do 
				TaskPlayAnim(ped, base, sub, 8.0, -8, -1, 16, 0, 0, 0, 0) 
				Citizen.Wait(time) 
			end 
		end 
	end) 
end
function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
	BoneID = GetPedBoneIndex(GetPed(), bone_ID)
	obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
	vX,vY,vZ = table.unpack(GetEntityCoords(GetPed()))
	xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPed(),2))
	AttachEntityToEntity(obj,  GetPed(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
	return obj
end
function Chat(text)
	TriggerEvent("chatMessage", 'SYSTEM', { 255,255,0}, text)
end

--------------------------------SELL SYSTEM & LOCATION--------------------------------

Citizen.CreateThread(
	function()
		local x = -1845.090
		local y = -1197.110
		local z = 19.186

		while true do
		Citizen.Wait(1)
			

			local playerPos = GetEntityCoords(GetPlayerPed(-1), true)

			if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 20.0) then
				DrawMarker(1, x, y, z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 1.5001, 255, 165, 0,165, 0, 0, 0,0)

				if (Vdist(playerPos.x, playerPos.y, playerPos.z, x, y, z) < 2.0) then
						DisplayHelpText(txt[lang]['sellFish'])
					if (IsControlJustReleased(1, 51)) then
						TriggerEvent("player:sellItem2", 15, 30)
						Citizen.Wait(500)
						TriggerEvent("player:sellItem2", 16, 300)
						Citizen.Wait(500)
						TriggerEvent("player:sellItem2", 17, 200)
						Citizen.Wait(500)
						TriggerEvent("player:sellItem2", 18, 50)
						Citizen.Wait(500)
						TriggerEvent("player:sellItem2", 19, 70)
						Citizen.Wait(500)
						TriggerEvent("player:sellItem2", 20, 20)
					end
				end
			end
		end
end)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
--------------------------------EDITED BY ZESHA--------------------------------