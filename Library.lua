return function()
    local Library = {}

    function Library:CreateWindow(titleText)
        local function gethui()
            return game:GetService("CoreGui") -- Fallback to CoreGui; in exploits, replace with actual gethui()
        end

        local CollectionService = game:GetService("CollectionService")
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")

        -- Detect if device is mobile
        local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

        -- Screen size detection for responsive design
        local screenSize = workspace.CurrentCamera.ViewportSize
        local isMobileScreen = screenSize.X < 768 or isMobile

        -- Create ScreenGui
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Title"
        screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        screenGui.IgnoreGuiInset = true
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 100
        screenGui.Parent = gethui()
        CollectionService:AddTag(screenGui, "main")

        -- Define theme colors inspired by LinoriaLib (dark theme with purple accents)
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

        -- Calculate menu size based on screen size
        local menuSize, menuPosition
        if isMobileScreen then
            -- Mobile: smaller menu, positioned for mobile use
            menuSize = UDim2.new(0.95, 0, 0.8, 0)
            menuPosition = UDim2.new(0.025, 0, 0.1, 0)
        else
            -- Desktop: original size
            menuSize = UDim2.new(0, 536, 0, 296)
            menuPosition = UDim2.new(0.5, -268, 0.5, -148)
        end

        -- UI Library Folder
        local uiLibrary = Instance.new("Folder")
        uiLibrary.Name = "UI Library"
        uiLibrary.Parent = screenGui

        -- Keybinds Folder
        local keybinds = Instance.new("Folder")
        keybinds.Name = "Keybinds"
        keybinds.Parent = uiLibrary

        -- Keybinds Background
        local keybindsBackground = Instance.new("Frame")
        keybindsBackground.Name = "Background"
        keybindsBackground.Visible = false
        keybindsBackground.ZIndex = 20
        keybindsBackground.BorderSizePixel = 0
        keybindsBackground.BackgroundColor3 = theme.Background
        keybindsBackground.Size = UDim2.new(0.2, 0, 0.3, 0)
        keybindsBackground.Position = UDim2.new(0, 6, 0, 78)
        keybindsBackground.Parent = keybinds

        local keybindsCorner = Instance.new("UICorner")
        keybindsCorner.CornerRadius = UDim.new(0, 6)
        keybindsCorner.Parent = keybindsBackground

        local keybindsStroke = Instance.new("UIStroke")
        keybindsStroke.Color = theme.Outline
        keybindsStroke.Parent = keybindsBackground

        local innerBackground = Instance.new("Frame")
        innerBackground.Name = "Background"
        innerBackground.BorderSizePixel = 0
        innerBackground.BackgroundColor3 = theme.InnerBackground
        innerBackground.Size = UDim2.new(1, -4, 1, -4)
        innerBackground.Position = UDim2.new(0, 2, 0, 2)
        innerBackground.Parent = keybindsBackground

        local innerCorner = Instance.new("UICorner")
        innerCorner.CornerRadius = UDim.new(0, 4)
        innerCorner.Parent = innerBackground

        local innerStroke = Instance.new("UIStroke")
        innerStroke.Color = theme.Accent
        innerStroke.Parent = innerBackground

        -- Menu Folder
        local menu = Instance.new("Folder")
        menu.Name = "Menu"
        menu.Parent = uiLibrary

        -- Menu Background
        local menuBackground = Instance.new("Frame")
        menuBackground.Name = "Background"
        menuBackground.Active = true
        menuBackground.ZIndex = 90
        menuBackground.BorderSizePixel = 0
        menuBackground.BackgroundColor3 = theme.Background
        menuBackground.Size = menuSize
        menuBackground.Position = menuPosition
        menuBackground.Parent = menu

        -- Variables for drag functionality
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        local isLocked = false

        -- Drag functionality
        local function updateInput(input)
            if not isDragging or isLocked then return end

            local delta = input.Position - dragStart
            menuBackground.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        menuBackground.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                isDragging = true
                dragStart = input.Position
                startPos = menuBackground.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        isDragging = false
                    end
                end)
            end
        end)

        menuBackground.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                updateInput(input)
            end
        end)

        local menuCorner = Instance.new("UICorner")
        menuCorner.CornerRadius = UDim.new(0, 6)
        menuCorner.Parent = menuBackground

        local menuInnerBackground = Instance.new("Frame")
        menuInnerBackground.Name = "Background"
        menuInnerBackground.BorderSizePixel = 0
        menuInnerBackground.BackgroundColor3 = theme.InnerBackground
        if isMobileScreen then
            menuInnerBackground.Size = UDim2.new(1, -8, 1, -36)
            menuInnerBackground.Position = UDim2.new(0, 4, 0, 32)
        else
            menuInnerBackground.Size = UDim2.new(0, 528, 0, 264)
            menuInnerBackground.Position = UDim2.new(0, 4, 0, 28)
        end
        menuInnerBackground.Parent = menuBackground

        local innerMenuCorner = Instance.new("UICorner")
        innerMenuCorner.CornerRadius = UDim.new(0, 4)
        innerMenuCorner.Parent = menuInnerBackground

        local innerMenuStroke = Instance.new("UIStroke")
        innerMenuStroke.Color = theme.Outline
        innerMenuStroke.Parent = menuInnerBackground

        local contentBackground = Instance.new("Frame")
        contentBackground.Name = "Background"
        contentBackground.BorderSizePixel = 0
        contentBackground.BackgroundColor3 = theme.InnerBackground
        if isMobileScreen then
            contentBackground.Size = UDim2.new(1, -160, 1, -4)
            contentBackground.Position = UDim2.new(0, 156, 0, 2)
        else
            contentBackground.Size = UDim2.new(0, 410, 0, 260)
            contentBackground.Position = UDim2.new(0, 116, 0, 2)
        end
        contentBackground.Parent = menuInnerBackground

        local contentCorner = Instance.new("UICorner")
        contentCorner.CornerRadius = UDim.new(0, 4)
        contentCorner.Parent = contentBackground

        local contentStroke = Instance.new("UIStroke")
        contentStroke.Color = theme.Outline
        contentStroke.Parent = contentBackground

        -- Menu UIStroke
        local menuStroke = Instance.new("UIStroke")
        menuStroke.Thickness = 1
        menuStroke.Color = theme.Outline
        menuStroke.Parent = menuBackground

        -- Menu Title
        local menuTitle = Instance.new("TextLabel")
        menuTitle.Name = "Title"
        menuTitle.TextWrapped = true
        menuTitle.BorderSizePixel = 0
        menuTitle.TextSize = 15
        menuTitle.TextXAlignment = Enum.TextXAlignment.Left
        menuTitle.TextScaled = true
        menuTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        menuTitle.Font = Enum.Font.SourceSansBold
        menuTitle.TextColor3 = theme.Text
        menuTitle.BackgroundTransparency = 1
        if isMobileScreen then
            menuTitle.Size = UDim2.new(1, -12, 0, 26)
            menuTitle.Position = UDim2.new(0, 6, 0, 2)
        else
            menuTitle.Size = UDim2.new(0, 520, 0, 22)
            menuTitle.Position = UDim2.new(0, 6, 0, 2)
        end
        menuTitle.Text = titleText or "Title"
        menuTitle.Parent = menuBackground

        -- Menu Frame (Tabs sidebar)
        local menuFrame = Instance.new("Frame")
        menuFrame.BorderSizePixel = 0
        menuFrame.BackgroundColor3 = theme.Background
        if isMobileScreen then
            menuFrame.Size = UDim2.new(0, 148, 1, -36)
            menuFrame.Position = UDim2.new(0, 6, 0, 34)
        else
            menuFrame.Size = UDim2.new(0, 148, 0, 260)
            menuFrame.Position = UDim2.new(0, 6, 0, 30)
        end
        menuFrame.Parent = menuBackground

        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = menuFrame

        local frameStroke = Instance.new("UIStroke")
        frameStroke.Color = theme.Outline
        frameStroke.Parent = menuFrame

        -- Tabs Folder
        local tabs = Instance.new("Folder")
        tabs.Name = "Tabs"
        tabs.Parent = menuFrame

        -- Tabs Scroll Frame with proper padding
        local tabsScroll = Instance.new("ScrollingFrame")
        tabsScroll.Name = "Scroll"
        tabsScroll.ScrollingDirection = Enum.ScrollingDirection.Y
        tabsScroll.BorderSizePixel = 0
        tabsScroll.CanvasPosition = Vector2.new(0, 0)
        tabsScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabsScroll.BackgroundTransparency = 1
        tabsScroll.ScrollBarImageTransparency = 1
        tabsScroll.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
        tabsScroll.Size = UDim2.new(1, -8, 1, -8)
        tabsScroll.Position = UDim2.new(0, 4, 0, 4)
        tabsScroll.ScrollBarThickness = 4
        tabsScroll.ScrollBarImageColor3 = theme.Accent
        tabsScroll.Parent = tabs

        local tabsScrollCorner = Instance.new("UICorner")
        tabsScrollCorner.CornerRadius = UDim.new(0, 4)
        tabsScrollCorner.Parent = tabsScroll

        local tabsLayout = Instance.new("UIListLayout")
        tabsLayout.FillDirection = Enum.FillDirection.Vertical
        tabsLayout.Padding = UDim.new(0, 4)
        tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabsLayout.Parent = tabsScroll

        -- Add padding to tabs scroll
        local tabsScrollPadding = Instance.new("UIPadding")
        tabsScrollPadding.PaddingLeft = UDim.new(0, 4)
        tabsScrollPadding.PaddingRight = UDim.new(0, 4)
        tabsScrollPadding.PaddingTop = UDim.new(0, 4)
        tabsScrollPadding.PaddingBottom = UDim.new(0, 4)
        tabsScrollPadding.Parent = tabsScroll

        -- Watermark Folder
        local watermarkT = Instance.new("Folder")
        watermarkT.Name = "WatermarkT"
        watermarkT.Parent = uiLibrary

        -- Watermark Frame
        local watermarkFrame = Instance.new("Frame")
        watermarkFrame.ZIndex = 91
        watermarkFrame.BorderSizePixel = 0
        watermarkFrame.BackgroundColor3 = theme.Background
        watermarkFrame.Size = UDim2.new(0, 90, 0, 26)
        watermarkFrame.Position = UDim2.new(1, -100, 0, 10) -- Top right position
        watermarkFrame.Parent = watermarkT

        local watermarkCorner = Instance.new("UICorner")
        watermarkCorner.CornerRadius = UDim.new(0, 6)
        watermarkCorner.Parent = watermarkFrame

        local watermarkText = Instance.new("TextLabel")
        watermarkText.Name = "WatermarkText"
        watermarkText.TextWrapped = true
        watermarkText.BorderSizePixel = 0
        watermarkText.TextXAlignment = Enum.TextXAlignment.Left
        watermarkText.TextScaled = true
        watermarkText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        watermarkText.Font = Enum.Font.SourceSans
        watermarkText.TextColor3 = theme.Text
        watermarkText.BackgroundTransparency = 1
        watermarkText.Size = UDim2.new(0, 80, 0, 22)
        watermarkText.Text = "Text..."
        watermarkText.Position = UDim2.new(0, 4, 0, 2)
        watermarkText.Parent = watermarkFrame

        local watermarkStroke = Instance.new("UIStroke")
        watermarkStroke.Thickness = 1
        watermarkStroke.Color = theme.Outline
        watermarkStroke.Parent = watermarkFrame

        -- Mobile Button Folder (only show on mobile)
        local mobileButton = Instance.new("Folder")
        mobileButton.Name = "Mobile_Button"
        mobileButton.Visible = isMobile or isMobileScreen -- Only visible on mobile devices
        mobileButton.Parent = uiLibrary

        -- Lock Button
        local lockButton = Instance.new("TextButton")
        lockButton.Name = "Lock"
        lockButton.TextTruncate = Enum.TextTruncate.AtEnd
        lockButton.BorderSizePixel = 0
        lockButton.TextSize = 15
        lockButton.AutoButtonColor = false
        lockButton.TextColor3 = theme.Text
        lockButton.BackgroundColor3 = theme.Background
        lockButton.Font = Enum.Font.SourceSans
        lockButton.ZIndex = 99
        lockButton.Size = UDim2.new(0, 84, 0, 30)
        lockButton.Text = "Unlock"
        lockButton.Position = UDim2.new(0, 4, 0, 40)
        lockButton.Parent = mobileButton

        local lockCorner = Instance.new("UICorner")
        lockCorner.CornerRadius = UDim.new(0, 6)
        lockCorner.Parent = lockButton

        local lockStroke = Instance.new("UIStroke")
        lockStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        lockStroke.Thickness = 1
        lockStroke.Color = theme.Accent
        lockStroke.Parent = lockButton

        -- Lock/Unlock functionality
        lockButton.MouseButton1Click:Connect(function()
            isLocked = not isLocked
            lockButton.Text = isLocked and "Lock" or "Unlock"
            lockButton.BackgroundColor3 = isLocked and theme.Accent or theme.Background
            lockButton.TextColor3 = isLocked and Color3.fromRGB(255, 255, 255) or theme.Text
        end)

        -- Toggle UI Button
        local toggleUI = Instance.new("TextButton")
        toggleUI.Name = "ToggleUI"
        toggleUI.TextWrapped = true
        toggleUI.TextTruncate = Enum.TextTruncate.AtEnd
        toggleUI.BorderSizePixel = 0
        toggleUI.TextSize = 15
        toggleUI.AutoButtonColor = false
        toggleUI.TextColor3 = theme.Text
        toggleUI.BackgroundColor3 = theme.Background
        toggleUI.Font = Enum.Font.SourceSans
        toggleUI.ZIndex = 99
        toggleUI.Size = UDim2.new(0, 88, 0, 32)
        toggleUI.Text = "Hide UI"
        toggleUI.Position = UDim2.new(0, 2, 0, 2)
        toggleUI.Parent = mobileButton

        local toggleUICorner = Instance.new("UICorner")
        toggleUICorner.CornerRadius = UDim.new(0, 6)
        toggleUICorner.Parent = toggleUI

        local toggleUIStroke = Instance.new("UIStroke")
        toggleUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        toggleUIStroke.Thickness = 1
        toggleUIStroke.Color = theme.Accent
        toggleUIStroke.Parent = toggleUI

        -- Toggle UI functionality
        local isUIVisible = true
        toggleUI.MouseButton1Click:Connect(function()
            isUIVisible = not isUIVisible
            menu.Visible = isUIVisible
            watermarkT.Visible = isUIVisible
            keybinds.Visible = isUIVisible and keybindsBackground.Visible
            toggleUI.Text = isUIVisible and "Hide UI" or "Show UI"
        end)

        -- Window object
        local Window = {}
        Window.Tabs = {}
        Window.CurrentTab = nil

        function Window:AddTab(tabName)
            local tab = {}

            -- Create scroll for this tab
            local scroll = Instance.new("ScrollingFrame")
            scroll.Name = "Scroll"
            scroll.ScrollingDirection = Enum.ScrollingDirection.Y
            scroll.BorderSizePixel = 0
            scroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            scroll.BackgroundTransparency = 1
            scroll.ScrollBarImageTransparency = 1
            scroll.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
            if isMobileScreen then
                scroll.Size = UDim2.new(1, -16, 1, -8)
                scroll.Position = UDim2.new(0, 8, 0, 4)
            else
                scroll.Size = UDim2.new(1, -40, 1, -8)
                scroll.Position = UDim2.new(0, 20, 0, 4)
            end
            scroll.ScrollBarThickness = 4
            scroll.ScrollBarImageColor3 = theme.Accent
            scroll.Parent = contentBackground
            scroll.Visible = false

            local scrollCorner = Instance.new("UICorner")
            scrollCorner.CornerRadius = UDim.new(0, 4)
            scrollCorner.Parent = scroll

            local scrollLayout = Instance.new("UIListLayout")
            scrollLayout.FillDirection = Enum.FillDirection.Vertical
            scrollLayout.Padding = UDim.new(0, 8)
            scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
            scrollLayout.Parent = scroll

            -- Add padding to scroll content
            local scrollPadding = Instance.new("UIPadding")
            scrollPadding.PaddingLeft = UDim.new(0, 8)
            scrollPadding.PaddingRight = UDim.new(0, 8)
            scrollPadding.PaddingTop = UDim.new(0, 8)
            scrollPadding.PaddingBottom = UDim.new(0, 8)
            scrollPadding.Parent = scroll

            -- Update canvas size
            scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scroll.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 16)
            end)

            -- Tab Button
            local tabButton = Instance.new("TextButton")
            tabButton.Name = "Tab_Button"
            tabButton.TextWrapped = true
            tabButton.LineHeight = 1.2
            tabButton.TextTruncate = Enum.TextTruncate.SplitWord
            tabButton.BorderSizePixel = 0
            tabButton.TextSize = 16
            tabButton.AutoButtonColor = false
            tabButton.TextScaled = true
            tabButton.TextColor3 = theme.Text
            tabButton.BackgroundColor3 = theme.InnerBackground
            tabButton.Font = Enum.Font.SourceSansSemibold
            tabButton.Size = UDim2.new(1, 0, 0, 25)
            tabButton.Text = tabName
            tabButton.Parent = tabsScroll

            local tabButtonCorner = Instance.new("UICorner")
            tabButtonCorner.CornerRadius = UDim.new(0, 4)
            tabButtonCorner.Parent = tabButton

            local tabButtonStroke = Instance.new("UIStroke")
            tabButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            tabButtonStroke.Color = theme.Accent
            tabButtonStroke.Transparency = 0.5 -- Slight transparency for unselected
            tabButtonStroke.Parent = tabButton

            -- Tab switch event
            tabButton.MouseButton1Click:Connect(function()
                if Window.CurrentTab then
                    Window.CurrentTab.Scroll.Visible = false
                end
                scroll.Visible = true
                Window.CurrentTab = tab
                -- Update stroke for selected
                for _, btn in ipairs(tabsScroll:GetChildren()) do
                    if btn:IsA("TextButton") then
                        btn:FindFirstChildOfClass("UIStroke").Transparency = 0.5
                    end
                end
                tabButtonStroke.Transparency = 0
            end)

            tab.Scroll = scroll

            -- AddToggle function
            function tab:AddToggle(key, options)
                options = options or {}
                local text = options.Text or "Toggle"
                local default = options.Default or false
                local disabled = options.Disabled or false
                local callback = options.Callback or function() end

                local toggleContainer = Instance.new("Frame")
                toggleContainer.Name = "Toggle_" .. key
                toggleContainer.BackgroundTransparency = 1
                toggleContainer.Size = UDim2.new(1, 0, 0, 30)
                toggleContainer.Parent = scroll

                -- Toggle Button
                local toggleButton = Instance.new("TextButton")
                toggleButton.BorderSizePixel = 0
                toggleButton.AutoButtonColor = false
                toggleButton.BackgroundColor3 = theme.Outline
                toggleButton.Size = UDim2.new(0, 22, 0, 22)
                toggleButton.Position = UDim2.new(0, 0, 0, 4)
                toggleButton.Text = ""
                toggleButton.Parent = toggleContainer

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 5)
                toggleCorner.Parent = toggleButton

                local toggleStroke = Instance.new("UIStroke")
                toggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                toggleStroke.Color = theme.Accent
                toggleStroke.Parent = toggleButton

                local toggleOn = Instance.new("Frame")
                toggleOn.Name = "ON"
                toggleOn.Visible = false
                toggleOn.BorderSizePixel = 0
                toggleOn.BackgroundColor3 = theme.ToggleOn
                toggleOn.Size = UDim2.new(0, 14, 0, 14)
                toggleOn.Position = UDim2.new(0, 4, 0, 4)
                toggleOn.Parent = toggleButton

                local toggleOnCorner = Instance.new("UICorner")
                toggleOnCorner.CornerRadius = UDim.new(0, 3)
                toggleOnCorner.Parent = toggleOn

                local toggleText = Instance.new("TextLabel")
                toggleText.Name = "Text_Toggle"
                toggleText.TextWrapped = true
                toggleText.BorderSizePixel = 0
                toggleText.TextXAlignment = Enum.TextXAlignment.Left
                toggleText.TextScaled = true
                toggleText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleText.Font = Enum.Font.SourceSans
                toggleText.TextColor3 = theme.Text
                toggleText.BackgroundTransparency = 1
                toggleText.Size = UDim2.new(1, -30, 0, 18)
                toggleText.Text = text
                toggleText.Position = UDim2.new(0, 30, 0, 6)
                toggleText.Parent = toggleContainer

                local toggled = default

                local function setToggle(state)
                    toggled = state
                    toggleOn.Visible = toggled
                    if toggled then
                        toggleStroke.Color = theme.ToggleOn
                    else
                        toggleStroke.Color = theme.Accent
                    end
                    callback(toggled)
                end

                -- Evento de clique
                if not disabled then
                    toggleButton.MouseButton1Click:Connect(function()
                        setToggle(not toggled)
                    end)
                else
                    toggleButton.Active = false
                    toggleText.TextColor3 = theme.DarkText
                end

                setToggle(default)
            end

            -- AddSlider function
            function tab:AddSlider(key, options)
                options = options or {}
                local text = options.Text or "Slider"
                local default = options.Default or 20
                local min = options.Min or 1
                local max = options.Max or 40
                local hideMax = options.HideMax or true
                local compact = options.Compact or true
                local suffix = options.Suffix or " %"
                local callback = options.Callback or function() end

                local sliderContainer = Instance.new("Frame")
                sliderContainer.Name = "Slider_" .. key
                sliderContainer.BackgroundTransparency = 1
                sliderContainer.Size = UDim2.new(1, 0, 0, compact and 30 or 60)
                sliderContainer.Parent = scroll

                local sliderBackground = Instance.new("Frame")
                sliderBackground.Name = "Background"
                sliderBackground.BorderSizePixel = 0
                sliderBackground.BackgroundColor3 = theme.Outline
                sliderBackground.Size = UDim2.new(1, 0, 0, 26)
                sliderBackground.Position = UDim2.new(0, 0, 0, compact and 2 or 28)
                sliderBackground.Parent = sliderContainer

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 5)
                sliderCorner.Parent = sliderBackground

                local sliderStroke = Instance.new("UIStroke")
                sliderStroke.Color = theme.Accent
                sliderStroke.Parent = sliderBackground

                local progress = Instance.new("Frame")
                progress.Name = "Progress"
                progress.ZIndex = 20
                progress.BorderSizePixel = 0
                progress.BackgroundColor3 = theme.InnerBackground
                progress.Size = UDim2.new(1, -8, 1, -8)
                progress.Position = UDim2.new(0, 4, 0, 4)
                progress.Parent = sliderBackground

                local progressCorner = Instance.new("UICorner")
                progressCorner.CornerRadius = UDim.new(0, 5)
                progressCorner.Parent = progress

                local progressStroke = Instance.new("UIStroke")
                progressStroke.Color = theme.Outline
                progressStroke.Parent = progress

                local progressBar = Instance.new("Frame")
                progressBar.Name = "ProgressBar"
                progressBar.ZIndex = 19
                progressBar.BorderSizePixel = 0
                progressBar.BackgroundColor3 = theme.SliderProgress
                progressBar.Size = UDim2.new(0, 10, 1, 0)
                progressBar.Parent = progress

                local progressBarCorner = Instance.new("UICorner")
                progressBarCorner.CornerRadius = UDim.new(0, 5)
                progressBarCorner.Parent = progressBar

                -- Text elements
                local compactoLabel = Instance.new("TextLabel")
                compactoLabel.TextWrapped = true
                compactoLabel.BorderSizePixel = 0
                compactoLabel.TextScaled = true
                compactoLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                compactoLabel.Font = Enum.Font.SourceSans
                compactoLabel.TextColor3 = theme.Text
                compactoLabel.BackgroundTransparency = 1
                compactoLabel.Size = UDim2.new(1, 0, 0, 14)
                compactoLabel.Visible = compact
                compactoLabel.Text = text .. ": " .. default .. suffix
                compactoLabel.Position = UDim2.new(0, 0, 0, 8)
                compactoLabel.Parent = sliderContainer

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Name = "Name"
                nameLabel.TextWrapped = true
                nameLabel.BorderSizePixel = 0
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.TextScaled = true
                nameLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.Font = Enum.Font.SourceSans
                nameLabel.TextColor3 = theme.Text
                nameLabel.BackgroundTransparency = 1
                nameLabel.Size = UDim2.new(1, 0, 0, 14)
                nameLabel.Text = text
                nameLabel.Position = UDim2.new(0, 0, 0, 4)
                nameLabel.Visible = not compact
                nameLabel.Parent = sliderContainer

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Name = "Value"
                valueLabel.TextWrapped = true
                valueLabel.BorderSizePixel = 0
                valueLabel.TextScaled = true
                valueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                valueLabel.Font = Enum.Font.SourceSans
                valueLabel.TextColor3 = theme.DarkText
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(1, 0, 0, 14)
                valueLabel.Text = tostring(default) .. suffix
                valueLabel.Position = UDim2.new(0, 6, 0, 36)
                valueLabel.Visible = not compact
                valueLabel.Parent = sliderContainer

                -- Configuração do Slider
                local sliderConfig = {
                    Min = min,
                    Max = max,
                    Value = default,
                    Compact = compact,
                    HideMax = hideMax,
                    Suffix = suffix
                }

                -- Atualiza UI de acordo com o valor
                local function updateSlider(value)
                    sliderConfig.Value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)

                    -- Progresso visual
                    local ratio = (sliderConfig.Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                    progressBar.Size = UDim2.new(ratio, 0, 1, 0)

                    -- Texto
                    local valText = tostring(sliderConfig.Value) .. sliderConfig.Suffix
                    if not sliderConfig.HideMax then
                        valText = valText .. " / " .. sliderConfig.Max .. sliderConfig.Suffix
                    end
                    if sliderConfig.Compact then
                        compactoLabel.Text = text .. ": " .. valText
                    else
                        valueLabel.Text = valText
                    end
                    callback(sliderConfig.Value)
                end

                -- Interação: clicar e arrastar
                local dragging = false

                progress.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local pos = input.Position.X
                        local barAbsPos = progress.AbsolutePosition.X
                        local barAbsSize = progress.AbsoluteSize.X
                        local percent = math.clamp((pos - barAbsPos) / barAbsSize, 0, 1)
                        updateSlider(math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent + 0.5))
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local pos = input.Position.X
                        local barAbsPos = progress.AbsolutePosition.X
                        local barAbsSize = progress.AbsoluteSize.X
                        local percent = math.clamp((pos - barAbsPos) / barAbsSize, 0, 1)
                        updateSlider(math.floor(sliderConfig.Min + (sliderConfig.Max - sliderConfig.Min) * percent + 0.5))
                    end
                end)

                -- Inicializa
                updateSlider(default)
            end

            table.insert(Window.Tabs, tab)
            if #Window.Tabs == 1 then
                scroll.Visible = true
                Window.CurrentTab = tab
                tabButtonStroke.Transparency = 0
            end

            -- Update tabs canvas size
            tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabsScroll.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y + 8)
            end)

            return tab
        end

        return Window
    end

    return Library
end
