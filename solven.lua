-- SolvenUI Library - Versão Compacta e Draggable
local SolvenUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

-- Player
local Player = Players.LocalPlayer

-- Mobile Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Theme Colors
local Theme = {
	Background = Color3.fromRGB(20, 20, 20),
	Secondary = Color3.fromRGB(30, 30, 30),
	Accent = Color3.fromRGB(120, 80, 255),
	AccentHover = Color3.fromRGB(140, 100, 255),
	Text = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(200, 200, 200),
	Success = Color3.fromRGB(80, 255, 120),
	Error = Color3.fromRGB(255, 80, 80),
	Border = Color3.fromRGB(60, 60, 60)
}

-- Utility Functions
local function CreateTween(object, properties, duration)
	duration = duration or 0.2
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	return TweenService:Create(object, tweenInfo, properties)
end

local function AddCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or 8)
	corner.Parent = parent
	return corner
end

-- Custom Drag Function (More reliable)
local function MakeDraggable(frame, dragHandle)
	dragHandle = dragHandle or frame
	local dragging = false
	local dragStart = nil
	local startPos = nil

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			
			local connection
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragging then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end)
end

-- Main Library Function
function SolvenUI:CreateWindow(config)
	config = config or {}
	local windowTitle = config.Name or "SolvenUI Window"
	local windowSize = config.Size or (isMobile and UDim2.new(0, 320, 0, 400) or UDim2.new(0, 400, 0, 350))

	-- Create ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "SolvenUI"
	ScreenGui.ResetOnSpawn = false
	if RunService:IsStudio() then
		ScreenGui.Parent = Player:WaitForChild("PlayerGui")
	else
		ScreenGui.Parent = game:GetService("CoreGui")
	end

	-- Main Frame (Compact)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
	MainFrame.Size = windowSize
	MainFrame.Active = true
	MainFrame.ClipsDescendants = true -- Good practice
	AddCorner(MainFrame, 10)

	-- Border
	local Border = Instance.new("UIStroke")
	Border.Parent = MainFrame
	Border.Color = Theme.Border
	Border.Thickness = 1

	-- Title Bar (Smaller)
	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = MainFrame
	TitleBar.BackgroundColor3 = Theme.Secondary
	TitleBar.Position = UDim2.new(0, 0, 0, 0)
	TitleBar.Size = UDim2.new(1, 0, 0, 32) -- Smaller title bar
	TitleBar.Active = true
	AddCorner(TitleBar, 10)

	-- Title Bar Bottom Fix
	local TitleBarFix = Instance.new("Frame")
	TitleBarFix.Parent = TitleBar
	TitleBarFix.BackgroundColor3 = Theme.Secondary
	TitleBarFix.Position = UDim2.new(0, 0, 1, -10)
	TitleBarFix.Size = UDim2.new(1, 0, 0, 10)
	TitleBarFix.BorderSizePixel = 0

	-- Make Main Frame Draggable via Title Bar
	MakeDraggable(MainFrame, TitleBar)

	-- Title Label (Smaller text)
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Parent = TitleBar
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Position = UDim2.new(0, 12, 0, 0)
	TitleLabel.Size = UDim2.new(1, -80, 1, 0)
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = windowTitle
	TitleLabel.TextColor3 = Theme.Text
	TitleLabel.TextSize = 14 -- Smaller text
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd

	-- Close Button (Smaller)
	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Parent = TitleBar
	CloseButton.BackgroundColor3 = Theme.Error
	CloseButton.Position = UDim2.new(1, -24, 0.5, -8)
	CloseButton.Size = UDim2.new(0, 16, 0, 16)
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = "×"
	CloseButton.TextColor3 = Theme.Text
	CloseButton.TextSize = 12
	AddCorner(CloseButton, 3)

	-- Minimize Button (Smaller)
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = TitleBar
	MinimizeButton.BackgroundColor3 = Theme.Accent
	MinimizeButton.Position = UDim2.new(1, -44, 0.5, -8)
	MinimizeButton.Size = UDim2.new(0, 16, 0, 16)
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = "−"
	MinimizeButton.TextColor3 = Theme.Text
	MinimizeButton.TextSize = 12
	AddCorner(MinimizeButton, 3)

	-- ==========================================================
	-- FIX: Container das abas agora é um ScrollingFrame horizontal
	-- ==========================================================
	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Name = "TabContainer"
	TabContainer.Parent = MainFrame
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, 8, 0, 40)
	TabContainer.Size = UDim2.new(1, -16, 0, 28)
	TabContainer.ScrollingDirection = Enum.ScrollingDirection.X -- Scroll Horizontal
	TabContainer.ScrollBarThickness = 4
	TabContainer.ScrollBarImageColor3 = Theme.Accent
	TabContainer.BorderSizePixel = 0
	TabContainer.CanvasSize = UDim2.new(0,0,0,0)
	TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X -- Ajusta a largura automaticamente

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabContainer
	TabLayout.FillDirection = Enum.FillDirection.Horizontal
	TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	TabLayout.Padding = UDim.new(0, 5)

	-- Content Container (Compact)
	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	ContentContainer.Parent = MainFrame
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.Position = UDim2.new(0, 8, 0, 76)
	ContentContainer.Size = UDim2.new(1, -16, 1, -84)
	ContentContainer.ClipsDescendants = true -- Previne que o conteúdo "vaze"

	-- Minimized Frame (Positioned to avoid Roblox buttons)
	local MinimizedFrame = Instance.new("Frame")
	MinimizedFrame.Name = "MinimizedFrame"
	MinimizedFrame.Parent = ScreenGui
	MinimizedFrame.BackgroundColor3 = Theme.Secondary
	MinimizedFrame.Position = UDim2.new(1, -180, 1, -50)
	MinimizedFrame.Size = UDim2.new(0, 170, 0, 30)
	MinimizedFrame.Visible = false
	MinimizedFrame.Active = true
	AddCorner(MinimizedFrame, 6)
	MakeDraggable(MinimizedFrame)

	local MinimizedBorder = Instance.new("UIStroke")
	MinimizedBorder.Parent = MinimizedFrame
	MinimizedBorder.Color = Theme.Border
	MinimizedBorder.Thickness = 1

	local MinimizedTitle = Instance.new("TextLabel")
	MinimizedTitle.Parent = MinimizedFrame
	MinimizedTitle.BackgroundTransparency = 1
	MinimizedTitle.Position = UDim2.new(0, 8, 0, 0)
	MinimizedTitle.Size = UDim2.new(1, -35, 1, 0)
	MinimizedTitle.Font = Enum.Font.GothamSemibold
	MinimizedTitle.Text = windowTitle
	MinimizedTitle.TextColor3 = Theme.Text
	MinimizedTitle.TextSize = 12
	MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
	MinimizedTitle.TextTruncate = Enum.TextTruncate.AtEnd

	local ExpandButton = Instance.new("TextButton")
	ExpandButton.Parent = MinimizedFrame
	ExpandButton.BackgroundColor3 = Theme.Accent
	ExpandButton.Position = UDim2.new(1, -22, 0.5, -8)
	ExpandButton.Size = UDim2.new(0, 16, 0, 16)
	ExpandButton.Font = Enum.Font.GothamBold
	ExpandButton.Text = "+"
	ExpandButton.TextColor3 = Theme.Text
	ExpandButton.TextSize = 10
	AddCorner(ExpandButton, 3)

	-- Window Object
	local Window = {}
	Window.Tabs = {}
	Window.CurrentTab = nil

	-- Button Hover Effects
	local function AddHover(button, normalColor, hoverColor)
		if not isMobile then
			button.MouseEnter:Connect(function()
				CreateTween(button, {BackgroundColor3 = hoverColor}):Play()
			end)
			button.MouseLeave:Connect(function()
				CreateTween(button, {BackgroundColor3 = normalColor}):Play()
			end)
		end
	end

	AddHover(CloseButton, Theme.Error, Color3.fromRGB(255, 100, 100))
	AddHover(MinimizeButton, Theme.Accent, Theme.AccentHover)
	AddHover(ExpandButton, Theme.Accent, Theme.AccentHover)

	-- Window Controls
	CloseButton.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	MinimizeButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
		MinimizedFrame.Visible = true
	end)

	ExpandButton.MouseButton1Click:Connect(function()
		MinimizedFrame.Visible = false
		MainFrame.Visible = true
	end)

	-- Create Tab Function
	function Window:CreateTab(config)
		config = config or {}
		local tabName = config.Name or "Tab"
		local tabIcon = config.Icon or ""

		-- Tab Button (More compact)
		local TabButton = Instance.new("TextButton")
		TabButton.Name = tabName .. "Tab"
		TabButton.Parent = TabContainer -- Parented to the new ScrollingFrame
		TabButton.BackgroundColor3 = Theme.Secondary
		TabButton.Size = UDim2.new(0, 80, 1, 0) -- Um pouco maior para caber o texto
		TabButton.Font = Enum.Font.GothamSemibold
		TabButton.Text = (tabIcon ~= "" and tabIcon .. " " or "") .. tabName
		TabButton.TextColor3 = Theme.TextSecondary
		TabButton.TextSize = 11 -- Smaller text
		TabButton.TextTruncate = Enum.TextTruncate.AtEnd
		AddCorner(TabButton, 4)

		-- Tab Content
		local TabContent = Instance.new("ScrollingFrame")
		TabContent.Name = tabName .. "Content"
		TabContent.Parent = ContentContainer
		TabContent.BackgroundTransparency = 1
		TabContent.Position = UDim2.new(0, 0, 0, 0)
		TabContent.Size = UDim2.new(1, 0, 1, 0)
		TabContent.ScrollBarThickness = 4
		TabContent.ScrollBarImageColor3 = Theme.Accent
		TabContent.Visible = false
		TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
		TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
		TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
		TabContent.BorderSizePixel = 0
		
		-- Content Layout
		local ContentLayout = Instance.new("UIListLayout")
		ContentLayout.Parent = TabContent
		ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ContentLayout.Padding = UDim.new(0, 6) -- Smaller spacing
		
		-- ===================================================
		-- FIX: Padding é o que causa o bug do scroll vertical
		-- O tamanho dos elementos precisa considerar o padding
		-- para o AutomaticCanvasSize funcionar corretamente.
		-- ===================================================
		local RIGHT_PADDING = 8
		local ContentPadding = Instance.new("UIPadding")
		ContentPadding.Parent = TabContent
		ContentPadding.PaddingTop = UDim.new(0, 4)
		ContentPadding.PaddingBottom = UDim.new(0, 4)
		ContentPadding.PaddingLeft = UDim.new(0, 0)
		ContentPadding.PaddingRight = UDim.new(0, RIGHT_PADDING)

		-- Tab Object
		local Tab = {}
		Tab.Content = TabContent
		Tab.Button = TabButton

		-- Tab Selection Logic
		TabButton.MouseButton1Click:Connect(function()
			-- Hide all other tabs
			for _, tab in pairs(Window.Tabs) do
				tab.Content.Visible = false
				CreateTween(tab.Button, { BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSecondary }):Play()
			end
			-- Show this tab
			TabContent.Visible = true
			Window.CurrentTab = Tab
			CreateTween(TabButton, { BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text }):Play()
		end)
		AddHover(TabButton, Theme.Secondary, Color3.fromRGB(45, 45, 45))

		-- Tab Methods
		function Tab:CreateButton(config)
			config = config or {}
			local buttonName = config.Name or "Button"
			local callback = config.Callback or function() end

			local Button = Instance.new("TextButton")
			Button.Name = buttonName .. "Button"
			Button.Parent = TabContent
			Button.BackgroundColor3 = Theme.Accent
			-- FIX: Ajusta o tamanho para compensar o PaddingRight
			Button.Size = UDim2.new(1, -RIGHT_PADDING, 0, 28)
			Button.Font = Enum.Font.GothamSemibold
			Button.Text = buttonName
			Button.TextColor3 = Theme.Text
			Button.TextSize = 12
			Button.TextTruncate = Enum.TextTruncate.AtEnd
			AddCorner(Button, 6)
			AddHover(Button, Theme.Accent, Theme.AccentHover)
			Button.MouseButton1Click:Connect(callback)
			return Button
		end

		function Tab:CreateToggle(config)
			config = config or {}
			local toggleName = config.Name or "Toggle"
			local defaultValue = config.Default or false
			local callback = config.Callback or function() end

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = toggleName .. "Toggle"
			ToggleFrame.Parent = TabContent
			ToggleFrame.BackgroundColor3 = Theme.Secondary
			-- FIX: Ajusta o tamanho para compensar o PaddingRight
			ToggleFrame.Size = UDim2.new(1, -RIGHT_PADDING, 0, 28)
			AddCorner(ToggleFrame, 6)

			local ToggleBorder = Instance.new("UIStroke")
			ToggleBorder.Parent = ToggleFrame
			ToggleBorder.Color = Theme.Border
			ToggleBorder.Thickness = 1

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
			ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
			ToggleLabel.Font = Enum.Font.GothamSemibold
			ToggleLabel.Text = toggleName
			ToggleLabel.TextColor3 = Theme.Text
			ToggleLabel.TextSize = 12
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
			ToggleLabel.TextTruncate = Enum.TextTruncate.AtEnd

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Parent = ToggleFrame
			ToggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Border
			ToggleButton.Position = UDim2.new(1, -38, 0.5, -8)
			ToggleButton.Size = UDim2.new(0, 30, 0, 16)
			ToggleButton.Text = ""
			AddCorner(ToggleButton, 8)

			local ToggleDot = Instance.new("Frame")
			ToggleDot.Parent = ToggleButton
			ToggleDot.BackgroundColor3 = Theme.Text
			ToggleDot.Position = defaultValue and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
			ToggleDot.Size = UDim2.new(0, 12, 0, 12)
			AddCorner(ToggleDot, 6)

			local toggleState = defaultValue
			ToggleButton.MouseButton1Click:Connect(function()
				toggleState = not toggleState
				CreateTween(ToggleButton, { BackgroundColor3 = toggleState and Theme.Success or Theme.Border }):Play()
				CreateTween(ToggleDot, { Position = toggleState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) }):Play()
				callback(toggleState)
			end)
			
			return {
				Frame = ToggleFrame,
				SetValue = function(value)
					toggleState = value
					CreateTween(ToggleButton, { BackgroundColor3 = toggleState and Theme.Success or Theme.Border }, 0):Play()
					CreateTween(ToggleDot, { Position = toggleState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) }, 0):Play()
				end
			}
		end

		function Tab:CreateLabel(config)
			config = config or {}
			local labelText = config.Text or "Label"

			local Label = Instance.new("TextLabel")
			Label.Name = "Label"
			Label.Parent = TabContent
			Label.BackgroundTransparency = 1
			-- FIX: Ajusta o tamanho para compensar o PaddingRight
			Label.Size = UDim2.new(1, -RIGHT_PADDING, 0, 20)
			Label.Font = Enum.Font.GothamSemibold
			Label.Text = labelText
			Label.TextColor3 = Theme.TextSecondary
			Label.TextSize = 11
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true
			return {
				Label = Label,
				SetText = function(text)
					Label.Text = text
				end
			}
		end

		table.insert(Window.Tabs, Tab)

		-- Auto-select first tab
		if #Window.Tabs == 1 then
			TabButton:SendToBack() -- Trigger the click logic
			TabButton.MouseButton1Click:Fire()
		end

		return Tab
	end

	-- Show Window
	MainFrame.Visible = true
	return Window
end

-- Notification System (Compact)
function SolvenUI:Notify(config)
	config = config or {}
	local title = config.Title or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 3

	local ScreenGui = Player.PlayerGui:FindFirstChild("SolvenUI_Notifications")
	if not ScreenGui then
		ScreenGui = Instance.new("ScreenGui")
		ScreenGui.Name = "SolvenUI_Notifications"
		ScreenGui.Parent = Player.PlayerGui
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
	end
    
    local NotifContainer = ScreenGui:FindFirstChild("Container")
    if not NotifContainer then
        NotifContainer = Instance.new("UIListLayout")
        NotifContainer.Name = "Container"
        NotifContainer.Parent = ScreenGui
        NotifContainer.HorizontalAlignment = Enum.HorizontalAlignment.Right
        NotifContainer.VerticalAlignment = Enum.VerticalAlignment.Top
        NotifContainer.Padding = UDim.new(0, 5)
        
        local Padding = Instance.new("UIPadding")
        Padding.Parent = ScreenGui
        Padding.PaddingTop = UDim.new(0, 10)
        Padding.PaddingRight = UDim.new(0, 10)
    end

	local Notification = Instance.new("Frame")
	Notification.Name = "Notification"
	Notification.Parent = ScreenGui
	Notification.BackgroundColor3 = Theme.Secondary
	Notification.Size = UDim2.new(0, 240, 0, 60)
    Notification.Position = UDim2.new(1, 250, 0, 0) -- Start off-screen
	AddCorner(Notification, 6)

	local NotificationBorder = Instance.new("UIStroke")
	NotificationBorder.Parent = Notification
	NotificationBorder.Color = Theme.Accent
	NotificationBorder.Thickness = 1

	local NotifTitle = Instance.new("TextLabel")
	NotifTitle.Parent = Notification
	NotifTitle.BackgroundTransparency = 1
	NotifTitle.Position = UDim2.new(0, 10, 0, 5)
	NotifTitle.Size = UDim2.new(1, -20, 0, 16)
	NotifTitle.Font = Enum.Font.GothamBold
	NotifTitle.Text = title
	NotifTitle.TextColor3 = Theme.Text
	NotifTitle.TextSize = 12
	NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
	NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd

	local NotifContent = Instance.new("TextLabel")
	NotifContent.Parent = Notification
	NotifContent.BackgroundTransparency = 1
	NotifContent.Position = UDim2.new(0, 10, 0, 21)
	NotifContent.Size = UDim2.new(1, -20, 1, -26)
	NotifContent.Font = Enum.Font.Gotham
	NotifContent.Text = content
	NotifContent.TextColor3 = Theme.TextSecondary
	NotifContent.TextSize = 10
	NotifContent.TextWrapped = true
	NotifContent.TextXAlignment = Enum.TextXAlignment.Left
	NotifContent.TextYAlignment = Enum.TextYAlignment.Top

	-- Slide in animation
	CreateTween(Notification, {Position = UDim2.new(1, -240, 0, 0)}, 0.3):Play()

	-- Auto dismiss
	task.delay(duration, function()
        if Notification and Notification.Parent then
            CreateTween(Notification, {Position = UDim2.new(1, 250, 0, 0)}, 0.3):Play()
            task.wait(0.3)
            Notification:Destroy()
        end
	end)
end

return SolvenUI
