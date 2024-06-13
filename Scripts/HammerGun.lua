-- I made this a bit ago, just never released it though.
local MELEE_ITEM = "Hammer"
local GUN_ITEM = "M4A1"
-- SETTINGS --
local Current = 30
local Max = 30
local FireRate = 0.0875
local Range = 9e9
local Spread = 9e9
local Bullets = 1
local AutoFire = true
local ReloadTime = 2
-- Services --
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Player Objects --
local Player = game:GetService("Players").LocalPlayer
local HUD = Player:WaitForChild("PlayerGui"):WaitForChild("Home"):WaitForChild("hud")
local GunFrame = HUD:WaitForChild("GunFrame")
local Character = Player.Character
-- Folders --
local Remote = workspace:WaitForChild("Remote")
local PrisonItems = workspace:WaitForChild("Prison_ITEMS")
local GunAnimations = ReplicatedStorage:WaitForChild("GunAnimations")
-- Events --
local ItemHandler = Remote:WaitForChild("ItemHandler")
local SoundEvent = ReplicatedStorage:WaitForChild("SoundEvent")
local ShootEvent, ReloadEvent = ReplicatedStorage:WaitForChild("ShootEvent"), ReplicatedStorage:WaitForChild("ReloadEvent")
-- Functions --
local AK47
local Animations = {}
local Tool

local function UpdateGunFrame()
	GunFrame.Label.Text = Tool.Name
	GunFrame.Magazine.Text = Current.."/"..Max
end
local function PlaySound( Sound )
	SoundEvent:FireServer(Sound)
	local NewSound = Sound:Clone()
	NewSound.Parent = Sound.Parent
	NewSound:Play()
	Debris:AddItem(NewSound, 5)
end

local function PlayAllDoors()
	for _,Door in pairs(workspace.Doors:GetChildren()) do
		PlaySound(Door.scn.cardScanner.Sound)
	end
end
local function LoadAnimations()
	local Humanoid = Player.Character.Humanoid
	Animations.Hold = Humanoid:LoadAnimation(GunAnimations.Hold)
	Animations.Shoot = Humanoid:LoadAnimation(GunAnimations.ShootShell)
	Animations.Reload = Humanoid:LoadAnimation(GunAnimations.ReloadMagazine)
end
-- Raycast --
local Muzzle
local RayPart = Instance.new("Part")
RayPart.Anchored = true
RayPart.CanCollide = false
RayPart.BrickColor = BrickColor.Yellow()
RayPart.Transparency = 0.5
RayPart.Material = Enum.Material.Neon
Instance.new("BlockMesh", RayPart).Scale = Vector3.new(0.5, 0.5, 1)
local function CreateRay(Start, Finish)
	local Table = {}
	for _ = 1, Bullets do
		local dist = (Start - Finish).Magnitude
		local s = dist / Spread
		local Vector = Vector3.new(math.random(-s,s)/10,math.random(-s,s)/10,math.random(-s,s)/10)
		local Ray = Ray.new(Start, ((Finish + Vector)- Start).unit*Range)
		local h, p = workspace:FindPartOnRay(Ray, Player.Character)
		local Distance = (p - Muzzle.Position).Magnitude
		local RayPartc = RayPart:Clone()
		RayPartc.Parent = workspace.CurrentCamera
		RayPartc.Size = Vector3.new(0.2, 0.2, Distance)
		RayPartc.CFrame = CFrame.new(p, Muzzle.Position) * CFrame.new(0, 0, -Distance / 2)
		table.insert(Table, { Hit = h, Cframe = RayPartc.CFrame, Distance = Distance, RayObject = Ray })
		Debris:AddItem(RayPartc, 0.05)
	end
	return Table
end
-- Bools --
local Equipped, MouseDown, Busy = false, false, false
-- Get Items --

ItemHandler:InvokeServer({ Position = Character.Head.Position, Parent = PrisonItems.single:WaitForChild(MELEE_ITEM) })
ItemHandler:InvokeServer({ Position = Character.Head.Position, Parent = PrisonItems.giver:WaitForChild(GUN_ITEM) })
-- Main --
local Hammer = Player.Backpack:WaitForChild(MELEE_ITEM)


AK47 = Player.Backpack:WaitForChild(GUN_ITEM)

--AK47:WaitForChild("GunInterface").Disabled = true
Hammer:WaitForChild("MeleeClient").Disabled = true
Muzzle = Hammer:WaitForChild("blade")

local function Reload()
	if Busy then
		return
	end
	Busy = true
	Animations.Reload:Play()
	GunFrame.Label.Text = "RELOADING"
	task.wait(ReloadTime)
	Current = Max
	if Equipped then
		UpdateGunFrame()
	end
	Busy = false
end

Hammer.Equipped:Connect(function(Mouse)
	Equipped = true
	GunFrame.Visible = true
	UpdateGunFrame()
	Animations.Hold:Play()
	Mouse.Button1Down:Connect(function()
		MouseDown = true
		if not Busy then
			Busy = true
			while MouseDown and Busy and Equipped and Current > 0 do
				Current -= 1
				Animations.Shoot:Play()
				--for i = 1,100 do PlayAllDoors() end
				PlaySound(Player.Character.Head.punchSound)
				ShootEvent:FireServer(CreateRay(Player.Character.Head.Position, Mouse.Hit.p), AK47)
				ReloadEvent:FireServer(AK47)
				UpdateGunFrame()
				task.wait(FireRate)
				if not AutoFire then
					break
				end
			end
			Busy = false
		end
	end)
	Mouse.Button1Up:connect(function()
		MouseDown = false
	end)
	Mouse.KeyDown:connect(function(Key)
		if string.lower(Key) == "r" then
			Reload()
		end
	end)
end)
Hammer.Unequipped:connect(function()
	Equipped = false
	GunFrame.Visible = false
	for i,Animation in pairs(Animations) do
		Animation:Stop()
	end
end)

Tool = Hammer
LoadAnimations()
