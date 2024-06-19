--i made this a bit ago, never released it either lol.
-- Services --
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Player --
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
-- Animations --
local Arms = Instance.new("Animation")
Arms.AnimationId = "rbxassetid://183294396"
local Attack = Instance.new("Animation")
Attack.AnimationId = "rbxassetid://180416148"
-- Load --
Arms = Humanoid:LoadAnimation(Arms)
Attack = Humanoid:LoadAnimation(Attack)
-- Functions --
local function Damage(Player)
	Attack:Play()
	Attack:AdjustSpeed(2)
	ReplicatedStorage.meleeEvent:FireServer(Player, { Name = "Crude Knife" }) -- Replace with any damage code to make it work in any game!
end
local function ValidCharacter(Model)
	return Model and Model:FindFirstChild("Humanoid") and Model:FindFirstChild("HumanoidRootPart") and Model.Humanoid.Health > 0
end
local function GetClosestPlayer()
	for _,Player in pairs(Players:GetPlayers()) do
		if Player ~= LocalPlayer and Player.Character and Player:DistanceFromCharacter(Character.Head.Position) <= 15 and ValidCharacter(Player.Character) then
			return Player
		end
	end
end
-- Main --
--Humanoid.WalkSpeed = 10
local LastTarget
Arms:Play()
while task.wait(1) do 
	if LocalPlayer.Character and LocalPlayer.Character ~= Character then
		print("loop broke cus new character")
		break
	end
	if not Target then
		Target = GetClosestPlayer()
		if Target then
			if LastTarget and Target == LastTarget then
				repeat task.wait() 
				until LastTarget ~= Target
			end
			local TargetCharacter = Target.Character
			local Torso = TargetCharacter.HumanoidRootPart
			repeat task.wait()
				Humanoid:MoveTo(Torso.Position)
				if LocalPlayer:DistanceFromCharacter(Torso.Position) <= 4 then
					Damage(Target)
					task.wait(1)
				end
			until not TargetCharacter:FindFirstChild("Humanoid") or TargetCharacter.Humanoid.Health < 1 or TargetCharacter ~= Target.Character
			LastTarget = Target
			Target = nil
		end
	end
end
