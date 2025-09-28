-- UI Library para Roblox - Versão Corrigida
-- Carregue com: local Library = loadstring(game:HttpGet("sua-url-aqui"))()()

local Library = {}
local Windows = {}

-- ========== SERVIÇOS ==========
local function gethui()
    return game:GetService("CoreGui") -- Substitua pela função gethui() real em exploits
end

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ========== DETECÇÃO DE DISPOSITIVO ==========
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize
local isMobileScreen = screenSize.X < 768 or isMobile

-- ========== TEMA ==========
local theme = {
    Background = Color3.fromRGB(30, 30, 30),
    InnerBackground = Color3.fromRGB(35, 35, 35),
    Outline = Color3.fromRGB(50, 50, 50),
    Accent = Color3.fromRGB(130, 55, 236),
    Text = Color3.fromRGB(255, 255, 255),
    DarkText = Color3.fromRGB(170, 170, 170),
    ToggleOn = Color3.fromRGB(130, 55, 236),
    SliderProgress = Color3.fromRGB(130, 55, 236)
}

-- ========== FUNÇÕES UTILITÁRIAS ==========
local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or theme.Outline
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, left or 0)
    padding.PaddingRight = UDim.new(0, right or 0)
    padding.PaddingTop = UDim.new(0, top or 0)
    padding.PaddingBottom = UDim.new(0, bottom or 0)
    padding.Parent = parent
    return padding
end

local function createListLayout(parent, direction, padding, sortOrder)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    layout.Padding = UDim.new(0, padding or 4)
    layout.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

-- ========== CLASSE WINDOW ==========
local Window = {}
Window.__index = Window

function Window:new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.Center = config.Center ~= false
    self.MenuFadeTime = config.MenuFadeTime or 0.2
    self.Tabs = {}
    self.CurrentTab = nil
    
    self:CreateWindow()
    return self
end

function Window:CreateWindow()
    -- Criar ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary_" .. self.Title
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    self.ScreenGui.Parent = gethui()
    
    -- Calcular tamanho do menu baseado no tamanho da tela
    local menuSize, menuPosition
    if isMobileScreen then
        menuSize = UDim2.new(0.9, 0, 0.85, 0) -- 90% largura, 85% altura
        menuPosition = UDim2.new(0.05, 0, 0.075, 0) -- centralizado
    else
        menuSize = UDim2.new(0, 536, 0, 296)
        menuPosition = self.Center and UDim2.new(0.5, -268, 0.5, -148) or UDim2.new(0, 100, 0, 100)
    end
    
    -- Frame Principal do Menu
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Active = true
    self.MainFrame.ZIndex = 90
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.BackgroundColor3 = theme.Background
    self.MainFrame.Size = menuSize
    self.MainFrame.Position = menuPosition
    self.MainFrame.Parent = self.ScreenGui
    
    createCorner(self.MainFrame, 6)
    createStroke(self.MainFrame, theme.Outline, 1)
    
    -- Funcionalidade de arrastar
    self:SetupDrag()
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.TextWrapped = true
    self.TitleLabel.BorderSizePixel = 0
    self.TitleLabel.TextSize = isMobileScreen and 18 or 15
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextScaled = false
    self.TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.Font = Enum.Font.SourceSansBold
    self.TitleLabel.TextColor3 = theme.Text
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.Parent = self.MainFrame
    
    if isMobileScreen then
        self.TitleLabel.Size = UDim2.new(1, -12, 0, 30)
        self.TitleLabel.Position = UDim2.new(0, 6, 0, 4)
    else
        self.TitleLabel.Size = UDim2.new(0, 520, 0, 22)
        self.TitleLabel.Position = UDim2.new(0, 6, 0, 2)
    end
    
    -- Fundo Interno
    self.InnerBackground = Instance.new("Frame")
    self.InnerBackground.Name = "InnerBackground"
    self.InnerBackground.BorderSizePixel = 0
    self.InnerBackground.BackgroundColor3 = theme.InnerBackground
    self.InnerBackground.Parent = self.MainFrame
    
    if isMobileScreen then
        self.InnerBackground.Size = UDim2.new(1, -8, 1, -40)
        self.InnerBackground.Position = UDim2.new(0, 4, 0, 36)
    else
        self.InnerBackground.Size = UDim2.new(0, 528, 0, 264)
        self.InnerBackground.Position = UDim2.new(0, 4, 0, 28)
    end
    
    createCorner(self.InnerBackground, 4)
    createStroke(self.InnerBackground, theme.Outline)
    
    -- Frame das Abas (Sidebar)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.BackgroundColor3 = theme.Background
    self.TabsFrame.Parent = self.InnerBackground
    
    if isMobileScreen then
        self.TabsFrame.Size = UDim2.new(0, 140, 1, -4)
        self.TabsFrame.Position = UDim2.new(0, 2, 0, 2)
    else
        self.TabsFrame.Size = UDim2.new(0, 148, 0, 260)
        self.TabsFrame.Position = UDim2.new(0, 2, 0, 2)
    end
    
    createCorner(self.TabsFrame, 6)
    createStroke(self.TabsFrame, theme.Outline)
    
    -- Scroll das Abas
    self.TabsScroll = Instance.new("ScrollingFrame")
    self.TabsScroll.Name = "TabsScroll"
    self.TabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabsScroll.BorderSizePixel = 0
    self.TabsScroll.BackgroundTransparency = 1
    self.TabsScroll.ScrollBarImageTransparency = isMobileScreen and 0 or 1
    self.TabsScroll.Size = UDim2.new(1, -8, 1, -8)
    self.TabsScroll.Position = UDim2.new(0, 4, 0, 4)
    self.TabsScroll.ScrollBarThickness = isMobileScreen and 8 or 4
    self.TabsScroll.ScrollBarImageColor3 = theme.Accent
    self.TabsScroll.Parent = self.TabsFrame
    
    createCorner(self.TabsScroll, 4)
    createPadding(self.TabsScroll, 4, 4, 4, 4)
    
    self.TabsLayout = createListLayout(self.TabsScroll, Enum.FillDirection.Vertical, 4)
    
    -- Frame de Conteúdo
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.BackgroundColor3 = theme.InnerBackground
    self.ContentFrame.Parent = self.InnerBackground
    
    if isMobileScreen then
        self.ContentFrame.Size = UDim2.new(1, -150, 1, -4)
        self.ContentFrame.Position = UDim2.new(0, 146, 0, 2)
    else
        self.ContentFrame.Size = UDim2.new(0, 376, 0, 260)
        self.ContentFrame.Position = UDim2.new(0, 150, 0, 2)
    end
    
    createCorner(self.ContentFrame, 4)
    createStroke(self.ContentFrame, theme.Outline)
    
    -- Atualizar tamanho do canvas
    self.TabsLayout.Changed:Connect(function()
        self.TabsScroll.CanvasSize = UDim2.new(0, 0, 0, self.TabsLayout.AbsoluteContentSize.Y + 8)
    end)
end

function Window:SetupDrag()
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        if not isDragging then return end
        
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.MainFrame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateInput(input)
        end
    end)
end

function Window:AddTab(name)
    local Tab = setmetatable({}, {__index = {}})
    Tab.Name = name
    Tab.Window = self
    Tab.Elements = {}
    
    -- Criar botão da aba
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = name
    Tab.Button.TextWrapped = true
    Tab.Button.BorderSizePixel = 0
    Tab.Button.TextSize = isMobileScreen and 18 or 16
    Tab.Button.AutoButtonColor = false
    Tab.Button.TextScaled = false
    Tab.Button.TextColor3 = theme.Text
    Tab.Button.BackgroundColor3 = theme.InnerBackground
    Tab.Button.Font = Enum.Font.SourceSansSemibold
    Tab.Button.Size = UDim2.new(1, 0, 0, isMobileScreen and 35 or 25)
    Tab.Button.Text = name
    Tab.Button.Parent = self.TabsScroll
    
    createCorner(Tab.Button, 4)
    Tab.ButtonStroke = createStroke(Tab.Button, theme.Accent)
    Tab.ButtonStroke.Transparency = 0.5
    
    -- Criar conteúdo da aba
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = name .. "_Content"
    Tab.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    Tab.Content.BorderSizePixel = 0
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.ScrollBarImageTransparency = isMobileScreen and 0 or 1
    Tab.Content.Size = UDim2.new(1, -16, 1, -8)
    Tab.Content.Position = UDim2.new(0, 8, 0, 4)
    Tab.Content.ScrollBarThickness = isMobileScreen and 8 or 4
    Tab.Content.ScrollBarImageColor3 = theme.Accent
    Tab.Content.Visible = false
    Tab.Content.Parent = self.ContentFrame
    
    createCorner(Tab.Content, 4)
    createPadding(Tab.Content, 8, 8, 8, 8)
    
    Tab.ContentLayout = createListLayout(Tab.Content, Enum.FillDirection.Vertical, 8)
    
    -- Atualizar tamanho do canvas
    Tab.ContentLayout.Changed:Connect(function()
        Tab.Content.CanvasSize = UDim2.new(0, 0, 0, Tab.ContentLayout.AbsoluteContentSize.Y + 16)
    end)
    
    -- Seleção da aba
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    -- ========== MÉTODO ADDTOGGLE ==========
    function Tab:AddToggle(id, config)
        local Toggle = {}
        Toggle.ID = id
        Toggle.Text = config.Text or "Toggle"
        Toggle.Default = config.Default or false
        Toggle.Disabled = config.Disabled or false
        Toggle.Callback = config.Callback or function() end
        Toggle.State = Toggle.Default
        
        -- Criar frame do toggle
        Toggle.Frame = Instance.new("Frame")
        Toggle.Frame.Name = id
        Toggle.Frame.BorderSizePixel = 0
        Toggle.Frame.BackgroundTransparency = 1
        Toggle.Frame.Size = UDim2.new(1, 0, 0, isMobileScreen and 40 or 34)
        Toggle.Frame.Parent = Tab.Content
        
        -- Botão do toggle
        Toggle.Button = Instance.new("TextButton")
        Toggle.Button.BorderSizePixel = 0
        Toggle.Button.AutoButtonColor = false
        Toggle.Button.BackgroundColor3 = theme.Outline
        Toggle.Button.Size = UDim2.new(0, isMobileScreen and 28 or 22, 0, isMobileScreen and 28 or 22)
        Toggle.Button.Position = UDim2.new(0, 0, 0, isMobileScreen and 6 or 6)
        Toggle.Button.Text = ""
        Toggle.Button.Parent = Toggle.Frame
        
        createCorner(Toggle.Button, 5)
        createStroke(Toggle.Button, theme.Accent)
        
        -- Indicador do toggle
        Toggle.Indicator = Instance.new("Frame")
        Toggle.Indicator.Name = "Indicator"
        Toggle.Indicator.Visible = Toggle.State
        Toggle.Indicator.BorderSizePixel = 0
        Toggle.Indicator.BackgroundColor3 = theme.ToggleOn
        Toggle.Indicator.Size = UDim2.new(0, isMobileScreen and 18 or 14, 0, isMobileScreen and 18 or 14)
        Toggle.Indicator.Position = UDim2.new(0, isMobileScreen and 5 : 4, 0, isMobileScreen and 5 or 4)
        Toggle.Indicator.Parent = Toggle.Button
        
        createCorner(Toggle.Indicator, 3)
        
        -- Texto do toggle
        Toggle.Label = Instance.new("TextLabel")
        Toggle.Label.Name = "Label"
        Toggle.Label.TextWrapped = true
        Toggle.Label.BorderSizePixel = 0
        Toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
        Toggle.Label.TextScaled = false
        Toggle.Label.TextSize = isMobileScreen and 18 or 14
        Toggle.Label.BackgroundTransparency = 1
        Toggle.Label.Font = Enum.Font.SourceSans
        Toggle.Label.TextColor3 = theme.Text
        Toggle.Label.Size = UDim2.new(1, isMobileScreen and -40 or -34, 0, isMobileScreen and 22 or 18)
        Toggle.Label.Text = Toggle.Text
        Toggle.Label.Position = UDim2.new(0, isMobileScreen and 36 or 28, 0, isMobileScreen and 9 or 8)
        Toggle.Label.Parent = Toggle.Frame
        
        -- Funcionalidade do toggle
        local function setToggle(state)
            Toggle.State = state
            Toggle.Indicator.Visible = Toggle.State
            pcall(Toggle.Callback, Toggle.State)
        end
        
        Toggle.Button.MouseButton1Click:Connect(function()
            if not Toggle.Disabled then
                setToggle(not Toggle.State)
            end
        end)
        
        -- Definir estado inicial
        setToggle(Toggle.State)
        
        Tab.Elements[id] = Toggle
        return Toggle
    end
    
    -- ========== MÉTODO ADDSLIDER (CORRIGIDO) ==========
    function Tab:AddSlider(id, config)
        local Slider = {}
        Slider.ID = id
        Slider.Text = config.Text or "Slider"
        Slider.Default = config.Default or 0
        Slider.Min = config.Min or 0
        Slider.Max = config.Max or 100
        Slider.HideMax = config.HideMax or false
        Slider.Compact = config.Compact or false
        Slider.Suffix = config.Suffix or ""
        Slider.Callback = config.Callback or function() end
        Slider.Value = Slider.Default
        
        -- Criar frame do slider
        Slider.Frame = Instance.new("Frame")
        Slider.Frame.Name = id
        Slider.Frame.BorderSizePixel = 0
        Slider.Frame.BackgroundTransparency = 1
        Slider.Frame.Size = UDim2.new(1, 0, 0, Slider.Compact and (isMobileScreen and 40 or 34) or (isMobileScreen and 60 or 52))
        Slider.Frame.Parent = Tab.Content
        
        -- Fundo do slider
        Slider.Background = Instance.new("TextButton") -- Mudado para TextButton para capturar input
        Slider.Background.BorderSizePixel = 0
        Slider.Background.BackgroundColor3 = theme.Outline
        Slider.Background.Size = UDim2.new(1, -12, 0, isMobileScreen and 32 or 26)
        Slider.Background.Position = UDim2.new(0, 6, 0, Slider.Compact and (isMobileScreen and 4 or 4) or (isMobileScreen and 26 or 22))
        Slider.Background.Text = ""
        Slider.Background.AutoButtonColor = false
        Slider.Background.Parent = Slider.Frame
        
        createCorner(Slider.Background, 5)
        createStroke(Slider.Background, theme.Accent)
        
        -- Fundo do progresso
        Slider.Progress = Instance.new("Frame")
        Slider.Progress.Name = "Progress"
        Slider.Progress.BorderSizePixel = 0
        Slider.Progress.BackgroundColor3 = theme.InnerBackground
        Slider.Progress.Size = UDim2.new(1, -8, 0, isMobileScreen and 24 or 18)
        Slider.Progress.Position = UDim2.new(0, 4, 0, 4)
        Slider.Progress.Parent = Slider.Background
        
        createCorner(Slider.Progress, 5)
        createStroke(Slider.Progress, theme.Outline)
        
        -- Barra de progresso
        Slider.ProgressBar = Instance.new("Frame")
        Slider.ProgressBar.Name = "ProgressBar"
        Slider.ProgressBar.BorderSizePixel = 0
        Slider.ProgressBar.BackgroundColor3 = theme.SliderProgress
        Slider.ProgressBar.Size = UDim2.new(0, 10, 0, isMobileScreen and 24 or 18)
        Slider.ProgressBar.Parent = Slider.Progress
        
        createCorner(Slider.ProgressBar, 5)
        
        -- Labels
        if not Slider.Compact then
            Slider.NameLabel = Instance.new("TextLabel")
            Slider.NameLabel.TextWrapped = true
            Slider.NameLabel.BorderSizePixel = 0
            Slider.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            Slider.NameLabel.TextScaled = false
            Slider.NameLabel.TextSize = isMobileScreen and 16 or 14
            Slider.NameLabel.BackgroundTransparency = 1
            Slider.NameLabel.Font = Enum.Font.SourceSans
            Slider.NameLabel.TextColor3 = theme.Text
            Slider.NameLabel.Size = UDim2.new(1, -12, 0, isMobileScreen and 18 or 14)
            Slider.NameLabel.Text = Slider.Text
            Slider.NameLabel.Position = UDim2.new(0, 6, 0, isMobileScreen and 6 or 4)
            Slider.NameLabel.Parent = Slider.Frame
            
            Slider.ValueLabel = Instance.new("TextLabel")
            Slider.ValueLabel.TextWrapped = true
            Slider.ValueLabel.BorderSizePixel = 0
            Slider.ValueLabel.TextScaled = false
            Slider.ValueLabel.TextSize = isMobileScreen and 14 or 12
            Slider.ValueLabel.BackgroundTransparency = 1
            Slider.ValueLabel.Font = Enum.Font.SourceSans
            Slider.ValueLabel.TextColor3 = theme.DarkText
            Slider.ValueLabel.Size = UDim2.new(1, -12, 0, isMobileScreen and 16 or 14)
            Slider.ValueLabel.Position = UDim2.new(0, 6, 0, isMobileScreen and 42 or 36)
            Slider.ValueLabel.Parent = Slider.Frame
        else
            Slider.CompactLabel = Instance.new("TextLabel")
            Slider.CompactLabel.TextWrapped = true
            Slider.CompactLabel.BorderSizePixel = 0
            Slider.CompactLabel.TextScaled = false
            Slider.CompactLabel.TextSize = isMobileScreen and 16 or 14
            Slider.CompactLabel.BackgroundTransparency = 1
            Slider.CompactLabel.Font = Enum.Font.SourceSans
            Slider.CompactLabel.TextColor3 = theme.Text
            Slider.CompactLabel.Size = UDim2.new(1, -12, 0, isMobileScreen and 16 or 14)
            Slider.CompactLabel.Position = UDim2.new(0, 6, 0, isMobileScreen and 42 or 38)
            Slider.CompactLabel.Parent = Slider.Frame
        end
        
        -- Função de atualizar slider
        local function updateSlider(value)
            Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
            
            local ratio = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Slider.ProgressBar.Size = UDim2.new(ratio, 0, 0, isMobileScreen and 24 or 18)
            
            local valueText = tostring(Slider.Value) .. Slider.Suffix
            if not Slider.HideMax then
                valueText = valueText .. " / " .. Slider.Max .. Slider.Suffix
            end
            
            if Slider.Compact then
                Slider.CompactLabel.Text = Slider.Text .. ": " .. valueText
            else
                if Slider.ValueLabel then
                    Slider.ValueLabel.Text = valueText
                end
            end
            
            pcall(Slider.Callback, Slider.Value)
        end
        
        -- Interação do slider (CORRIGIDA)
        local dragging = false
        
        local function getPercent(input)
            local barPos = Slider.Progress.AbsolutePosition.X
            local barSize = Slider.Progress.AbsoluteSize.X
            local inputX
            
            if input.UserInputType == Enum.UserInputType.Touch then
                inputX = input.Position.X
            else
                inputX = input.Position.X
            end
            
            return math.clamp((inputX - barPos) / barSize, 0, 1)
        end
        
        Slider.Background.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateSlider(math.floor(Slider.Min + (Slider.Max - Slider.Min) * getPercent(input)))
            end
        end)
        
        Slider.Background.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        -- Para input do mouse em movimento
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local barPos = Slider.Progress.AbsolutePosition.X
                local barSize = Slider.Progress.AbsoluteSize.X
                local inputX
                
                if input.UserInputType == Enum.UserInputType.Touch then
                    inputX = input.Position.X
                else
                    inputX = UserInputService:GetMouseLocation().X
                end
                
                local percent = math.clamp((inputX - barPos) / barSize, 0, 1)
                updateSlider(math.floor(Slider.Min + (Slider.Max - Slider.Min) * percent))
            end
        end)
        
        -- Inicializar
        updateSlider(Slider.Value)
        
        Tab.Elements[id] = Slider
        return Slider
    end
    
    self.Tabs[name] = Tab
    
    -- Selecionar primeira aba automaticamente
    if not self.CurrentTab then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function Window:SelectTab(tab)
    -- Esconder todas as abas
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        t.ButtonStroke.Transparency = 0.5
        t.Button.BackgroundColor3 = theme.InnerBackground
    end
    
    -- Mostrar aba selecionada
    tab.Content.Visible = true
    tab.ButtonStroke.Transparency = 0
    tab.Button.BackgroundColor3 = theme.Accent
    
    self.CurrentTab = tab
end

-- ========== FUNÇÕES DA BIBLIOTECA ==========
function Library:CreateWindow(config)
    local window = Window:new(config)
    Windows[#Windows + 1] = window
    return window
end

-- Retornar a biblioteca
return function()
    return Library
end
