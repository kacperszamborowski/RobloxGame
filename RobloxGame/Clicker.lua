local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local GainPower = Remotes.GainPower

local AutoClicker = script.Parent.AutoClicker
local AutoClickerRedButton = AutoClicker.RedButton
local AutoClickerGreenButton = AutoClickerRedButton.GreenButton
local ClickerEvent = Instance.new("BindableEvent")
ClickerEvent.Name = "ClickerEvent"
ClickerEvent.Parent = ReplicatedStorage
local fastOn = false

local SlowAutoClicker = script.Parent.SlowAutoClicker
local SlowAutoClickerRedButton = SlowAutoClicker.RedButton
local SlowAutoClickerGreenButton = SlowAutoClickerRedButton.GreenButton
local SlowClickerEvent = Instance.new("BindableEvent")
SlowClickerEvent.Name = "SlowClickerEvent"
SlowClickerEvent.Parent = ReplicatedStorage
local slowOn = false

local function SlowAutoClicker()

	if slowOn == false then
		
		--szybki off
		if(fastOn) then
			AutoClickerRedButton.ImageTransparency = 0
			AutoClickerGreenButton.ImageTransparency = 1
			fastOn = false
		end
		
		--wolny on
		SlowAutoClickerRedButton.ImageTransparency = 1
		SlowAutoClickerGreenButton.ImageTransparency = 0
		slowOn = true
		while slowOn do
			wait(0.4)
			print("x")
			SlowClickerEvent:Fire()
		end
	else
		--wolny off
		SlowAutoClickerRedButton.ImageTransparency = 0
		SlowAutoClickerGreenButton.ImageTransparency = 1
		slowOn = false
		return
	end
end

local function AutoClicker()

	if fastOn == false then
		
		--wolny off
		if(slowOn) then
			SlowAutoClickerRedButton.ImageTransparency = 0
			SlowAutoClickerGreenButton.ImageTransparency = 1
			slowOn = false
		end
		
		--szybki on
		AutoClickerRedButton.ImageTransparency = 1
		AutoClickerGreenButton.ImageTransparency = 0
		fastOn = true
		while fastOn do
			print("x")
			wait(0.2)
			ClickerEvent:Fire()
		end
	else
		--szybki off
		AutoClickerRedButton.ImageTransparency = 0
		AutoClickerGreenButton.ImageTransparency = 1
		fastOn = false
		return
	end
end

SlowAutoClickerGreenButton.MouseButton1Click:Connect(SlowAutoClicker)
AutoClickerGreenButton.MouseButton1Click:Connect(AutoClicker)