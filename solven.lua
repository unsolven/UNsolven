-- SolvenUI Library
-- A modern UI library with a darker, more purple theme and mobile auto-resize.
-- Similar to Rayfield but with custom styling.

local SolvenUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer

-- Theme Colors (Darker & More Purple)
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(110, 40, 220), -- More intense purple
    AccentHover = Color3.fromRGB(130, 60, 240),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(190, 190, 190),
    Success = Color3.fromRGB(70, 225, 110),
    Error = Color3.fromRGB(225, 70, 70),
    Border = Color3.fromRGB(50, 50, 50)
}

-- Animation Settings
local AnimationSpeed = 0.25
local EaseStyle = Enum.EasingStyle.Quad
local EaseDirection = Enum.EasingDirection.Out

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

-- Main Library Functions
function SolvenUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "SolvenUI Window"
    
    -- Use scale for auto-resizing, with constraints for min/max size.
    local windowSize = UDim2.new(0.4, 0, 0.5, 0) -- Scaled size
    local minSize = Vector2.new(400, 300) -- Minimum size in pixels
    local maxSize = Vector2.new(700, 600) -- Maximum size in pixels

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SolvenUI"
    ScreenGui.ResetOnSpawn = false
    
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
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Center the frame
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Position at center
    MainFrame.Size = windowSize
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    
    -- Add size constraints for better scaling
    local SizeConstraint = Instance.new("UISizeConstraint")
    SizeConstraint.Parent = MainFrame
    SizeConstraint.MinSize = minSize
    SizeConstraint.MaxSize = maxSize
    
    AddCorner(MainFrame, 10)
    AddStroke(MainFrame, Theme.Border, 1)
    
    -- Title Bar (Thinner)
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.Size = UDim2.new(1, 0, 0, 35) -- Made thinner
    
    AddCorner(TitleBar, 10)
    
    -- Fix corner clipping
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Theme.Secondary
    TitleBarFix.Position = UDim2.new(0, 0, 1, -10)
    TitleBarFix.Size = UDim2.new(1, 0, 0, 10)
    TitleBarFix.BorderSizePixel = 0
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 15 -- Slightly smaller
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button (Smaller)
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.Position = UDim2.new(1, -30, 0.5, -9)
    CloseButton.Size = UDim2.new(0, 18, 0, 18)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 12
    
    AddCorner(CloseButton, 4)
    
    -- Minimize Button (Smaller)
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Theme.Accent
    MinimizeButton.Position = UDim2.new(1, -52, 0.5, -9)
    MinimizeButton.Size = UDim2.new(0, 18, 0, 18)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 12
    
    AddCorner(MinimizeButton, 4)
    
    -- Tab Container (Scrolling for horizontal tabs)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(1, -20, 0, 30)
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Theme.Accent
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabContainer.BorderSizePixel = 0

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 10, 0, 85) -- Adjusted position
    ContentContainer.Size = UDim2.new(1, -20, 1, -95) -- Adjusted size
    
    -- Minimized Frame
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Parent = ScreenGui
    MinimizedFrame.BackgroundColor3 = Theme.Secondary
    MinimizedFrame.Position = UDim2.new(0, 20, 0, 20)
    MinimizedFrame.Size = UDim2.new(0, 180, 0, 28) -- Smaller
    MinimizedFrame.Visible = false
    MinimizedFrame.Active = true
    MinimizedFrame.Draggable = true
    
    AddCorner(MinimizedFrame, 6)
    AddStroke(MinimizedFrame, Theme.Border, 1)
    
    local MinimizedTitle = Instance.new("TextLabel")
    MinimizedTitle.Parent = MinimizedFrame
    MinimizedTitle.BackgroundTransparency = 1
    MinimizedTitle.Position = UDim2.new(0, 8, 0, 0)
    MinimizedTitle.Size = UDim2.new(1, -35, 1, 0)
    MinimizedTitle.Font = Enum.Font.GothamSemibold
    MinimizedTitle.Text = windowTitle
    MinimizedTitle.TextColor3 = Theme.Text
    MinimizedTitle.TextSize = 11
    MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ExpandButton = Instance.new("TextButton")
    ExpandButton.Parent = MinimizedFrame
    ExpandButton.BackgroundColor3 = Theme.Accent
    ExpandButton.Position = UDim2.new(1, -22, 0.5, -7)
    ExpandButton.Size = UDim2.new(0, 14, 0, 14)
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
    local function AddButtonHover(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = hoverColor}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    AddButtonHover(CloseButton, Theme.Error, Color3.fromRGB(255, 90, 90))
    AddButtonHover(MinimizeButton, Theme.Accent, Theme.AccentHover)
    AddButtonHover(ExpandButton, Theme.Accent, Theme.AccentHover)
    
    -- Window Controls
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
        MinimizedFrame.Position = UDim2.fromOffset(MainFrame.AbsolutePosition.X, MainFrame.AbsolutePosition.Y)
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
        
        -- Create tab text (combine icon and name properly)
        local tabDisplayText = ""
        if tabIcon and tabIcon ~= "" then
            tabDisplayText = tabIcon .. " " .. tabName
        else
            tabDisplayText = tabName
        end

        -- Tab Button (Fixed: Use TextButton directly instead of complex Frame setup)
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabDisplayText  -- Fixed: Set the text properly
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 11
        TabButton.TextScaled = false
        TabButton.TextWrapped = false
        TabButton.ClipsDescendants = true
        
        AddCorner(TabButton, 5)

        -- Tab Content (Vertical Scrolling)
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.BorderSizePixel = 0
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 6) -- Tighter padding
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 2)
        ContentPadding.PaddingBottom = UDim.new(0, 2)
        
        -- Tab Object
        local Tab = {}
        Tab.Content = TabContent
        Tab.Button = TabButton  -- Fixed: Store the actual button
        Tab.Elements = {}
        
        -- Tab Selection
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab == Tab then return end
            
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Content.Visible = false
                if otherTab.Button.BackgroundColor3 ~= Theme.Secondary then
                    CreateTween(otherTab.Button, { BackgroundColor3 = Theme.Secondary }):Play()
                    CreateTween(otherTab.Button, { TextColor3 = Theme.TextSecondary }):Play()
                end
            end
            
            TabContent.Visible = true
            Window.CurrentTab = Tab
            CreateTween(TabButton, { BackgroundColor3 = Theme.Accent }):Play()
            CreateTween(TabButton, { TextColor3 = Theme.Text }):Play()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(TabButton, { BackgroundColor3 = Color3.fromRGB(45, 45, 45) }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                 CreateTween(TabButton, { BackgroundColor3 = Theme.Secondary }):Play()
            end
        end)
        
        -- Element Creation Functions
        function Tab:CreateButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = buttonText .. "Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = Theme.Accent
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            
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
            ToggleFrame.Size = UDim2.new(1, 0, 0, 32)
            
            AddCorner(ToggleFrame, 6)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 11
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Border
            ToggleButton.Position = UDim2.new(1, -40, 0.5, -8)
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
            
            local publicMethods = {}
            function publicMethods:SetValue(value)
                if toggleState == value then return end
                toggleState = value
                CreateTween(ToggleButton, { BackgroundColor3 = toggleState and Theme.Success or Theme.Border }, 0.1):Play()
                CreateTween(ToggleDot, { Position = toggleState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6) }, 0.1):Play()
            end
            
            return publicMethods
        end
        
        function Tab:CreateLabel(config)
            config = config or {}
            local labelText = config.Text or "Label"
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = TabContent
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = labelText
            Label.TextColor3 = Theme.TextSecondary
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local publicMethods = {}
            function publicMethods:SetText(text)
                Label.Text = text
            end
            
            return publicMethods
        end
        
        -- Auto-select first tab
        if #Window.Tabs == 0 then
            TabContent.Visible = true
            Window.CurrentTab = Tab
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
        end
        
        table.insert(Window.Tabs, Tab)
        return Tab
    end
    
    -- Show Window with Animation
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0,0,0,0)
    CreateTween(MainFrame, {Size = windowSize}, 0.4):Play()
    
    return Window
end

-- Notification System
function SolvenUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    local ScreenGui = Player.PlayerGui:FindFirstChild("SolvenUI") or Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.Name = "SolvenUI"
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Theme.Secondary
    Notification.Position = UDim2.new(1, 10, 1, -100) -- Start off-screen
    Notification.Size = UDim2.new(0, 280, 0, 70) -- Smaller
    Notification.AnchorPoint = Vector2.new(1, 1)
    
    AddCorner(Notification, 6)
    AddStroke(Notification, Theme.Accent, 1.5)
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = Notification
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 12, 0, 6)
    NotifTitle.Size = UDim2.new(1, -24, 0, 20)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Theme.Text
    NotifTitle.TextSize = 13
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Parent = Notification
    NotifContent.BackgroundTransparency = 1
    NotifContent.Position = UDim2.new(0, 12, 0, 26)
    NotifContent.Size = UDim2.new(1, -24, 1, -32)
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.Text = content
    NotifContent.TextColor3 = Theme.TextSecondary
    NotifContent.TextSize = 11
    NotifContent.TextWrapped = true
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Animate in
    CreateTween(Notification, {Position = UDim2.new(1, -10, 1, -100)}):Play()
    
    -- Auto dismiss
    task.delay(duration, function()
        if Notification and Notification.Parent then
            CreateTween(Notification, {Position = UDim2.new(1, 10, 1, -100)}):Play()
            task.wait(0.3)
            Notification:Destroy()
        end
    end)
end

return SolvenUI
