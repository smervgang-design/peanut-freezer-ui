-- Peanut Freezer UI (Final Inner Padding Added)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FreezerUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main Card
local main = Instance.new("Frame")
main.Size = UDim2.fromScale(0.40, 0.50)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- ✅ INNER PADDING (THIS IS THE FIX)
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 14)
padding.PaddingBottom = UDim.new(0, 14)
padding.PaddingLeft = UDim.new(0, 14)
padding.PaddingRight = UDim.new(0, 14)
padding.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 0.11)
title.BackgroundTransparency = 1
title.Text = "🥜 PEANUT FREEZER – Dual Mode"
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 200, 90)
title.Parent = main

--------------------------------------------------
-- PANELS
--------------------------------------------------
local panels = Instance.new("Frame")
panels.Size = UDim2.fromScale(1, 0.50)
panels.Position = UDim2.fromScale(0, 0.14)
panels.BackgroundTransparency = 1
panels.Parent = main

-- Starter panel
local starter = Instance.new("Frame")
starter.Size = UDim2.fromScale(0.46, 1)
starter.Position = UDim2.fromScale(0.02, 0)
starter.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
starter.Parent = panels
Instance.new("UICorner", starter).CornerRadius = UDim.new(0, 12)

local starterStroke = Instance.new("UIStroke")
starterStroke.Color = Color3.fromRGB(80, 200, 120)
starterStroke.Thickness = 1
starterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
starterStroke.Parent = starter

-- Main lag panel
local mainLag = Instance.new("Frame")
mainLag.Size = UDim2.fromScale(0.46, 1)
mainLag.Position = UDim2.fromScale(0.52, 0)
mainLag.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
mainLag.Parent = panels
Instance.new("UICorner", mainLag).CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(210, 80, 80)
mainStroke.Thickness = 1
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainLag

--------------------------------------------------
-- HELPERS
--------------------------------------------------
local function sectionHeading(parent, text)
	local h = Instance.new("TextLabel")
	h.Size = UDim2.fromScale(1, 0.12)
	h.Position = UDim2.fromScale(0.05, 0.03)
	h.BackgroundTransparency = 1
	h.Text = text
	h.Font = Enum.Font.GothamBold
	h.TextScaled = true
	h.TextXAlignment = Enum.TextXAlignment.Left
	h.TextColor3 = Color3.new(1,1,1)
	h.Parent = parent
end

local function info(parent, text, value, y)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.fromScale(0.7, 0.10)
	l.Position = UDim2.fromScale(0.05, y)
	l.BackgroundTransparency = 1
	l.Text = text
	l.Font = Enum.Font.Gotham
	l.TextScaled = true
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.TextColor3 = Color3.fromRGB(170,170,170)
	l.Parent = parent

	local r = Instance.new("TextLabel")
	r.Size = UDim2.fromScale(0.25, 0.10)
	r.Position = UDim2.fromScale(0.7, y)
	r.BackgroundTransparency = 1
	r.Text = value
	r.Font = Enum.Font.GothamBold
	r.TextScaled = true
	r.TextXAlignment = Enum.TextXAlignment.Right
	r.TextColor3 = Color3.fromRGB(235,235,235)
	r.Parent = parent
end

local function bigButton(parent, text, color, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromScale(0.9, 0.18)
	b.Position = UDim2.fromScale(0.05, y)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
end

--------------------------------------------------
-- STARTER LAG
--------------------------------------------------
sectionHeading(starter, "STARTER LAG")
info(starter, "Power (0.01–100):", "0.05", 0.20)
bigButton(starter, "⚡ ACTIVATE", Color3.fromRGB(80,190,130), 0.40)
bigButton(starter, "🚀 START + TP HIGHEST", Color3.fromRGB(140,110,220), 0.62)

--------------------------------------------------
-- MAIN LAG
--------------------------------------------------
sectionHeading(mainLag, "MAIN LAG")
info(mainLag, "Power (0.01–100):", "0.5", 0.20)
info(mainLag, "Lag After Steal:", "ON", 0.32)
info(mainLag, "Duration (sec):", "0.5", 0.44)
bigButton(mainLag, "⚡ ACTIVATE", Color3.fromRGB(225,135,80), 0.64)

--------------------------------------------------
-- ACTION BUTTONS
--------------------------------------------------
local actions = Instance.new("Frame")
actions.Size = UDim2.fromScale(1, 0.14)
actions.Position = UDim2.fromScale(0, 0.70)
actions.BackgroundTransparency = 1
actions.Parent = main

local function actionButton(parent, text, color, x)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromScale(0.3, 0.85)
	b.Position = UDim2.fromScale(x, 0.075)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextScaled = true
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
end

actionButton(actions, "📍 TP TO HIGHEST", Color3.fromRGB(90,140,220), 0.03)
actionButton(actions, "👢 Kick Self", Color3.fromRGB(90,140,220), 0.36)
actionButton(actions, "🛑 STOP ALL", Color3.fromRGB(200,70,70), 0.69)

--------------------------------------------------
-- FLOOR BUTTONS
--------------------------------------------------
local floors = Instance.new("Frame")
floors.Size = UDim2.fromScale(1, 0.12)
floors.Position = UDim2.fromScale(0, 0.87)
floors.BackgroundTransparency = 1
floors.Parent = main

actionButton(floors, "Floor 1", Color3.fromRGB(45,45,45), 0.03)
actionButton(floors, "Floor 2", Color3.fromRGB(45,45,45), 0.36)
actionButton(floors, "Floor 3", Color3.fromRGB(45,45,45), 0.69)

-- Toggle
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		main.Visible = not main.Visible
	end
end)

