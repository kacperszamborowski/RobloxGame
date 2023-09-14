local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local Cooldown = {}

local CLICK_COOLDOWN = 0.1

local function GainPower(player: Player)
	--cooldown
	if table.find(Cooldown, player) then return end
	table.insert(Cooldown, player)
	task.delay(CLICK_COOLDOWN, function ()
		local foundPlayer = table.find(Cooldown, player)
		if foundPlayer then
			table.remove(Cooldown, foundPlayer)
		end
	end)
	
	local powerAdded = 5
	Remotes.DisplayPower:FireClient(player, powerAdded)
	--dodanie powera
	PlayerData.AdjustPower(player, powerAdded)
	
	Remotes.ShakeGui:FireClient(player)
end

Remotes.GainPower.OnServerEvent:Connect(GainPower)