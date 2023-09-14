local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local Manager = {}

Manager.Profiles = {}

function Manager.AdjustPower(player: Player, amount: number)
	
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	--dodanie powera
	profile.Data.Power += amount
	--update leaderstats
	player.leaderstats.Power.Value = FormatNumber.FormatCompact(profile.Data.Power, ".##")
	--update mocy na gui
	Remotes.UpdatePower:FireClient(player, profile.Data.Power)
	
end

function Manager.AdjustMoney(player: Player, amount: number)
	
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	--analogicznie do adjustpower
	profile.Data.Money += amount
	player.leaderstats.Money.Value = FormatNumber.FormatCompact(profile.Data.Money, ".##")
	Remotes.UpdateMoney:FireClient(player, profile.Data.Money)
	
end

function Manager.AdjustInventory(player: Player, resource: string, amount: number)
	
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	profile.Data.Inventory[resource] += amount
	Remotes.UpdateInventory:FireClient(player, resource, profile.Data.Inventory[resource])
	
end

local function GetData(player: Player, directory: string, invDirectory: string?)
	
	local profile = Manager.Profiles[player]
	if not profile then return end
	if directory ~= "Inventory" then
		return profile.Data[directory]
	else
		return profile.Data.Inventory[invDirectory]
	end
	
end

Remotes.GetData.OnServerInvoke = GetData

return Manager
