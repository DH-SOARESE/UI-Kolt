-- UI Library for Roblox
-- Kolt UI Library 1.1

local Library = {}
local Windows = {}
local DPI_SCALE = 1.0 -- Novo: Variável de escala de DPI global

-- Services
local function gethui()
    return game:GetService("CoreGui") -- Replace with actual gethui() 
end

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Detect if device is mobile
-- Variável 'isMobile' já está definida, mas a API exige que ela seja acessível pela Library
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Screen size detection for responsive design
local screenSize = workspace.CurrentCamera.ViewportSize
local isMobileScreen = screenSize.X < 768 or isMobile

-- Define theme colors
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

-- Utility Functions
-- Função para aplicar a escala DPI ao UDim
local function applyDPIScale(value)
    if value.Scale > 0 then
        return UDim.new(value.Scale * DPI_SCALE, value.Offset)
    else
        return UDim.new(value.Scale, math.floor(value.Offset * DPI_SCALE))
    end
end

-- Função para aplicar a escala DPI ao UDim2
local function applyDPIScale2(udim2)
    return UDim2.new(
        applyDPIScale(udim2.X),
        applyDPIScale(udim2.Y)
    )
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    -- Aplica DPI à CornerRadius
    corner.CornerRadius = applyDPIScale(UDim.new(0, radius or 6))
    corner.Parent = parent
    return corner
end

local function createStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or theme.Outline
    -- Aplica DPI à espessura
    stroke.Thickness = math.floor((thickness or 1) * DPI_SCALE)
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function createPadding(parent, left, right, top, bottom)
    local padding = Instance.new("UIPadding")
    -- Aplica DPI ao Padding
    padding.PaddingLeft = applyDPIScale(UDim.new(0, left or 0))
    padding.PaddingRight = applyDPIScale(UDim.new(0, right or 0))
    padding.PaddingTop = applyDPIScale(UDim.new(0, top or 0))
    padding.PaddingBottom = applyDPIScale(UDim.new(0, bottom or 0))
    padding.Parent = parent
    return padding
end

local function createListLayout(parent, direction, padding, sortOrder)
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = direction or Enum.FillDirection.Vertical
    -- Aplica DPI ao Padding
    layout.Padding = applyDPIScale(UDim.new(0, padding or 4))
    layout.SortOrder = sortOrder or Enum.SortOrder.LayoutOrder
    layout.Parent = parent
    return layout
end

-- Window Class
local Window = {}
Window.__index = Window

function Window:new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Window"
    self.Center = config.Center ~= false
    self.MenuFadeTime = config.MenuFadeTime or 0.2
    self.Tabs = {}
    self.CurrentTab = nil
    self.isLocked = false
    
    self:CreateWindow()
    return self
end

function Window:CreateWindow()
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "UILibrary_" .. self.Title
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.DisplayOrder = 100
    self.ScreenGui.Parent = gethui()
    
    -- Calculate menu size based on screen size (Com DPI)
    local menuSize, menuPosition
    if isMobileScreen then
        menuSize = UDim2.new(0.9, 0, 0.85, 0)
        menuPosition = UDim2.new(0.05, 0, 0.075, 0)
    else
        -- Aplica DPI aos offsets
        menuSize = applyDPIScale2(UDim2.new(0, 536, 0, 296))
        menuPosition = self.Center and applyDPIScale2(UDim2.new(0.5, -268, 0.5, -148)) or applyDPIScale2(UDim2.new(0, 100, 0, 100))
    end
    
    -- Main Menu Frame
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
    
    -- Drag functionality
    self:SetupDrag()
    
    -- Title
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.TextWrapped = true
    self.TitleLabel.BorderSizePixel = 0
    -- Aplica DPI ao TextSize
    self.TitleLabel.TextSize = math.floor(15 * DPI_SCALE)
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.TextScaled = false -- Alterado para 'false' para usar TextSize com DPI
    self.TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.Font = Enum.Font.SourceSansBold
    self.TitleLabel.TextColor3 = theme.Text
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.Parent = self.MainFrame
    
    if isMobileScreen then
        self.TitleLabel.Size = applyDPIScale2(UDim2.new(1, -12, 0, 26))
        self.TitleLabel.Position = applyDPIScale2(UDim2.new(0, 6, 0, 2))
    else
        self.TitleLabel.Size = applyDPIScale2(UDim2.new(0, 520, 0, 22))
        self.TitleLabel.Position = applyDPIScale2(UDim2.new(0, 6, 0, 2))
    end
    
    -- Inner Background
    self.InnerBackground = Instance.new("Frame")
    self.InnerBackground.Name = "InnerBackground"
    self.InnerBackground.BorderSizePixel = 0
    self.InnerBackground.BackgroundColor3 = theme.InnerBackground
    self.InnerBackground.Parent = self.MainFrame
    
    if isMobileScreen then
        self.InnerBackground.Size = applyDPIScale2(UDim2.new(1, -8, 1, -36))
        self.InnerBackground.Position = applyDPIScale2(UDim2.new(0, 4, 0, 32))
    else
        self.InnerBackground.Size = applyDPIScale2(UDim2.new(0, 528, 0, 264))
        self.InnerBackground.Position = applyDPIScale2(UDim2.new(0, 4, 0, 28))
    end
    
    createCorner(self.InnerBackground, 4)
    createStroke(self.InnerBackground, theme.Outline)
    
    -- Tabs Frame (Sidebar)
    self.TabsFrame = Instance.new("Frame")
    self.TabsFrame.BorderSizePixel = 0
    self.TabsFrame.BackgroundColor3 = theme.Background
    self.TabsFrame.Parent = self.InnerBackground
    
    if isMobileScreen then
        self.TabsFrame.Size = applyDPIScale2(UDim2.new(0, 148, 1, -4))
        self.TabsFrame.Position = applyDPIScale2(UDim2.new(0, 2, 0, 2))
    else
        self.TabsFrame.Size = applyDPIScale2(UDim2.new(0, 148, 0, 260))
        self.TabsFrame.Position = applyDPIScale2(UDim2.new(0, 2, 0, 2))
    end
    
    createCorner(self.TabsFrame, 6)
    createStroke(self.TabsFrame, theme.Outline)
    
    -- Tabs Scroll
    self.TabsScroll = Instance.new("ScrollingFrame")
    self.TabsScroll.Name = "TabsScroll"
    self.TabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    self.TabsScroll.BorderSizePixel = 0
    self.TabsScroll.BackgroundTransparency = 1
    self.TabsScroll.ScrollBarImageTransparency = 1
    self.TabsScroll.Size = applyDPIScale2(UDim2.new(1, -8, 1, -8))
    self.TabsScroll.Position = applyDPIScale2(UDim2.new(0, 4, 0, 4))
    -- Aplica DPI ao ScrollBarThickness
    self.TabsScroll.ScrollBarThickness = math.floor(4 * DPI_SCALE)
    self.TabsScroll.ScrollBarImageColor3 = theme.Accent
    self.TabsScroll.Parent = self.TabsFrame
    
    createCorner(self.TabsScroll, 4)
    createPadding(self.TabsScroll, 4, 4, 4, 4)
    
    self.TabsLayout = createListLayout(self.TabsScroll, Enum.FillDirection.Vertical, 4)
    
    -- Content Frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.BackgroundColor3 = theme.InnerBackground
    self.ContentFrame.Parent = self.InnerBackground
    
    if isMobileScreen then
        self.ContentFrame.Size = applyDPIScale2(UDim2.new(1, -160, 1, -4))
        self.ContentFrame.Position = applyDPIScale2(UDim2.new(0, 156, 0, 2))
    else
        self.ContentFrame.Size = applyDPIScale2(UDim2.new(0, 376, 0, 260))
        self.ContentFrame.Position = applyDPIScale2(UDim2.new(0, 150, 0, 2))
    end
    
    createCorner(self.ContentFrame, 4)
    createStroke(self.ContentFrame, theme.Outline)
    
    -- Update canvas size
    self.TabsLayout.Changed:Connect(function()
        -- Aplica DPI à constante 8
        self.TabsScroll.CanvasSize = UDim2.new(0, 0, 0, self.TabsLayout.AbsoluteContentSize.Y + math.floor(8 * DPI_SCALE))
    end)
    
    -- Add mobile buttons or PC hotkey
    if isMobile then
        -- Lock/Unlock button
        self.LockButton = Instance.new("TextButton")
        self.LockButton.Name = "LockButton"
        self.LockButton.Text = self.isLocked and "Unlock" or "Lock"
        -- Aplica DPI
        self.LockButton.Size = applyDPIScale2(UDim2.new(0, 80, 0, 30))
        self.LockButton.Position = applyDPIScale2(UDim2.new(0, 10, 0.5, 0))
        self.LockButton.BackgroundColor3 = theme.Background
        self.LockButton.TextColor3 = theme.Text
        self.LockButton.Font = Enum.Font.SourceSansBold
        -- Aplica DPI
        self.LockButton.TextSize = math.floor(14 * DPI_SCALE)
        self.LockButton.Parent = self.ScreenGui
        self.LockButton.ZIndex = 99
        createCorner(self.LockButton, 4)
        createStroke(self.LockButton, theme.Accent)
        
        self.LockButton.MouseButton1Click:Connect(function()
            self.isLocked = not self.isLocked
            self.LockButton.Text = self.isLocked and "Unlock" or "Lock"
        end)
        
        -- Toggle UI button
        self.ToggleUIButton = Instance.new("TextButton")
        self.ToggleUIButton.Name = "ToggleUIButton"
        self.ToggleUIButton.Text = "Toggle UI"
        -- Aplica DPI
        self.ToggleUIButton.Size = applyDPIScale2(UDim2.new(0, 80, 0, 30))
        self.ToggleUIButton.Position = applyDPIScale2(UDim2.new(0, 10, 0.5, -40)) -- Ajustada a posição para não sobrepor o LockButton
        self.ToggleUIButton.BackgroundColor3 = theme.Background
        self.ToggleUIButton.TextColor3 = theme.Text
        self.ToggleUIButton.Font = Enum.Font.SourceSansBold
        -- Aplica DPI
        self.ToggleUIButton.TextSize = math.floor(14 * DPI_SCALE)
        self.ToggleUIButton.Parent = self.ScreenGui
        createCorner(self.ToggleUIButton, 4)
        createStroke(self.ToggleUIButton, theme.Accent)
        self.ToggleUIButton.ZIndex = 99
        
        self.ToggleUIButton.MouseButton1Click:Connect(function()
            self.MainFrame.Visible = not self.MainFrame.Visible
        end)
    else
        -- PC F3 toggle
        UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.F3 then
                self.MainFrame.Visible = not self.MainFrame.Visible
            end
        end)
    end
end

function Window:SetupDrag()
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        if not isDragging or self.isLocked then return end
        
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    self.MainFrame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not self.isLocked then
            isDragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
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
    
    -- Create tab button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Name = name
    Tab.Button.TextWrapped = true
    Tab.Button.BorderSizePixel = 0
    -- Aplica DPI
    Tab.Button.TextSize = math.floor(16 * DPI_SCALE)
    Tab.Button.AutoButtonColor = false
    Tab.Button.TextScaled = false -- Alterado para 'false'
    Tab.Button.TextColor3 = theme.Text
    Tab.Button.BackgroundColor3 = theme.InnerBackground
    Tab.Button.Font = Enum.Font.SourceSansSemibold
    -- Aplica DPI
    Tab.Button.Size = applyDPIScale2(UDim2.new(1, 0, 0, 25))
    Tab.Button.Text = name
    Tab.Button.Parent = self.TabsScroll
    
    createCorner(Tab.Button, 4)
    Tab.ButtonStroke = createStroke(Tab.Button, theme.Accent)
    Tab.ButtonStroke.Transparency = 0.5
    
    -- Create tab content
    Tab.Content = Instance.new("ScrollingFrame")
    Tab.Content.Name = name .. "_Content"
    Tab.Content.ScrollingDirection = Enum.ScrollingDirection.Y
    Tab.Content.BorderSizePixel = 0
    Tab.Content.BackgroundTransparency = 1
    Tab.Content.ScrollBarImageTransparency = 1
    -- Aplica DPI
    Tab.Content.Size = applyDPIScale2(UDim2.new(1, -16, 1, -8))
    Tab.Content.Position = applyDPIScale2(UDim2.new(0, 8, 0, 4))
    -- Aplica DPI
    Tab.Content.ScrollBarThickness = math.floor(4 * DPI_SCALE)
    Tab.Content.ScrollBarImageColor3 = theme.Accent
    Tab.Content.Visible = false
    Tab.Content.Parent = self.ContentFrame
    
    createCorner(Tab.Content, 4)
    createPadding(Tab.Content, 8, 8, 8, 8)
    
    Tab.ContentLayout = createListLayout(Tab.Content, Enum.FillDirection.Vertical, 8)
    
    -- Update canvas size
    Tab.ContentLayout.Changed:Connect(function()
        -- Aplica DPI à constante 16
        Tab.Content.CanvasSize = UDim2.new(0, 0, 0, Tab.ContentLayout.AbsoluteContentSize.Y + math.floor(16 * DPI_SCALE))
    end)
    
    -- Tab selection
    Tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(Tab)
    end)
    
    -- AddToggle
    function Tab:AddToggle(id, config)
        local Toggle = {}
        Toggle.ID = id
        Toggle.Text = config.Text or "Toggle"
        Toggle.Default = config.Default or false
        Toggle.Disabled = config.Disabled or false
        Toggle.Callback = config.Callback or function() end
        Toggle.State = Toggle.Default
        
        -- Create toggle frame
        Toggle.Frame = Instance.new("Frame")
        Toggle.Frame.Name = id
        Toggle.Frame.BorderSizePixel = 0
        Toggle.Frame.BackgroundTransparency = 1
        -- Aplica DPI
        Toggle.Frame.Size = applyDPIScale2(UDim2.new(1, 0, 0, 34))
        Toggle.Frame.Parent = Tab.Content
        
        -- Toggle button
        Toggle.Button = Instance.new("TextButton")
        Toggle.Button.BorderSizePixel = 0
        Toggle.Button.AutoButtonColor = false
        Toggle.Button.BackgroundColor3 = theme.Outline
        -- Aplica DPI
        Toggle.Button.Size = applyDPIScale2(UDim2.new(0, 22, 0, 22))
        Toggle.Button.Position = applyDPIScale2(UDim2.new(0, 0, 0, 6))
        Toggle.Button.Text = ""
        Toggle.Button.Parent = Toggle.Frame
        
        createCorner(Toggle.Button, 5)
        createStroke(Toggle.Button, theme.Accent)
        
        -- Toggle indicator
        Toggle.Indicator = Instance.new("Frame")
        Toggle.Indicator.Name = "Indicator"
        Toggle.Indicator.Visible = Toggle.State
        Toggle.Indicator.BorderSizePixel = 0
        Toggle.Indicator.BackgroundColor3 = theme.ToggleOn
        -- Aplica DPI
        Toggle.Indicator.Size = applyDPIScale2(UDim2.new(0, 14, 0, 14))
        Toggle.Indicator.Position = applyDPIScale2(UDim2.new(0, 4, 0, 4))
        Toggle.Indicator.Parent = Toggle.Button
        
        createCorner(Toggle.Indicator, 3)
        
        -- Toggle text
        Toggle.Label = Instance.new("TextLabel")
        Toggle.Label.Name = "Label"
        Toggle.Label.TextWrapped = true
        Toggle.Label.BorderSizePixel = 0
        Toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
        Toggle.Label.TextScaled = true
        Toggle.Label.BackgroundTransparency = 1
        Toggle.Label.Font = Enum.Font.SourceSans
        Toggle.Label.TextColor3 = theme.Text
        -- Aplica DPI
        Toggle.Label.Size = applyDPIScale2(UDim2.new(1, -34, 0, 18))
        Toggle.Label.Text = Toggle.Text
        Toggle.Label.Position = applyDPIScale2(UDim2.new(0, 28, 0, 8))
        Toggle.Label.Parent = Toggle.Frame
        
        -- Toggle functionality
        local function setToggle(state)
            Toggle.State = state
            Toggle.Indicator.Visible = Toggle.State
            Toggle.Callback(Toggle.State)
        end
        
        Toggle.Button.MouseButton1Click:Connect(function()
            if not Toggle.Disabled then
                setToggle(not Toggle.State)
            end
        end)
        
        -- Set initial state
        setToggle(Toggle.State)
        
        Tab.Elements[id] = Toggle
        return Toggle
    end
    
    -- AddSlider
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

    -- Frame base
    Slider.Frame = Instance.new("Frame")
    Slider.Frame.Name = id
    Slider.Frame.BorderSizePixel = 0
    Slider.Frame.BackgroundTransparency = 1
    -- Aplica DPI
    Slider.Frame.Size = applyDPIScale2(UDim2.new(1, 0, 0, Slider.Compact and 34 or 52))
    Slider.Frame.Parent = Tab.Content

    -- Fundo
    Slider.Background = Instance.new("Frame")
    Slider.Background.BorderSizePixel = 0
    Slider.Background.BackgroundColor3 = theme.Outline
    -- Aplica DPI
    Slider.Background.Size = applyDPIScale2(UDim2.new(1, -12, 0, 26))
    Slider.Background.Position = applyDPIScale2(UDim2.new(0, 6, 0, Slider.Compact and 4 or 22))
    Slider.Background.Parent = Slider.Frame

    createCorner(Slider.Background, 5)
    createStroke(Slider.Background, theme.Accent)

    -- Barra de progresso
    Slider.Progress = Instance.new("Frame")
    Slider.Progress.Name = "Progress"
    Slider.Progress.BorderSizePixel = 0
    Slider.Progress.BackgroundColor3 = theme.InnerBackground
    -- Aplica DPI
    Slider.Progress.Size = applyDPIScale2(UDim2.new(1, -8, 0, 18))
    Slider.Progress.Position = applyDPIScale2(UDim2.new(0, 4, 0, 4))
    Slider.Progress.Parent = Slider.Background

    createCorner(Slider.Progress, 5)
    createStroke(Slider.Progress, theme.Outline)

    -- Parte preenchida
    Slider.ProgressBar = Instance.new("Frame")
    Slider.ProgressBar.Name = "ProgressBar"
    Slider.ProgressBar.BorderSizePixel = 0
    Slider.ProgressBar.BackgroundColor3 = theme.SliderProgress
    -- Aplica DPI
    Slider.ProgressBar.Size = applyDPIScale2(UDim2.new(0, 10, 0, 18))
    Slider.ProgressBar.Parent = Slider.Progress

    createCorner(Slider.ProgressBar, 5)

    -- Label de título (modo normal)
    Slider.NameLabel = Instance.new("TextLabel")
    Slider.NameLabel.TextWrapped = true
    Slider.NameLabel.BorderSizePixel = 0
    Slider.NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    Slider.NameLabel.TextScaled = true
    Slider.NameLabel.BackgroundTransparency = 1
    Slider.NameLabel.Font = Enum.Font.SourceSans
    Slider.NameLabel.TextColor3 = theme.Text
    -- Aplica DPI
    Slider.NameLabel.Size = applyDPIScale2(UDim2.new(1, -12, 0, 14))
    Slider.NameLabel.Text = Slider.Text
    Slider.NameLabel.Position = applyDPIScale2(UDim2.new(0, 6, 0, 4))
    Slider.NameLabel.Visible = not Slider.Compact
    Slider.NameLabel.Parent = Slider.Frame

    -- Valor centralizado (modo normal)
    Slider.CenterLabel = Instance.new("TextLabel")
    Slider.CenterLabel.TextWrapped = true
    Slider.CenterLabel.BorderSizePixel = 0
    Slider.CenterLabel.TextScaled = true
    Slider.CenterLabel.BackgroundTransparency = 1
    Slider.CenterLabel.Font = Enum.Font.SourceSansBold
    Slider.CenterLabel.TextColor3 = theme.DarkText
    Slider.CenterLabel.Size = UDim2.new(1, 0, 1, 0)
    Slider.CenterLabel.Position = UDim2.new(0, 0, 0, 0)
    Slider.CenterLabel.Visible = not Slider.Compact
    Slider.CenterLabel.Parent = Slider.Progress

    -- Label compacta (Nome + Valor juntos)
    Slider.DisplayLabel = Instance.new("TextLabel")
    Slider.DisplayLabel.TextWrapped = true
    Slider.DisplayLabel.BorderSizePixel = 0
    Slider.DisplayLabel.TextXAlignment = Enum.TextXAlignment.Center
    Slider.DisplayLabel.BackgroundTransparency = 1
    Slider.DisplayLabel.Font = Enum.Font.SourceSansBold
    Slider.DisplayLabel.TextColor3 = theme.Text
    -- Aplica DPI
    Slider.DisplayLabel.Size = applyDPIScale2(UDim2.new(1, -12, 0, 20))
    Slider.DisplayLabel.Position = applyDPIScale2(UDim2.new(0, 6, 0, 6))
    Slider.DisplayLabel.Visible = Slider.Compact
    Slider.DisplayLabel.Parent = Slider.Frame

    -- Função de atualização
    local function updateSlider(value)
        Slider.Value = math.clamp(value, Slider.Min, Slider.Max)
        local ratio = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
        -- Aplica DPI
        Slider.ProgressBar.Size = applyDPIScale2(UDim2.new(ratio, 0, 0, 18))

        local valueText = tostring(Slider.Value) .. Slider.Suffix
        if not Slider.HideMax then
            valueText = valueText .. " / " .. Slider.Max .. Slider.Suffix
        end

        if Slider.Compact then
            -- Formato compacto: "Nome: Valor"
            Slider.DisplayLabel.Text = string.format("%s: %s", Slider.Text, valueText)
        else
            -- Formato normal
            Slider.CenterLabel.Text = valueText
        end

        Slider.Callback(Slider.Value)
    end

    -- Interação
    local dragging = false
    local function getPercent(x)
        local barPos = Slider.Progress.AbsolutePosition.X
        local barSize = Slider.Progress.AbsoluteSize.X
        return math.clamp((x - barPos) / barSize, 0, 1)
    end

    Slider.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local pos = UserInputService:GetMouseLocation()
            updateSlider(math.floor(Slider.Min + (Slider.Max - Slider.Min) * getPercent(pos.X)))
        end
    end)

    Slider.Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = UserInputService:GetMouseLocation()
            updateSlider(math.floor(Slider.Min + (Slider.Max - Slider.Min) * getPercent(pos.X)))
        end
    end)

    -- Inicialização
    updateSlider(Slider.Value)

    Tab.Elements[id] = Slider
    return Slider
end

    -- AddLabel
    function Tab:AddLabel(id, config)
        local Label = {}
        Label.ID = id
        Label.Text = config.Text or "Label"
        -- Aplica DPI
        Label.Size = applyDPIScale2(config.Size or UDim2.new(1, 0, 0, 22))

        Label.Frame = Instance.new("Frame")
        Label.Frame.Name = id
        Label.Frame.BackgroundTransparency = 1
        Label.Frame.Size = Label.Size
        Label.Frame.Parent = Tab.Content

        Label.Label = Instance.new("TextLabel")
        Label.Label.Text = Label.Text
        Label.Label.TextWrapped = true
        Label.Label.BorderSizePixel = 0
        Label.Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Label.TextScaled = true
        Label.Label.BackgroundTransparency = 1
        Label.Label.Font = Enum.Font.SourceSansBold
        Label.Label.TextColor3 = theme.Text
        Label.Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Label.Parent = Label.Frame

        Tab.Elements[id] = Label
        return Label
    end

    -- AddDivider
    function Tab:AddDivider(id, config)
        local Divider = {}
        Divider.ID = id
        -- Aplica DPI
        Divider.Size = applyDPIScale2(config.Size or UDim2.new(1, 0, 0, 6))

        Divider.Frame = Instance.new("Frame")
        Divider.Frame.Name = id
        Divider.Frame.BackgroundColor3 = theme.Outline
        Divider.Frame.Size = Divider.Size
        Divider.Frame.BorderSizePixel = 0
        Divider.Frame.Parent = Tab.Content

        createCorner(Divider.Frame, 3)

        Tab.Elements[id] = Divider
        return Divider
    end

    -- AddButton
    function Tab:AddButton(id, config)
        local Button = {}
        Button.ID = id
        Button.Text = config.Text or "Button"
        Button.Callback = config.Callback or function() end
        -- Aplica DPI
        Button.Size = applyDPIScale2(config.Size or UDim2.new(1, 0, 0, 32))

        Button.Frame = Instance.new("Frame")
        Button.Frame.Name = id
        Button.Frame.BackgroundTransparency = 1
        Button.Frame.Size = Button.Size
        Button.Frame.Parent = Tab.Content

        Button.Button = Instance.new("TextButton")
        Button.Button.Name = id .. "_Button"
        Button.Button.Text = Button.Text
        Button.Button.Size = UDim2.new(1, 0, 1, 0)
        Button.Button.BackgroundColor3 = theme.Accent
        Button.Button.TextColor3 = theme.Text
        Button.Button.Font = Enum.Font.SourceSansBold
        Button.Button.TextScaled = true
        Button.Button.BorderSizePixel = 0
        Button.Button.Parent = Button.Frame

        createCorner(Button.Button, 5)
        createStroke(Button.Button, theme.Outline, 1)

        Button.Button.MouseButton1Click:Connect(function()
            Button.Callback()
        end)

        Tab.Elements[id] = Button
        return Button
    end

    -- AddDropdown
    function Tab:AddDropdown(id, config)
        local Dropdown = {}
        Dropdown.ID = id
        Dropdown.Text = config.Text or "Dropdown"
        Dropdown.Value = config.Value or {}
        Dropdown.Default = config.Default or {}
        Dropdown.Mult = config.Mult or false
        Dropdown.Callback = config.Callback or function() end
        -- Aplica DPI
        Dropdown.Size = applyDPIScale2(config.Size or UDim2.new(1, 0, 0, 38))

        Dropdown.Frame = Instance.new("Frame")
        Dropdown.Frame.Name = id
        Dropdown.Frame.BackgroundTransparency = 1
        Dropdown.Frame.Size = Dropdown.Size
        Dropdown.Frame.Parent = Tab.Content

        Dropdown.Label = Instance.new("TextLabel")
        Dropdown.Label.Name = id .. "_Label"
        Dropdown.Label.Text = Dropdown.Text
        Dropdown.Label.TextWrapped = true
        Dropdown.Label.BorderSizePixel = 0
        Dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
        Dropdown.Label.TextScaled = true
        Dropdown.Label.BackgroundTransparency = 1
        Dropdown.Label.Font = Enum.Font.SourceSansSemibold
        Dropdown.Label.TextColor3 = theme.Text
        -- Aplica DPI
        Dropdown.Label.Size = applyDPIScale2(UDim2.new(1, -34, 0, 20))
        Dropdown.Label.Position = applyDPIScale2(UDim2.new(0, 0, 0, 0))
        Dropdown.Label.Parent = Dropdown.Frame

        Dropdown.Button = Instance.new("TextButton")
        Dropdown.Button.Name = id .. "_Button"
        Dropdown.Button.Text = "▼"
        -- Aplica DPI
        Dropdown.Button.Size = applyDPIScale2(UDim2.new(0, 32, 0, 20))
        Dropdown.Button.Position = applyDPIScale2(UDim2.new(1, -32, 0, 0))
        Dropdown.Button.BackgroundColor3 = theme.Accent
        Dropdown.Button.TextColor3 = theme.Text
        Dropdown.Button.Font = Enum.Font.SourceSansBold
        Dropdown.Button.TextScaled = true
        Dropdown.Button.BorderSizePixel = 0
        Dropdown.Button.Parent = Dropdown.Frame

        createCorner(Dropdown.Button, 5)
        createStroke(Dropdown.Button, theme.Outline, 1)

        -- Dropdown List Frame
        Dropdown.ListFrame = Instance.new("Frame")
        Dropdown.ListFrame.Name = id .. "_ListFrame"
        Dropdown.ListFrame.Visible = false
        Dropdown.ListFrame.BackgroundColor3 = theme.InnerBackground
        -- Aplica DPI
        Dropdown.ListFrame.Size = applyDPIScale2(UDim2.new(1, 0, 0, 100))
        Dropdown.ListFrame.Position = applyDPIScale2(UDim2.new(0, 0, 1, 2))
        Dropdown.ListFrame.BorderSizePixel = 0
        Dropdown.ListFrame.Parent = Dropdown.Frame

        createCorner(Dropdown.ListFrame, 5)
        createStroke(Dropdown.ListFrame, theme.Outline, 1)

        Dropdown.ListLayout = createListLayout(Dropdown.ListFrame, Enum.FillDirection.Vertical, 2)

        Dropdown.Selected = {}
        for _, v in ipairs(Dropdown.Default) do
            Dropdown.Selected[v] = true
        end

        local function updateDropdown()
            Dropdown.Label.Text = Dropdown.Text .. ": " .. (Dropdown.Mult and table.concat(Dropdown.GetSelected(), ", ") or Dropdown.GetSelected()[1] or "")
            Dropdown.Callback(Dropdown.GetSelected())
        end

        function Dropdown.GetSelected()
            local selected = {}
            for _, value in ipairs(Dropdown.Value) do
                if Dropdown.Selected[value] then
                    table.insert(selected, value)
                end
            end
            return selected
        end

        for _, value in ipairs(Dropdown.Value) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Name = "Option_" .. tostring(value)
            optionBtn.Text = tostring(value)
            -- Aplica DPI
            optionBtn.Size = applyDPIScale2(UDim2.new(1, 0, 0, 22))
            optionBtn.BackgroundColor3 = theme.Outline
            optionBtn.TextColor3 = theme.Text
            optionBtn.Font = Enum.Font.SourceSans
            optionBtn.TextScaled = true
            optionBtn.BorderSizePixel = 0
            optionBtn.Parent = Dropdown.ListFrame

            createCorner(optionBtn, 5)
            createStroke(optionBtn, theme.Accent, 1)

            optionBtn.MouseButton1Click:Connect(function()
                if Dropdown.Mult then
                    Dropdown.Selected[value] = not Dropdown.Selected[value]
                else
                    for _, v in ipairs(Dropdown.Value) do
                        Dropdown.Selected[v] = false
                    end
                    Dropdown.Selected[value] = true
                    Dropdown.ListFrame.Visible = false
                end
                updateDropdown()
            end)
        end

        Dropdown.Button.MouseButton1Click:Connect(function()
            Dropdown.ListFrame.Visible = not Dropdown.ListFrame.Visible
        end)

        updateDropdown()

        Tab.Elements[id] = Dropdown
        return Dropdown
    end

    self.Tabs[name] = Tab
    
    -- Select first tab automatically
    if not self.CurrentTab then
        self:SelectTab(Tab)
    end
    
    return Tab
end

function Window:SelectTab(tab)
    -- Hide all tabs
    for _, t in pairs(self.Tabs) do
        t.Content.Visible = false
        t.ButtonStroke.Transparency = 0.5
        t.Button.BackgroundColor3 = theme.InnerBackground
    end
    
    -- Show selected tab
    tab.Content.Visible = true
    tab.ButtonStroke.Transparency = 0
    tab.Button.BackgroundColor3 = theme.Accent
    
    self.CurrentTab = tab
end

--- NOVAS FUNÇÕES DA API ---

## Funções da Library

### Library:Unload()
Esta função limpa todos os elementos da interface criados pela biblioteca.

```lua
function Library:Unload()
    for _, window in ipairs(Windows) do
        if window.ScreenGui and window.ScreenGui.Parent then
            -- Destrói o ScreenGui, que leva consigo todos os elementos filhos
            window.ScreenGui:Destroy()
        end
        -- Remove os botões extra se existirem (ex: mobile)
        if isMobile and window.LockButton and window.LockButton.Parent then
            window.LockButton:Destroy()
        end
        if isMobile and window.ToggleUIButton and window.ToggleUIButton.Parent then
            window.ToggleUIButton:Destroy()
        end
    end
    -- Limpa a tabela de janelas para garantir que não haja referências perdidas
    Windows = {}
    
    -- Restaura a visibilidade do mouse padrão do Roblox
    if Players.LocalPlayer then
        Players.LocalPlayer.PlayerGui.MouseLockCursorEnabled = false
        UserInputService.MouseIconEnabled = true
    end

    print("Kolt UI Library Unloaded.")
end
