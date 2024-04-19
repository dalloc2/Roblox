-- Prison Life Controller Script --
--[[
    Instructions:
    X - Reload,
    B - Punch,
    Y - Crouch,
    L2 - Sprint
--]]
-- Services --
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
-- Functions --
local Actions = {
    ["X"] = "R",
    ["B"] = "F",
    ["Y"] = "C",
}
local function PressKey(Key, Hold)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[Key], false, nil)
    if not Hold then
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[Key], false, nil)
    end
end
local function InputBegan(Input, Focused)
    local Action = Actions[string.sub(Input.KeyCode.Name, 7)]
    if Action then
        PressKey(Action)
    elseif Input.KeyCode == Enum.KeyCode.ButtonL2 then
        PressKey("LeftShift", true)
    end
end
local function InputEnded(Input)
    if Input.KeyCode == Enum.KeyCode.ButtonL2 then
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, nil)
    end
end
-- Connections --
UserInputService.InputBegan:Connect(InputBegan)
UserInputService.InputEnded:Connect(InputEnded)
