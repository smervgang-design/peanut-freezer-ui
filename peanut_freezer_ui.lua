-- Gods Eye
-- Shows the top-earning Brainrot globally

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local brainrotFolder = workspace:WaitForChild("Brainrots")

-- CONFIG
local MAX_SIZE = 6
local MIN_SIZE = 1.5
local MAX_DISTANCE = 300
local UPDATE_INTERVAL = 1

-- Billboard
local billboard = Instance.new("BillboardGui")
billboard.Name = "GodsEyeBillboard"
billboard.AlwaysOnTop = true
billboard.LightInfluence = 0
billboard.Size = UDim2.fromScale(MAX_SIZE, MAX_SIZE)
billboard.StudsOffset = Vector3.new(0, 6, 0)

-- UI Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.fromScale(1, 1)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BackgroundTransparency = 0.2
frame.Parent = billboard

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0.2, 0)
corner.Parent = frame

-- Text
local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.TextColor3 = Color3.fromRGB(255, 215, 0)
label.TextStrokeTransparency = 0
label.TextWrapped = true
label.Parent = frame

-- Finds the best brainrot
local function getTopBrainrot()
	local bestBrainrot = nil
	local highestMPS = 0

	for _, brainrot in pairs(brainrotFolder:GetChildren()) do
		local mps = brainrot:FindFirstChild("MoneyPerSecond")
		if mps and mps.Value > highestMPS then
			highestMPS = mps.Value
			bestBrainrot = brainrot
		end
	end

	return bestBrainrot, highestMPS
end

-- Update loop
task.spawn(function()
	while true do
		local brainrot, mps = getTopBrainrot()

		if brainrot and brainrot.PrimaryPart then
			billboard.Parent = brainrot.PrimaryPart

			local owner = brainrot:FindFirstChild("Owner")
			local ownerName = owner and owner.Value or "Unknown"

			label.Text = string.format(
				"👁 GOD'S EYE\n%s\n💰 %s / sec",
				ownerName,
				string.format("%0.1f", mps)
			)
		else
			billboard.Parent = nil
		end

		task.wait(UPDATE_INTERVAL)
	end
end)

-- Distance-based scaling
RunService.RenderStepped:Connect(function()
	if not billboard.Parent then return end

	local root = billboard.Parent
	local char = player.Character
	if not char then return end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local distance = (hrp.Position - root.Position).Magnitude
	local alpha = math.clamp(distance / MAX_DISTANCE, 0, 1)
	local size = MIN_SIZE + (MAX_SIZE - MIN_SIZE) * alpha

	billboard.Size = UDim2.fromScale(size, size)
end)
