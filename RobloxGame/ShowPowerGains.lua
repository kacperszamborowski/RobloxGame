local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplacableItems = ReplicatedStorage.ReplacableItems
local Remotes = ReplicatedStorage.Remotes

local TextDisplayTemplate = ReplacableItems:WaitForChild("TextDisplayTemplate")

local powerGui = script.Parent.Moc.ImageLabel
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

local function placeTextBoxRandomly(amount: number)
	
	local viewportWidth = workspace.CurrentCamera.ViewportSize.X
	local viewportHeight = workspace.CurrentCamera.ViewportSize.Y

	local offsetX = math.floor(viewportWidth * 0.3)
	local offsetY = math.floor(viewportHeight * 0.2)

	local randomX = offsetX + math.random(viewportWidth - 2 * offsetX)
	local randomY = offsetY + math.random(viewportHeight - 2 * offsetY)

	local textBoxClone = TextDisplayTemplate:Clone()
	textBoxClone.Position = UDim2.new(0, randomX, 0, randomY)
	textBoxClone.Text = "+ " .. tostring(amount)
	textBoxClone.Parent = script.Parent.ShowGains

	local textBoxWidth = viewportWidth * 0.1  -- Adjust this value as needed
	local textBoxHeight = viewportHeight * 0.06  -- Adjust this value as needed

	local popTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local popTween = tweenService:Create(textBoxClone, popTweenInfo, { Size = UDim2.new(0, textBoxWidth, 0, textBoxHeight) })
	popTween:Play()

	popTween.Completed:Connect(function()
		wait(0.4)

		local powerGuiCenter = powerGui.AbsolutePosition + powerGui.AbsoluteSize / 2
		local textBoxTargetPosition = powerGuiCenter - Vector2.new(textBoxClone.Size.X.Offset / 2, textBoxClone.Size.Y.Offset / 2)

		local moveTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
		local moveTween = tweenService:Create(textBoxClone, moveTweenInfo, { Position = UDim2.new(0, textBoxTargetPosition.X, 0, textBoxTargetPosition.Y) })
		moveTween:Play()

		local distanceThreshold = 20
		local connection

		connection = runService.RenderStepped:Connect(function()
			local textBoxPosition = textBoxClone.Position
			local distance = (Vector2.new(textBoxPosition.X.Offset, textBoxPosition.Y.Offset) - textBoxTargetPosition).Magnitude

			if distance <= distanceThreshold then
				textBoxClone:Destroy()
				connection:Disconnect()
			end
		end)
	end)
end

Remotes.DisplayPower.OnClientEvent:Connect(placeTextBoxRandomly)