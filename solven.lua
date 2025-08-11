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
    
    -- Tab Container (Changed to ScrollingFrame for horizontal scroll)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.Size = UDim2.new(1, -20, 0, 35) -- Increased height slightly for scrollbar
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.X -- Set to horizontal
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.X   -- Auto-resize canvas for tabs
    TabContainer.ScrollBarThickness = 4                        -- Set scrollbar thickness
    TabContainer.ScrollBarImageColor3 = Theme.Accent           -- Style the scrollbar

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
    ContentContainer.Position = UDim2.new(0, 10, 0, 85)
    ContentContainer.Size = UDim2.new(1, -20, 1, -95)
    
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
        local tabName = config.Name or "Tab " .. (#Window.Tabs + 1)
        local tabIcon = config.Icon or ""
        
        -- Create display text
        local displayText = tabName
        if tabIcon ~= "" then
            displayText = tabIcon .. " " .. tabName
        end
        
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = "Tab_" .. tabName
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Text = displayText
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 12
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.LayoutOrder = #Window.Tabs + 1
        
        AddCorner(TabButton, 6)
        
        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = "Content_" .. tabName
        TabFrame.Parent = ContentContainer
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Position = UDim2.new(0, 0, 0, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.ScrollBarThickness = 6
        TabFrame.ScrollBarImageColor3 = Theme.Accent
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        TabFrame.Visible = false
        
        -- Layout for tab content
        local Layout = Instance.new("UIListLayout")
        Layout.Parent = TabFrame
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 8)
        
        local Padding = Instance.new("UIPadding")
        Padding.Parent = TabFrame
        Padding.PaddingTop = UDim.new(0, 10)
        Padding.PaddingBottom = UDim.new(0, 10)
        Padding.PaddingLeft = UDim.new(0, 5)
        Padding.PaddingRight = UDim.new(0, 15)
        
        -- Tab object
        local Tab = {
            Name = tabName,
            Button = TabButton,
            Frame = TabFrame,
            Layout = Layout,
            Elements = {},
            ElementCount = 0
        }
        
        -- Tab selection logic
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, otherTab in pairs(Window.Tabs) do
                if otherTab ~= Tab then
                    otherTab.Frame.Visible = false
                    otherTab.Button.BackgroundColor3 = Theme.Secondary
                    otherTab.Button.TextColor3 = Theme.TextSecondary
                end
            end
            
            -- Show this tab
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
        end)
        
        -- Hover effects
        TabButton.MouseEnter:Connect(function()
            if Tab ~= Window.CurrentTab then
                CreateTween(TabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Tab ~= Window.CurrentTab then
                CreateTween(TabButton, {BackgroundColor3 = Theme.Secondary}):Play()
            end
        end)
        
        -- Element creation functions
        function Tab:CreateButton(config)
            config = config or {}
            local name = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = name
            Button.Parent = TabFrame
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundColor3 = Theme.Accent
            Button.Text = name
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            Button.Font = Enum.Font.SourceSansBold
            Button.LayoutOrder = Tab.ElementCount + 1
            
            AddCorner(Button, 8)
            
            -- Hover effect
            Button.MouseEnter:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Theme.AccentHover}):Play()
            end)
            Button.MouseLeave:Connect(function()
                CreateTween(Button, {BackgroundColor3 = Theme.Accent}):Play()
            end)
            
            Button.MouseButton1Click:Connect(callback)
            
            Tab.ElementCount = Tab.ElementCount + 1
            table.insert(Tab.Elements, Button)
            return Button
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local name = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local Container = Instance.new("Frame")
            Container.Name = name .. "Container"
            Container.Parent = TabFrame
            Container.Size = UDim2.new(1, 0, 0, 35)
            Container.BackgroundColor3 = Theme.Secondary
            Container.LayoutOrder = Tab.ElementCount + 1
            
            AddCorner(Container, 8)
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Container
            Label.Size = UDim2.new(1, -50, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Theme.Text
            Label.TextSize = 14
            Label.Font = Enum.Font.SourceSans
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = Container
            ToggleButton.Size = UDim2.new(0, 40, 0, 20)
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.BackgroundColor3 = default and Theme.Success or Theme.Border
            ToggleButton.Text = ""
            
            AddCorner(ToggleButton, 10)
            
            local Indicator = Instance.new("Frame")
            Indicator.Parent = ToggleButton
            Indicator.Size = UDim2.new(0, 16, 0, 16)
            Indicator.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            Indicator.BackgroundColor3 = Theme.Text
            
            AddCorner(Indicator, 8)
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                CreateTween(ToggleButton, {
                    BackgroundColor3 = toggled and Theme.Success or Theme.Border
                }):Play()
                
                CreateTween(Indicator, {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }):Play()
                
                callback(toggled)
            end)
            
            Tab.ElementCount = Tab.ElementCount + 1
            table.insert(Tab.Elements, Container)
            return Container
        end
        
        function Tab:CreateLabel(config)
            config = config or {}
            local text = config.Text or "Label"
            
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Parent = TabFrame
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.TextSecondary
            Label.TextSize = 12
            Label.Font = Enum.Font.SourceSans
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.LayoutOrder = Tab.ElementCount + 1
            
            Tab.ElementCount = Tab.ElementCount + 1
            table.insert(Tab.Elements, Label)
            return Label
        end
        
        -- Add to window tabs
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Theme.Accent
            TabButton.TextColor3 = Theme.Text
            Window.CurrentTab = Tab
        end
        
        return Tab
    end
    
    -- Show window
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
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
