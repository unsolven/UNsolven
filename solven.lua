-- SolvenUI Library
-- A modern UI library with a darker, more purple theme and mobile auto-resize.
-- Fixed the layout bug from the previous version. Tabs are now correctly contained.

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
    
    local windowSize = UDim2.new(0.4, 0, 0.5, 0)
    local minSize = Vector2.new(400, 300)
    local maxSize = Vector2.new(700, 600)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SolvenUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = RunService:IsStudio() and Player:WaitForChild("PlayerGui") or game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = windowSize
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    
    local SizeConstraint = Instance.new("UISizeConstraint")
    SizeConstraint.Parent = MainFrame
    SizeConstraint.MinSize = minSize
    SizeConstraint.MaxSize = maxSize
    
    AddCorner(MainFrame, 10)
    AddStroke(MainFrame, Theme.Border, 1)
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    AddCorner(TitleBar, 10)
    
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Theme.Secondary
    TitleBarFix.Position = UDim2.new(0, 0, 1, -10)
    TitleBarFix.Size = UDim2.new(1, 0, 0, 10)
    TitleBarFix.BorderSizePixel = 0
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 15
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
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
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(1, -20, 0, 30)
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.X
    TabContainer.ScrollBarThickness = 0
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 10, 0, 85)
    ContentContainer.Size = UDim2.new(1, -20, 1, -95)
    
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Parent = ScreenGui
    MinimizedFrame.BackgroundColor3 = Theme.Secondary
    MinimizedFrame.Position = UDim2.new(0, 20, 0, 20)
    MinimizedFrame.Size = UDim2.new(0, 180, 0, 28)
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
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    
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
    
    CloseButton.MouseButton1Click:Connect(function()
        -- FIX: Use a valid UDim2 for the closing animation
        CreateTween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2):Play()
        task.wait(0.2)
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
    
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or ""
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabIcon .. " " .. tabName
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 11
        AddCorner(TabButton, 5)
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = false
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 6)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 2)
        ContentPadding.PaddingBottom = UDim.new(0, 2)
        
        local Tab = {}
        Tab.Content = TabContent
        Tab.Button = TabButton
        
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab == Tab then return end
            
            for _, otherTab in pairs(Window.Tabs) do
                otherTab.Content.Visible = false
                if otherTab.Button.BackgroundColor3 ~= Theme.Secondary then
                    CreateTween(otherTab.Button, {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.TextSecondary}):Play()
                end
            end
            
            TabContent.Visible = true
            Window.CurrentTab = Tab
            CreateTween(TabButton, {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Text}):Play()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(TabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                CreateTween(TabButton, {BackgroundColor3 = Theme.Secondary}):Play()
            end
        end)
        
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
        
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            Window.CurrentTab = Tab
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
        end
        
        return Tab
    end
    
    MainFrame.Visible = true
    -- FIX: Use a valid UDim2 for the opening animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    CreateTween(MainFrame, {Size = windowSize}, 0.4):Play()
    
    return Window
end

return SolvenUI
