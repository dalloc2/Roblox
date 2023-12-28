local tool = Instance.new("Tool", game.Players.LocalPlayer.Backpack)
tool.Name = "M9"
tool.TextureId = "http://www.roblox.com/asset/?id=158835819"
tool.GripForward = Vector3.new(0, -0.3, 0.3)
local handle = Instance.new("Part", tool)
local gunMesh = Instance.new("SpecialMesh")
local strikes = Instance.new("IntValue", handle)
handle.Name = "Handle"
handle.Size = Vector3.new(0.2, 0.2, 0.2)
handle.BrickColor = BrickColor.new("Really black")
gunMesh.MeshId = "http://www.roblox.com/asset/?id=4372594"
gunMesh.Parent = handle
strikes.Name = "strikes"

function createSound(sound, id)
	local newSound = Instance.new("Sound")
	newSound.Parent = handle
	newSound.Name = sound
	newSound.SoundId = id
end

function createAnim(name, id)
	local newAnim = Instance.new("Animation", handle)
	newAnim.Name = name
	newAnim.AnimationId = id
end

createSound("FireSound", "http://www.roblox.com/asset/?id=134436500")
createSound("Hitmarker", "http://www.roblox.com/asset/?id=160432334")
createSound("ReloadSound", "http://www.roblox.com/asset/?id=138084889")

createAnim("Hold2H", "http://www.roblox.com/asset/?id=180925807")
createAnim("Reload2H", "http://www.roblox.com/asset/?id=180924343")
--gui stuff
local Ambox = Instance.new("ScreenGui")
local Counter = Instance.new("Frame")
local CurrentAmmo = Instance.new("TextLabel")
local TextLabel = Instance.new("TextLabel")
local Weapon = Instance.new("TextLabel")
local StoredAmmo = Instance.new("TextLabel")
local reload = Instance.new("TextButton")

Ambox.Name = "Ambox"
Ambox.Parent = handle

Counter.Name = "Counter"
Counter.Parent = Ambox
Counter.BackgroundColor3 = Color3.new(49/255, 49/255, 49/255)
Counter.BackgroundTransparency = 0.2
Counter.BorderColor3 = Color3.new(26/255, 26/255, 26/255)
Counter.Position = UDim2.new(0.800000012, 0, 0.800000012, 0)
Counter.Size = UDim2.new(0, 150, 0, 50)

CurrentAmmo.Name = "CurrentAmmo"
CurrentAmmo.Parent = Counter
CurrentAmmo.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
CurrentAmmo.BackgroundTransparency = 1
CurrentAmmo.BorderColor3 = Color3.new(0/255,0/255,0/255)
CurrentAmmo.BorderSizePixel = 4
CurrentAmmo.Position = UDim2.new(0, 5, 0, 0)
CurrentAmmo.Size = UDim2.new(0, 40, 1, 0)
CurrentAmmo.Font = Enum.Font.SourceSansBold
CurrentAmmo.Text = "27/"
CurrentAmmo.TextColor3 = Color3.new(250/255, 250/255, 250/255)
CurrentAmmo.TextSize = 36
CurrentAmmo.TextXAlignment = Enum.TextXAlignment.Right
CurrentAmmo.TextYAlignment = Enum.TextYAlignment.Bottom

TextLabel.Name = ""
TextLabel.Parent = CurrentAmmo
TextLabel.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
TextLabel.BackgroundTransparency = 1
TextLabel.BorderColor3 = Color3.new(255/255, 255/255, 255/255)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(1, 5, 0, 22)
TextLabel.Size = UDim2.new(0, 20, 0, 15)
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.Text = "30"
TextLabel.TextColor3 = Color3.new(222/255, 222/255, 222/255)
TextLabel.TextSize = 24.000

Weapon.Name = "Weapon"
Weapon.Parent = Counter
Weapon.BackgroundColor3 = Color3.new(49/255, 49/255, 49/255)
Weapon.BackgroundTransparency = 0.200
Weapon.BorderColor3 = Color3.new(26/255, 26/255, 26/255)
Weapon.Position = UDim2.new(0, 0, 0, -35)
Weapon.Size = UDim2.new(0, 150, 0, 30)
Weapon.Font = Enum.Font.SourceSansBold
Weapon.Text = "Weapon"
Weapon.TextColor3 = Color3.new(250/255, 250/255, 250/255)
Weapon.TextSize = 24.000
Weapon.TextXAlignment = Enum.TextXAlignment.Left

StoredAmmo.Name = "StoredAmmo"
StoredAmmo.Parent = Counter
StoredAmmo.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
StoredAmmo.BackgroundTransparency = 1.000
StoredAmmo.BorderColor3 = Color3.new(0/255, 0/255, 0/255)
StoredAmmo.BorderSizePixel = 4
StoredAmmo.Position = UDim2.new(0, 2, 0, 2)
StoredAmmo.Size = UDim2.new(1, 0, 0, 20)
StoredAmmo.Font = Enum.Font.SourceSansBold
StoredAmmo.Text = "9999"
StoredAmmo.TextColor3 = Color3.new(109/255, 109/255, 109/255)
StoredAmmo.TextSize = 24.000
StoredAmmo.TextXAlignment = Enum.TextXAlignment.Left

reload.Name = "reload"
reload.Parent = Counter
reload.BackgroundTransparency = 1.000
reload.Size = UDim2.new(1, 0, 1, 0)
reload.ZIndex = 5
reload.Font = Enum.Font.SourceSans
reload.Text = ""
reload.TextSize = 14.000
--main handling here

Game:GetService("ContentProvider"):Preload("http://www.roblox.com/asset/?id=180925807")

local muzzle = handle
local player = game.Players.LocalPlayer
local busy = false
local MouseDown = false
local Contraband = {"M4A1","AK47","M9","Remington 870","Sledgehammer","Pickaxe","Pocketknife","Fight"}
local character
local Equip
--Animations
local Hold2H = handle:WaitForChild("Hold2H")
local Reload2H = handle:WaitForChild("Reload2H")
local EquipAnim
local HoldAnim
local ReloadAnim
local deb = false
--Gun Values
local damage = 11.1
local spread = 8
local fireRate = .1
local range = 400
local IsReloading = false
local IsAuto = false
local StoredAmmo = 300
local MaxAmmo = 12
local CurrentAmmo = MaxAmmo
local ReloadTime = 2
local Projectiles = 1
--Functions
function UpdateGui()
	if Ambox then
		local Counter = Ambox.Counter
		Counter.CurrentAmmo.Text = CurrentAmmo.."/"
		Counter.CurrentAmmo[""].Text = MaxAmmo
		if IsReloading then
			Ambox.Counter.StoredAmmo.Text = "RELOADING"
		else Counter.StoredAmmo.Text = StoredAmmo
		end
	end
end
Ambox.Counter.Weapon.Text = tool.Name
UpdateGui()

--HOSTILE SCRIPTS
function hostile(plyr)
	if hostiled ~= true then
		hostiled = false
	end
	return hostiled
end

function hostileCheck(plyr)
	local hostiled
	for i, v in ipairs(plyr.Backpack:GetChildren()) do
		if v.Name == "M16" or v.Name == "AK-47" or v.Name == "M9" or v.Name == "Remington 870" or v.Name == "Sledgehammer" or v.Name == "Fight" then
			hostiled = true
			break
		else hostiled = false
		end
	end
	local hostiled2
	for i, v in ipairs(plyr.Character:GetChildren()) do
		if v.Name == "M16" or v.Name == "AK-47" or v.Name == "M9" or v.Name == "Remington 870" or v.Name == "Sledgehammer" or v.Name == "Fight" then
			hostiled2 = true
			break
		else hostiled2 = false
		end
	end
	return hostiled2 or hostiled
end

function checkIfHostile(p)
	if hostileCheck(p) then
		print("Player was hostile")
	else
		print("player was not hostile")
		handle.strikes.Value = handle.strikes.Value-1
		if handle.strikes.Value > 0 then
			local warning = handle.WarnGui:clone()
			warning.Parent = player.PlayerGui
			warning.Frame.TextLabel.Text = "Killing prisoners for no reason is against the rules! The prisoner must be a threat in order for you to kill prisoners. If you kill "..handle.strikes.Value.." more innocent prisoners, you will be arrested."
		else 
			player.TeamColor = BrickColor.new("Mid gray")
			player.Character.Humanoid.Health = 0		
		end
	end
end
function isOnSameTeam(ply)
	if ply.TeamColor == player.TeamColor then
		return true
	end
end
--RAYCASTING FUNCTIONS
function ray(start, finish, mouse)
	local Range = (mouse.Hit.p - muzzle.CFrame.p).magnitude
	local s = (Range/spread)
	local vector = Vector3.new(math.random(-s,s)/10,math.random(-s,s)/10,math.random(-s,s)/10)
	local ray = Ray.new(start, ((finish + vector)- start).unit*range)
	local hit, position = game.Workspace:FindPartOnRay(ray, character)
	local humanoid
	local item = hit and hit.Parent
	if item then
		humanoid = hit.Parent:findFirstChild("Humanoid") or hit.Parent.Parent:findFirstChild("Humanoid")
	end
	if humanoid then
		local playerHit = game:GetService("Players"):GetPlayerFromCharacter(humanoid.Parent)
		if playerHit ~= nil then
			if humanoid.Health ~= 0 then
				if not isOnSameTeam(playerHit) then
					humanoid:TakeDamage(damage)
					handle.Hitmarker:Play()
					if humanoid.Health <= 0 and player.TeamColor.Name == "Bright blue" then
						if deb == false then
							deb = true
							checkIfHostile(playerHit)
							wait(.1)
							deb = false
						end

					end
				end
			end
		else humanoid:TakeDamage(damage)
		end
	end
	local distance = (position - muzzle.CFrame.p).magnitude
	local rayPart = Instance.new("Part", tool)

	local mesh = Instance.new("BlockMesh",rayPart)

	game.Debris:AddItem(sound,.2)
	mesh.Scale = Vector3.new(.4,.4,1)
	rayPart.Name          = "RayPart"
	rayPart.BrickColor    = BrickColor.new("Bright yellow")
	rayPart.Anchored      = true
	rayPart.CanCollide    = false
	rayPart.Transparency = .3
	rayPart.TopSurface    = Enum.SurfaceType.Smooth
	rayPart.BottomSurface = Enum.SurfaceType.Smooth
	rayPart.formFactor    = Enum.FormFactor.Custom
	rayPart.Size          = Vector3.new(0.2, 0.2, distance)
	rayPart.CFrame        = CFrame.new(position, muzzle.CFrame.p) * CFrame.new(0, 0, -distance/2)
	game.Debris:AddItem(rayPart,.03)
end
--Gun script
tool.Equipped:connect(function(mouse)
	character = tool.Parent
	Equip = true
	HoldAnim = character.Humanoid:LoadAnimation(Hold2H)
	HoldAnim:Play()
	Ambox.Parent = player.PlayerGui
	mouse.Icon = ("http://www.roblox.com/asset/?id=108821806")
	mouse.Button1Down:connect(function()
		MouseDown = true
		if not busy then
			busy = true
			while MouseDown and CurrentAmmo>0 and Equip do
				for i=1,Projectiles do
					ray(muzzle.Position,mouse.Hit.p,mouse) --Call the ray function.
				end
				local sound = handle.FireSound:clone()
				sound.Parent = handle
				sound:Play()
				CurrentAmmo = CurrentAmmo - 1
				UpdateGui()
				wait(fireRate)
				if not IsAuto then break end
			end
			busy = false
		end

	end)
	mouse.Button1Up:connect(function()
		MouseDown = false
	end)
	mouse.KeyDown:connect(function(key)
		if key:lower() == "r" then
			if not busy and not IsReloading then
				ReloadAnim = character.Humanoid:LoadAnimation(Reload2H)
				ReloadAnim:Play()
				handle.ReloadSound:Play()
				local BulletsNeeded = MaxAmmo-CurrentAmmo
				busy = true
				IsReloading = true
				UpdateGui()
				wait(ReloadTime)
				if BulletsNeeded<=StoredAmmo then
					CurrentAmmo = CurrentAmmo+BulletsNeeded
					StoredAmmo = StoredAmmo-BulletsNeeded
				elseif BulletsNeeded>StoredAmmo then
					CurrentAmmo = CurrentAmmo+StoredAmmo
					StoredAmmo = 0
				end
				IsReloading = false
				busy = false
				UpdateGui()
			end
		elseif key:lower() == "e" then
			print("refill ammo")
		end
	end)
	tool.Unequipped:connect(function()
		Equip = false
		mouse.Icon = ("")
		Ambox.Parent = handle
		if HoldAnim then
			HoldAnim:Stop()
		end
		if ReloadAnim then
			ReloadAnim:Stop()
		end
	end)
end)

Ambox.Counter.reload.MouseButton1Down:connect(function()
	if not busy and not IsReloading then
		ReloadAnim = character.Humanoid:LoadAnimation(Reload2H)
		ReloadAnim:Play()
		handle.ReloadSound:Play()
		local BulletsNeeded = MaxAmmo-CurrentAmmo
		busy = true
		IsReloading = true
		UpdateGui()
		wait(ReloadTime)
		if BulletsNeeded<=StoredAmmo then
			CurrentAmmo = CurrentAmmo+BulletsNeeded
			StoredAmmo = StoredAmmo-BulletsNeeded
		elseif BulletsNeeded>StoredAmmo then
			CurrentAmmo = CurrentAmmo+StoredAmmo
			StoredAmmo = 0
		end
		IsReloading = false
		busy = false
		UpdateGui()
	end
end)
