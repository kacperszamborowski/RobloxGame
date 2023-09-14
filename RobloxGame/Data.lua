local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes


local Template = require(ServerScriptService.PlayerData.Template)
local Manager = require(ServerScriptService.PlayerData.Manager)
local ProfileService = require(ServerScriptService.Libs.ProfileService)

local ProfileStore = ProfileService.GetProfileStore("Test", Template)

local KICK_MESSAGE = "Data issue, try again shortly. If issue persists, contact us!"

local function CreateLeaderstats(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local power = Instance.new("StringValue", leaderstats)
	power.Name = "Power"
	power.Value = FormatNumber.FormatCompact(profile.Data.Power, ".##")
	
	local coins = Instance.new("StringValue", leaderstats)
	coins.Name = "Money"
	coins.Value = FormatNumber.FormatCompact(profile.Data.Money, ".##")
end

local function LoadProfile(player: Player)
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId)
	if not profile then
		player:Kick(KICK_MESSAGE)
		return
	end
	
	
	--pierdolenie
	profile:AddUserId(player.UserId)
	profile:Reconcile()
	
	--update wszystko
	Remotes.UpdatePower:FireClient(player, profile.Data.Power)
	Remotes.UpdateMoney:FireClient(player, profile.Data.Money)
	
	local resources = profile.Data.Inventory
	for resourceName, resourceAmount in pairs(resources) do
		Remotes.UpdateInventory:FireClient(player, resourceName, resourceAmount)
	end
	
	--pierdolenie
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil
		player:Kick(KICK_MESSAGE)
	end)
	
	--cos tam robi leaderboardsy
	if player:IsDescendantOf(Players) == true then
		Manager.Profiles[player] = profile
		CreateLeaderstats(player)
	else
		profile:Release()
	end
	
end

for _, player in Players:GetPlayers() do
	task.spawn(LoadProfile, player)
end

Players.PlayerAdded:Connect(LoadProfile)
Players.PlayerRemoving:Connect(function(player)
	local profile = Manager.Profiles[player]
	if profile then
		profile:Release()
	end
end)