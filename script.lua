-- Rollback Experimental (Bloqueio de salvamento + fechamento do jogo)
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Função para bloquear eventos suspeitos de salvamento
local function bloquearEventos()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("save") or obj.Name:lower():find("data") then
                obj:Destroy()
                warn("Remote destruído:", obj.Name)
            end
        end
    end
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RollbackProtector"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 220, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Text = "Ativar Anti-Save (Rollback)"

btn.MouseButton1Click:Connect(function()
    bloquearEventos()
    btn.Text = "Proteção Ativada - Fechando..."
    wait(0.5)
    game:Shutdown() -- fecha o jogo automaticamente para tentar impedir salvamento
end)
