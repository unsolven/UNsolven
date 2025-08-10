-- SolvenUI Library - Versão Corrigida e Funcional
local SolvenUI = {}

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

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
    duration = duration or 0.25
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    return TweenService:Create(object, tweenInfo, properties)
end

local function AddCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Main Library Function
function SolvenUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Name or "SolvenUI Window"
    local windowSize = config.Size or (isMobile and UDim2.new(0.9, 0, 0.8, 0) or UDim2.new(0, 500, 0, 400))
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SolvenUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    
    if RunService:IsStudio() then
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    else
        ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Size = windowSize
    MainFrame.Active = true
    MainFrame.Draggable = not isMobile
    
    AddCorner(MainFrame, 12)
    
    -- Border
    local Border = Instance.new("UIStroke")
    Border.Parent = MainFrame
    Border.Color = Theme.Border
    Border.Thickness = 1
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    
    AddCorner(TitleBar, 12)
    
    -- Title Bar Bottom Fix
    local TitleBarFix = Instance.new("Frame")
    TitleBarFix.Parent = TitleBar
    TitleBarFix.BackgroundColor3 = Theme.Secondary
    TitleBarFix.Position = UDim2.new(0, 0, 1, -12)
    TitleBarFix.Size = UDim2.new(1, 0, 0, 12)
    TitleBarFix.BorderSizePixel = 0
    
    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Parent = TitleBar
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = TitleBar
    CloseButton.BackgroundColor3 = Theme.Error
    CloseButton.Position = UDim2.new(1, -30, 0.5, -10)
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
    MinimizeButton.Position = UDim2.new(1, -55, 0.5, -10)
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
    MinimizedFrame.Size = UDim2.new(0, 200, 0, 35)
    MinimizedFrame.Visible = false
    MinimizedFrame.Active = true
    MinimizedFrame.Draggable = not isMobile
    
    AddCorner(MinimizedFrame, 8)
    
    local MinimizedBorder = Instance.new("UIStroke")
    MinimizedBorder.Parent = MinimizedFrame
    MinimizedBorder.Color = Theme.Border
    MinimizedBorder.Thickness = 1
    
    local MinimizedTitle = Instance.new("TextLabel")
    MinimizedTitle.Parent = MinimizedFrame
    MinimizedTitle.BackgroundTransparency = 1
    MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
    MinimizedTitle.Size = UDim2.new(1, -40, 1, 0)
    MinimizedTitle.Font = Enum.Font.GothamSemibold
    MinimizedTitle.Text = windowTitle
    MinimizedTitle.TextColor3 = Theme.Text
    MinimizedTitle.TextSize = 14
    MinimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local ExpandButton = Instance.new("TextButton")
    ExpandButton.Parent = MinimizedFrame
    ExpandButton.BackgroundColor3 = Theme.Accent
    ExpandButton.Position = UDim2.new(1, -25, 0.5, -8)
    ExpandButton.Size = UDim2.new(0, 20, 0, 16)
    ExpandButton.Font = Enum.Font.GothamBold
    ExpandButton.Text = "+"
    ExpandButton.TextColor3 = Theme.Text
    ExpandButton.TextSize = 12
    
    AddCorner(ExpandButton, 4)
    
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
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Theme.Secondary
        TabButton.Size = UDim2.new(0, 100, 1, 0)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = (tabIcon ~= "" and tabIcon .. " " or "") .. tabName
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
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        
        -- Content Layout
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 8)
        
        -- Content Padding
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.PaddingLeft = UDim.new(0, 0)
        ContentPadding.PaddingRight = UDim.new(0, 10)
        
        -- Tab Object
        local Tab = {}
        Tab.Content = TabContent
        Tab.Button = TabButton
        
        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                CreateTween(tab.Button, {
                    BackgroundColor3 = Theme.Secondary,
                    TextColor3 = Theme.TextSecondary
                }):Play()
            end
            
            -- Show this tab
            TabContent.Visible = true
            Window.CurrentTab = Tab
            CreateTween(TabButton, {
                BackgroundColor3 = Theme.Accent,
                TextColor3 = Theme.Text
            }):Play()
        end)
        
        AddHover(TabButton, Theme.Secondary, Color3.fromRGB(40, 40, 40))
        
        -- Tab Methods
        function Tab:CreateButton(config)
            config = config or {}
            local buttonName = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = buttonName .. "Button"
            Button.Parent = TabContent
            Button.BackgroundColor3 = Theme.Accent
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = buttonName
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            
            AddCorner(Button, 8)
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
            ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
            
            AddCorner(ToggleFrame, 8)
            
            local ToggleBorder = Instance.new("UIStroke")
            ToggleBorder.Parent = ToggleFrame
            ToggleBorder.Color = Theme.Border
            ToggleBorder.Thickness = 1
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Parent = ToggleFrame
            ToggleButton.BackgroundColor3 = defaultValue and Theme.Success or Theme.Border
            ToggleButton.Position = UDim2.new(1, -45, 0.5, -10)
            ToggleButton.Size = UDim2.new(0, 35, 0, 20)
            ToggleButton.Text = ""
            
            AddCorner(ToggleButton, 10)
            
            local ToggleDot = Instance.new("Frame")
            ToggleDot.Parent = ToggleButton
            ToggleDot.BackgroundColor3 = Theme.Text
            ToggleDot.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            ToggleDot.Size = UDim2.new(0, 16, 0, 16)
            
            AddCorner(ToggleDot, 8)
            
            local toggleState = defaultValue
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggleState = not toggleState
                
                CreateTween(ToggleButton, {
                    BackgroundColor3 = toggleState and Theme.Success or Theme.Border
                }):Play()
                
                CreateTween(ToggleDot, {
                    Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
                        Position = toggleState and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
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
            Label.TextWrapped = true
            
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
    
    -- Show Window
    MainFrame.Visible = true
    
    return Window
end

-- Notification System
function SolvenUI:Notify(config)
    config = config or {}
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local duration = config.Duration or 3
    
    local ScreenGui = Player:FindFirstChild("PlayerGui"):FindFirstChild("SolvenUI_Notifications")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SolvenUI_Notifications"
        ScreenGui.Parent = Player.PlayerGui
        ScreenGui.IgnoreGuiInset = true
    end
    
    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.Parent = ScreenGui
    Notification.BackgroundColor3 = Theme.Secondary
    Notification.Position = UDim2.new(1, -320, 0, 20)
    Notification.Size = UDim2.new(0, 300, 0, 80)
    
    AddCorner(Notification, 8)
    
    local NotificationBorder = Instance.new("UIStroke")
    NotificationBorder.Parent = Notification
    NotificationBorder.Color = Theme.Accent
    NotificationBorder.Thickness = 2
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = Notification
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 10)
    NotifTitle.Size = UDim2.new(1, -30, 0, 20)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Theme.Text
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifContent = Instance.new("TextLabel")
    NotifContent.Parent = Notification
    NotifContent.BackgroundTransparency = 1
    NotifContent.Position = UDim2.new(0, 15, 0, 30)
    NotifContent.Size = UDim2.new(1, -30, 1, -40)
    NotifContent.Font = Enum.Font.Gotham
    NotifContent.Text = content
    NotifContent.TextColor3 = Theme.TextSecondary
    NotifContent.TextSize = 12
    NotifContent.TextWrapped = true
    NotifContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifContent.TextYAlignment = Enum.TextYAlignment.Top
    
    -- Slide in animation
    CreateTween(Notification, {Position = UDim2.new(1, -320, 0, 20)}):Play()
    
    -- Auto dismiss
    spawn(function()
        wait(duration)
        CreateTween(Notification, {Position = UDim2.new(1, 0, 0, 20)}):Play()
        wait(0.3)
        Notification:Destroy()
    end)
end

return SolvenUI
