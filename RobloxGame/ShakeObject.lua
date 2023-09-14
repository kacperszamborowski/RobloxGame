local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes

local function shakeEffect(object)
	
	local leaves = object:WaitForChild("Leaves")
	local leavesOriginalPosition = leaves.Position
	local originalPosition = object.Position
	
	local Particles = object.Particles.ParticleEmitter
	Particles.Enabled = true
	
	local shakeDuration = 0.01 -- Adjust as needed
	local shakeMagnitude = 1 -- Adjust as needed
	
	local startTime = tick()
	
	
	while tick() - startTime < shakeDuration do
		local offsetX = math.random(-shakeMagnitude, shakeMagnitude)
		local offsetZ = math.random(-shakeMagnitude, shakeMagnitude)

		object.Position = originalPosition + Vector3.new(offsetX, 0, offsetZ)
		leaves.Position = leavesOriginalPosition + Vector3.new(offsetX, 0, offsetZ)
		
		wait(0.03) -- Adjust the wait time for smoother animation
		
	end
	
	-- Reset to original position
	object.Position = originalPosition
	leaves.Position = leavesOriginalPosition
	
	wait(1)
	Particles.Enabled = false
	
end

Remotes.ShakeObject.OnClientEvent:Connect(shakeEffect)
