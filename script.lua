
-- Rollback Experimental (Bloqueio de salvamento)
-- Use com cautela. Pode não funcionar em todos os jogos e pode causar ban.

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Função para bloquear eventos suspeitos
local function bloquearEventos()
    for _, obj in pairs(getgc(true)) do
        if typeof(obj) == "table" then
            for k, v in pairs(obj) do
                if type(v) == "function" and getfenv(v).script and tostring(getfenv(v).script):lower():find("data") then
                    hookfunction(v, function(...)
                        warn("Tentativa de salvar bloqueada:", getfenv(v).script:GetFullName())
                        return nil
                    end)
                end
            end
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            if obj.Name:lower():find("save") or obj.Name:lower():find("data") then
                obj:Destroy()
                warn("Remote destruído:", obj.Name)
            end
        end
    end
end

-- Interface simples para ativar o bloqueio
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RollbackProtector"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 200, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.Text = "Ativar Anti-Save (Rollback)"

btn.MouseButton1Click:Connect(function()
    bloquearEventos()
    btn.Text = "Proteção Ativada"
end)
