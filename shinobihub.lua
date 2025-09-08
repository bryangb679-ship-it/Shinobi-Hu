-- Shinobi Hub by Rupert
-- Script Local único (interface + funções)

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ShinobiHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Funções utilitárias
local function makeCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,-20,0,35)
    btn.Position = UDim2.new(0,10,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    makeCorner(btn, 8)
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Quadrado flutuante (abrir hub)
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Size = UDim2.fromOffset(50,50)
OpenBtn.Position = UDim2.new(0,100,0.5,-25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
OpenBtn.Image = ""
makeCorner(OpenBtn, 12)
OpenBtn.Parent = ScreenGui
local dragging, dragInput, dragStart, startPos
OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = OpenBtn.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
OpenBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        OpenBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Janela principal
local Main = Instance.new("Frame")
Main.Size = UDim2.fromOffset(480, 0)
Main.Position = UDim2.new(0.5, -240, 0.5, -270)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.Visible = false
Main.Parent = ScreenGui
makeCorner(Main, 12)

-- Gradiente
local ThemeGradient = Instance.new("UIGradient")
ThemeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,20)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180,0,0))
}
ThemeGradient.Rotation = 90
ThemeGradient.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,-80,0,42)
Title.BackgroundTransparency = 1
Title.Text = "Shinobi Hub"
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0,10,0,0)
Title.Parent = Main

local Sub = Instance.new("TextLabel")
Sub.Position = UDim2.new(0,10,0,42)
Sub.Size = UDim2.new(1,-80,0,20)
Sub.BackgroundTransparency = 1
Sub.Text = "by Rupert"
Sub.Font = Enum.Font.Gotham
Sub.TextScaled = true
Sub.TextColor3 = Color3.fromRGB(210,210,210)
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Main

-- Botões fechar/minimizar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(30,30)
CloseBtn.Position = UDim2.new(1,-35,0,5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextScaled = true
CloseBtn.Parent = Main
makeCorner(CloseBtn, 8)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.fromOffset(30,30)
MinBtn.Position = UDim2.new(1,-70,0,5)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true
MinBtn.Parent = Main
makeCorner(MinBtn, 8)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)
MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Mostrar hub
OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        Main:TweenSize(UDim2.fromOffset(480,540), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
    end
end)

-- Tabs
local Tabs = Instance.new("Frame")
Tabs.Size = UDim2.new(1,0,0,40)
Tabs.Position = UDim2.new(0,0,0,70)
Tabs.BackgroundTransparency = 1
Tabs.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,5)
TabLayout.Parent = Tabs

local tabFrames = {}
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(80,30)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextScaled = true
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = Tabs
    makeCorner(btn, 8)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,-20,1,-130)
    frame.Position = UDim2.new(0,10,0,120)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    frame.Parent = Main
    tabFrames[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _,f in pairs(tabFrames) do f.Visible = false end
        frame.Visible = true
    end)
end

createTab("Home")
createTab("Admin")
createTab("Players")
createTab("Kick")
createTab("Settings")

-- ... (restante das funções do Hub já fundidas)
