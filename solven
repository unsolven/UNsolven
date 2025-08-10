-- SolvenUI Library
-- A modern UI library with purple and black theme
-- Similar to Rayfield but with custom styling

local SolvenUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Player
local Player = Players.LocalPlayer

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
local AnimationSpeed = 0.3
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
    corner.CornerRadius = UDim.new(0, radius or 8)
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
    local windowSize = config.Size or UDim2.new(0, 500, 0, 400)
    
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
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    MainFrame.Size = windowSize
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    
    AddCorner(MainFrame, 12)
    AddStroke(MainFrame, Theme.Border, 1)
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    AddCorner(TitleBar, 12)
    
    -- Fix corner clipping
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Theme.Secondary
    TitleBarFix.Position = UDim2.new(0, 0, 1, -12)
    TitleBarFix.Size = UDim2.new(1, 0, 0, 12)
    TitleBarFix.BorderSizePixel = 0
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowTitle
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 14
    
    AddCorner(CloseButton, 4)
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = TitleBar
    MinimizeButton.BackgroundColor3 = Theme.Accent
    MinimizeButton.Position = UDim2.new(1, -60, 0.5, -10)
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "−"
    MinimizeButton.TextColor3 = Theme.Text
    MinimizeButton.TextSize = 14
    
    AddCorner(MinimizeButton, 4)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(1, -20, 0, 35)
    
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
    ContentContainer.Position = UDim2.new(0, 10, 0, 95)
    ContentContainer.Size = UDim2.new(1, -20, 1, -105)
    
    -- Minimized Frame
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Parent = ScreenGui
    MinimizedFrame.BackgroundColor3 = Theme.Secondary
    MinimizedFrame.Position = UDim2.new(0, 20, 0, 20)
    MinimizedFrame.Size = UDim2.new(0, 200, 0, 30)
    MinimizedFrame.Visible = false
    MinimizedFrame.Active = true
    MinimizedFrame.Draggable = true
    
    AddCorner(MinimizedFrame, 8)
    AddStroke(MinimizedFrame, Theme.Border, 1)
    
    local MinimizedTitle = Instance.new("TextLabel")
    MinimizedTitle.Parent = MinimizedFrame
    MinimizedTitle.BackgroundTransparency = 1
    MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
    MinimizedTitle.Size = UDim2.new(1, -40, 1, 0)
    MinimizedTitle.Font = Enum.Font.GothamSemibold
    MinimizedTitle.Text = windowTitle
    MinimizedTitle.TextColor3 = Theme.Text
    MinimizedTitle.TextSize = 12
    MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ExpandButton = Instance.new("TextButton")
    ExpandButton.Parent = MinimizedFrame
    ExpandButton.BackgroundColor3 = Theme.Accent
    ExpandButton.Position = UDim2.new(1, -25, 0.5, -8)
    ExpandButton.Size = UDim2.new(0, 16, 0, 16)
    ExpandButton.Font = Enum.Font.GothamBold
    ExpandButton.Text = "+"
    ExpandButton.TextColor3 = Theme.Text
    ExpandButton.TextSize = 12
    
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
        MinimizedFrame.Position = UDim2.new(0, MainFrame.AbsolutePosition.X, 0, MainFrame.AbsolutePosition.Y)
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
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, 120, 1, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabIcon .. " " .. tabName
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 12
        
        AddCorner(TabButton, 6)
        
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
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
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
        
        -- Add hover effect
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
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            
            AddCorner(Button, 8)
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
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            
            AddCorner(ToggleFrame, 8)
            AddStroke(ToggleFrame, Theme.Border, 1)
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 12
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
                
                CreateTween(ToggleButton, {
                    BackgroundColor3 = toggleState and Theme.Success or Theme.Border
                }):Play()
                
                CreateTween(ToggleDot, {
                    Position = toggleState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
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
                        Position = toggleState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
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
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.Font = Enum.Font.GothamSemibold
            Label.Text = labelText
            Label.TextColor3 = Theme.TextSecondary
            Label.TextSize = 12
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
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
    
    return Window
end

-- Notification System
function SolvenUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    local ScreenGui = Player:FindFirstChild("PlayerGui"):FindFirstChild("SolvenUI")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SolvenUI"
        ScreenGui.Parent = Player.PlayerGui
    end
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Theme.Secondary
    Notification.Position = UDim2.new(1, -320, 0, 20)
    Notification.Size = UDim2.new(0, 300, 0, 80)
    
    AddCorner(Notification, 8)
    AddStroke(Notification, Theme.Accent, 2)
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = Notification
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 8)
    NotifTitle.Size = UDim2.new(1, -30, 0, 20)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Theme.Text
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Parent = Notification
    NotifContent.BackgroundTransparency = 1
    NotifContent.Position = UDim2.new(0, 15, 0, 28)
    NotifContent.Size = UDim2.new(1, -30, 1, -36)
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.Text = content
    NotifContent.TextColor3 = Theme.TextSecondary
    NotifContent.TextSize = 12
    NotifContent.TextWrapped = true
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Animate in
    CreateTween(Notification, {Position = UDim2.new(1, -320, 0, 20)}):Play()
    
    -- Auto dismiss
    wait(duration)
    CreateTween(Notification, {Position = UDim2.new(1, 0, 0, 20)}):Play()
    wait(0.3)
    Notification:Destroy()
end

return SolvenUI
