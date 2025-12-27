-- Peanut Freezer UI (Final Inner Padding Added)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local originalTransparency = {}


-- Get currently equipped tool
local function getEquippedTool()
	local character = player.Character or player.CharacterAdded:Wait()

	for _, obj in ipairs(character:GetChildren()) do
		if obj:IsA("Tool") then
			return obj
		end
	end

	return nil
end


-- State
local starterLagEnabled = false
local mainLagEnabled = false
local rapidFireEnabled = false
local guideLine
local guideConnection




-- STARTER LAG LOGIC
local function setStarterLag(enabled)
	starterLagEnabled = enabled

	if enabled then
		print("Starter Lag ACTIVATED")
		-- 🔧 put starter lag logic here
	else
		print("Starter Lag DEACTIVATED")
		-- 🔧 cleanup starter lag here
	end
end

-- MAIN LAG LOGIC
local function setMainLag(enabled)
	mainLagEnabled = enabled

	if enabled then
		print("Main Lag ACTIVATED")
		-- 🔧 put main lag logic here
	else
		print("Main Lag DEACTIVATED")
		-- 🔧 cleanup main lag here
	end
end

local FADE_AMOUNT = 0.25 -- tweak: 0.15 subtle | 0.25 balanced | 0.35 strong
local originalTransparency = {}

local function isGroundFloor(part)
	-- Floors are wide and thin
	return part.Size.Y <= 2
		and part.Size.X > 10
		and part.Size.Z > 10
end

local function setWorldFaint(enabled)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			-- ❌ skip player & tools
			if player.Character and obj:IsDescendantOf(player.Character) then continue end
			if obj:IsDescendantOf(player.Backpack) then continue end

			-- ❌ skip ground floor
			if isGroundFloor(obj) then continue end

			if enabled then
				if originalTransparency[obj] == nil then
					originalTransparency[obj] = obj.Transparency
				end

				obj.Transparency = math.clamp(
					originalTransparency[obj] + FADE_AMOUNT,
					0,
					0.7
				)
			else
				if originalTransparency[obj] ~= nil then
					obj.Transparency = originalTransparency[obj]
				end
			end
		end
	end

	if not enabled then
		originalTransparency = {}
	end
end

local function setGuideline(enabled)
	-- TURN OFF
	if not enabled then
		if guideConnection then
			guideConnection:Disconnect()
			guideConnection = nil
		end
		if guideLine then
			guideLine:Destroy()
			guideLine = nil
		end
		return
	end

	-- TURN ON
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	guideLine = Instance.new("Part")
	guideLine.Anchored = true
	guideLine.CanCollide = false
	guideLine.Material = Enum.Material.Neon
	guideLine.Color = Color3.fromRGB(255, 80, 80)
	guideLine.Size = Vector3.new(0.15, 0.15, 1)
	guideLine.Parent = workspace

	guideConnection = RunService.RenderStepped:Connect(function()
		print("Guideline running")

		local folder = workspace:FindFirstChild("Brainrots")
		if not folder then return end

		local closestPart
		local closestDist = math.huge

		for _, obj in ipairs(folder:GetChildren()) do
			local targetPart =
				obj:IsA("Model") and obj.PrimaryPart
				or (obj:IsA("BasePart") and obj)

			if targetPart then
				local dist = (hrp.Position - targetPart.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestPart = targetPart
				end
			end
		end

		if closestPart then
			local midpoint = (hrp.Position + closestPart.Position) / 2
			guideLine.Size = Vector3.new(0.15, 0.15, closestDist)
			guideLine.CFrame = CFrame.lookAt(midpoint, closestPart.Position)
		end
	end)
end





local RunService = game:GetService("RunService")
local guideLine
local guideConnection

local function showBrainrotPath(enabled)
	if not enabled then
		if guideConnection then guideConnection:Disconnect() end
		if guideLine then guideLine:Destroy() end
		return
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	guideLine = Instance.new("Part")
	guideLine.Anchored = true
	guideLine.CanCollide = false
	guideLine.Material = Enum.Material.Neon
	guideLine.Color = Color3.fromRGB(255, 50, 50)
	guideLine.Parent = workspace

	guideConnection = RunService.RenderStepped:Connect(function()
		local brainrots = workspace:FindFirstChild("Brainrots")
		if not brainrots then return end

		local closest
		local closestDist = math.huge

		for _, obj in ipairs(brainrots:GetChildren()) do
			local pos = obj:IsA("Model") and obj.PrimaryPart or obj
			if pos then
				local dist = (hrp.Position - pos.Position).Magnitude
				if dist < closestDist then
					closestDist = dist
					closest = pos
				end
			end
		end

		if closest then
			local midpoint = (hrp.Position + closest.Position) / 2
			guideLine.Size = Vector3.new(0.15, 0.15, closestDist)
			guideLine.CFrame = CFrame.lookAt(midpoint, closest.Position)
		end
	end)
end



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
	return b -- ✅ THIS FIXES EVERYTHING
end


--------------------------------------------------
-- STARTER LAG
--------------------------------------------------
sectionHeading(starter, "STARTER LAG")
info(starter, "Power (0.01–100):", "0.05", 0.20)

local starterActivateBtn =
	bigButton(starter, "⚡ ACTIVATE", Color3.fromRGB(80,190,130), 0.40)

starterActivateBtn.MouseButton1Click:Connect(function()
	rapidFireEnabled = not rapidFireEnabled
	setStarterLag(rapidFireEnabled)
	setWorldFaint(rapidFireEnabled)
	showBrainrotPath(rapidFireEnabled)
	setGuideline(true)




	local tool = getEquippedTool()
	if tool then
		if rapidFireEnabled then
			tool:SetAttribute("FireRateMultiplier", 3) -- 3x faster
		else
			tool:SetAttribute("FireRateMultiplier", 1)
		end
	end

	if rapidFireEnabled then
		setGuideline(true)
		setWorldFaint(true)
		starterActivateBtn.Text = "⚡ ACTIVE"
		starterActivateBtn.BackgroundColor3 = Color3.fromRGB(60,160,110)
	else
		setGuideline(false)
		setWorldFaint(false)
		starterActivateBtn.Text = "⚡ ACTIVATE"
		starterActivateBtn.BackgroundColor3 = Color3.fromRGB(80,190,130)
	end
end)


bigButton(starter, "🚀 START + TP HIGHEST", Color3.fromRGB(140,110,220), 0.62)

--------------------------------------------------
-- MAIN LAG
--------------------------------------------------
sectionHeading(mainLag, "MAIN LAG")
info(mainLag, "Power (0.01–100):", "0.5", 0.20)
info(mainLag, "Lag After Steal:", "ON", 0.32)
info(mainLag, "Duration (sec):", "0.5", 0.44)

local mainActivateBtn =
	bigButton(mainLag, "⚡ ACTIVATE", Color3.fromRGB(225,135,80), 0.64)

mainActivateBtn.MouseButton1Click:Connect(function()
	mainLagEnabled = not mainLagEnabled
	setMainLag(mainLagEnabled)

	if mainLagEnabled then
		mainActivateBtn.Text = "⚡ ACTIVE"
		mainActivateBtn.BackgroundColor3 = Color3.fromRGB(190,110,70)
	else
		mainActivateBtn.Text = "⚡ ACTIVATE"
		mainActivateBtn.BackgroundColor3 = Color3.fromRGB(225,135,80)
	end
end)


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
	return b
end

local tpHighestBtn = actionButton(actions, "📍 TP TO HIGHEST", Color3.fromRGB(90,140,220), 0.03)
local kickSelfBtn  = actionButton(actions, "👢 Kick Self", Color3.fromRGB(90,140,220), 0.36)
local stopAllBtn = actionButton(actions, "🛑 STOP ALL", Color3.fromRGB(200,70,70), 0.69)


stopAllBtn.MouseButton1Click:Connect(function()
	-- turn off starter / main logic
	if starterLagEnabled then
		setStarterLag(false)
	end
	if mainLagEnabled then
		setMainLag(false)
	end

	starterLagEnabled = false
	mainLagEnabled = false
	rapidFireEnabled = false
	setWorldFaint(false)
	showBrainrotPath(false)
	setGuideline(false)



	-- 🔥 THIS IS THE PART YOU WERE ASKING ABOUT
	local tool = getEquippedTool()
	if tool then
		tool:SetAttribute("FireRateMultiplier", 1)
	end
	-- 🔥 END OF ADDED PART

	-- reset button visuals
	starterActivateBtn.Text = "⚡ ACTIVATE"
	starterActivateBtn.BackgroundColor3 = Color3.fromRGB(80,190,130)

	mainActivateBtn.Text = "⚡ ACTIVATE"
	mainActivateBtn.BackgroundColor3 = Color3.fromRGB(225,135,80)

	print("ALL FEATURES STOPPED")
end)



-- Kick Self logic
kickSelfBtn.MouseButton1Click:Connect(function()
	player:Kick("You kicked yourself.")
end)


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

