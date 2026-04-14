-- main.lua (FULLY UPDATED - Complete Working Script)
-- Murderers VS Sheriffs DUELS - Cheat Script
-- Features: Aimbot, AutoFire (Triggerbot), NoClip, Fly, Teleport Behind, ESP (Box + Full Skeleton), FOV Circle

-- ==================== UI LIBRARY ====================
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Library = { Toggled = true, Accent = Color3.fromRGB(160, 60, 255), _blockDrag = false }

local Icons = {
    home          = { 16898613509, 48, 48, 820, 147 },
    flame         = { 16898613353, 48, 48, 967, 306 },
    settings      = { 16898613777, 48, 48, 771, 257 },
    account       = { 16898613869, 48, 48, 661, 869 },
    eye           = { 16898613353, 48, 48, 771, 563 },
    ["map-pin"]   = { 16898613613, 48, 48, 820, 257 },
    ["bar-chart-2"] = { 16898612629, 48, 48, 967, 710 },
    swords        = { 16898613777, 48, 48, 967, 759 },
    user          = { 16898613869, 48, 48, 661, 869 },
    shield        = { 16898613777, 48, 48, 869,   0 },
    zap           = { 16898613869, 48, 48, 918, 906 },
    target        = { 16898613869, 48, 48, 514, 771 },
    globe         = { 16898613509, 48, 48, 771, 563 },
    layout        = { 16898613509, 48, 48, 967, 612 },
    search        = { 16898613699, 48, 48, 918, 857 },
    save          = { 16898613699, 48, 48, 918, 453 },
    sliders       = { 16898613777, 48, 48, 404, 771 },
}

local function Create(class, props)
    local obj = Instance.new(class)
    for i, v in next, props do if i ~= "Parent" then obj[i] = v end end
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
            didDrag  = false
            dStart   = i.Position
            sPos     = target.Position
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

    return function() local v = didDrag; didDrag = false; return v end
end

function Library:GetIcon(name)
    return Icons[name] or Icons["home"]
end

function Library:CreateWindow(title)
    local ScreenGui = Create("ScreenGui", {
        Name = "KurbyLib",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui) or CoreGui,
        ResetOnSpawn = false
    })
    if getgenv then
        if getgenv()._KurbyUI then getgenv()._KurbyUI:Destroy() end
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
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(255, 70, 70) }) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(200, 55, 55) }) end)
    CloseBtn.MouseButton1Click:Connect(function()
        if wasDragging() then return end
        toggled = false
        Main.Visible = false
    end)

    local SubTabBar = Create("Frame", { Parent = Header, BackgroundTransparency = 1, Position = UDim2.new(0, 200, 0, 0), Size = UDim2.new(1, -240, 1, 0) })
    Create("UIListLayout", { Parent = SubTabBar, FillDirection = "Horizontal", Padding = UDim.new(0, 16), VerticalAlignment = "Center" })
    Create("Frame", { Parent = Header, BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1) })

    local Folder = Create("Frame", { Parent = Container, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 48), Size = UDim2.new(1, 0, 1, -48) })

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
                    if v:FindFirstChild("Indicator") then Tween(v.Indicator, 0.25, { BackgroundTransparency = 1 }) end
                    if v:FindFirstChild("Icon") then Tween(v.Icon, 0.25, { ImageColor3 = Color3.fromRGB(140, 140, 140) }) end
                    for _, f in next, v:GetChildren() do
                        if f:IsA("Frame") and f.Name ~= "Indicator" then Tween(f, 0.25, { BackgroundTransparency = 1 }) end
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
            for _, st in next, Tab.SubTabs do st.Btn.Visible = true end
            if Tab.CurrentST then Tab.CurrentST:Select() elseif Tab.SubTabs[1] then Tab.SubTabs[1]:Select() end
        end

        Btn.MouseButton1Click:Connect(function() Tab:Select() end)
        Btn.MouseEnter:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 0.92 }) end end)
        Btn.MouseLeave:Connect(function() if not Window.Current or Window.Current.Tab ~= Tab then Tween(Highlight, 0.2, { BackgroundTransparency = 1 }) end end)

        function Tab:CreateSubTab(stName, stIconName)
            local stIconData = Library:GetIcon(stIconName or "layout")
            local SBtn = Create("Frame", { Parent = SubTabBar, BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = "X", Visible = false })
            local SClick = Create("TextButton", { Parent = SBtn, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Text = "" })
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
            local SPage = Create("ScrollingFrame", { Parent = Folder, BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 2, ScrollBarImageColor3 = Library.Accent })
            Create("UIListLayout", { Parent = SPage, Padding = UDim.new(0, 10), HorizontalAlignment = "Center" })
            Create("UIPadding", { Parent = SPage, PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18) })

            local SubTab = { Page = SPage, Btn = SBtn }

            function SubTab:Select()
                if Tab.CurrentST then
                    Tab.CurrentST.Page.Visible = false
                    Tween(Tab.CurrentST.Btn.Label, 0.2, { TextColor3 = Color3.fromRGB(160, 160, 160) })
                    Tween(Tab.CurrentST.Btn.Icon, 0.2, { ImageColor3 = Color3.fromRGB(160, 160, 160) })
                    local oldLine = Tab.CurrentST.Btn:FindFirstChildOfClass("Frame")
                    if oldLine then Tween(oldLine, 0.2, { BackgroundTransparency = 1 }) end
                end
                Tab.CurrentST = SubTab
                SPage.Visible = true
                Tween(SText, 0.2, { TextColor3 = Color3.new(1, 1, 1) })
                Tween(SIco, 0.2, { ImageColor3 = Library.Accent })
                Tween(SLine, 0.2, { BackgroundTransparency = 0 })
            end
            SClick.MouseButton1Click:Connect(function() SubTab:Select() end)
            table.insert(Tab.SubTabs, SubTab)

            function SubTab:CreateSection(secName)
                local Sec = Create("Frame", { Parent = SPage, BackgroundColor3 = Color3.fromRGB(16, 16, 16), Size = UDim2.new(1, 0, 0, 30) })
                Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = Sec })
                Create("Frame", { Parent = Sec, BackgroundColor3 = Library.Accent, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 6), Size = UDim2.new(0, 2, 0, 18) })
                Create("TextLabel", { Parent = Sec, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), Font = "GothamBold", Text = secName:upper(), TextColor3 = Color3.fromRGB(190, 190, 190), TextSize = 11, TextXAlignment = "Left" })
                local Content = Create("Frame", { Parent = SPage, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0) })
                local L = Create("UIListLayout", { Parent = Content, Padding = UDim.new(0, 6) })
                L:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    Content.Size = UDim2.new(1, 0, 0, L.AbsoluteContentSize.Y)
                    SPage.CanvasSize = UDim2.new(0, 0, 0, SPage.UIListLayout.AbsoluteContentSize.Y + 40)
                end)
                local S = {}

                function S:CreateToggle(n, def, cb)
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local O = Create("Frame", { Parent = F, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.new(0, 36, 0, 18) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = O })
                    local I = Create("Frame", { Parent = O, BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 14, 0, 14) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = I })
                    local t = def or false
                    local function u() Tween(O, 0.2, { BackgroundColor3 = t and Library.Accent or Color3.fromRGB(35, 35, 35) }); Tween(I, 0.2, { Position = t and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) }); if cb then cb(t) end end
                    F.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then t = not t; u() end end)
                    u()
                    return { Set = function(_, v) t = v; u() end }
                end

                function S:CreateButton(n, cb)
                    local B = Create("TextButton", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = B })
                    Create("TextLabel", { Parent = B, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14 })
                    B.MouseEnter:Connect(function() Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }) end)
                    B.MouseLeave:Connect(function() Tween(B, 0.15, { BackgroundColor3 = Color3.fromRGB(13, 13, 13) }) end)
                    B.MouseButton1Click:Connect(function() if cb then cb() end end)
                end

                function S:CreateSlider(n, min, max, def, cb)
                    min = min or 0; max = max or 100; def = def or min; cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 50) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -70, 0, 24), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Val = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 0), Size = UDim2.new(0, 48, 0, 24), Font = "GothamBold", Text = tostring(def), TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })
                    local Bar = Create("Frame", { Parent = F, BackgroundColor3 = Color3.fromRGB(35, 35, 35), Position = UDim2.new(0, 12, 0, 32), Size = UDim2.new(1, -24, 0, 6) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Bar })
                    local Fill = Create("Frame", { Parent = Bar, BackgroundColor3 = Library.Accent, Size = UDim2.new((def - min) / (max - min), 0, 1, 0) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })
                    local Knob = Create("Frame", { Parent = Fill, AnchorPoint = Vector2.new(1, 0.5), BackgroundColor3 = Color3.new(1, 1, 1), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12) })
                    Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })
                    local dragging = false
                    local function move(input)
                        local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                        local val = math.floor(min + (max - min) * pos)
                        Fill.Size = UDim2.new(pos, 0, 1, 0)
                        Val.Text = tostring(val)
                        cb(val)
                    end
                    Bar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = true; Library._blockDrag = true; move(i) end end)
                    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false; Library._blockDrag = false end end)
                    UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then move(i) end end)
                    return { Set = function(_, v) local p = (v - min)/(max - min); Fill.Size = UDim2.new(p, 0, 1, 0); Val.Text = tostring(v); cb(v) end }
                end

                function S:CreateDropdown(n, items, def, cb)
                    items = items or {}; cb = cb or function() end
                    local selected = def
                    
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    
                    local MainBtn = Create("TextButton", { Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -44, 0, 42), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local SelLbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 0, 42), Font = "Gotham", Text = tostring(def or "None"), TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })
                    local Arrow = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 21), Size = UDim2.new(0, 20, 0, 20), Font = "GothamBold", Text = "v", TextColor3 = Color3.fromRGB(140, 140, 140), TextSize = 12 })

                    local ItemList = Create("Frame", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 42), Size = UDim2.new(1, -12, 0, 0) })
                    local LList = Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 3) })
                    
                    local opened = false

                    local function uDropdown()
                        local h = opened and (42 + LList.AbsoluteContentSize.Y + 8) or 42
                        Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                        Tween(Arrow, 0.25, { Rotation = opened and 180 or 0 })
                    end

                    local function refresh(list)
                        items = list
                        for _, c in next, ItemList:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
                        for _, item in next, list do
                            local Btn = Create("TextButton", { Parent = ItemList, BackgroundColor3 = Color3.fromRGB(20, 20, 20), Size = UDim2.new(1, 0, 0, 30), Font = "Gotham", Text = tostring(item), TextColor3 = (selected == item) and Library.Accent or Color3.fromRGB(200, 200, 200), TextSize = 13, AutoButtonColor = false })
                            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
                            
                            Btn.MouseEnter:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) }) end)
                            Btn.MouseLeave:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }) end)

                            Btn.MouseButton1Click:Connect(function()
                                selected = item
                                SelLbl.Text = tostring(item)
                                opened = false
                                uDropdown()
                                cb(item)
                                refresh(items)
                            end)
                        end
                        if opened then uDropdown() end
                    end

                    refresh(items)
                    MainBtn.MouseButton1Click:Connect(function()
                        opened = not opened
                        uDropdown()
                    end)

                    return { 
                        Refresh = refresh, 
                        Set = function(_, v) 
                            selected = v; 
                            SelLbl.Text = tostring(v); 
                            cb(v); 
                            refresh(items) 
                        end 
                    }
                end

                function S:CreateMultiDropdown(n, items, def, cb)
                    items = items or {}; cb = cb or function() end
                    local selected = def or {}
                    
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42), ClipsDescendants = true })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    
                    local MainBtn = Create("TextButton", { Parent = F, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 42), Text = "", AutoButtonColor = false })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -44, 0, 42), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local SelLbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -64, 0, 42), Font = "Gotham", Text = "None", TextColor3 = Library.Accent, TextSize = 13, TextXAlignment = "Right" })
                    local Arrow = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -12, 0, 21), Size = UDim2.new(0, 20, 0, 20), Font = "GothamBold", Text = "v", TextColor3 = Color3.fromRGB(140, 140, 140), TextSize = 12 })

                    local function updateText()
                        local t = ""
                        for i, v in next, selected do
                            t = t .. (i == 1 and "" or ", ") .. tostring(v)
                        end
                        if t == "" then t = "None" end
                        if #t > 24 then t = #selected .. " Selected" end
                        SelLbl.Text = t
                    end
                    updateText()

                    local ItemList = Create("Frame", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 6, 0, 42), Size = UDim2.new(1, -12, 0, 0) })
                    local LList = Create("UIListLayout", { Parent = ItemList, Padding = UDim.new(0, 3) })
                    
                    local opened = false

                    local function uDropdown()
                        local h = opened and (42 + LList.AbsoluteContentSize.Y + 8) or 42
                        Tween(F, 0.25, { Size = UDim2.new(1, 0, 0, h) })
                        Tween(Arrow, 0.25, { Rotation = opened and 180 or 0 })
                    end

                    local function refresh(list)
                        items = list
                        for _, c in next, ItemList:GetChildren() do if c:IsA("TextButton") then c:Destroy() end end
                        for _, item in next, list do
                            local isSelected = table.find(selected, item)
                            local Btn = Create("TextButton", { Parent = ItemList, BackgroundColor3 = Color3.fromRGB(20, 20, 20), Size = UDim2.new(1, 0, 0, 30), Font = "Gotham", Text = tostring(item), TextColor3 = isSelected and Library.Accent or Color3.fromRGB(200, 200, 200), TextSize = 13, AutoButtonColor = false })
                            Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Btn })
                            
                            Btn.MouseEnter:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(26, 26, 26) }) end)
                            Btn.MouseLeave:Connect(function() Tween(Btn, 0.1, { BackgroundColor3 = Color3.fromRGB(20, 20, 20) }) end)

                            Btn.MouseButton1Click:Connect(function()
                                local idx = table.find(selected, item)
                                if idx then
                                    table.remove(selected, idx)
                                else
                                    table.insert(selected, item)
                                end
                                updateText()
                                Tween(Btn, 0.1, { TextColor3 = table.find(selected, item) and Library.Accent or Color3.fromRGB(200, 200, 200) })
                                cb(selected)
                            end)
                        end
                        if opened then uDropdown() end
                    end

                    refresh(items)
                    MainBtn.MouseButton1Click:Connect(function()
                        opened = not opened
                        uDropdown()
                    end)

                    return { 
                        Refresh = refresh, 
                        Set = function(_, v) 
                            selected = v; 
                            updateText(); 
                            cb(v); 
                            refresh(items) 
                        end 
                    }
                end

                function S:CreateTextBox(n, placeholder, cb)
                    cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(0.4, 0, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local Box = Create("TextBox", {
                        Parent = F,
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0.5, -10, 0, 26),
                        Font = "Gotham",
                        Text = "",
                        PlaceholderText = placeholder or "Enter...",
                        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 13,
                        ClearTextOnFocus = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Box })
                    Create("UIPadding", { Parent = Box, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
                    Box.Focused:Connect(function() Tween(Box, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 30) }) end)
                    Box.FocusLost:Connect(function(enter) Tween(Box, 0.15, { BackgroundColor3 = Color3.fromRGB(22, 22, 22) }); if enter then cb(Box.Text) end end)
                    return { Set = function(_, v) Box.Text = v end, Get = function() return Box.Text end }
                end

                function S:CreateLabel(n)
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 32) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    local Lbl = Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -24, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(180, 180, 180), TextSize = 13, TextXAlignment = "Left" })
                    return { Set = function(_, v) Lbl.Text = v end }
                end

                function S:CreateKeybind(n, defKey, cb)
                    cb = cb or function() end
                    local F = Create("Frame", { Parent = Content, BackgroundColor3 = Color3.fromRGB(13, 13, 13), Size = UDim2.new(1, 0, 0, 42) })
                    Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = F })
                    Create("TextLabel", { Parent = F, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, -100, 1, 0), Font = "Gotham", Text = n, TextColor3 = Color3.fromRGB(225, 225, 225), TextSize = 14, TextXAlignment = "Left" })
                    local KeyBtn = Create("TextButton", {
                        Parent = F,
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        Position = UDim2.new(1, -10, 0.5, 0),
                        Size = UDim2.new(0, 70, 0, 26),
                        Font = "GothamBold",
                        Text = defKey and defKey.Name or "None",
                        TextColor3 = Library.Accent,
                        TextSize = 12,
                        AutoButtonColor = false
                    })
                    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = KeyBtn })
                    local binding = false
                    local currentKey = defKey
                    KeyBtn.MouseButton1Click:Connect(function()
                        binding = true
                        KeyBtn.Text = "..."
                    end)
                    UIS.InputBegan:Connect(function(input)
                        if binding then
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                currentKey = input.KeyCode
                                KeyBtn.Text = input.KeyCode.Name
                                binding = false
                            end
                        elseif currentKey and input.KeyCode == currentKey then
                            cb(currentKey)
                        end
                    end)
                end

                return S
            end
            return SubTab
        end
        if not Window.Current then Tab:Select() end
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
local LocalPlayer = Players.LocalPlayer

-- Cheat config
local Cheat = {
    Aimbot = false,
    AutoFire = false,
    NoClip = false,
    Fly = false,
    ESP = false,
    SkeletonESP = false,
    BoxESP = true,
    ESPBoxSize = 3,
    ShowFOVCircle = false,
    AimbotFOV = 120,
    AimbotSmoothness = 0.3,
    TargetPart = "Head",
    AutoFireDelay = 0.05,
}

local autoFireConnection = nil
local flyBodyVelocity = nil
local espBoxes = {}
local skeletonLines = {}
local fovCircle = nil

-- Helper: get closest enemy to mouse cursor
local function GetClosestPlayer()
    local closest = nil
    local shortest = Cheat.AimbotFOV
    local mouseLocation = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local part = player.Character:FindFirstChild(Cheat.TargetPart) or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPoint, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mouseLocation).Magnitude
                    if distance < shortest then
                        shortest = distance
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- FOV Circle
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

-- Aimbot (move mouse)
local function UpdateAimbot()
    if not Cheat.Aimbot then return end
    local targetPlayer = GetClosestPlayer()
    if targetPlayer and targetPlayer.Character then
        local targetPart = targetPlayer.Character:FindFirstChild(Cheat.TargetPart) or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
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
end

-- AutoFire (Triggerbot) - Shoots through walls
local function StartAutoFire()
    if autoFireConnection then return end
    
    autoFireConnection = RunService.Heartbeat:Connect(function()
        if not Cheat.AutoFire then 
            if autoFireConnection then 
                autoFireConnection:Disconnect() 
                autoFireConnection = nil 
            end
            return 
        end
        
        local targetPlayer = GetClosestPlayer()
        if targetPlayer and targetPlayer.Character then
            local targetPart = targetPlayer.Character:FindFirstChild(Cheat.TargetPart) or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local screenPoint = Camera:WorldToViewportPoint(targetPart.Position)
                if screenPoint.Z > 0 then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - UserInputService:GetMouseLocation()).Magnitude
                    if distance < 30 then
                        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool and tool:IsA("Tool") then
                            tool:Activate()
                        end
                    end
                end
            end
        end
        task.wait(Cheat.AutoFireDelay)
    end)
end

local function StopAutoFire()
    if autoFireConnection then
        autoFireConnection:Disconnect()
        autoFireConnection = nil
    end
end

-- NoClip
local function UpdateNoClip()
    if not Cheat.NoClip then return end
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CanCollide = false
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part ~= hrp then
                    part.CanCollide = false
                end
            end
        end
    end
end

-- Fly
local function UpdateFly()
    if not Cheat.Fly then
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
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
            local moveDirection = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + Vector3.new(0,0,-1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection + Vector3.new(0,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection + Vector3.new(-1,0,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + Vector3.new(1,0,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection + Vector3.new(0,-1,0) end
            if moveDirection.Magnitude > 0 then moveDirection = moveDirection.Unit end
            local speed = 50
            flyBodyVelocity.Velocity = (Camera.CFrame.RightVector * moveDirection.X + Camera.CFrame.UpVector * moveDirection.Y + Camera.CFrame.LookVector * moveDirection.Z) * speed
        end
    end
end

-- Teleport Behind
local function TeleportBehindPlayer()
    local targetPlayer = GetClosestPlayer()
    if targetPlayer and targetPlayer.Character then
        local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            local behindPos = targetHRP.Position - targetHRP.CFrame.LookVector * 5
            myHRP.CFrame = CFrame.new(behindPos)
        end
    end
end

-- ESP Box + Full Skeleton
local function UpdateESP()
    -- Clean up old objects
    for _, obj in pairs(espBoxes) do
        pcall(function() 
            if obj and obj:IsA("BasePart") then obj:Destroy() 
            elseif obj and obj.Destroy then obj:Destroy() end
        end)
    end
    espBoxes = {}
    
    for _, item in pairs(skeletonLines) do
        pcall(function() 
            if item and item.line then item.line:Remove() end
        end)
    end
    skeletonLines = {}

    if not Cheat.ESP then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
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
            
            if hrp then
                -- Box ESP
                if Cheat.BoxESP then
                    local box = Instance.new("BoxHandleAdornment")
                    box.Size = Vector3.new(Cheat.ESPBoxSize, Cheat.ESPBoxSize * 1.5, Cheat.ESPBoxSize)
                    box.Adornee = hrp
                    box.Color3 = Color3.new(1, 0, 0)
                    box.AlwaysOnTop = true
                    box.ZIndex = 0
                    box.Transparency = 0.5
                    pcall(function() box.Parent = hrp end)
                    table.insert(espBoxes, box)
                end
                
                -- Full Skeleton ESP
                if Cheat.SkeletonESP then
                    -- Head to Torso
                    if head and torso then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = torso, partB = head})
                    end
                    -- Torso to Left Arm
                    if torso and leftArm then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = torso, partB = leftArm})
                    end
                    -- Torso to Right Arm
                    if torso and rightArm then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = torso, partB = rightArm})
                    end
                    -- Torso to Left Leg
                    if torso and leftLeg then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = torso, partB = leftLeg})
                    end
                    -- Torso to Right Leg
                    if torso and rightLeg then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = torso, partB = rightLeg})
                    end
                    -- Left Arm to Left Forearm
                    if leftArm and leftForearm then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = leftArm, partB = leftForearm})
                    end
                    -- Right Arm to Right Forearm
                    if rightArm and rightForearm then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = rightArm, partB = rightForearm})
                    end
                    -- Left Leg to Left Shin
                    if leftLeg and leftShin then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = leftLeg, partB = leftShin})
                    end
                    -- Right Leg to Right Shin
                    if rightLeg and rightShin then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = Color3.new(0, 1, 0)
                        line.Thickness = 1
                        line.Transparency = 0.7
                        table.insert(skeletonLines, {line = line, partA = rightLeg, partB = rightShin})
                    end
                end
            end
        end
    end
end

-- Update skeleton line positions
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
                if item.line then item.line.Visible = false end
            end
        end
    end
end

-- Main loop
local function OnRenderStep()
    if Cheat.Aimbot then UpdateAimbot() end
    if Cheat.NoClip then UpdateNoClip() end
    if Cheat.Fly then UpdateFly() end
    UpdateESP()
    UpdateSkeletonPositions()
    UpdateFOVCircle()
end

-- Character respawn handling
local function OnCharacterAdded(character)
    if Cheat.NoClip then
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CanCollide = false end
    end
end

-- Setup connections
local Connections = {}
Connections.CharacterAdded = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
Connections.RenderStepped = RunService.RenderStepped:Connect(OnRenderStep)

-- ==================== UI CREATION ====================
local Window = Library:CreateWindow("MVSD Cheat")
local CombatTab = Window:CreateTab("Combat", "swords")
local CombatSection = CombatTab:CreateSubTab("Aimbot", "target"):CreateSection("Aimbot Settings")
CombatSection:CreateToggle("Aimbot", false, function(val) Cheat.Aimbot = val; UpdateFOVCircle() end)
CombatSection:CreateToggle("Auto Fire (Triggerbot)", false, function(val) 
    Cheat.AutoFire = val
    if val then
        StartAutoFire()
    else
        StopAutoFire()
    end
end)
CombatSection:CreateSlider("Auto Fire Delay (Seconds)", 0.01, 0.3, 0.05, function(val) Cheat.AutoFireDelay = val end)
CombatSection:CreateSlider("Aimbot FOV", 0, 360, 120, function(val) Cheat.AimbotFOV = val; if fovCircle then fovCircle.Radius = val end end)
CombatSection:CreateSlider("Aimbot Smoothness", 0.05, 1, 0.3, function(val) Cheat.AimbotSmoothness = val end)
CombatSection:CreateDropdown("Target Part", {"Head", "HumanoidRootPart"}, "Head", function(val) Cheat.TargetPart = val end)
CombatSection:CreateToggle("Show FOV Circle", false, function(val) Cheat.ShowFOVCircle = val; UpdateFOVCircle() end)

local MovementTab = Window:CreateTab("Movement", "zap")
local MovementSection = MovementTab:CreateSubTab("Movement", "map-pin"):CreateSection("Movement Features")
MovementSection:CreateToggle("NoClip", false, function(val)
    Cheat.NoClip = val
    if not val and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CanCollide = true end
    end
end)
MovementSection:CreateToggle("Fly", false, function(val)
    Cheat.Fly = val
    if not val and flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
end)
MovementSection:CreateButton("Teleport Behind Enemy", function() TeleportBehindPlayer() end)

local VisualsTab = Window:CreateTab("Visuals", "eye")
local VisualsSection = VisualsTab:CreateSubTab("ESP", "eye"):CreateSection("ESP Settings")
VisualsSection:CreateToggle("ESP Enabled", false, function(val) Cheat.ESP = val end)
VisualsSection:CreateToggle("Box ESP", true, function(val) Cheat.BoxESP = val end)
VisualsSection:CreateToggle("Skeleton ESP (Full Body)", false, function(val) Cheat.SkeletonESP = val end)
VisualsSection:CreateSlider("Box Size", 1, 8, 3, function(val) Cheat.ESPBoxSize = val end)

-- Start
if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end

print("MVSD Cheat Loaded Successfully! Press Right Shift to open UI.")