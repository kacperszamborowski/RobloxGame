local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)

local object = script.Parent.Parent.Parent.Parent

local healthBar = object.HealthBar
local redBar = healthBar.RedBar
local greenBar = redBar.GreenBar
local hpTxt = healthBar.HpTxt

local maxHealth = object:GetAttribute("MaxHealth")
local tmpHealth = object:GetAttribute("Health")

local function waitForAttributes()
	while not (maxHealth and tmpHealth) do
		maxHealth = object:GetAttribute("MaxHealth")
		tmpHealth = object:GetAttribute("Health")
		wait()
	end
end

waitForAttributes()

hpTxt.Text = FormatNumber.FormatCompact(tmpHealth) .. "/" .. FormatNumber.FormatCompact(maxHealth) .. " HP"

local function OnAttributeChanged()
	local health = object:GetAttribute("Health")
	local healthPercentage = health / maxHealth

	greenBar.Size = UDim2.new(healthPercentage, 0, 1, 0)

	local displayText = FormatNumber.FormatCompact(health) .. "/" .. FormatNumber.FormatCompact(maxHealth) .. " HP"
	hpTxt.Text = displayText

end

local attributeChangelSignal = object:GetAttributeChangedSignal("Health")
attributeChangelSignal:Connect(OnAttributeChanged)