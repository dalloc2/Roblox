-- 17/04/2024
if not game.Loaded then
	game.Loaded:Wait()
end
-- Forces new chat bubble on game!
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Chat = game:GetService("Chat")
-- Player --
local LocalPlayer = Players.LocalPlayer
-- Disable Bubble Chat --
LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("BubbleChat").Disabled = true
-- Event --
local DefaultChatSystemChatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
if not DefaultChatSystemChatEvents then
	return
end
local OnMessageDoneFiltering = DefaultChatSystemChatEvents:WaitForChild("OnMessageDoneFiltering")
OnMessageDoneFiltering.OnClientEvent:connect(function(Info)
	local Speaker = Info.FromSpeaker and Players:FindFirstChild(Info.FromSpeaker)
	if not Speaker then
		return
	end
	if Speaker.Character and Speaker.Character:FindFirstChild("Head") then
		Chat:Chat(Speaker.Character.Head, tostring(Info.Message), Enum.ChatColor.White)
	end
end)
