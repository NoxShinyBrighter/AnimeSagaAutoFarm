-- Script Anti-Save / Rollback ativável
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RollbackProtector"

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 250, 0, 50)
btn.Position = UDim2.new(0, 20, 0, 100)
btn.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 20
btn.Text = "Ativar Proteção Anti-Save"

local desconectarList = {}

local function desconectarRemote(obj)
    if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
        local nomeMinusculo = obj.Name:lower()
        if nomeMinusculo:find("save") or nomeMinusculo:find("data") or nomeMinusculo:find("update") then
            if obj:IsA("RemoteEvent") then
                local connections = getconnections(obj.OnServerEvent)
                for _, conn in pairs(connections) do
                    conn:Disable()
                    table.insert(desconectarList, conn)
                end
            elseif obj:IsA("RemoteFunction") then
                -- Substitui a função InvokeServer por uma função vazia
                obj.InvokeServer = function() end
            end
            print("Desconectado:", obj.Name)
        end
    end
end

local ativado = false

btn.MouseButton1Click:Connect(function()
    if ativado then
        btn.Text = "Proteção já ativada"
        return
    end
    ativado = true
    btn.Text = "Proteção ativada! Bloqueando saves..."
    -- Percorre todo o jogo procurando remotes
    for _, obj in pairs(game:GetDescendants()) do
        desconectarRemote(obj)
    end
    warn("Anti-save ativado!")
end)
