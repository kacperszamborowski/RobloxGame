local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local replaceItems = ReplicatedStorage.ReplacableItems

local ServerScriptService = game:GetService("ServerScriptService")
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local TweenService = game:GetService("TweenService")
local itemModel = ReplicatedStorage.Plate

local stopFacing = Remotes.StopFacing

local function Respawn(player: Player, object)
	--zrobienie klona i wrzucenie go do replicated storage
	local Clone = object:Clone()
	Clone.Name = object.Name
	Clone.Parent = replaceItems
	--opozniony respawn o 5 sekund
	task.delay(5, function()
		local respawnObject = Clone:Clone()
		respawnObject.Parent = workspace.DestroyableObjects
		--usuniecie klona
		Clone.Parent = nil
		--ustawienie hp na maxhp obietku
		respawnObject:SetAttribute("Health", respawnObject:GetAttribute("MaxHealth"))
	end)
end

--zniszczenie
local function Destroy(player, object)
	stopFacing:FireClient(player)
	object:Destroy()
	
end

--robi dmg i respawnuje/niszczy/ustawia hp obiektu
local function DoDamage(player: Player, object, amount: number)
	
	--shake
	Remotes.ShakeObject:FireClient(player, object)
	
	--damage
	local objectHp = object:GetAttribute("Health")
	if objectHp then
		objectHp = tonumber(objectHp)
		--nowe hp po zadaniu dmg
		local newHealth = objectHp - amount
		
		if newHealth <= 0 then
			
			Remotes.DropItems:FireClient(player, object)
			
			newHealth = 0
			
			--test output
			print(player, "killed ", object, " with ", amount, " of damage, now", object, " has ", newHealth, " hp")
			
			--ustawienie hp na zero
			object:SetAttribute("Health", newHealth)
			
			Respawn(player,object)
			Destroy(player,object)
			
			task.delay(1.2, function()
				PlayerData.AdjustMoney(player, object:GetAttribute("MoneyDropped"))
				PlayerData.AdjustInventory(player, "Wood", 1000)
			end)
			
			return
		end
		--test output
		print(player, "damaged ", object, " with ", amount, " of damage, now", object, " has ", newHealth, " hp")
		--ustawienie nowego hp
		object:SetAttribute("Health", newHealth)
	end

			
end

Remotes.DoDamage.OnServerInvoke = DoDamage