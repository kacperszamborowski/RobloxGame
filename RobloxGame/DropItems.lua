local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local TweenService = game:GetService("TweenService")
local itemModel = ReplicatedStorage.Plate

local player = script.Parent.Parent

local function findGroundPosition(startPosition)
	local raycastResult = workspace:Raycast(
		startPosition,
		Vector3.new(0, -100, 0), -- Raycast downwards to find the ground
		RaycastParams.new()
	)
	if raycastResult then
		-- Add an offset to raise the item slightly above the ground
		return raycastResult.Position + Vector3.new(0, 0.1, 0) -- Adjust the height offset as needed
	end
	return nil
end

local function onMonsterDied(object)
	
	local numDrops = 5 -- Adjust the number of drops you want
	local dropDistance = 2 -- Adjust the distance of the drops from the monster's position
	local liftDuration = 1 -- Adjust the duration of the lift animation in seconds
	local fadeDuration = 1 -- Adjust the duration of the fade-out animation in seconds

	for i = 1, numDrops do
		local item = itemModel:Clone()
		item.Position = object.Position
		item.Parent = game.Workspace -- Spawn the item in the workspace
		item.Locked = Vector3.new(true, false, true)

		-- Randomly generate the drop position within a sphere around the monster
		local randomOffset = Vector3.new(
			math.random(-dropDistance, dropDistance),
			0, -- Start at 0 height (ground level)
			math.random(-dropDistance, dropDistance)
		)
		local targetPosition = object.Position + randomOffset

		-- Find the ground position below the target position
		local groundPosition = findGroundPosition(targetPosition)
		if groundPosition then
			targetPosition = groundPosition
		end

		-- Animate the item's position from the monster's position to the target position
		local tweenInfo = TweenInfo.new(
			0.5, -- Duration of the initial animation in seconds
			Enum.EasingStyle.Quad, -- Easing style (you can try different styles)
			Enum.EasingDirection.Out -- Easing direction (you can try different directions)
		)
		local tween = TweenService:Create(item, tweenInfo, {Position = targetPosition})
		tween:Play()

		-- After the initial drop animation, start the lift and fade animations with a delay
		task.delay(0.5, function()
			-- Start the lift animation for the item
			local liftTweenInfo = TweenInfo.new(
				liftDuration, -- Duration of the lift animation in seconds
				Enum.EasingStyle.Quad, -- Easing style (you can try different styles)
				Enum.EasingDirection.Out -- Easing direction (you can try different directions)
			)
			local liftTween = TweenService:Create(item, liftTweenInfo, {Position = targetPosition + Vector3.new(0, 5, 0)})
			liftTween:Play()

			-- Start the fade-out animation for the item
			local fadeTweenInfo = TweenInfo.new(
				fadeDuration, -- Duration of the fade-out animation in seconds
				Enum.EasingStyle.Linear -- Linear easing for a smooth fade
			)
			local fadeTween = TweenService:Create(item, fadeTweenInfo, {Transparency = 1})
			fadeTween:Play()

			-- Find and fade the Image inside the BillboardGui
			local billboardGui = item:FindFirstChild("BillboardGui")
			if billboardGui then
				
				local coinImage = billboardGui:FindFirstChild("Coin")
				
				if coinImage and coinImage:IsA("ImageLabel") then
					
					local billboardFadeTweenInfo = TweenInfo.new(
						fadeDuration, -- Duration of the fade-out animation in seconds
						Enum.EasingStyle.Linear -- Linear easing for a smooth fade
					)
					
					local billboardFadeTween = TweenService:Create(coinImage, billboardFadeTweenInfo, {ImageTransparency = 1})
					billboardFadeTween:Play()
					
					--dodanie siana (i==1 dlatego ze tylko raz)
					if i == 1 then
						--local x = object:GetAttribute()
						--Remotes.AdjustMoney:FireServer(player, )
						--Remotes.AdjustInventory:FireServer(player, "Wood", 10)
					end
				end
			end

			-- Destroy the item after the total duration of the animations
			task.delay(liftDuration + fadeDuration, function()
				item:Destroy()
			end)
		end)
	end
end

Remotes.DropItems.OnClientEvent:Connect(onMonsterDied)
