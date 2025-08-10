-- SolvenUI Library (Fixed Version)
-- A modern UI library with purple and black theme
-- Mobile responsive and compact design

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
    Accent = Color3.fromRGB(120, 80, 255), -- Purple
    AccentHover = Color3.fromRGB(140, 100, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Success = Color3.fromRGB(80, 255, 120),
    Error = Color3.fromRGB(255, 80, 80),
    Border = Color3.fromRGB(60, 60, 60)
}

-- Animation Settings
local AnimationSpeed = 0.25
local EaseStyle = Enum.EasingStyle.Quad
local EaseDirection = Enum.EasingDirection.Out

-- Mobile/PC Sizes
local Sizes = {
    Window = isMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 480, 0, 360),
    TitleBar = isMobile and 45 or 35,
    TabHeight = isMobile and 40 or 32,
    ElementHeight = isMobile and 40 or 32,
    ElementSpacing = isMobile and 8 : 6,
    TextSize = {
        Title = isMobile and 18 or 16,
        Tab = isMobile and 14 or 12,
        Button = isMobile and 14 or 12,
        Label = isMobile and 12 or 10
    }
}

-- Utility Functions
local function CreateTween(object, properties, duration)
    duration = duration or AnimationSpeed
    local tweenInfo = TweenInfo.new(duration, EaseStyle, EaseDirection)
    return TweenService:Create(object, tweenInfo, properties)
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function AddStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Parent = parent
    return stroke
end

-- Safe Area Calculation for Mobile
local function GetSafeArea()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local topInset = GuiService:GetGuiInset().Y
    
    return {
        Size = screenSize,
        TopInset = topInset,
        SafeWidth = screenSize.X * 0.95,
        SafeHeight = (screenSize.Y - topInset) * 0.9
    }
end

-- Main Library Functions
function SolvenUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "SolvenUI Window"
    
    -- Auto-size for mobile
    local safeArea = GetSafeArea()
    local windowSize = isMobile and 
        UDim2.new(0, math.min(safeArea.SafeWidth, 400), 0, math.min(safeArea.SafeHeight, 500)) or
        (config.Size or UDim2.new(0, 480, 0, 360))
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SolvenUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = isMobile
    
    if RunService:IsStudio() then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main Container
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = isMobile and 
        UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2) or
        UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    MainFrame.Size = windowSize
    MainFrame.Active = true
    MainFrame.Visible = false
    
    -- Enable dragging only on PC or with title bar
    if not isMobile then
        MainFrame.Draggable = true
    end
    
    AddCorner(MainFrame, isMobile and 12 or 8)
    AddStroke(MainFrame, Theme.Border, 1)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.Size = UDim2.new(1, 0, 0, Sizes.TitleBar)
    
    AddCorner(TitleBar, isMobile and 12 or 8)
    
    -- Fix corner clipping
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Theme.Secondary
    TitleBarFix.Position = UDim2.new(0, 0, 1, -(isMobile and 12 or 8))
    TitleBarFix.Size = UDim2.new(1, 0, 0, isMobile and 12 or 8)
    TitleBarFix.BorderSizePixel = 0
    
    -- Mobile drag handle
    if isMobile then
        TitleBar.Active = true
        local dragStart = nil
        local startPos = nil
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = input.Position
                startPos = MainFrame.Position
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(
                    startPos.X.Scale, 
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)
        
        TitleBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragStart = nil
                startPos = nil
            end
        end)
    end
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = Sizes.TextSize.Title
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextScaled = isMobile
    
    -- Button Container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Parent = TitleBar
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Position = UDim2.new(1, -(isMobile and 80 or 65), 0, 0)
    ButtonContainer.Size = UDim2.new(0, isMobile and 80 or 65, 1, 0)
    
    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.Parent = ButtonContainer
    ButtonLayout.FillDirection = Enum.FillDirection.Horizontal
    ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ButtonLayout.Padding = UDim.new(0, 4)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = ButtonContainer
    MinimizeButton.BackgroundColor3 = Theme.Accent
    MinimizeButton.Size = UDim2.new(0, isMobile and 28 or 22, 0, isMobile and 28 or 18)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = isMobile and 16 : 12
    MinimizeButton.TextScaled = true
    
    AddCorner(MinimizeButton, 4)
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = ButtonContainer
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.Size = UDim2.new(0, isMobile and 28 or 22, 0, isMobile and 28 or 18)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = isMobile and 16 : 12
    CloseButton.TextScaled = true
    
    AddCorner(CloseButton, 4)
    
    -- Tab Container (Scrollable for many tabs)
    local TabScrollFrame = Instance.new("ScrollingFrame")
    TabScrollFrame.Name = "TabScrollFrame"
    TabScrollFrame.Parent = MainFrame
    TabScrollFrame.BackgroundTransparency = 1
    TabScrollFrame.Position = UDim2.new(0, 8, 0, Sizes.TitleBar + 4)
    TabScrollFrame.Size = UDim2.new(1, -16, 0, Sizes.TabHeight)
    TabScrollFrame.ScrollBarThickness = 0
    TabScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
    TabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = TabScrollFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(0, 0, 1, 0)
    TabContainer.AutomaticSize = Enum.AutomaticSize.X
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 4)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 8, 0, Sizes.TitleBar + Sizes.TabHeight + 12)
    ContentContainer.Size = UDim2.new(1, -16, 1, -(Sizes.TitleBar + Sizes.TabHeight + 20))
    
    -- Minimized Frame
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Parent = ScreenGui
    MinimizedFrame.BackgroundColor3 = Theme.Secondary
    MinimizedFrame.Position = isMobile and UDim2.new(0, 10, 0, 50) or UDim2.new(0, 20, 0, 20)
    MinimizedFrame.Size = isMobile and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 200, 0, 30)
    MinimizedFrame.Visible = false
    MinimizedFrame.Active = true
    
    if not isMobile then
        MinimizedFrame.Draggable = true
    end
    
    AddCorner(MinimizedFrame, 6)
    AddStroke(MinimizedFrame, Theme.Border, 1)
    
    local MinimizedTitle = Instance.new("TextLabel")
    MinimizedTitle.Parent = MinimizedFrame
    MinimizedTitle.BackgroundTransparency = 1
    MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
    MinimizedTitle.Size = UDim2.new(1, -50, 1, 0)
    MinimizedTitle.Font = Enum.Font.GothamSemibold
    MinimizedTitle.Text = windowTitle
    MinimizedTitle.TextColor3 = Theme.Text
    MinimizedTitle.TextSize = Sizes.TextSize.Label
    MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
    MinimizedTitle.TextScaled = isMobile
    
    local ExpandButton = Instance.new("TextButton")
    ExpandButton.Parent = MinimizedFrame
    ExpandButton.BackgroundColor3 = Theme.Accent
    ExpandButton.Position = UDim2.new(1, -(isMobile and 35 or 25), 0.5, -(isMobile and 15 or 8))
    ExpandButton.Size = UDim2.new(0, isMobile and 30 or 20, 0, isMobile and 30 or 16)
    ExpandButton.Font = Enum.Font.GothamBold
    ExpandButton.Text = "+"
    ExpandButton.TextColor3 = Theme.Text
    ExpandButton.TextSize = isMobile and 14 : 10
    ExpandButton.TextScaled = true
    
    AddCorner(ExpandButton, 4)
    
    -- Window Object
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
    -- Button Hover Effects (PC only)
    local function AddButtonHover(button, normalColor, hoverColor)
        if not isMobile then
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = hoverColor}):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = normalColor}):Play()
            end)
        end
    end
    
    AddButtonHover(CloseButton, Theme.Error, Color3.fromRGB(255, 100, 100))
    AddButtonHover(MinimizeButton, Theme.Accent, Theme.AccentHover)
    AddButtonHover(ExpandButton, Theme.Accent, Theme.AccentHover)
    
    -- Window Controls
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        if not isMobile then
            MinimizedFrame.Position = UDim2.new(0, MainFrame.AbsolutePosition.X, 0, MainFrame.AbsolutePosition.Y)
        end
    end)
    
    ExpandButton.MouseButton1Click:Connect(function()
        MinimizedFrame.Visible = false
        MainFrame.Visible = true
    end)
    
    -- Tab Functions
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or ""
        
        -- Tab Button (Compact)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, isMobile and 100 or 85, 1, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = (tabIcon ~= "" and tabIcon .. " " or "") .. tabName
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = Sizes.TextSize.Tab
        TabButton.TextScaled = isMobile
        
        AddCorner(TabButton, 4)
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Position = UDim2.new(0, 0, 0, 0)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = isMobile and 8 or 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 4)
        ContentPadding.PaddingBottom = UDim.new(0, 4)
        ContentPadding.PaddingLeft = UDim.new(0, 0)
        ContentPadding.PaddingRight = UDim.new(0, isMobile and 8 or 4)
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, Sizes.ElementSpacing)
        
        -- Tab Object
        local Tab = {}
        Tab.Content = TabContent
        Tab.Button = TabButton
        Tab.Elements = {}
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                CreateTween(tab.Button, {
                    BackgroundColor3 = Theme.Secondary,
                    TextColor3 = Theme.TextSecondary
                }):Play()
            end
            
            -- Show selected tab
            TabContent.Visible = true
            Window.CurrentTab = Tab
            CreateTween(TabButton, {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Theme.Text
            }):Play()
        end)
        
        -- Add hover effect (PC only)
        AddButtonHover(TabButton, Theme.Secondary, Color3.fromRGB(40, 40, 40))
        
        -- Element Creation Functions
        function Tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = buttonText .. "Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = Theme.Accent
            Button.Size = UDim2.new(1, 0, 0, Sizes.ElementHeight)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = Sizes.TextSize.Button
            Button.TextScaled = isMobile
            
            AddCorner(Button, 6)
            AddButtonHover(Button, Theme.Accent, Theme.AccentHover)
            
            Button.MouseButton1Click:Connect(callback)
            
            return Button
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleText = config.Name or "Toggle"
            local defaultValue = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = toggleText .. "Toggle"
            ToggleFrame.Parent = TabContent
            ToggleFrame.BackgroundColor3 = Theme.Secondary
            ToggleFrame.Size = UDim2.new(1, 0, 0, Sizes.ElementHeight)
            
            AddCorner(ToggleFrame, 6)
            AddStroke(ToggleFrame, Theme.Border, 1)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -(isMobile and 70 or 55), 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = Sizes.TextSize.Button
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.TextScaled = isMobile
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Border
            ToggleButton.Position = UDim2.new(1, -(isMobile and 50 : 40), 0.5, -(isMobile and 12 : 8))
            ToggleButton.Size = UDim2.new(0, isMobile and 40 or 30, 0, isMobile and 24 : 16)
            ToggleButton.Text = ""
            
            AddCorner(ToggleButton, isMobile and 12 : 8)
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Parent = ToggleButton
            ToggleDot.BackgroundColor3 = Theme.Text
            ToggleDot.Position = defaultValue and 
                UDim2.new(1, -(isMobile and 20 or 14), 0.5, -(isMobile and 8 : 6)) or 
                UDim2.new(0, isMobile and 4 : 2, 0.5, -(isMobile and 8 : 6))
            ToggleDot.Size = UDim2.new(0, isMobile and 16 : 12, 0, isMobile and 16 : 12)
            
            AddCorner(ToggleDot, isMobile and 8 : 6)
            
            local toggleState = defaultValue
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                
                CreateTween(ToggleButton, {
                    BackgroundColor3 = toggleState and Theme.Success or Theme.Border
                }):Play()
                
                CreateTween(ToggleDot, {
                    Position = toggleState and 
                        UDim2.new(1, -(isMobile and 20 or 14), 0.5, -(isMobile and 8 : 6)) or 
                        UDim2.new(0, isMobile and 4 : 2, 0.5, -(isMobile and 8 : 6))
                }):Play()
                
                callback(toggleState)
            end)
            
            return {
                Frame = ToggleFrame,
                SetValue = function(value)
                    toggleState = value
                    CreateTween(ToggleButton, {
                        BackgroundColor3 = toggleState and Theme.Success or Theme.Border
                    }):Play()
                    
                    CreateTween(ToggleDot, {
                        Position = toggleState and 
                            UDim2.new(1, -(isMobile and 20 or 14), 0.5, -(isMobile and 8 : 6)) or 
                            UDim2.new(0, isMobile and 4 : 2, 0.5, -(isMobile and 8 : 6))
                    }):Play()
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
            Label.Size = UDim2.new(1, 0, 0, isMobile and 25 : 20)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = labelText
            Label.TextColor3 = Theme.TextSecondary
            Label.TextSize = Sizes.TextSize.Label
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.TextScaled = isMobile
            
            return {
                Label = Label,
                SetText = function(text)
                    Label.Text = text
                end
            }
        end
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            Window.CurrentTab = Tab
            CreateTween(TabButton, {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Theme.Text
            }):Play()
        end
        
        Window.Tabs[#Window.Tabs + 1] = Tab
        return Tab
    end
    
    -- Show Window with Animation
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(MainFrame, {Size = windowSize}, 0.4):Play()
    
    -- Handle screen rotation on mobile
    if isMobile then
        local function handleRotation()
            local newSafeArea = GetSafeArea()
            local newSize = UDim2.new(0, math.min(newSafeArea.SafeWidth, 400), 0, math.min(newSafeArea.SafeHeight, 500))
            MainFrame.Size = newSize
            MainFrame.Position = UDim2.new(0.5, -newSize.X.Offset/2, 0.5, -newSize.Y.Offset/2)
        end
        
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(handleRotation)
    end
    
    return Window
end

-- Notification System (Mobile Optimized)
function SolvenUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    local ScreenGui = Player:FindFirstChild("PlayerGui"):FindFirstChild("SolvenUI")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SolvenUI"
        ScreenGui.IgnoreGuiInset = isMobile
        ScreenGui.Parent = Player.PlayerGui
    end
    
    local notifSize = isMobile and UDim2.new(0.9, 0, 0, 100) or UDim2.new(0, 300, 0, 80)
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Theme.Secondary
    Notification.Position = isMobile and 
        UDim2.new(0.5, 0, 0, -100) or 
        UDim2.new(1, -320, 0, 20)
    Notification.Size = notifSize
    Notification.AnchorPoint = isMobile and Vector2.new(0.5, 0) or Vector2.new(0, 0)
    
    AddCorner(Notification, 8)
    AddStroke(Notification, Theme.Accent, 2)
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = Notification
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 8)
    NotifTitle.Size = UDim2.new(1, -30, 0, isMobile and 25 : 20)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Theme.Text
    NotifTitle.TextSize = isMobile and 16 : 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.TextScaled = isMobile
    
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Parent = Notification
    NotifContent.BackgroundTransparency = 1
    NotifContent.Position = UDim2.new(0, 15, 0, isMobile and 33 : 28)
    NotifContent.Size = UDim2.new(1, -30, 1, -(isMobile and 41 : 36))
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.Text = content
    NotifContent.TextColor3 = Theme.TextSecondary
    NotifContent.TextSize = isMobile and 14 : 12
    NotifContent.TextWrapped = true
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.TextYAlignment = Enum.TextYAlignment.Top
    NotifContent.TextScaled = isMobile
    
    -- Animate in
    local targetPos = isMobile and 
        UDim2.new(0.5, 0, 0, 20) or 
        UDim2.new(1, -320, 0, 20)
    
    CreateTween(Notification, {Position = targetPos}):Play()
    
    -- Auto dismiss
    spawn(function()
        wait(duration)
        local exitPos = isMobile and 
            UDim2.new(0.5, 0, 0, -100) or 
            UDim2.new(1, 0, 0, 20)
        
        CreateTween(Notification, {Position = exitPos}):Play()
        wait(0.3)
        Notification:Destroy()
    end)
end

return SolvenUI
