-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
local Notification = Instance.new("Frame")
local MainFrame = Instance.new("Frame")
local MinimizedFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ButtonsHolder = Instance.new("Frame")
-- Parent the ScreenGui to the right place
if game:GetService("RunService"):IsStudio() then
    ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end
-- Create Notification
Notification.Name = "Notification"
Notification.Parent = ScreenGui
Notification.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Notification.Position = UDim2.new(0.5, -150, 0.1, 0)
Notification.Size = UDim2.new(0, 300, 0, 60)
Notification.Visible = false
local NotifText = Instance.new("TextLabel")
NotifText.Parent = Notification
NotifText.BackgroundTransparency = 1
NotifText.Position = UDim2.new(0, 0, 0, 0)
NotifText.Size = UDim2.new(1, 0, 1, 0)
NotifText.Font = Enum.Font.GothamBold
NotifText.Text = "Created by Atranathus Brick Selector GUI"
NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifText.TextSize = 14
-- Create Minimized Frame
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinimizedFrame.Position = UDim2.new(0.5, -100, 0.5, -15)
MinimizedFrame.Size = UDim2.new(0, 200, 0, 30)
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Draggable = true
-- Add corner to minimized frame
local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.Parent = MinimizedFrame
MinimizedCorner.CornerRadius = UDim.new(0, 8)
-- Create Minimized Title
local MinimizedTitle = Instance.new("TextLabel")
MinimizedTitle.Name = "MinimizedTitle"
MinimizedTitle.Parent = MinimizedFrame
MinimizedTitle.BackgroundTransparency = 1
MinimizedTitle.Position = UDim2.new(0, 10, 0, 0)
MinimizedTitle.Size = UDim2.new(1, -40, 1, 0)
MinimizedTitle.Font = Enum.Font.GothamBold
MinimizedTitle.Text = "Dino Selector (Gamepass)"
MinimizedTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedTitle.TextSize = 14
-- Create Expand Button
local ExpandButton = Instance.new("TextButton")
ExpandButton.Name = "ExpandButton"
ExpandButton.Parent = MinimizedFrame
ExpandButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ExpandButton.Position = UDim2.new(1, -25, 0.5, -10)
ExpandButton.Size = UDim2.new(0, 20, 0, 20)
ExpandButton.Font = Enum.Font.GothamBold
ExpandButton.Text = "+"
ExpandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ExpandButton.TextSize = 14
-- Create Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.Size = UDim2.new(0, 300, 0, 400) -- Ajuste para caber todos os botões
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
-- Add corner to main frame
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)
-- Create Title
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Dino Selector (Gamepass)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
-- Create Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Position = UDim2.new(1, -25, 0, 5)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
-- Create Minimize Button
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Position = UDim2.new(1, -50, 0, 5)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 14
-- Create Buttons Holder
ButtonsHolder.Name = "ButtonsHolder"
ButtonsHolder.Parent = MainFrame
ButtonsHolder.BackgroundTransparency = 1
ButtonsHolder.Position = UDim2.new(0, 10, 0, 40)
ButtonsHolder.Size = UDim2.new(1, -20, 1, -50)
-- Dino List (Gamepass)
local dinos = {
    "Tyrannosaurus1",
    "Mapusaurus1",
    "Spinosaurus1",
    "Majungasaurus1",
    "Megalosaurus1",
    "Diplodocus1",
    "Turiasaurus1",
    "Quetzalcoatl1",
    "Ankylosaurus1",
    "Xiphactinus1",
    "Sarcosuchus1",
    "Dakotaraptor1"
}
-- Create Buttons
for i, dino in ipairs(dinos) do
    local button = Instance.new("TextButton")
    button.Name = dino .. "Button"
    button.Parent = ButtonsHolder
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.Position = UDim2.new(0, 0, 0, (i-1) * 35)
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Font = Enum.Font.GothamSemibold
    button.Text = dino
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    
    -- Add corner to button
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.Parent = button
    buttonCorner.CornerRadius = UDim.new(0, 6)
    
    -- Button Click Function
    button.MouseButton1Click:Connect(function()
        local args = {
            [1] = "Gamepass",
            [2] = dino,
            [3] = 1038028394,
            [4] = true
        }
        game:GetService("ReplicatedStorage").SpawnEventsGamepass.Standard:FireServer(unpack(args))
    end)
end
-- Minimize Button Function
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
    MinimizedFrame.Position = MainFrame.Position
end)
-- Expand Button Function
ExpandButton.MouseButton1Click:Connect(function()
    MinimizedFrame.Visible = false
    MainFrame.Visible = true
    MainFrame.Position = MinimizedFrame.Position
end)
-- Close Button Function
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = false
end)
-- Show Notification and Main Frame
Notification.Visible = true
wait(3)
Notification.Visible = false
MainFrame.Visible = true
