-- Peanut Lagger UI (AUTO-STEAL legit + STOP ALL reset)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- Main Frame (bottom-right, draggable)
local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.22, 0.28)
main.Position = UDim2.fromScale(0.76, 0.64)
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
title.Size = UDim2.fromScale(1, 0.2)
title.BackgroundTransparency = 1
title.Text = "PEANUT LAGGER"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 60, 60)
title.Parent = main

-- Button factory
local function createButton(text, yPos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(0.9, 0.18)
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
local executeBtn   = createButton("EXECUTE", 0.22)
local autoStealBtn = createButton("AUTO-STEAL: OFF", 0.45)
local stopAllBtn   = createButton("STOP ALL", 0.68)

-- Tween helper
local function tween(btn, color)
	TweenService:Create(
		btn,
		TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundColor3 = color}
	):Play()
end

-- EXECUTE (placeholder)
executeBtn.MouseButton1Click:Connect(function()
	tween(executeBtn, Color3.fromRGB(255, 90, 90))
	task.delay(0.15, function()
		tween(executeBtn, Color3.fromRGB(220, 50, 50))
	end)
	print("Peanut Lagger: Execute")
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

-- AUTO-STEAL proximity check (LEGIT)
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
			local distance = (root.Position - part.Position).Magnitude
			if distance <= STEAL_DISTANCE then
				-- Request steal (server validates)
				StealBrainrotEvent:FireServer(brainrot)
			end
		end
	end
end)

-- STOP ALL (reset cleanly)
stopAllBtn.MouseButton1Click:Connect(function()
	autoSteal = false

	autoStealBtn.Text = "AUTO-STEAL: OFF"
	tween(autoStealBtn, Color3.fromRGB(220, 50, 50))

	tween(stopAllBtn, Color3.fromRGB(120, 120, 120))
	task.delay(0.15, function()
		tween(stopAllBtn, Color3.fromRGB(220, 50, 50))
	end)

	print("Peanut Lagger: STOP ALL")
end)

-- Right Ctrl toggles UI
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		gui.Enabled = not gui.Enabled
	end
end)
