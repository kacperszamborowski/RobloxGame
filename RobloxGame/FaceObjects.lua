local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local Damage = Remotes.GetData:InvokeServer("Power")

local proximityDistance = 10
local isFacingObject = false

local stopFacingEvent = Remotes.StopFacing
local DoDamage = Remotes.DoDamage

local tmpObject = nil

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Cooldown = {}
local ATTACK_COOLDOWN = 0.2

local SlowClickerEvent = ReplicatedStorage:WaitForChild("SlowClickerEvent")
local ClickerEvent = ReplicatedStorage:WaitForChild("ClickerEvent")


local function findObjectInProximity()
	local objects = workspace.DestroyableObjects:GetChildren()

	for _, object in ipairs(objects) do
		if object:GetAttribute("Tag") == "Destroyable" then
			local objectPosition = object.Target.Position
			local playerPosition = character.HumanoidRootPart.Position
			if (objectPosition - playerPosition).magnitude <= proximityDistance then
				return object.Target
			end
		end
	end

	return nil
end

local function faceObject(object)
	if object then
		local direction = (object.Position - character.HumanoidRootPart.Position).unit
		character:SetPrimaryPartCFrame(CFrame.lookAt(character.HumanoidRootPart.Position, character.HumanoidRootPart.Position + Vector3.new(direction.X, 0, direction.Z)))
	end
end


local function stopFacingObject()
	humanoid.AutoRotate = true
	isFacingObject = false
	tmpObject = nil
end

local function onMouseButton1Click()
	--cooldown
	if table.find(Cooldown, player) then return end
	table.insert(Cooldown, player)
	task.delay(ATTACK_COOLDOWN, function ()
		local foundPlayer = table.find(Cooldown, player)
		if foundPlayer then
			table.remove(Cooldown, foundPlayer)
		end
	end)
	--dodaj powera
	Remotes.GainPower:FireServer()
	--pobierz ilosc powera
	Damage = Remotes.GetData:InvokeServer("Power")
	--print(Damage)
	
	local object = findObjectInProximity()
	tmpObject = object
	if object then
		if (object.Position - character.HumanoidRootPart.Position).magnitude <= proximityDistance then
			if not isFacingObject then
				faceObject(object)
				humanoid.AutoRotate = false
				isFacingObject = true
				DoDamage:InvokeServer(object.Parent, Damage)
			else
				DoDamage:InvokeServer(object.Parent, Damage)
			end
		end
	end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, isProcessed)
	if not isProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input.KeyCode == Enum.KeyCode.ButtonR2 then
		onMouseButton1Click()
	end
end)

game:GetService("RunService").Heartbeat:Connect(function()
	if isFacingObject then
		if tmpObject and (tmpObject.Position - character.HumanoidRootPart.Position).magnitude <= proximityDistance then
			faceObject(tmpObject)
		else
			stopFacingObject()
		end
	end

end)

stopFacingEvent.OnClientEvent:Connect(stopFacingObject)
SlowClickerEvent.Event:Connect(onMouseButton1Click)
ClickerEvent.Event:Connect(onMouseButton1Click)