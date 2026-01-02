-- Peanut Lagger UI (AUTO-STEAL legit + STOP ALL reset + REAL FPS & Ping)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- RemoteEvent (must exist on server)
local StealBrainrotEvent = ReplicatedStorage:WaitForChild("StealBrainrot")

-- Settings
local STEAL_DISTANCE = 8
local brainrotFolder = workspace:WaitForChild("Brainrots")

-- State
local autoSteal = false

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "PeanutLaggerGui"
gui.ResetOnSpawn = false
gui.Enabled = true
gui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.22, 0.32)
main.Position = UDim2.fromScale(0.76, 0.62)
main.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.16)
title.BackgroundTransparency = 1
title.Text = "PEANUT LAGGER"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 60, 60)
title.Parent = main

-- FPS / Ping label
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.fromScale(1, 0.12)
statsLabel.Position = UDim2.fromScale(0, 0.16)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "FPS: -- | Ping: -- ms"
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 14
statsLabel.TextColor3 = Color3.fromRGB(60, 60, 60)
statsLabel.Parent = main

-- Button factory
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.9, 0.16)
	btn.Position = UDim2.fromScale(0.05, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
	btn.Text = text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.AutoButtonColor = false
	btn.Parent = main

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = btn

	return btn
end

-- Buttons
local executeBtn   = createButton("EXECUTE", 0.30)
local autoStealBtn = createButton("AUTO-STEAL: OFF", 0.50)
local stopAllBtn   = createButton("STOP ALL", 0.70)

-- Tween helper
local function tween(btn, color)
	TweenService:Create(
		btn,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundColor3 = color}
	):Play()
end

-- EXECUTE
executeBtn.MouseButton1Click:Connect(function()
	tween(executeBtn, Color3.fromRGB(255, 90, 90))
	task.delay(0.15, function()
		tween(executeBtn, Color3.fromRGB(220, 50, 50))
	end)
end)

-- AUTO-STEAL toggle
autoStealBtn.MouseButton1Click:Connect(function()
	autoSteal = not autoSteal
	autoStealBtn.Text = "AUTO-STEAL: " .. (autoSteal and "ON" or "OFF")

	tween(
		autoStealBtn,
		autoSteal and Color3.fromRGB(60, 200, 120)
			or Color3.fromRGB(220, 50, 50)
	)
end)

-- AUTO-STEAL logic
RunService.Heartbeat:Connect(function()
	if not autoSteal then return end

	local character = player.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	for _, brainrot in ipairs(brainrotFolder:GetChildren()) do
		local part =
			brainrot:IsA("Model") and brainrot.PrimaryPart
			or brainrot:IsA("BasePart") and brainrot

		if part then
			if (root.Position - part.Position).Magnitude <= STEAL_DISTANCE then
				StealBrainrotEvent:FireServer(brainrot)
			end
		end
	end
end)

-- STOP ALL
stopAllBtn.MouseButton1Click:Connect(function()
	autoSteal = false
	autoStealBtn.Text = "AUTO-STEAL: OFF"
	tween(autoStealBtn, Color3.fromRGB(220, 50, 50))

	tween(stopAllBtn, Color3.fromRGB(120, 120, 120))
	task.delay(0.15, function()
		tween(stopAllBtn, Color3.fromRGB(220, 50, 50))
	end)
end)

-- 🔥 REAL FPS + REAL PING
do
	local fpsAverage = 0
	local alpha = 0.1 -- smoothing

	RunService.RenderStepped:Connect(function(dt)
		local fps = math.floor(1 / dt)
		fpsAverage = fpsAverage + (fps - fpsAverage) * alpha

		local pingMs = 0
		local pingItem = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if pingItem then
			pingMs = math.floor(pingItem:GetValue() / 1000) -- μs → ms
		end

		statsLabel.Text = string.format(
			"FPS: %d | Ping: %d ms",
			math.floor(fpsAverage),
			pingMs
		)
	end)
end

-- Right Ctrl toggle
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		gui.Enabled = not gui.Enabled
	end
end)
