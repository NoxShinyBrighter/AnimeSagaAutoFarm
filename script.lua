-- Auto Farm Anime Saga com GUI e Rollback (by Vilu & Vi)
local moduleCode = [[
local Module = {}

Module.FarmAtivo = false
Module.RollbackAtivo = false
Module.RollbackPos = nil

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
local inimigos = workspace:WaitForChild("Enemies") -- ajuste o nome se necessário

function Module.Atacar()
    mouse1click()
end

function Module.UsarHabilidades()
    local UserInputService = game:GetService("UserInputService")
    local teclas = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C}
    for _, tecla in ipairs(teclas) do
        UserInputService:SetKeyDown(tecla)
        wait(0.1)
        UserInputService:SetKeyUp(tecla)
        wait(0.1)
    end
end

function Module.Start()
    spawn(function()
        while true do
            if Module.RollbackAtivo and Module.RollbackPos then
                wait(15)
                humanoidRootPart.CFrame = Module.RollbackPos
            end
            wait(1)
        end
    end)
    spawn(function()
        while true do
            if Module.FarmAtivo then
                Module.RollbackPos = humanoidRootPart.CFrame
                for _, inimigo in pairs(inimigos:GetChildren()) do
                    if inimigo:FindFirstChild("HumanoidRootPart") and inimigo:FindFirstChild("Humanoid") and inimigo.Humanoid.Health > 0 then
                        humanoidRootPart.CFrame = inimigo.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        wait(0.3)
                        Module.Atacar()
                        Module.UsarHabilidades()
                        wait(0.5)
                    end
                end
            end
            wait(0.5)
        end
    end)
end

return Module
]]

local Module = loadstring(moduleCode)()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoFarmGUI"

local function criarBotao(texto, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = texto
    btn.Parent = ScreenGui
    return btn
end

local toggleFarm = criarBotao("Ativar Auto Farm", 100)
local toggleRollback = criarBotao("Ativar Rollback", 150)

toggleFarm.MouseButton1Click:Connect(function()
    Module.FarmAtivo = not Module.FarmAtivo
    toggleFarm.Text = Module.FarmAtivo and "Desativar Auto Farm" or "Ativar Auto Farm"
end)

toggleRollback.MouseButton1Click:Connect(function()
    Module.RollbackAtivo = not Module.RollbackAtivo
    toggleRollback.Text = Module.RollbackAtivo and "Desativar Rollback" or "Ativar Rollback"
end)

Module.Start()
