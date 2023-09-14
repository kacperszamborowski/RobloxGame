local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local StarterGui = script.Parent
local PowerGui = StarterGui:WaitForChild("Moc")
local MoneyGui = StarterGui:WaitForChild("Kasa")
local InventoryGui = StarterGui:WaitForChild("Inventory")

local PowerFrame = PowerGui.ImageLabel
local MoneyFrame = MoneyGui.ImageLabel
local InventoryFrame = InventoryGui.Frame


local PowerText = PowerFrame.Amount
local MoneyText = MoneyFrame.Amount
local InventoryScrollingFrame = InventoryFrame.ScrollingFrame

local function UpdatePower(currency: "Power", amount: number)
	if amount then
		PowerText.Text = FormatNumber.FormatCompact(amount, ".##")
	end
end

local function UpdateMoney(currency: "Money", amount: number)
	if amount then
		MoneyText.Text = FormatNumber.FormatCompact(amount, ".##")
	end
end

local function UpdateInventory(resource: string, amount: number)
	if amount then
		local ResourceImage = InventoryScrollingFrame:WaitForChild(resource)
		ResourceImage.Amount.Text = FormatNumber.FormatCompact(amount, ".##")
	end
end

UpdatePower("Power", Remotes.GetData:InvokeServer("Power"))

Remotes.UpdatePower.OnClientEvent:Connect(function(amount)
	UpdatePower("Power", amount)
end)

UpdateMoney("Money", Remotes.GetData:InvokeServer("Money"))

Remotes.UpdateMoney.OnClientEvent:Connect(function(amount)
	UpdateMoney("Money", amount)
end)

--UpdateInventory()
Remotes.UpdateInventory.OnClientEvent:Connect(function(resource, amount)
	UpdateInventory(resource, amount)
end)