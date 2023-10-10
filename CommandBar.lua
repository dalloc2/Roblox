local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Time = 5
local tick = tick
local FromHSV = Color3.fromHSV
local HideDelay


local CommandGui = Instance.new("ScreenGui")
local Bar = Instance.new("TextBox")
local Commands = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Close = Instance.new("TextButton")
local Container = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local Example = Instance.new("TextLabel")

CommandGui.Name = "CommandGui"
CommandGui.Parent = game.CoreGui

Bar.Name = "Bar"
Bar.Parent = CommandGui
Bar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
Bar.BorderSizePixel = 0
Bar.Position = UDim2.new(0.5, -242, 1, -100)
Bar.Size = UDim2.new(0, 485, 0, 26)
Bar.Font = Enum.Font.SourceSans
Bar.PlaceholderColor3 = Color3.fromRGB(178, 178, 178)
Bar.PlaceholderText = "Command"
Bar.Text = ""
Bar.TextColor3 = Color3.fromRGB(255, 255, 255)
Bar.TextSize = 16.000

Commands.Name = "Commands"
Commands.Parent = CommandGui
Commands.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Commands.BorderColor3 = Color3.fromRGB(0, 0, 0)
Commands.BorderSizePixel = 0
Commands.Position = UDim2.new(0.5, -121, 1, -380)
Commands.Size = UDim2.new(0, 243, 0, 276)
Commands.Active = true
Commands.Selectable = true
Commands.Draggable = true
Commands.Visible = false

Title.Name = "Title"
Title.Parent = Commands
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.SourceSans
Title.Text = "Commands"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14.000

Close.Name = "Close"
Close.Parent = Commands
Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Close.BackgroundTransparency = 1.000
Close.BorderColor3 = Color3.fromRGB(0, 0, 0)
Close.BorderSizePixel = 0
Close.Position = UDim2.new(1, -20, 0, 0)
Close.Size = UDim2.new(0, 20, 0, 20)
Close.ZIndex = 3
Close.Font = Enum.Font.SourceSans
Close.Text = "x"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 14.000
Close.MouseButton1Click:connect(function()
   Commands.Visible = false
end)

Container.Name = "Container"
Container.Parent = Commands
Container.Active = true
Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Container.BackgroundTransparency = 1.000
Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0, 0, 0.0724637657, 0)
Container.Size = UDim2.new(0, 243, 0, 256)
Container.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
Container.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

Example.Name = "Example"
Example.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Example.BackgroundTransparency = 1.000
Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
Example.BorderSizePixel = 0
Example.Size = UDim2.new(1, 0, 0, 20)
Example.Font = Enum.Font.SourceSans
Example.Text = "1. Hello"
Example.TextColor3 = Color3.fromRGB(255, 255, 255)
Example.TextSize = 14.000
Example.TextXAlignment = Enum.TextXAlignment.Left

local function Focus()
	if HideDelay then task.cancel(HideDelay) HideDelay = nil end
	Bar.Visible = true
	TweenService:Create(Bar, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
	TweenService:Create(Bar, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
	Bar:CaptureFocus()
	repeat task.wait() until Bar.Text ~= ""
	Bar.Text = ""
end

local function Hide()
  TweenService:Create(Bar, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Bar, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
	HideDelay = task.delay(0.2, function()
		Bar.Visible = false
		HideDelay = nil
	end)
end

local function StartRainbow()
  RunService:BindToRenderStep("Rainbow", 1000, function()
	  local HUE = tick() % Time / Time
	  local Color = FromHSV(HUE, 1, 1)
	  Bar.TextColor3 = Color
	  Commands.Title.TextColor3 = Color
	  Commands.Close.TextColor3 = Color
	  for _,Command in pairs(Container:GetChildren()) do
 		  if Command:IsA("TextLabel") then Command.TextColor3 = Color end
  	end 
  end)
end

return {
	CommandBar = Bar,
	Commands = Commands,
  Example = Example,
	CommandGui = CommandGui,
  Hide = Hide,
  Focus = Focus,
  Rainbow = StartRainbow
}
