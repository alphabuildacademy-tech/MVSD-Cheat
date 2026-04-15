-- main.lua (FINAL - Fixed Transparency + Proper Keybind Toggles)
-- Murderers VS Sheriffs DUELS - Cheat Script

-- ==================== UI LIBRARY ====================
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = { Toggled = true, Accent = Color3.fromRGB(160, 60, 255), _blockDrag = false }

local Icons = {
    home = { 16898613509, 48, 48, 820, 147 },
    flame = { 16898613353, 48, 48, 967, 306 },
    settings = { 16898613777, 48, 48, 771, 257 },
    account = { 16898613869, 48, 48, 661, 869 },
    eye = { 16898613353, 48, 48, 771, 563 },
    ["map-pin"] = { 16898613613, 48, 48, 820, 257 },
    ["bar-chart-2"] = { 16898612629, 48, 48, 967, 710 },
    swords = { 16898613777, 48, 48, 967, 759 },
    user = { 16898613869, 48, 48, 661, 869 },
    shield = { 16898613777, 48, 48, 869, 0 },
    zap = { 16898613869, 48, 48, 918, 906 },
    target = { 16898613869, 48, 48, 514, 771 },
    globe = { 16898613509, 48, 48, 771, 563 },
    layout = { 16898613509, 48, 48, 967, 612 },
    search = { 16898613699, 48, 48, 918, 857 },
    save = { 16898613699, 48, 48, 918, 453 },
    sliders = { 16898613777, 48, 48, 404, 771 }
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do
        if i ~= "Parent" then
            obj[i] = v
        end
    end
    obj.Parent = props.Parent
    return obj
end

local function Tween(obj, time, props)
    TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

function Library:MakeDraggable(handle, target)
    target = target or handle
    local THRESHOLD = 4
    local dragging, didDrag = false, false
    local dStart, sPos

    handle.InputBegan:Connect(function(i)
        if (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) and not Library._blockDrag then
            dragging = true
            didDrag = false
            dStart = i.Position
            sPos = target.Position
        end
    end)

    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dStart
            if not didDrag and (math.abs(d.X) >= THRESHOLD or math.abs(d.Y) >= THRESHOLD) then
                didDrag = true
            end
            if didDrag then
                target.Position = UDim2.new(
                    sPos.X.Scale, sPos.X.Offset + d.X,
                    sPos.Y.Scale, sPos.Y.Offset + d.Y
                )
            end
        end
    end)

    return function()
        local v = didDrag
        didDrag = false
        return v
    end
end

function Library:GetIcon(name)
    return Icons[name] or Icons.home
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "KurbyLib",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })
    if getgenv then
        if getgenv()._KurbyUI then
            getgenv()._KurbyUI:Destroy()
        end
        getgenv()._KurbyUI = ScreenGui
    end

    local Main = Create("Frame", {
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(8, 8, 8),
        Position = UDim2.new(0.5, -300, 0.5, -220),
        Size = UDim2.new(0, 600, 0, 440)
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = Main })
    Create("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Parent = Main })

    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
        Size = UDim2.new(0, 50, 1, 0)
    })
    Create("UIStroke", { Color = Color3.fromRGB(35, 35, 35), ApplyStrokeMode = "Border", Parent = Sidebar })

    Create("TextLabel", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        Font = "GothamBold",
        Text = "K",
        TextColor3 = Library.Accent,
        TextSize = 22
    })

    local List = Create("Frame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 36),
        Size = UDim2.new(1, 0, 1, -36)
    })
    Create("UIListLayout", {
        Parent = List,
        HorizontalAlignment = "Center",
        Padding = UDim.new(0, 4)
    })

    local Container = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 50, 0, 0),
        Size = UDim2.new(1, -50, 1, 0)
    })

    local DragBar = Create("Frame", {
        Name = "DragBar",
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 0
    })
    local DragSide = Create("Frame", {
        Name = "DragSide",
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 36),
        ZIndex = 10
    })
    local wasDragging = Library:MakeDraggable(DragBar, Main)
    Library:MakeDraggable(DragSide, Main)

    local Header = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 48) })
    Create("TextLabel", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 16, 0, 0),
        Size = UDim2.new(0, 180, 1, 0),
        Font = "GothamBold",
        Text = title or "Kurby Hub",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 18,
        TextXAlignment = "Left"
    })

    local CloseBtn = Create("TextButton", {
        Name = "CloseBtn",
        Parent = Header,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(200, 55, 55),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.new(0, 22, 0, 22),
        Font = "GothamBold",
        Text = "X",
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 12,
        AutoButtonColor = false,
        ZIndex = 10
    })
    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = CloseBtn })
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 70, 70) })
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(200, 55, 55) })
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        if wasDragging() then return end
        toggled = false
        Main.Visible = false
    end)

    local SubTabBar = Create("Frame", {
        Parent = Header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 200, 0, 0),
        Size = UDim2.new(1, -240, 1, 0)
    })
    Create("UIListLayout", {
        Parent = SubTabBar,
        FillDirection = "Horizontal",
        Padding = UDim.new(0, 16),
        VerticalAlignment = "Center"
    })
    Create("Frame", {
        Parent = Header,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -1),
        Size = UDim2.new(1, 0, 0, 1)
    })

    local Folder = Create("Frame", {
        Parent = Container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 48),
        Size = UDim2.new(1, 0, 1, -48)
    })

    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local toggled = true

    local function toggleUI()
        toggled = not toggled
        Main.Visible = toggled
    end

    UIS.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.RightShift then
            toggleUI()
        end
    end)

    if isMobile then
        local ToggleBtn = Create("ImageButton", {
            Name = "MobileToggle",
            Parent = ScreenGui,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Position = UDim2.new(1, -60, 1, -60),
            Size = UDim2.new(0, 44, 0, 44),
            Image = "",
            AutoButtonColor = false,
            ZIndex = 100
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ToggleBtn })
        Create("UIStroke", { Color = Library.Accent, Thickness = 2, Parent = ToggleBtn })
        Create("TextLabel", {
            Parent = ToggleBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Font = "GothamBold",
            Text = "K",
            TextColor3 = Library.Accent,
            TextSize = 20,
            ZIndex = 101
        })
        local wasDraggingBtn = Library:MakeDraggable(ToggleBtn)
        ToggleBtn.InputEnded:Connect(function(i)
            if (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) and not wasDraggingBtn() then
                toggleUI()
            end
        end)
    end

    local Window = { Current = nil }

    function Window:CreateTab(name, iconName)
        local Btn = Create("ImageButton", {
            Name = name .. "Tab",
            Parent = List,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 50)
        })

        local Highlight = Create("Frame", {
            Parent = Btn,
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0)
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Highlight })

        local Ind = Create("Frame", {
            Name = "Indicator",
            Parent = Btn,
            BackgroundColor3 = Library.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, -12),
            Size = UDim2.new(0, 3, 0, 24),
            BackgroundTransparency = 1,
            ZIndex = 5
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Ind })

        local iconData = Library:GetIcon(iconName or "home")
        local Ico = Create("ImageLabel", {
            Name = "Icon",
            Parent = Btn,
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -12, 0.5, -12),
            Size = UDim2.new(0, 24, 0, 24),
            Image = "rbxassetid://" .. iconData[1],
            ImageRectSize = Vector2.new(iconData[2], iconData[3]),
            ImageRectOffset = Vector2.new(iconData[4], iconData[5]),
            ImageColor3 = Color3.fromRGB(140, 140, 140),
            ScaleType = Enum.ScaleType.Fit,
            ZIndex = 6
        })

        local Tab = { SubTabs = {}, CurrentST = nil }

        function Tab:Select()
            for _, v in next, List:GetChildren() do
                if v:IsA("ImageButton") then
                    if v:FindFirstChild("Indicator") then
                        Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 })
                    end
                    if v:FindFirstChild("Icon") then
                        Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) })
                    end
                    for _, f in next, v:GetChildren() do
                        if f:IsA("Frame") and f.Name ~= "Indicator" then
                            Tween(f, 0.25, { BackgroundTransparency = 1 })
                        end
                    end
                end
            end
            if Window.Current then
                for _, st in next, Window.Current.Tab.SubTabs do
                    st.Btn.Visible = false
                    st.Page.Visible = false
                end
            end
            Window.Current = { Tab = Tab }
            Tween(Ico, 0.25, { ImageColor3 = Library.Accent })
            Tween(Ind, 0.25, { BackgroundTransparency = 0 })
            Tween(Highlight, 0.25, { BackgroundTransparency = 0.85 })
            for _, st in next, Tab.SubTabs do
                st.Btn.Visible = true
            end
            if Tab.CurrentST then
                Tab.CurrentST:Select()
            elseif Tab.SubTabs[1] then
                Tab.SubTabs[1]:Select()
            end
        end

        Btn.MouseButton1Click:Connect(function()
            Tab:Select()
        end)
        Btn.MouseEnter:Connect(function()
            if not Window.Current or Window.Current.Tab ~= Tab then
                Tween(Highlight, 0.2, { BackgroundTransparency = 0.92 })
            end
        end)
        Btn.MouseLeave:Connect(function()
            if not Window.Current or Window.Current.Tab ~= Tab then
                Tween(Highlight, 0.2, { BackgroundTransparency = 1 })
            end
        end)

        function Tab:CreateSubTab(stName, stIconName)
            local stIconData = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", {
                Parent = SubTabBar,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Visible = false
            })
            local SClick = Create("TextButton", {
                Parent = SBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Text = ""
            })
            local SIco = Create("ImageLabel", {
                Name = "Icon",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                Image = "rbxassetid://" .. stIconData[1],
                ImageRectSize = Vector2.new(stIconData[2], stIconData[3]),
                ImageRectOffset = Vector2.new(stIconData[4], stIconData[5]),
                ImageColor3 = Color3.fromRGB(160, 160, 160),
                ScaleType = Enum.ScaleType.Fit
            })
            local SText = Create("TextLabel", {
                Name = "Label",
                Parent = SBtn,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 20, 0, 0),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = "X",
                Font = "Gotham",
                Text = stName,
                TextColor3 = Color3.fromRGB(160, 160, 160),
                TextSize = 13
            })
            local SLine = Create("Frame", {
                Parent = SBtn,
                BackgroundColor3 = Library.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 1, -2),
                Size = UDim2.new(1, 0, 0, 2)
            })
            local SPage = Create("ScrollingFrame", {
                Parent = Folder,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.new(1, 0, 1, 0),
                Visible = false,
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Library.Accent
            })
            Create("UIListLayout", {
                Parent = SPage,
                Padding = UDim.new(0, 10),
                HorizontalAlignment = "Center"
            })
            Create("UIPadding", {
                Parent = SPage,
                PaddingTop = UDim.new(0, 14),
                PaddingLeft = UDim.new(0, 18),
                PaddingRight = UDim.new(0, 18)
            })

            local SubTab = { Page = SPage, Btn = SBtn }

            function SubTab:Select()
                if Tab.CurrentST then
                    Tab.CurrentST.Page.Visible = false
                    Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) })
                    Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) })
                    local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame")
                    if oldLine then
                        Tween(oldLine, 0.2, { BackgroundTransparency = 1 })
                    end
                end
                Tab.CurrentST = SubTab
                SPage.Visible = true
                Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
                Tween(SIco, 0.2, { ImageColor3 = Library.Accent })
                Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function()
                SubTab:Select()
            end)
            table.insert(Tab.SubTabs, SubTab)

            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", {
                    Parent = SPage,
                    BackgroundColor3 = Color3.fromRGB(16, 16, 16),
                    Size = UDim2.new(1, 0, 0, 30)
                })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec })
                Create("Frame", {
                    Parent = Sec,
                    BackgroundColor3 = Library.Accent,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 6),
                    Size = UDim2.new(0, 2, 0, 18)
                })
                Create("TextLabel", {
                    Parent = Sec,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -10, 1, 0),
                    Font = "GothamBold",
                    Text = secName:upper(),
                    TextColor3 = Color3.fromRGB(190, 190, 190),
                    TextSize = 11,
                    TextXAlignment = "Left"
                })
                local Content = Create("Frame", {
                    Parent = SPage,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6) })
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
                    SPage.CanvasSize = UDim2.new(0, 0, 0, SPage.UIListLayout.AbsoluteContentSize.Y + 40)
                end)
                local S = {}

                function S:CreateToggle(n, def, cb)
                    local toggleValue = def or false
                    local toggleObject = nil
                    
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 42)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -64, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 14,
                        TextXAlignment = "Left"
                    })
                    local O = Create("Frame", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(1, -12, 0.5, 0),
                        Size = UDim2.new(0, 36, 0, 18)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    local I = Create("Frame", {
                        Parent = O,
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Position = UDim2.new(0, 2, 0.5, -7),
                        Size = UDim2.new(0, 14, 0, 14)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    
                    local function u()
                        Tween(O, 0.2, { BackgroundColor3 = toggleValue and Library.Accent or Color3.fromRGB(35, 35, 35) })
                        Tween(I, 0.2, { Position = toggleValue and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
                        if cb then
                            cb(toggleValue)
                        end
                    end
                    
                    F.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 then
                            toggleValue = not toggleValue
                            u()
                        end
                    end)
                    u()
                    
                    toggleObject = {
                        Set = function(_, v)
                            toggleValue = v
                            u()
                        end,
                        Get = function()
                            return toggleValue
                        end
                    }
                    return toggleObject
                end

                function S:CreateButton(n, cb)
                    local B = Create("TextButton", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 42),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B })
                    Create("TextLabel", {
                        Parent = B,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 14
                    })
                    B.MouseEnter:Connect(function()
                        Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
                    end)
                    B.MouseLeave:Connect(function()
                        Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(13, 13, 13) })
                    end)
                    B.MouseButton1Click:Connect(function()
                        if cb then
                            cb()
                        end
                    end)
                end

                function S:CreateSlider(n, min, max, def, cb)
                    min = min or 0
                    max = max or 100
                    local currentValue = def or min
                    local isDragging = false
                    
                    cb = cb or function() end
                    
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 50)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -70, 0, 24),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 14,
                        TextXAlignment = "Left"
                    })
                    local Val = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -60, 0, 0),
                        Size = UDim2.new(0, 48, 0, 24),
                        Font = "GothamBold",
                        Text = tostring(currentValue),
                        TextColor3 = Library.Accent,
                        TextSize = 13,
                        TextXAlignment = "Right"
                    })
                    local Bar = Create("Frame", {
                        Parent = F,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(0, 12, 0, 32),
                        Size = UDim2.new(1, -24, 0, 6)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                    local Fill = Create("Frame", {
                        Parent = Bar,
                        BackgroundColor3 = Library.Accent,
                        Size = UDim2.new((currentValue - min) / (max - min), 0, 1, 0)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    local Knob = Create("Frame", {
                        Parent = Fill,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.new(1, 1, 1),
                        Position = UDim2.new(1, 0, 0.5, 0),
                        Size = UDim2.new(0, 12, 0, 12)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
                    
                    local function updateValue(input)
                        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = min + (max - min) * pos
                        val = math.floor(val * 100) / 100
                        currentValue = val
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        Val.Text = tostring(currentValue)
                        cb(currentValue)
                    end
                    
                    Bar.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            isDragging = true
                            Library._blockDrag = true
                            updateValue(i)
                        end
                    end)
                    
                    UIS.InputEnded:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                            isDragging = false
                            Library._blockDrag = false
                        end
                    end)
                    
                    UIS.InputChanged:Connect(function(i)
                        if isDragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                            updateValue(i)
                        end
                    end)
                    
                    return {
                        SetValue = function(_, v)
                            v = math.clamp(v, min, max)
                            local pos = (v - min) / (max - min)
                            currentValue = v
                            Fill.Size = UDim2.new(pos, 0, 1, 0)
                            Val.Text = tostring(v)
                            cb(v)
                        end,
                        GetValue = function()
                            return currentValue
                        end
                    }
                end

                function S:CreateDropdown(n, items, def, cb)
                    items = items or {}
                    cb = cb or function() end
                    local selected = def or items[1] or "None"

                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 42),
                        ClipsDescendants = true
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })

                    local MainBtn = Create("TextButton", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 42),
                        Text = "",
                        AutoButtonColor = false
                    })
                    local Lbl = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -44, 0, 42),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 14,
                        TextXAlignment = "Left"
                    })
                    local SelLbl = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -64, 0, 42),
                        Font = "Gotham",
                        Text = tostring(selected),
                        TextColor3 = Library.Accent,
                        TextSize = 13,
                        TextXAlignment = "Right"
                    })
                    local Arrow = Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -12, 0, 21),
                        Size = UDim2.new(0, 20, 0, 20),
                        Font = "GothamBold",
                        Text = "v",
                        TextColor3 = Color3.fromRGB(140, 140, 140),
                        TextSize = 12
                    })

                    local ItemList = Create("Frame", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 6, 0, 42),
                        Size = UDim2.new(1, -12, 0, 0)
                    })
                    local LList = Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 3) })

                    local opened = false

                    local function uDropdown()
                        local h = opened and (42 + LList.AbsoluteContentSize.Y + 8) or 42
                        Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                        Tween(Arrow, 0.25, { Rotation = opened and 180 or 0 })
                    end

                    local function refresh(list)
                        items = list
                        for _, c in next, ItemList:GetChildren() do
                            if c:IsA("TextButton") then
                                c:Destroy()
                            end
                        end
                        for _, item in next, list do
                            local Btn = Create("TextButton", {
                                Parent = ItemList,
                                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                                Size = UDim2.new(1, 0, 0, 30),
                                Font = "Gotham",
                                Text = tostring(item),
                                TextColor3 = (selected == item) and Library.Accent or Color3.fromRGB(200, 200, 200),
                                TextSize = 13,
                                AutoButtonColor = false
                            })
                            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })

                            Btn.MouseEnter:Connect(function()
                                Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) })
                            end)
                            Btn.MouseLeave:Connect(function()
                                Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) })
                            end)

                            Btn.MouseButton1Click:Connect(function()
                                selected = item
                                SelLbl.Text = tostring(item)
                                opened = false
                                uDropdown()
                                cb(item)
                                refresh(items)
                            end)
                        end
                        if opened then
                            uDropdown()
                        end
                    end

                    refresh(items)
                    MainBtn.MouseButton1Click:Connect(function()
                        opened = not opened
                        uDropdown()
                    end)

                    return {
                        Refresh = refresh,
                        Set = function(_, v)
                            selected = v
                            SelLbl.Text = tostring(v)
                            cb(v)
                            refresh(items)
                        end,
                        Get = function()
                            return selected
                        end
                    }
                end

                function S:CreateKeybind(n, defKey, cb)
                    local currentKey = defKey or Enum.KeyCode.None
                    cb = cb or function() end
                    
                    local F = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 42)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", {
                        Parent = F,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0, 0),
                        Size = UDim2.new(1, -100, 1, 0),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 14,
                        TextXAlignment = "Left"
                    })
                    local KeyBtn = Create("TextButton", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 70, 0, 26),
                        Font = "GothamBold",
                        Text = currentKey.Name,
                        TextColor3 = Library.Accent,
                        TextSize = 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBtn })
                    
                    local waiting = false
                    
                    KeyBtn.MouseButton1Click:Connect(function()
                        waiting = true
                        KeyBtn.Text = "..."
                    end)
                    
                    UIS.InputBegan:Connect(function(input, gameProcessed)
                        if gameProcessed then return end
                        if waiting then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                waiting = false
                                currentKey = input.KeyCode
                                KeyBtn.Text = currentKey.Name
                                cb(currentKey)
                            end
                        end
                    end)
                    
                    return {
                        SetKey = function(_, key)
                            currentKey = key
                            KeyBtn.Text = key.Name
                            cb(key)
                        end,
                        GetKey = function()
                            return currentKey
                        end
                    }
                end

                function S:CreateColorPicker(n, defaultColor, cb)
                    local hue = 0
                    local isRainbow = false
                    local rainbowConnection = nil
                    local currentColor = defaultColor

                    local container = Create("Frame", {
                        Parent = Content,
                        BackgroundColor3 = Color3.fromRGB(13, 13, 13),
                        Size = UDim2.new(1, 0, 0, 65),
                        ClipsDescendants = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = container })

                    local label = Create("TextLabel", {
                        Parent = container,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 5),
                        Size = UDim2.new(1, -20, 0, 20),
                        Font = "Gotham",
                        Text = n,
                        TextColor3 = Color3.fromRGB(225, 225, 225),
                        TextSize = 12,
                        TextXAlignment = "Left"
                    })

                    local colorDisplay = Create("Frame", {
                        Parent = container,
                        BackgroundColor3 = defaultColor,
                        Position = UDim2.new(0, 10, 0, 28),
                        Size = UDim2.new(0, 80, 0, 25)
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = colorDisplay })
                    Create("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Parent = colorDisplay })

                    local rgbButton = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                        Position = UDim2.new(0, 100, 0, 28),
                        Size = UDim2.new(0, 60, 0, 25),
                        Font = "GothamBold",
                        Text = "RGB",
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = rgbButton })

                    local redBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
                        Position = UDim2.new(0, 170, 0, 28),
                        Size = UDim2.new(0, 25, 0, 25),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = redBtn })

                    local greenBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(50, 255, 50),
                        Position = UDim2.new(0, 200, 0, 28),
                        Size = UDim2.new(0, 25, 0, 25),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = greenBtn })

                    local blueBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(50, 50, 255),
                        Position = UDim2.new(0, 230, 0, 28),
                        Size = UDim2.new(0, 25, 0, 25),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = blueBtn })

                    local whiteBtn = Create("TextButton", {
                        Parent = container,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Position = UDim2.new(0, 260, 0, 28),
                        Size = UDim2.new(0, 25, 0, 25),
                        Text = "",
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = whiteBtn })

                    local function updateColor(color)
                        currentColor = color
                        colorDisplay.BackgroundColor3 = color
                        if cb then
                            cb(color)
                        end
                    end

                    local function startRainbow()
                        isRainbow = true
                        rgbButton.TextColor3 = Color3.fromRGB(160, 60, 255)
                        if rainbowConnection then
                            rainbowConnection:Disconnect()
                        end
                        rainbowConnection = RunService.RenderStepped:Connect(function()
                            hue = (hue + 0.01) % 1
                            updateColor(Color3.fromHSV(hue, 1, 1))
                        end)
                    end

                    local function stopRainbow()
                        isRainbow = false
                        rgbButton.TextColor3 = Color3.new(1, 1, 1)
                        if rainbowConnection then
                            rainbowConnection:Disconnect()
                            rainbowConnection = nil
                        end
                    end

                    rgbButton.MouseButton1Click:Connect(function()
                        if isRainbow then
                            stopRainbow()
                        else
                            startRainbow()
                        end
                    end)

                    redBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(255, 50, 50))
                    end)

                    greenBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(50, 255, 50))
                    end)

                    blueBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(50, 50, 255))
                    end)

                    whiteBtn.MouseButton1Click:Connect(function()
                        stopRainbow()
                        updateColor(Color3.fromRGB(255, 255, 255))
                    end)

                    return {
                        SetColor = function(_, color)
                            stopRainbow()
                            updateColor(color)
                        end,
                        SetRainbow = function(_, enabled)
                            if enabled then
                                startRainbow()
                            else
                                stopRainbow()
                            end
                        end,
                        GetColor = function()
                            return currentColor
                        end,
                        IsRainbow = function()
                            return isRainbow
                        end
                    }
                end

                return S
            end
            return SubTab
        end
        if not Window.Current then
            Tab:Select()
        end
        return Tab
    end
    return Window
end

-- ==================== END UI LIBRARY ====================

-- ==================== CHEAT SCRIPT ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Find ShootGun remote
local ShootGunRemote = nil
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
if Remotes then
    ShootGunRemote = Remotes:FindFirstChild("ShootGun")
end

-- Cheat config
local Cheat = {
    Aimbot = false,
    AutoFire = false,
    WallBang = false,
    NoClip = false,
    Fly = false,
    ESP = false,
    SkeletonESP = false,
    BoxESP = true,
    ESPBoxSize = 3,
    ESPColor = Color3.new(1, 0, 0),
    ESPRainbow = false,
    SkeletonColor = Color3.new(0, 1, 0),
    SkeletonRainbow = false,
    SkeletonThickness = 1,
    ShowHead = true,
    ShowTorso = true,
    ShowArms = true,
    ShowLegs = true,
    ShowForearms = true,
    ShowShins = true,
    ShowFOVCircle = false,
    AimbotFOV = 120,
    AimbotSmoothness = 0.3,
    TargetPart = "Head",
    AutoFireDelay = 0.1,
    WalkSpeed = 16,
    Invisible = false,
}

-- Variables
local autoFireConnection = nil
local flyBodyVelocity = nil
local espBoxes = {}
local skeletonLines = {}
local fovCircle = nil
local lastShotTime = 0
local espHue = 0
local skeletonHue = 0
local originalWalkSpeed = 16

-- Keybind variables
local keybinds = {
    Aimbot = Enum.KeyCode.X,
    AutoFire = Enum.KeyCode.Z,
    WallBang = Enum.KeyCode.C,
    NoClip = Enum.KeyCode.V,
    Fly = Enum.KeyCode.B,
    ESP = Enum.KeyCode.N,
    Invisible = Enum.KeyCode.I,
    SpeedBoost = Enum.KeyCode.K,
}

-- UI Element References (for syncing)
local uiElements = {
    AimbotToggle = nil,
    AutoFireToggle = nil,
    WallBangToggle = nil,
    NoClipToggle = nil,
    FlyToggle = nil,
    ESPToggle = nil,
}

-- ==================== CONFIG SYSTEM ====================
local ConfigData = {
    Aimbot = false,
    AutoFire = false,
    WallBang = false,
    NoClip = false,
    Fly = false,
    ESP = false,
    BoxESP = true,
    SkeletonESP = false,
    ESPBoxSize = 3,
    ESPRainbow = false,
    SkeletonRainbow = false,
    SkeletonThickness = 1,
    ShowHead = true,
    ShowTorso = true,
    ShowArms = true,
    ShowLegs = true,
    ShowForearms = true,
    ShowShins = true,
    ShowFOVCircle = false,
    AimbotFOV = 120,
    AimbotSmoothness = 0.3,
    TargetPart = "Head",
    AutoFireDelay = 0.1,
    WalkSpeed = 16,
    Invisible = false,
    AimbotKey = "X",
    AutoFireKey = "Z",
    WallBangKey = "C",
    NoClipKey = "V",
    FlyKey = "B",
    ESPKey = "N",
    InvisibleKey = "I",
    SpeedBoostKey = "K",
    ESPColorR = 1,
    ESPColorG = 0,
    ESPColorB = 0,
    SkeletonColorR = 0,
    SkeletonColorG = 1,
    SkeletonColorB = 0,
}

local function SaveConfig()
    ConfigData.Aimbot = Cheat.Aimbot
    ConfigData.AutoFire = Cheat.AutoFire
    ConfigData.WallBang = Cheat.WallBang
    ConfigData.NoClip = Cheat.NoClip
    ConfigData.Fly = Cheat.Fly
    ConfigData.ESP = Cheat.ESP
    ConfigData.BoxESP = Cheat.BoxESP
    ConfigData.SkeletonESP = Cheat.SkeletonESP
    ConfigData.ESPBoxSize = Cheat.ESPBoxSize
    ConfigData.ESPRainbow = Cheat.ESPRainbow
    ConfigData.SkeletonRainbow = Cheat.SkeletonRainbow
    ConfigData.SkeletonThickness = Cheat.SkeletonThickness
    ConfigData.ShowHead = Cheat.ShowHead
    ConfigData.ShowTorso = Cheat.ShowTorso
    ConfigData.ShowArms = Cheat.ShowArms
    ConfigData.ShowLegs = Cheat.ShowLegs
    ConfigData.ShowForearms = Cheat.ShowForearms
    ConfigData.ShowShins = Cheat.ShowShins
    ConfigData.ShowFOVCircle = Cheat.ShowFOVCircle
    ConfigData.AimbotFOV = Cheat.AimbotFOV
    ConfigData.AimbotSmoothness = Cheat.AimbotSmoothness
    ConfigData.TargetPart = Cheat.TargetPart
    ConfigData.AutoFireDelay = Cheat.AutoFireDelay
    ConfigData.WalkSpeed = Cheat.WalkSpeed
    ConfigData.Invisible = Cheat.Invisible
    ConfigData.AimbotKey = keybinds.Aimbot.Name
    ConfigData.AutoFireKey = keybinds.AutoFire.Name
    ConfigData.WallBangKey = keybinds.WallBang.Name
    ConfigData.NoClipKey = keybinds.NoClip.Name
    ConfigData.FlyKey = keybinds.Fly.Name
    ConfigData.ESPKey = keybinds.ESP.Name
    ConfigData.InvisibleKey = keybinds.Invisible.Name
    ConfigData.SpeedBoostKey = keybinds.SpeedBoost.Name
    ConfigData.ESPColorR = Cheat.ESPColor.R
    ConfigData.ESPColorG = Cheat.ESPColor.G
    ConfigData.ESPColorB = Cheat.ESPColor.B
    ConfigData.SkeletonColorR = Cheat.SkeletonColor.R
    ConfigData.SkeletonColorG = Cheat.SkeletonColor.G
    ConfigData.SkeletonColorB = Cheat.SkeletonColor.B
    
    if getgenv then
        getgenv().MVSD_Config = ConfigData
    end
    
    if syn and syn.storage then
        syn.storage.MVSD_Config = ConfigData
    end
    
    print("✅ Config Saved!")
end

local function LoadConfig()
    local loadedConfig = nil
    
    if getgenv and getgenv().MVSD_Config then
        loadedConfig = getgenv().MVSD_Config
    elseif syn and syn.storage and syn.storage.MVSD_Config then
        loadedConfig = syn.storage.MVSD_Config
    end
    
    if loadedConfig then
        ConfigData = loadedConfig
        
        Cheat.Aimbot = ConfigData.Aimbot
        Cheat.AutoFire = ConfigData.AutoFire
        Cheat.WallBang = ConfigData.WallBang
        Cheat.NoClip = ConfigData.NoClip
        Cheat.Fly = ConfigData.Fly
        Cheat.ESP = ConfigData.ESP
        Cheat.BoxESP = ConfigData.BoxESP
        Cheat.SkeletonESP = ConfigData.SkeletonESP
        Cheat.ESPBoxSize = ConfigData.ESPBoxSize
        Cheat.ESPRainbow = ConfigData.ESPRainbow
        Cheat.SkeletonRainbow = ConfigData.SkeletonRainbow
        Cheat.SkeletonThickness = ConfigData.SkeletonThickness
        Cheat.ShowHead = ConfigData.ShowHead
        Cheat.ShowTorso = ConfigData.ShowTorso
        Cheat.ShowArms = ConfigData.ShowArms
        Cheat.ShowLegs = ConfigData.ShowLegs
        Cheat.ShowForearms = ConfigData.ShowForearms
        Cheat.ShowShins = ConfigData.ShowShins
        Cheat.ShowFOVCircle = ConfigData.ShowFOVCircle
        Cheat.AimbotFOV = ConfigData.AimbotFOV
        Cheat.AimbotSmoothness = ConfigData.AimbotSmoothness
        Cheat.TargetPart = ConfigData.TargetPart
        Cheat.AutoFireDelay = ConfigData.AutoFireDelay
        Cheat.WalkSpeed = ConfigData.WalkSpeed
        Cheat.Invisible = ConfigData.Invisible
        
        if ConfigData.AimbotKey then
            keybinds.Aimbot = Enum.KeyCode[ConfigData.AimbotKey] or Enum.KeyCode.X
        end
        if ConfigData.AutoFireKey then
            keybinds.AutoFire = Enum.KeyCode[ConfigData.AutoFireKey] or Enum.KeyCode.Z
        end
        if ConfigData.WallBangKey then
            keybinds.WallBang = Enum.KeyCode[ConfigData.WallBangKey] or Enum.KeyCode.C
        end
        if ConfigData.NoClipKey then
            keybinds.NoClip = Enum.KeyCode[ConfigData.NoClipKey] or Enum.KeyCode.V
        end
        if ConfigData.FlyKey then
            keybinds.Fly = Enum.KeyCode[ConfigData.FlyKey] or Enum.KeyCode.B
        end
        if ConfigData.ESPKey then
            keybinds.ESP = Enum.KeyCode[ConfigData.ESPKey] or Enum.KeyCode.N
        end
        if ConfigData.InvisibleKey then
            keybinds.Invisible = Enum.KeyCode[ConfigData.InvisibleKey] or Enum.KeyCode.I
        end
        if ConfigData.SpeedBoostKey then
            keybinds.SpeedBoost = Enum.KeyCode[ConfigData.SpeedBoostKey] or Enum.KeyCode.K
        end
        
        Cheat.ESPColor = Color3.new(ConfigData.ESPColorR, ConfigData.ESPColorG, ConfigData.ESPColorB)
        Cheat.SkeletonColor = Color3.new(ConfigData.SkeletonColorR, ConfigData.SkeletonColorG, ConfigData.SkeletonColorB)
        
        print("✅ Config Loaded!")
        return true
    end
    
    print("ℹ️ No saved config found, using defaults")
    return false
end

-- Helper functions
local function GetCharacterRayOrigin()
    local char = LocalPlayer.Character
    if not char then
        return nil
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return nil
    end
    return (hrp.CFrame * CFrame.new(0, 0, hrp.Size.Z / 2)).Position
end

local function GetBestTarget()
    local bestTarget = nil
    local bestScore = Cheat.AimbotFOV
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(Cheat.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                    if distance < bestScore then
                        bestScore = distance
                        bestTarget = part
                    end
                end
            end
        end
    end
    return bestTarget
end

local function GetBestTargetPosition()
    local bestTarget = nil
    local bestDistance = Cheat.AimbotFOV
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(Cheat.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                    if distance < bestDistance then
                        bestDistance = distance
                        bestTarget = part
                    end
                end
            end
        end
    end

    return bestTarget
end

local function IsVisible(origin, targetPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
    local direction = targetPart.Position - origin
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result then
        local hitInstance = result.Instance
        local targetCharacter = targetPart.Parent
        local hitCharacter = hitInstance:FindFirstAncestorOfClass("Model")
        if hitCharacter == targetCharacter then
            return true
        end
        return false
    end
    return true
end

local function GetAutoFireTarget()
    local targetPart = GetBestTarget()
    if targetPart and targetPart.Parent and LocalPlayer.Character then
        local origin = GetCharacterRayOrigin()
        if origin then
            local visible = IsVisible(origin, targetPart)
            if visible or Cheat.WallBang then
                return targetPart
            end
        end
    end
    return nil
end

local function ShootAtTarget(targetPart)
    if not ShootGunRemote then
        return false
    end
    if not targetPart then
        return false
    end

    local origin = GetCharacterRayOrigin()
    if not origin then
        return false
    end

    local targetPos = targetPart.Position
    local offset = Vector3.new((math.random() - 0.5) * 0.5, (math.random() - 0.5) * 0.5, (math.random() - 0.5) * 0.5)
    local adjustedTarget = targetPos + offset

    pcall(function()
        ShootGunRemote:FireServer(origin, adjustedTarget, targetPart, targetPos)
    end)
    return true
end

-- Setup Wall Bang
local function SetupWallBang()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if Cheat.WallBang then
                local targetPart = GetBestTargetPosition()
                if targetPart and ShootGunRemote then
                    local origin = GetCharacterRayOrigin()
                    if origin then
                        pcall(function()
                            ShootGunRemote:FireServer(origin, targetPart.Position, targetPart, targetPart.Position)
                        end)
                    end
                end
            end
        end
    end)
end

-- Update functions
local function UpdateFOVCircle()
    if Cheat.ShowFOVCircle and Cheat.Aimbot then
        if not fovCircle then
            fovCircle = Drawing.new("Circle")
            fovCircle.Thickness = 1
            fovCircle.Radius = Cheat.AimbotFOV
            fovCircle.Filled = false
            fovCircle.Color = Color3.fromRGB(255, 255, 255)
            fovCircle.Transparency = 0.7
            fovCircle.Visible = true
        end
        local mousePos = UserInputService:GetMouseLocation()
        fovCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
        fovCircle.Radius = Cheat.AimbotFOV
    else
        if fovCircle then
            fovCircle.Visible = false
            fovCircle:Remove()
            fovCircle = nil
        end
    end
end

local function UpdateAimbot()
    if not Cheat.Aimbot then
        return
    end
    local targetPart = GetBestTarget()
    if targetPart then
        local targetScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if targetScreen.Z > 0 then
            local mousePos = UserInputService:GetMouseLocation()
            local delta = Vector2.new(targetScreen.X - mousePos.X, targetScreen.Y - mousePos.Y)
            if delta.Magnitude > 1 then
                local smoothDelta = delta * Cheat.AimbotSmoothness
                mousemoverel(smoothDelta.X, smoothDelta.Y)
            end
        end
    end
end

local function StartAutoFire()
    if autoFireConnection then
        return
    end

    autoFireConnection = RunService.Heartbeat:Connect(function()
        if not Cheat.AutoFire then
            if autoFireConnection then
                autoFireConnection:Disconnect()
                autoFireConnection = nil
            end
            return
        end

        local currentTime = tick()
        if currentTime - lastShotTime < Cheat.AutoFireDelay then
            return
        end

        local targetPart = GetAutoFireTarget()
        if targetPart then
            local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
            if screenPoint.Z > 0 then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - UserInputService:GetMouseLocation()).Magnitude
                if distance < 30 then
                    ShootAtTarget(targetPart)
                    lastShotTime = currentTime
                end
            end
        end
    end)
end

local function StopAutoFire()
    if autoFireConnection then
        autoFireConnection:Disconnect()
        autoFireConnection = nil
    end
end

local function UpdateNoClip()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = not Cheat.NoClip
        end
    end
end

local function UpdateFly()
    if not Cheat.Fly then
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        return
    end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if not flyBodyVelocity then
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            end
            flyBodyVelocity.Parent = hrp
            local moveDirection = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Vector3.new(0, 0, -1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection + Vector3.new(0, 0, 1)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection + Vector3.new(-1, 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Vector3.new(1, 0, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection + Vector3.new(0, -1, 0)
            end
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            local speed = 50
            flyBodyVelocity.Velocity = (Camera.CFrame.RightVector * moveDirection.X + Camera.CFrame.UpVector * moveDirection.Y + Camera.CFrame.LookVector * moveDirection.Z) * speed
        end
    end
end

-- Update Walk Speed
local function UpdateWalkSpeed()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Cheat.WalkSpeed
        end
    end
end

-- FIXED: Update Invisible (Only affects BaseParts, not Humanoid)
local function UpdateInvisible()
    local char = LocalPlayer.Character
    if char then
        -- Only make BaseParts transparent, Humanoid doesn't have Transparency property
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = Cheat.Invisible and 1 or 0
            end
        end
    end
end

-- Update ESP colors for RGB
local function UpdateESPColors()
    if Cheat.ESPRainbow then
        espHue = (espHue + 0.005) % 1
        Cheat.ESPColor = Color3.fromHSV(espHue, 1, 1)
    end
    if Cheat.SkeletonRainbow then
        skeletonHue = (skeletonHue + 0.005) % 1
        Cheat.SkeletonColor = Color3.fromHSV(skeletonHue, 1, 1)
    end
end

-- ESP
local function UpdateESP()
    UpdateESPColors()

    for _, obj in pairs(espBoxes) do
        pcall(function()
            if obj then
                obj:Destroy()
            end
        end)
    end
    espBoxes = {}

    for _, item in pairs(skeletonLines) do
        pcall(function()
            if item and item.line then
                item.line:Remove()
            end
        end)
    end
    skeletonLines = {}

    if not Cheat.ESP then
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    -- Box ESP
                    if Cheat.BoxESP then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Size = Vector3.new(Cheat.ESPBoxSize, Cheat.ESPBoxSize * 1.5, Cheat.ESPBoxSize)
                        box.Adornee = hrp
                        box.Color3 = Cheat.ESPColor
                        box.AlwaysOnTop = true
                        box.ZIndex = 0
                        box.Transparency = 0.5
                        pcall(function()
                            box.Parent = hrp
                        end)
                        table.insert(espBoxes, box)
                    end

                    -- Skeleton ESP
                    if Cheat.SkeletonESP then
                        local head = char:FindFirstChild("Head")
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                        local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                        local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                        local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                        local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                        local leftForearm = char:FindFirstChild("LeftLowerArm")
                        local rightForearm = char:FindFirstChild("RightLowerArm")
                        local leftShin = char:FindFirstChild("LeftLowerLeg")
                        local rightShin = char:FindFirstChild("RightLowerLeg")

                        local function addLine(partA, partB)
                            if partA and partB then
                                local line = Drawing.new("Line")
                                line.Visible = true
                                line.Color = Cheat.SkeletonColor
                                line.Thickness = Cheat.SkeletonThickness
                                line.Transparency = 0.7
                                table.insert(skeletonLines, { line = line, partA = partA, partB = partB })
                            end
                        end

                        if Cheat.ShowHead and torso and head then
                            addLine(torso, head)
                        end
                        if Cheat.ShowArms then
                            if torso and leftArm then
                                addLine(torso, leftArm)
                            end
                            if torso and rightArm then
                                addLine(torso, rightArm)
                            end
                        end
                        if Cheat.ShowLegs then
                            if torso and leftLeg then
                                addLine(torso, leftLeg)
                            end
                            if torso and rightLeg then
                                addLine(torso, rightLeg)
                            end
                        end
                        if Cheat.ShowForearms then
                            if leftArm and leftForearm then
                                addLine(leftArm, leftForearm)
                            end
                            if rightArm and rightForearm then
                                addLine(rightArm, rightForearm)
                            end
                        end
                        if Cheat.ShowShins then
                            if leftLeg and leftShin then
                                addLine(leftLeg, leftShin)
                            end
                            if rightLeg and rightShin then
                                addLine(rightLeg, rightShin)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function UpdateSkeletonPositions()
    for _, item in pairs(skeletonLines) do
        if item and item.line and item.partA and item.partB then
            local success, a, b = pcall(function()
                return Camera:WorldToViewportPoint(item.partA.Position), Camera:WorldToViewportPoint(item.partB.Position)
            end)

            if success and a and b then
                if a.Z > 0 and b.Z > 0 then
                    item.line.From = Vector2.new(a.X, a.Y)
                    item.line.To = Vector2.new(b.X, b.Y)
                    item.line.Visible = true
                else
                    item.line.Visible = false
                end
            else
                if item.line then
                    item.line.Visible = false
                end
            end
        end
    end
end

-- Speed Boost temporary function
local function SpeedBoost()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local originalSpeed = humanoid.WalkSpeed
            humanoid.WalkSpeed = 80
            task.wait(3)
            humanoid.WalkSpeed = Cheat.WalkSpeed
        end
    end
end

-- FIXED: Keybind system (toggles both enable and disable properly)
local function SetupKeybinds()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then
            return
        end

        -- Aimbot Toggle (X)
        if input.KeyCode == keybinds.Aimbot then
            Cheat.Aimbot = not Cheat.Aimbot
            if uiElements.AimbotToggle then
                uiElements.AimbotToggle.Set(Cheat.Aimbot)
            end
            UpdateFOVCircle()
            print("Aimbot: " .. (Cheat.Aimbot and "ON" or "OFF"))
            
        -- AutoFire Toggle (Z)
        elseif input.KeyCode == keybinds.AutoFire then
            Cheat.AutoFire = not Cheat.AutoFire
            if uiElements.AutoFireToggle then
                uiElements.AutoFireToggle.Set(Cheat.AutoFire)
            end
            if Cheat.AutoFire then
                StartAutoFire()
            else
                StopAutoFire()
            end
            print("Auto Fire: " .. (Cheat.AutoFire and "ON" or "OFF"))
            
        -- WallBang Toggle (C)
        elseif input.KeyCode == keybinds.WallBang then
            Cheat.WallBang = not Cheat.WallBang
            if uiElements.WallBangToggle then
                uiElements.WallBangToggle.Set(Cheat.WallBang)
            end
            print("Wall Bang: " .. (Cheat.WallBang and "ON" or "OFF"))
            
        -- NoClip Toggle (V)
        elseif input.KeyCode == keybinds.NoClip then
            Cheat.NoClip = not Cheat.NoClip
            if uiElements.NoClipToggle then
                uiElements.NoClipToggle.Set(Cheat.NoClip)
            end
            UpdateNoClip()
            print("NoClip: " .. (Cheat.NoClip and "ON" or "OFF"))
            
        -- Fly Toggle (B)
        elseif input.KeyCode == keybinds.Fly then
            Cheat.Fly = not Cheat.Fly
            if uiElements.FlyToggle then
                uiElements.FlyToggle.Set(Cheat.Fly)
            end
            if not Cheat.Fly and flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            print("Fly: " .. (Cheat.Fly and "ON" or "OFF"))
            
        -- ESP Toggle (N)
        elseif input.KeyCode == keybinds.ESP then
            Cheat.ESP = not Cheat.ESP
            if uiElements.ESPToggle then
                uiElements.ESPToggle.Set(Cheat.ESP)
            end
            print("ESP: " .. (Cheat.ESP and "ON" or "OFF"))
            
        -- Invisible Toggle (I)
        elseif input.KeyCode == keybinds.Invisible then
            Cheat.Invisible = not Cheat.Invisible
            if uiElements.InvisibleToggle then
                uiElements.InvisibleToggle.Set(Cheat.Invisible)
            end
            UpdateInvisible()
            print("Invisible: " .. (Cheat.Invisible and "ON" or "OFF"))
            
        -- Speed Boost (K) - Temporary, not a toggle
        elseif input.KeyCode == keybinds.SpeedBoost then
            SpeedBoost()
            print("Speed Boost Activated!")
        end
    end)
end

-- Main loop
local function OnRenderStep()
    if Cheat.Aimbot then
        UpdateAimbot()
    end
    UpdateNoClip()
    if Cheat.Fly then
        UpdateFly()
    end
    if Cheat.ESP then
        UpdateESP()
    end
    UpdateSkeletonPositions()
    UpdateFOVCircle()
    UpdateWalkSpeed()
    UpdateInvisible()
end

-- Character respawn handling
local function OnCharacterAdded(character)
    if Cheat.NoClip then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = false
        end
    end
    
    -- Apply walk speed on respawn
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = Cheat.WalkSpeed
    end
    
    -- Apply invisibility on respawn (only BaseParts)
    if Cheat.Invisible then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end

-- Setup connections
local Connections = {}
Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
Connections.RenderStepped = RunService.RenderStepped:Connect(OnRenderStep)

-- Setup Wall Bang
SetupWallBang()

-- Setup Keybinds
SetupKeybinds()

-- Load saved config
LoadConfig()

-- ==================== UI CREATION ====================
local Window = Library:CreateWindow("MVSD Cheat")

-- Combat Tab
local CombatTab = Window:CreateTab("Combat", "swords")
local CombatSubTab = CombatTab:CreateSubTab("Aimbot", "target")
local CombatSection = CombatSubTab:CreateSection("Aimbot Settings")

uiElements.AimbotToggle = CombatSection:CreateToggle("Aimbot", Cheat.Aimbot, function(val)
    Cheat.Aimbot = val
    UpdateFOVCircle()
end)

CombatSection:CreateKeybind("Aimbot Keybind", keybinds.Aimbot, function(key)
    keybinds.Aimbot = key
end)

uiElements.AutoFireToggle = CombatSection:CreateToggle("Auto Fire", Cheat.AutoFire, function(val)
    Cheat.AutoFire = val
    if val then
        StartAutoFire()
    else
        StopAutoFire()
    end
end)

CombatSection:CreateKeybind("Auto Fire Keybind", keybinds.AutoFire, function(key)
    keybinds.AutoFire = key
end)

uiElements.WallBangToggle = CombatSection:CreateToggle("Wall Bang", Cheat.WallBang, function(val)
    Cheat.WallBang = val
end)

CombatSection:CreateKeybind("Wall Bang Keybind", keybinds.WallBang, function(key)
    keybinds.WallBang = key
end)

local autoFireDelaySlider = CombatSection:CreateSlider("Auto Fire Delay", 0.05, 0.5, Cheat.AutoFireDelay, function(val)
    Cheat.AutoFireDelay = val
end)

local aimbotSmoothnessSlider = CombatSection:CreateSlider("Aimbot Smoothness", 0.05, 1, Cheat.AimbotSmoothness, function(val)
    Cheat.AimbotSmoothness = val
end)

local aimbotFOVSlider = CombatSection:CreateSlider("Aimbot FOV", 0, 360, Cheat.AimbotFOV, function(val)
    Cheat.AimbotFOV = val
    if fovCircle then
        fovCircle.Radius = val
    end
end)

local targetPartDropdown = CombatSection:CreateDropdown("Target Part", { "Head", "HumanoidRootPart" }, Cheat.TargetPart, function(val)
    Cheat.TargetPart = val
end)

local fovCircleToggle = CombatSection:CreateToggle("Show FOV Circle", Cheat.ShowFOVCircle, function(val)
    Cheat.ShowFOVCircle = val
    UpdateFOVCircle()
end)

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", "zap")
local MovementSubTab = MovementTab:CreateSubTab("Movement", "map-pin")
local MovementSection = MovementSubTab:CreateSection("Movement Features")

uiElements.NoClipToggle = MovementSection:CreateToggle("NoClip", Cheat.NoClip, function(val)
    Cheat.NoClip = val
    UpdateNoClip()
end)

MovementSection:CreateKeybind("NoClip Keybind", keybinds.NoClip, function(key)
    keybinds.NoClip = key
end)

uiElements.FlyToggle = MovementSection:CreateToggle("Fly", Cheat.Fly, function(val)
    Cheat.Fly = val
    if not val and flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
end)

MovementSection:CreateKeybind("Fly Keybind", keybinds.Fly, function(key)
    keybinds.Fly = key
end)

local walkSpeedSlider = MovementSection:CreateSlider("Walk Speed", 16, 100, Cheat.WalkSpeed, function(val)
    Cheat.WalkSpeed = val
    UpdateWalkSpeed()
end)

uiElements.InvisibleToggle = MovementSection:CreateToggle("Invisible", Cheat.Invisible, function(val)
    Cheat.Invisible = val
    UpdateInvisible()
end)

MovementSection:CreateKeybind("Invisible Keybind", keybinds.Invisible, function(key)
    keybinds.Invisible = key
end)

MovementSection:CreateButton("Speed Boost (3s)", function()
    SpeedBoost()
end)

MovementSection:CreateKeybind("Speed Boost Keybind", keybinds.SpeedBoost, function(key)
    keybinds.SpeedBoost = key
end)

-- Visuals Tab
local VisualsTab = Window:CreateTab("Visuals", "eye")
local VisualsSubTab = VisualsTab:CreateSubTab("ESP", "eye")
local VisualsSection = VisualsSubTab:CreateSection("ESP Settings")

uiElements.ESPToggle = VisualsSection:CreateToggle("ESP Enabled", Cheat.ESP, function(val)
    Cheat.ESP = val
end)

VisualsSection:CreateKeybind("ESP Keybind", keybinds.ESP, function(key)
    keybinds.ESP = key
end)

local boxESPToggle = VisualsSection:CreateToggle("Box ESP", Cheat.BoxESP, function(val)
    Cheat.BoxESP = val
end)

local boxSizeSlider = VisualsSection:CreateSlider("Box Size", 1, 8, Cheat.ESPBoxSize, function(val)
    Cheat.ESPBoxSize = val
end)

local espColorPicker = VisualsSection:CreateColorPicker("Box Color", Cheat.ESPColor, function(val)
    Cheat.ESPColor = val
    Cheat.ESPRainbow = false
end)

local espRainbowToggle = VisualsSection:CreateToggle("Rainbow Box", Cheat.ESPRainbow, function(val)
    Cheat.ESPRainbow = val
end)

local skeletonESPToggle = VisualsSection:CreateToggle("Skeleton ESP", Cheat.SkeletonESP, function(val)
    Cheat.SkeletonESP = val
end)

local skeletonThicknessSlider = VisualsSection:CreateSlider("Skeleton Thickness", 1, 3, Cheat.SkeletonThickness, function(val)
    Cheat.SkeletonThickness = val
end)

local skeletonColorPicker = VisualsSection:CreateColorPicker("Skeleton Color", Cheat.SkeletonColor, function(val)
    Cheat.SkeletonColor = val
    Cheat.SkeletonRainbow = false
end)

local skeletonRainbowToggle = VisualsSection:CreateToggle("Rainbow Skeleton", Cheat.SkeletonRainbow, function(val)
    Cheat.SkeletonRainbow = val
end)

-- Body Part Toggles
local bodySection = VisualsSubTab:CreateSection("Body Parts")
local headToggle = bodySection:CreateToggle("Show Head", Cheat.ShowHead, function(val)
    Cheat.ShowHead = val
end)

local torsoToggle = bodySection:CreateToggle("Show Torso", Cheat.ShowTorso, function(val)
    Cheat.ShowTorso = val
end)

local armsToggle = bodySection:CreateToggle("Show Arms", Cheat.ShowArms, function(val)
    Cheat.ShowArms = val
end)

local legsToggle = bodySection:CreateToggle("Show Legs", Cheat.ShowLegs, function(val)
    Cheat.ShowLegs = val
end)

local forearmsToggle = bodySection:CreateToggle("Show Forearms", Cheat.ShowForearms, function(val)
    Cheat.ShowForearms = val
end)

local shinsToggle = bodySection:CreateToggle("Show Shins", Cheat.ShowShins, function(val)
    Cheat.ShowShins = val
end)

-- Settings Tab
local SettingsTab = Window:CreateTab("Settings", "sliders")
local SettingsSubTab = SettingsTab:CreateSubTab("Config", "save")
local SettingsSection = SettingsSubTab:CreateSection("Configuration")

SettingsSection:CreateButton("Save Config", function()
    SaveConfig()
end)

SettingsSection:CreateButton("Load Config", function()
    if LoadConfig() then
        if uiElements.AimbotToggle then uiElements.AimbotToggle.Set(Cheat.Aimbot) end
        if uiElements.AutoFireToggle then uiElements.AutoFireToggle.Set(Cheat.AutoFire) end
        if uiElements.WallBangToggle then uiElements.WallBangToggle.Set(Cheat.WallBang) end
        if uiElements.NoClipToggle then uiElements.NoClipToggle.Set(Cheat.NoClip) end
        if uiElements.FlyToggle then uiElements.FlyToggle.Set(Cheat.Fly) end
        if uiElements.ESPToggle then uiElements.ESPToggle.Set(Cheat.ESP) end
        if uiElements.InvisibleToggle then uiElements.InvisibleToggle.Set(Cheat.Invisible) end
        
        autoFireDelaySlider.SetValue(Cheat.AutoFireDelay)
        aimbotSmoothnessSlider.SetValue(Cheat.AimbotSmoothness)
        aimbotFOVSlider.SetValue(Cheat.AimbotFOV)
        targetPartDropdown.Set(Cheat.TargetPart)
        fovCircleToggle.Set(Cheat.ShowFOVCircle)
        
        walkSpeedSlider.SetValue(Cheat.WalkSpeed)
        
        boxESPToggle.Set(Cheat.BoxESP)
        boxSizeSlider.SetValue(Cheat.ESPBoxSize)
        espColorPicker.SetColor(Cheat.ESPColor)
        espRainbowToggle.Set(Cheat.ESPRainbow)
        skeletonESPToggle.Set(Cheat.SkeletonESP)
        skeletonThicknessSlider.SetValue(Cheat.SkeletonThickness)
        skeletonColorPicker.SetColor(Cheat.SkeletonColor)
        skeletonRainbowToggle.Set(Cheat.SkeletonRainbow)
        
        headToggle.Set(Cheat.ShowHead)
        torsoToggle.Set(Cheat.ShowTorso)
        armsToggle.Set(Cheat.ShowArms)
        legsToggle.Set(Cheat.ShowLegs)
        forearmsToggle.Set(Cheat.ShowForearms)
        shinsToggle.Set(Cheat.ShowShins)
        
        UpdateFOVCircle()
        UpdateWalkSpeed()
        UpdateInvisible()
    end
end)

SettingsSection:CreateButton("Reset to Defaults", function()
    Cheat.Aimbot = false
    Cheat.AutoFire = false
    Cheat.WallBang = false
    Cheat.NoClip = false
    Cheat.Fly = false
    Cheat.ESP = false
    Cheat.BoxESP = true
    Cheat.SkeletonESP = false
    Cheat.ESPBoxSize = 3
    Cheat.ESPRainbow = false
    Cheat.SkeletonRainbow = false
    Cheat.SkeletonThickness = 1
    Cheat.ShowHead = true
    Cheat.ShowTorso = true
    Cheat.ShowArms = true
    Cheat.ShowLegs = true
    Cheat.ShowForearms = true
    Cheat.ShowShins = true
    Cheat.ShowFOVCircle = false
    Cheat.AimbotFOV = 120
    Cheat.AimbotSmoothness = 0.3
    Cheat.TargetPart = "Head"
    Cheat.AutoFireDelay = 0.1
    Cheat.WalkSpeed = 16
    Cheat.Invisible = false
    Cheat.ESPColor = Color3.new(1, 0, 0)
    Cheat.SkeletonColor = Color3.new(0, 1, 0)
    
    if uiElements.AimbotToggle then uiElements.AimbotToggle.Set(false) end
    if uiElements.AutoFireToggle then uiElements.AutoFireToggle.Set(false) end
    if uiElements.WallBangToggle then uiElements.WallBangToggle.Set(false) end
    if uiElements.NoClipToggle then uiElements.NoClipToggle.Set(false) end
    if uiElements.FlyToggle then uiElements.FlyToggle.Set(false) end
    if uiElements.ESPToggle then uiElements.ESPToggle.Set(false) end
    if uiElements.InvisibleToggle then uiElements.InvisibleToggle.Set(false) end
    
    autoFireDelaySlider.SetValue(0.1)
    aimbotSmoothnessSlider.SetValue(0.3)
    aimbotFOVSlider.SetValue(120)
    targetPartDropdown.Set("Head")
    fovCircleToggle.Set(false)
    
    walkSpeedSlider.SetValue(16)
    
    boxESPToggle.Set(true)
    boxSizeSlider.SetValue(3)
    espColorPicker.SetColor(Color3.new(1, 0, 0))
    espRainbowToggle.Set(false)
    skeletonESPToggle.Set(false)
    skeletonThicknessSlider.SetValue(1)
    skeletonColorPicker.SetColor(Color3.new(0, 1, 0))
    skeletonRainbowToggle.Set(false)
    
    headToggle.Set(true)
    torsoToggle.Set(true)
    armsToggle.Set(true)
    legsToggle.Set(true)
    forearmsToggle.Set(true)
    shinsToggle.Set(true)
    
    UpdateFOVCircle()
    UpdateWalkSpeed()
    UpdateInvisible()
    
    print("✅ Reset to default settings!")
end)

local InfoSection = SettingsSubTab:CreateSection("Info")
InfoSection:CreateButton("Show Keybinds", function()
    print("=== MVSD CHEAT KEYBINDS ===")
    print("Right Shift - Toggle UI")
    print("X - Toggle Aimbot")
    print("Z - Toggle Auto Fire")
    print("C - Toggle Wall Bang")
    print("V - Toggle NoClip")
    print("B - Toggle Fly")
    print("N - Toggle ESP")
    print("I - Toggle Invisible")
    print("K - Speed Boost (3 seconds)")
    print("===========================")
end)

-- Start
if LocalPlayer.Character then
    OnCharacterAdded(LocalPlayer.Character)
end

print("MVSD Cheat Loaded Successfully! Press Right Shift to open UI.")