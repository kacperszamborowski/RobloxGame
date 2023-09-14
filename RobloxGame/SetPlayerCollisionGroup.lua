local Players = game:GetService("Players")

local function SetCollisionGroup(char: Model)
	
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CollisionGroup = "PlayerCollision"
		end
	end
	
	char.DescendantAdded:Connect(function(descendant: Instance)
		if descendant:IsA("BasePart") then
			descendant.CollisionGroup = "PlayerCollision"
		end
	end)
end

Players.PlayerAdded:Connect(function(plr: Player)
	plr.CharacterAdded:Connect(SetCollisionGroup)
end)