local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = char:WaitForChild("HumanoidRootPart")

local rollbackAtivo = false
local rollbackPos = nil

-- Criar GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RollbackGui"

local botao = Instance.new("TextButton", gui)
botao.Size = UDim2.new(0, 180, 0, 40)
botao.Position = UDim2.new(0, 20, 0, 100)
botao.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
botao.TextColor3 = Color3.fromRGB(255, 255, 255)
botao.Font = Enum.Font.SourceSansBold
botao.TextSize = 18
botao.Text = "Ativar Rollback"

botao.MouseButton1Click:Connect(function()
    if not rollbackAtivo then
        rollbackPos = humanoidRootPart.CFrame
        botao.Text = "Voltar (Rollback)"
        rollbackAtivo = true
    else
        if rollbackPos then
            humanoidRootPart.CFrame = rollbackPos
        end
        botao.Text = "Ativar Rollback"
        rollbackAtivo = false
    end
end)
