--==================================================
-- BR TOOLS | CLIENT GUI
-- Single-file client-side utility GUI
-- Features: Position / Visual / Server
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    warn("BR Tools: LocalPlayer not found")
    return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Remove previous copy
local Previous = PlayerGui:FindFirstChild("BR_Tools")
if Previous then
    Previous:Destroy()
end

--==================================================
-- GUI ROOT
--==================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BR_Tools"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(520, 360)
Main.Position = UDim2.new(0.5, -260, 0.5, -180)
Main.BackgroundColor3 = Color3.fromRGB(25, 27, 34)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = Main

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 9)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.fromOffset(12, 0)
Title.BackgroundTransparency = 1
Title.Text = "BR TOOLS"
Title.TextColor3 = Color3.fromRGB(245, 245, 250)
Title.TextSize = 17
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.fromOffset(34, 28)
Minimize.Position = UDim2.new(1, -43, 0, 7)
Minimize.BackgroundColor3 = Color3.fromRGB(65, 70, 85)
Minimize.Text = "_"
Minimize.TextColor3 = Color3.new(1, 1, 1)
Minimize.TextSize = 18
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 5)
MinCorner.Parent = Minimize

local TabBar = Instance.new("Frame")
TabBar.Position = UDim2.fromOffset(10, 52)
TabBar.Size = UDim2.new(1, -20, 0, 34)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local ContentHolder = Instance.new("Frame")
ContentHolder.Position = UDim2.fromOffset(10, 94)
ContentHolder.Size = UDim2.new(1, -20, 1, -104)
ContentHolder.BackgroundTransparency = 1
ContentHolder.Parent = Main

--==================================================
-- PAGE / TAB SYSTEM
--==================================================

local Tabs = {}
local TabButtons = {}

local function CreateTab(Name)
    local Page = Instance.new("ScrollingFrame")
    Page.Name = Name
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundColor3 = Color3.fromRGB(31, 34, 42)
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 5
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.Visible = false
    Page.Parent = ContentHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Page

    local Padding = Instance.new("UIPadding")
    Padding.PaddingTop = UDim.new(0, 9)
    Padding.PaddingBottom = UDim.new(0, 9)
    Padding.PaddingLeft = UDim.new(0, 9)
    Padding.PaddingRight = UDim.new(0, 9)
    Padding.Parent = Page

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 7)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.fromOffset(0, Layout.AbsoluteContentSize.Y + 20)
    end)

    Tabs[Name] = Page
    return Page
end

local PositionTab = CreateTab("Position")
local VisualTab = CreateTab("Visual")
local ServerTab = CreateTab("Server")

local function ShowTab(Name)
    for TabName, Page in pairs(Tabs) do
        Page.Visible = (TabName == Name)
    end

    for TabName, Button in pairs(TabButtons) do
        Button.BackgroundColor3 =
            (TabName == Name)
            and Color3.fromRGB(75, 105, 170)
            or Color3.fromRGB(49, 53, 65)
    end
end

local function CreateTabButton(Name, Order)
    local Button = Instance.new("TextButton")
    Button.Name = Name .. "TabButton"
    Button.Size = UDim2.new(1/3, -6, 1, 0)
    Button.Position = UDim2.new((Order - 1)/3, (Order - 1) * 3, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(49, 53, 65)
    Button.Text = Name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = TabBar

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        ShowTab(Name)
    end)

    TabButtons[Name] = Button
end

CreateTabButton("Position", 1)
CreateTabButton("Visual", 2)
CreateTabButton("Server", 3)

--==================================================
-- UI ELEMENT CREATORS
--==================================================

local function CreateButton(Parent, Name, Callback)
    local Button = Instance.new("TextButton")
    Button.Name = Name
    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = Color3.fromRGB(53, 59, 75)
    Button.Text = Name
    Button.TextColor3 = Color3.fromRGB(245, 245, 250)
    Button.TextSize = 13
    Button.Font = Enum.Font.Gotham
    Button.AutoButtonColor = true
    Button.Parent = Parent

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Button

    Button.MouseButton1Click:Connect(function()
        if typeof(Callback) == "function" then
            local Success, ErrorMessage = pcall(Callback)
            if not Success then
                warn("BR Tools button error:", ErrorMessage)
            end
        end
    end)

    return Button
end

local function CreateLabel(Parent, Text)
    local Label = Instance.new("TextLabel")
    Label.Name = "InfoLabel"
    Label.Size = UDim2.new(1, 0, 0, 29)
    Label.BackgroundTransparency = 1
    Label.Text = tostring(Text)
    Label.TextColor3 = Color3.fromRGB(215, 220, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = Parent
    return Label
end

-- Use these two functions to add elements to any existing tab.
local function AddButton(TabName, Name, Callback)
    local Page = Tabs[TabName]
    if not Page then
        warn("BR Tools: Tab does not exist:", TabName)
        return nil
    end
    return CreateButton(Page, Name, Callback)
end

local function AddLabel(TabName, Text)
    local Page = Tabs[TabName]
    if not Page then
        warn("BR Tools: Tab does not exist:", TabName)
        return nil
    end
    return CreateLabel(Page, Text)
end

--==================================================
-- HELPER FUNCTIONS
--==================================================

local function GetRoot()
    local Character = LocalPlayer.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChild("HumanoidRootPart")
end

local function CopyText(Value)
    local Text = tostring(Value)
    if typeof(setclipboard) == "function" then
        local Success = pcall(setclipboard, Text)
        if Success then
            print("Copied:", Text)
            return true
        end
    end
    warn("Clipboard API is unavailable. Value:", Text)
    return false
end

local function FormatVector(Vector)
    return string.format("%.3f, %.3f, %.3f", Vector.X, Vector.Y, Vector.Z)
end

--==================================================
-- POSITION TAB
--==================================================

AddLabel("Position", "POSITION TOOLS")

AddButton("Position", "Show Current Position", function()
    local Root = GetRoot()
    if not Root then
        warn("Character or HumanoidRootPart not found")
        return
    end
    print("Position:", FormatVector(Root.Position))
end)

AddButton("Position", "Copy Position", function()
    local Root = GetRoot()
    if not Root then
        warn("Character or HumanoidRootPart not found")
        return
    end
    CopyText(FormatVector(Root.Position))
end)

AddButton("Position", "Show Current CFrame", function()
    local Root = GetRoot()
    if not Root then
        warn("Character or HumanoidRootPart not found")
        return
    end
    print("CFrame:", tostring(Root.CFrame))
end)

AddButton("Position", "Copy CFrame", function()
    local Root = GetRoot()
    if not Root then
        warn("Character or HumanoidRootPart not found")
        return
    end
    CopyText(tostring(Root.CFrame))
end)

AddButton("Position", "Show Character Name", function()
    print("Character:", LocalPlayer.Character and LocalPlayer.Character.Name or "Not spawned")
end

--==================================================
-- SERVER TAB
-- Client-visible session information only.
--==================================================

AddLabel("Server", "SERVER INFORMATION")

local PlaceLabel = AddLabel("Server", "PlaceId: " .. tostring(game.PlaceId))
local JobLabel = AddLabel("Server", "JobId: " .. tostring(game.JobId))
local MapLabel = AddLabel("Server", "MapName: " .. tostring(workspace.Name))

AddButton("Server", "Copy PlaceId", function()
    CopyText(game.PlaceId)
end)

AddButton("Server", "Copy JobId", function()
    CopyText(game.JobId)
end)

AddButton("Server", "Refresh Server Info", function()
    PlaceLabel.Text = "PlaceId: " .. tostring(game.PlaceId)
    JobLabel.Text = "JobId: " .. tostring(game.JobId)
    MapLabel.Text = "MapName: " .. tostring(workspace.Name)
end)

--==================================================
-- MINIMIZE / RESTORE
--==================================================

local IsMinimized = false
local OldMainSize = Main.Size

Minimize.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    ContentHolder.Visible = not IsMinimized
    TabBar.Visible = not IsMinimized

    if IsMinimized then
        Main.Size = UDim2.fromOffset(520, 42)
        Minimize.Text = "+"
    else
        Main.Size = OldMainSize
        Minimize.Text = "_"
    end
end)

--==================================================
-- DRAG WINDOW
--==================================================

local Dragging = false
local DragInput
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch then
        DragInput = Input
    end
end)

UserInputService.InputChanged:Connect(function(Input)
    if Dragging and Input == DragInput then
        local Delta = Input.Position - DragStart
        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

--==================================================
-- CUSTOM BUTTONS / LABELS
-- สร้าง Button และ Label ใหม่ตรงนี้เท่านั้น
--==================================================

-- ตัวอย่าง Button ใน Visual
AddButton("Visual", "Dark Dex Mobile", function()
    print("Test Button clicked")
end)

--[[-- ตัวอย่าง Label ใน Visual
--AddLabel("Visual", "My New Label")

 ตัวอย่าง Button ใน Position
--[[AddButton("Position", "Test Position", function()
    print("Position clicked")
end)
]]
-- ตัวอย่าง Button ใน Server
AddButton("Server", "Rejoin", function()
    print("Rejoin clicked - ต้องเชื่อมระบบ Teleport ที่เกมรองรับ")
end)

ShowTab("Position")

print("BR Tools loaded")
