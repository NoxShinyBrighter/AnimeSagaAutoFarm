local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "RollbackProtector"

-- Botão Proteção Anti-Save
local btnProtecao = Instance.new("TextButton", gui)
btnProtecao.Size = UDim2.new(0, 300, 0, 50)
btnProtecao.Position = UDim2.new(0, 20, 0, 100)
btnProtecao.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
btnProtecao.TextColor3 = Color3.fromRGB(255, 255, 255)
btnProtecao.Font = Enum.Font.SourceSansBold
btnProtecao.TextSize = 20
btnProtecao.Text = "Ativar Proteção Anti-Save"

-- Botão Resetar Sessão
local btnReset = Instance.new("TextButton", gui)
btnReset.Size = UDim2.new(0, 300, 0, 50)
btnReset.Position = UDim2.new(0, 20, 0, 170)
btnReset.BackgroundColor3 = Color3.fromRGB(20, 20, 120)
btnReset.TextColor3 = Color3.fromRGB(255, 255, 255)
btnReset.Font = Enum.Font.SourceSansBold
btnReset.TextSize = 20
btnReset.Text = "Resetar Sessão (Fechar Jogo)"

local blockedConnections = {}
local originalInvokeFunctions = {}

local ativado = false

local function bloquearRemote(obj)
    if obj:IsA("RemoteEvent") then
        local nomeMinusculo = obj.Name:lower()
        if nomeMinusculo:find("save") or nomeMinusculo:find("data") or nomeMinusculo:find("update") then
            local conns = getconnections(obj.OnServerEvent)
            blockedConnections[obj] = conns
            for _, conn in pairs(conns) do
                conn:Disable()
            end
            print("Bloqueado RemoteEvent:", obj.Name)
        end
    elseif obj:IsA("RemoteFunction") then
        local nomeMinusculo = obj.Name:lower()
        if nomeMinusculo:find("save") or nomeMinusculo:find("data") or nomeMinusculo:find("update") then
            originalInvokeFunctions[obj] = obj.InvokeServer
            obj.InvokeServer = function()
                print("InvokeServer bloqueado:", obj.Name)
                return nil
            end
            print("Bloqueado RemoteFunction:", obj.Name)
        end
    end
end

local function desbloquearRemote()
    for obj, conns in pairs(blockedConnections) do
        for _, conn in pairs(conns) do
            conn:Enable()
        end
        print("Desbloqueado RemoteEvent:", obj.Name)
    end
    blockedConnections = {}

    for obj, originalFunc in pairs(originalInvokeFunctions) do
        obj.InvokeServer = originalFunc
        print("Desbloqueado RemoteFunction:", obj.Name)
    end
    originalInvokeFunctions = {}
end

btnProtecao.MouseButton1Click:Connect(function()
    if ativado then
        desbloquearRemote()
        btnProtecao.Text = "Ativar Proteção Anti-Save"
        btnProtecao.BackgroundColor3 = Color3.fromRGB(120, 20, 20)
        ativado = false
        print("Proteção desativada. Salvamento liberado.")
    else
        for _, obj in pairs(game:GetDescendants()) do
            bloquearRemote(obj)
        end
        btnProtecao.Text = "Desativar Proteção Anti-Save"
        btnProtecao.BackgroundColor3 = Color3.fromRGB(20, 120, 20)
        ativado = true
        print("Proteção ativada. Salvamento bloqueado.")
    end
end)

btnReset.MouseButton1Click:Connect(function()
    print("Fechando o jogo para resetar a sessão...")
    wait(0.5)
    -- Fechar o Roblox:
    local RunService = game:GetService("RunService")
    if RunService:IsStudio() then
        print("No Studio, não pode fechar.")
    else
        -- Vai fechar o Roblox
        local success, err = pcall(function()
            game:Shutdown()
        end)
        if not success then
            -- Em alguns executores pode não funcionar, tenta forçar:
            os.exit()
        end
    end
end)
