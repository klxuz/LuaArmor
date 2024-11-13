repeat
    task.wait()
until game:IsLoaded()

local library
do
    local folder = "xgre"
    local services = setmetatable({}, {
        __index = function(_, service)
            if service == "InputService" then
                return game:GetService("UserInputService")
            end

            return game:GetService(service)
        end
    })

    local utility = {}

    function utility.randomstring(length)
        local str = ""
        local chars = string.split("abcdefghijklmnopqrstuvwxyz1234567890", "")

        for i = 1, length do
            local i = math.random(1, #chars)

            if not tonumber(chars[i]) then
                local uppercase = math.random(1, 2) == 2 and true or false
                str = str .. (uppercase and chars[i]:upper() or chars[i])
            else
                str = str .. chars[i]
            end
        end

        return str
    end

    function utility.create(class, properties)
        local obj = Instance.new(class)

        local forced = {
            AutoButtonColor = false
        }

        for prop, v in next, properties do
            obj[prop] = v
        end

        for prop, v in next, forced do
            pcall(function()
                obj[prop] = v
            end)
        end

        obj.Name = utility.randomstring(16)

        return obj
    end

    function utility.dragify(object, speed)
        local start, objectPosition, dragging
        speed = speed or 0
        object.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                objectPosition = object.Position
            end
        end)

        object.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        services.InputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch and dragging then
                utility.tween(object, { speed }, { Position = UDim2.new(objectPosition.X.Scale, objectPosition.X.Offset + (input.Position - start).X, objectPosition.Y.Scale, objectPosition.Y.Offset + (input.Position - start).Y) })
            end
        end)
    end

    function utility.getrgb(color)
        local r = math.floor(color.r * 255)
        local g = math.floor(color.g * 255)
        local b = math.floor(color.b * 255)

        return r, g, b
    end

    function utility.getcenter(sizeX, sizeY)
        return UDim2.new(0.5, -(sizeX / 2), 0.5, -(sizeY / 2))
    end

    function utility.table(tbl)
        tbl = tbl or {}

        local newtbl = {}

        for i, v in next, tbl do
            if type(i) == "string" then
                newtbl[i:lower()] = v
            end
        end

        return setmetatable({}, {
            __newindex = function(_, k, v)
                rawset(newtbl, k:lower(), v)
            end,

            __index = function(_, k)
                return newtbl[k:lower()]
            end
        })
    end

    function utility.tween(obj, info, properties, callback)
        local anim = services.TweenService:Create(obj, TweenInfo.new(unpack(info)), properties)
        anim:Play()

        if callback then
            anim.Completed:Connect(callback)
        end

        return anim
    end

    function utility.makevisible(obj, bool)
        if bool == false then
            local tween

            if not obj.ClassName:find("UI") then
                if obj.ClassName:find("Text") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, TextTransparency = obj.TextTransparency + 1, TextStrokeTransparency = obj.TextStrokeTransparency + 1 })
                elseif obj.ClassName:find("Image") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, ImageTransparency = obj.ImageTransparency + 1 })
                elseif obj.ClassName:find("Scrolling") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1, ScrollBarImageTransparency = obj.ScrollBarImageTransparency + 1 })
                else
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency + 1 })
                end
            end

            tween.Completed:Connect(function()
                obj.Visible = false
            end)

            for _, descendant in next, obj:GetDescendants() do
                if not descendant.ClassName:find("UI") then
                    if descendant.ClassName:find("Text") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, TextTransparency = descendant.TextTransparency + 1, TextStrokeTransparency = descendant.TextStrokeTransparency + 1 })
                    elseif descendant.ClassName:find("Image") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, ImageTransparency = descendant.ImageTransparency + 1 })
                    elseif descendant.ClassName:find("Scrolling") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1, ScrollBarImageTransparency = descendant.ScrollBarImageTransparency + 1 })
                    else
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency + 1 })
                    end
                end
            end

            return tween
        elseif bool == true then
            local tween

            if not obj.ClassName:find("UI") then
                obj.Visible = true

                if obj.ClassName:find("Text") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, TextTransparency = obj.TextTransparency - 1, TextStrokeTransparency = obj.TextStrokeTransparency - 1 })
                elseif obj.ClassName:find("Image") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, ImageTransparency = obj.ImageTransparency - 1 })
                elseif obj.ClassName:find("Scrolling") then
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1, ScrollBarImageTransparency = obj.ScrollBarImageTransparency - 1 })
                else
                    tween = utility.tween(obj, { 0.2 }, { BackgroundTransparency = obj.BackgroundTransparency - 1 })
                end
            end

            for _, descendant in next, obj:GetDescendants() do
                if not descendant.ClassName:find("UI") then
                    if descendant.ClassName:find("Text") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, TextTransparency = descendant.TextTransparency - 1, TextStrokeTransparency = descendant.TextStrokeTransparency - 1 })
                    elseif descendant.ClassName:find("Image") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, ImageTransparency = descendant.ImageTransparency - 1 })
                    elseif descendant.ClassName:find("Scrolling") then
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1, ScrollBarImageTransparency = descendant.ScrollBarImageTransparency - 1 })
                    else
                        utility.tween(descendant, { 0.2 }, { BackgroundTransparency = descendant.BackgroundTransparency - 1 })
                    end
                end
            end

            return tween
        end
    end

    function utility.updatescrolling(scrolling, list)
        return list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            scrolling.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y)
        end)
    end

    function utility.changecolor(color, amount)
        local r, g, b = utility.getrgb(color)
        r = math.clamp(r + amount, 0, 255)
        g = math.clamp(g + amount, 0, 255)
        b = math.clamp(b + amount, 0, 255)

        return Color3.fromRGB(r, g, b)
    end

    function utility.gradient(colors)
        local colortbl = {}

        for i, color in next, colors do
            table.insert(colortbl, ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color))
        end

        return ColorSequence.new(colortbl)
    end

    library = utility.table {
        flags = {},
        toggled = true,
        accent = Color3.fromRGB(87, 250, 96),
        outline = { Color3.fromRGB(125, 250, 131), Color3.fromRGB(87, 250, 96) },
        keybind = Enum.KeyCode.RightShift
    }

    local accentobjects = { gradient = {}, bg = {}, text = {} }

    function library:ChangeAccent(accent)
        library.accent = accent

        for obj, color in next, accentobjects.gradient do
            obj.Color = color(accent)
        end

        for _, obj in next, accentobjects.bg do
            obj.BackgroundColor3 = accent
        end

        for _, obj in next, accentobjects.text do
            obj.TextColor3 = accent
        end
    end

    local outlineobjs = {}

    function library:ChangeOutline(colors)
        for _, obj in next, outlineobjs do
            obj.Color = utility.gradient(colors)
        end
    end

    local gui = utility.create("ScreenGui", {})

    local flags = {}

    function library:SaveConfig(name, universal)
        local configtbl = {}
        local placeid = universal and "universal" or game.PlaceId

        for flag, _ in next, flags do
            local value = library.flags[flag]
            if typeof(value) == "EnumItem" then
                configtbl[flag] = tostring(value)
            elseif typeof(value) == "Color3" then
                configtbl[flag] = { math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255) }
            else
                configtbl[flag] = value
            end
        end

        local config = services.HttpService:JSONEncode(configtbl)
        local folderpath = string.format("%s//%s", folder, placeid)

        if not isfolder(folderpath) then
            makefolder(folderpath)
        end

        local filepath = string.format("%s//%s.json", folderpath, name)
        writefile(filepath, config)
    end

    function library:DeleteConfig(name, universal)
        local placeid = universal and "universal" or game.PlaceId

        local folderpath = string.format("%s//%s", folder, placeid)

        if isfolder(folderpath) then
            local folderpath = string.format("%s//%s", folder, placeid)
            local filepath = string.format("%s//%s.json", folderpath, name)

            delfile(filepath)
        end
    end

    function library:LoadConfig(name)
        local placeidfolder = string.format("%s//%s", folder, game.PlaceId)
        local placeidfile = string.format("%s//%s.json", placeidfolder, name)

        local filepath
        do
            if isfolder(placeidfolder) and isfile(placeidfile) then
                filepath = placeidfile
            else
                filepath = string.format("%s//universal//%s.json", folder, name)
            end
        end

        local file = readfile(filepath)
        local config = services.HttpService:JSONDecode(file)

        for flag, v in next, config do
            local func = flags[flag]
            func(v)
        end
    end

    function library:ListConfigs(universal)
        local configs = {}
        local placeidfolder = string.format("%s//%s", folder, game.PlaceId)
        local universalfolder = folder .. "//universal"

        for _, config in next, (isfolder(placeidfolder) and listfiles(placeidfolder) or {}) do
            local name = config:gsub(placeidfolder .. "\\", ""):gsub(".json", "")
            table.insert(configs, name)
        end

        if universal and isfolder(universalfolder) then
            for _, config in next, (isfolder(placeidfolder) and listfiles(placeidfolder) or {}) do
                configs[config:gsub(universalfolder .. "\\", "")] = readfile(config)
            end
        end
        return configs
    end

    function library:Watermark(options)
        local text = table.concat(options, " <font color=\"#D2D2D2\">|</font> ")

        local watermarksize = services.TextService:GetTextSize(text:gsub("<font color=\"#D2D2D2\">", ""):gsub("</font>", ""), 14, Enum.Font.Kalam, Vector2.new(1000, 1000)).X + 16

        local watermark = utility.create("TextLabel", {
            ZIndex = 2,
            Size = UDim2.new(0, watermarksize, 0, 20),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            Position = UDim2.new(0, 10, 0, 10),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            FontSize = Enum.FontSize.Size14,
            TextStrokeTransparency = 0,
            TextSize = 16,
            RichText = true,
            TextColor3 = library.accent,
            Text = text,
            Font = Enum.Font.Kalam,
            Parent = gui
        })

        table.insert(accentobjects.text, watermark)

        utility.create("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            Parent = watermark
        })

        local outline = utility.create("Frame", {
            Size = UDim2.new(1, 2, 1, 4),
            BorderColor3 = Color3.fromRGB(45, 45, 45),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = watermark
        })

        utility.create("Frame", {
            ZIndex = 0,
            Size = UDim2.new(1, 2, 1, 2),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = outline
        })

        local outlinegradient = utility.create("UIGradient", {
            Rotation = 45,
            Color = utility.gradient(library.outline),
            Parent = outline
        })

        table.insert(outlineobjs, outlinegradient)

        local watermarktypes = utility.table()

        function watermarktypes:Update(options)
            local text = table.concat(options, " <font color=\"#D2D2D2\">|</font> ")
            local watermarksize = services.TextService:GetTextSize(text:gsub("<font color=\"#D2D2D2\">", ""):gsub("</font>", ""), 14, Enum.Font.Kalam, Vector2.new(1000, 1000)).X + 16

            watermark.Size = UDim2.new(0, watermarksize, 0, 20)
            watermark.Text = text
        end

        local toggling = false
        local toggled = true

        function watermarktypes:Toggle()
            if not toggling then
                toggling = true

                toggled = not toggled
                local tween = utility.makevisible(watermark, toggled)
                tween.Completed:Wait()

                toggling = false
            end
        end

        return watermarktypes
    end

    function library:New(options)
        options = utility.table(options)
        local name = options.name
        local accent = options.accent or library.accent
        local outlinecolor = options.outline or { accent, utility.changecolor(accent, -100) }
        local sizeX = options.sizeX or 400
        local sizeY = options.sizeY or 620

        library.accent = accent
        library.outline = outlinecolor

        local holder = utility.create("Frame", {
            Size = UDim2.new(0, sizeX, 0, 24),
            BackgroundTransparency = 1,
            Position = utility.getcenter(sizeX, sizeY),
            Parent = gui
        })

        local toggling = false
        function library:Toggle()
            if not toggling then
                toggling = true

                library.toggled = not library.toggled
                local tween = utility.makevisible(holder, library.toggled)
                tween.Completed:Wait()

                toggling = false
            end
        end

        utility.dragify(holder)

        local title = utility.create("TextLabel", {
            ZIndex = 5,
            Size = UDim2.new(0, 0, 1, -2),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 12, 0, 0),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            FontSize = Enum.FontSize.Size14,
            TextStrokeTransparency = 0,
            TextSize = 16,
            TextColor3 = library.accent,
            Text = name,
            Font = Enum.Font.Kalam,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = holder
        })

        table.insert(accentobjects.text, title)

        local main = utility.create("Frame", {
            ZIndex = 2,
            Size = UDim2.new(1, 0, 0, sizeY),
            BorderColor3 = Color3.fromRGB(27, 42, 53),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = holder
        })

        local outline = utility.create("Frame", {
            Size = UDim2.new(1, 2, 1, 2),
            BorderColor3 = Color3.fromRGB(45, 45, 45),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = main
        })

        local outlinegradient = utility.create("UIGradient", {
            Rotation = 45,
            Color = utility.gradient(library.outline),
            Parent = outline
        })

        table.insert(outlineobjs, outlinegradient)

        local border = utility.create("Frame", {
            ZIndex = 0,
            Size = UDim2.new(1, 2, 1, 2),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
            Parent = outline
        })

        local tabs = utility.create("Frame", {
            ZIndex = 4,
            Size = UDim2.new(1, -16, 1, -30),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            Position = UDim2.new(0, 8, 0, 22),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = main
        })

        utility.create("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(25, 25, 25), Color3.fromRGB(20, 20, 20)),
            Parent = tabs
        })

        utility.create("Frame", {
            ZIndex = 3,
            Size = UDim2.new(1, 2, 1, 2),
            Position = UDim2.new(0, -1, 0, -1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = tabs
        })

        local tabtoggles = utility.create("Frame", {
            Size = UDim2.new(0, 395, 0, 22),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = tabs
        })

        utility.create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 4),
            Parent = tabtoggles
        })

        local tabframes = utility.create("Frame", {
            ZIndex = 5,
            Size = UDim2.new(1, -12, 1, -35),
            BorderColor3 = Color3.fromRGB(50, 50, 50),
            Position = UDim2.new(0, 6, 0, 29),
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            Parent = tabs
        })

        local tabholder = utility.create("Frame", {
            Size = UDim2.new(1, -16, 1, -16),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = tabframes
        })

        local windowtypes = utility.table()

        local pagetoggles = {}

        local switchingtabs = false

        local firsttab
        local currenttab

        function windowtypes:Page(options)
            options = utility.table(options)
            local name = options.name

            local first = #tabtoggles:GetChildren() == 1

            local togglesizeX = math.clamp(services.TextService:GetTextSize(name, 14, Enum.Font.Kalam, Vector2.new(1000, 1000)).X, 25, math.huge)

            local tabtoggle = utility.create("TextButton", {
                Size = UDim2.new(0, togglesizeX + 18, 1, 0),
                BackgroundTransparency = 1,
                FontSize = Enum.FontSize.Size14,
                TextSize = 16,
                Parent = tabtoggles
            })

            local antiborder = utility.create("Frame", {
                ZIndex = 6,
                Visible = first,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Parent = tabtoggle
            })

            local selectedglow = utility.create("Frame", {
                ZIndex = 6,
                Size = UDim2.new(1, 0, 0, 1),
                Visible = first,
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                BorderSizePixel = 0,
                BackgroundColor3 = library.accent,
                Parent = tabtoggle
            })

            table.insert(accentobjects.bg, selectedglow)

            utility.create("Frame", {
                ZIndex = 7,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                Parent = selectedglow
            })

            local titleholder = utility.create("Frame", {
                ZIndex = 6,
                Size = UDim2.new(1, 0, 1, first and -1 or -4),
                BorderColor3 = Color3.fromRGB(50, 50, 50),
                Position = UDim2.new(0, 0, 0, first and 1 or 4),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = tabtoggle
            })

            local title = utility.create("TextLabel", {
                ZIndex = 7,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                FontSize = Enum.FontSize.Size14,
                TextStrokeTransparency = 0,
                TextSize = 16,
                TextColor3 = first and library.accent or Color3.fromRGB(110, 110, 110),
                Text = name,
                Font = Enum.Font.Kalam,
                Parent = titleholder
            })

            if first then
                table.insert(accentobjects.text, title)
            end

            local tabglowgradient = utility.create("UIGradient", {
                Rotation = 90,
                Color = first and utility.gradient { utility.changecolor(library.accent, -30), Color3.fromRGB(25, 25, 25) } or utility.gradient { Color3.fromRGB(22, 22, 22), Color3.fromRGB(22, 22, 22) },
                Offset = Vector2.new(0, -0.55),
                Parent = titleholder
            })

            if first then
                accentobjects.gradient[tabglowgradient] = function(color)
                    return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(25, 25, 25) }
                end
            end

            local tabtoggleborder = utility.create("Frame", {
                ZIndex = 5,
                Size = UDim2.new(1, 2, 1, 2),
                Position = UDim2.new(0, -1, 0, -1),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                Parent = title
            })

            pagetoggles[tabtoggle] = {}
            pagetoggles[tabtoggle] = function()
                utility.tween(antiborder, { 0.2 }, { BackgroundTransparency = 1 }, function()
                    antiborder.Visible = false
                end)

                utility.tween(selectedglow, { 0.2 }, { BackgroundTransparency = 1 }, function()
                    selectedglow.Visible = false
                end)

                utility.tween(titleholder, { 0.2 }, { Size = UDim2.new(1, 0, 1, -4), Position = UDim2.new(0, 0, 0, 4) })

                utility.tween(title, { 0.2 }, { TextColor3 = Color3.fromRGB(110, 110, 110) })
                if table.find(accentobjects.text, title) then
                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                end

                tabglowgradient.Color = utility.gradient { Color3.fromRGB(22, 22, 22), Color3.fromRGB(22, 22, 22) }

                if accentobjects.gradient[tabglowgradient] then
                    accentobjects.gradient[tabglowgradient] = function() end
                end
            end

            local tab = utility.create("Frame", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = first and 1 or 2,
                Visible = first,
                Parent = tabholder
            })

            if first then
                currenttab = tab
                firsttab = tab
            end

            tab.DescendantAdded:Connect(function(descendant)
                if tab ~= currenttab then
                    task.wait()
                    if not descendant.ClassName:find("UI") then
                        if descendant.ClassName:find("Text") then
                            descendant.TextTransparency = descendant.TextTransparency + 1
                            descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                        end

                        if descendant.ClassName:find("Scrolling") then
                            descendant.ScrollBarImageTransparency = descendant.ScrollBarImageTransparency + 1
                        end

                        descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                    end
                end
            end)

            local column1 = utility.create("ScrollingFrame", {
                Size = UDim2.new(0.5, -5, 1, 0),
                BackgroundTransparency = 1,
                Active = true,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 123),
                ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                ScrollBarThickness = 0,
                Parent = tab
            })

            local column1list = utility.create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = column1
            })

            utility.updatescrolling(column1, column1list)

            local column2 = utility.create("ScrollingFrame", {
                Size = UDim2.new(0.5, -5, 1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 7, 0, 0),
                Active = true,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
                ScrollBarThickness = 0,
                Parent = tab
            })

            local column2list = utility.create("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 10),
                Parent = column2
            })

            utility.updatescrolling(column2, column2list)

            local function opentab()
                if not switchingtabs then
                    switchingtabs = true

                    currenttab = tab

                    for toggle, close in next, pagetoggles do
                        if toggle ~= tabtoggle then
                            close()
                        end
                    end

                    for _, obj in next, tabholder:GetChildren() do
                        if obj ~= tab and obj.BackgroundTransparency <= 1 then
                            utility.makevisible(obj, false)
                        end
                    end

                    antiborder.Visible = true
                    utility.tween(antiborder, { 0.2 }, { BackgroundTransparency = 0 })

                    selectedglow.Visible = true
                    utility.tween(selectedglow, { 0.2 }, { BackgroundTransparency = 0 })

                    utility.tween(titleholder, { 0.2 }, { Size = UDim2.new(1, 0, 1, -1), Position = UDim2.new(0, 0, 0, 1) })

                    utility.tween(title, { 0.2 }, { TextColor3 = library.accent })

                    table.insert(accentobjects.text, title)

                    tabglowgradient.Color = utility.gradient { utility.changecolor(library.accent, -30), Color3.fromRGB(25, 25, 25) }

                    accentobjects.gradient[tabglowgradient] = function(color)
                        return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(25, 25, 25) }
                    end

                    tab.Visible = true
                    if tab.BackgroundTransparency > 1 then
                        task.wait(0.2)

                        local tween = utility.makevisible(tab, true)
                        tween.Completed:Wait()
                    end

                    switchingtabs = false
                end
            end

            tabtoggle.MouseButton1Click:Connect(opentab)

            local pagetypes = utility.table()

            function pagetypes:Section(options)
                options = utility.table(options)
                local name = options.name
                local side = options.side or "left"
                local max = options.max or math.huge
                local column = (side:lower() == "left" and column1) or (side:lower() == "right" and column2)

                local sectionholder = utility.create("Frame", {
                    Size = UDim2.new(1, -1, 0, 28),
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = column
                })

                local section = utility.create("Frame", {
                    ZIndex = 6,
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    Position = UDim2.new(0, 1, 0, 1),
                    BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                    Parent = sectionholder
                })

                local title = utility.create("TextLabel", {
                    ZIndex = 8,
                    Size = UDim2.new(0, 0, 0, 14),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 3),
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    FontSize = Enum.FontSize.Size14,
                    TextStrokeTransparency = 0,
                    TextSize = 16,
                    TextColor3 = library.accent,
                    Text = name,
                    Font = Enum.Font.Kalam,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = section
                })

                table.insert(accentobjects.text, title)

                local glow = utility.create("Frame", {
                    ZIndex = 8,
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderColor3 = Color3.fromRGB(50, 50, 50),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                    Parent = section
                })

                table.insert(accentobjects.bg, glow)

                utility.create("Frame", {
                    ZIndex = 9,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                    Parent = glow
                })

                local fade = utility.create("Frame", {
                    ZIndex = 7,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = glow
                })

                local fadegradient = utility.create("UIGradient", {
                    Rotation = 90,
                    Color = utility.gradient { Color3.fromRGB(48, 48, 48), Color3.fromRGB(22, 22, 22) },
                    Offset = Vector2.new(0, -0.55),
                    Parent = fade
                })

                accentobjects.gradient[fadegradient] = function(color)
                    return utility.gradient { utility.changecolor(color, -30), Color3.fromRGB(22, 22, 22) }
                end

                local sectioncontent = utility.create("ScrollingFrame", {
                    ZIndex = 7,
                    Size = UDim2.new(1, -7, 1, -26),
                    BorderColor3 = Color3.fromRGB(27, 42, 53),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 20),
                    Active = true,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    CanvasSize = UDim2.new(0, 0, 0, 1),
                    ScrollBarThickness = 2,
                    Parent = section
                })

                local sectionlist = utility.create("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                    Parent = sectioncontent
                })

                utility.updatescrolling(sectioncontent, sectionlist)

                local sectiontypes = utility.table()

                function sectiontypes:Label(options)
                    options = utility.table(options)
                    local name = options.name

                    utility.create("TextLabel", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 0, 0, 13),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 6, 0, 3),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = sectioncontent
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end
                end

                function sectiontypes:Button(options)
                    options = utility.table(options)
                    local name = options.name
                    local callback = options.callback

                    local buttonholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 17),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local button = utility.create("TextButton", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 1, -4),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        Parent = buttonholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(34, 34, 34),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = button
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = bg
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = button
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    button.MouseButton1Click:Connect(callback)

                    button.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            bggradient.Color = utility.gradient { Color3.fromRGB(45, 45, 45), Color3.fromRGB(35, 35, 35) }
                        end
                    end)

                    button.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            bggradient.Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) }
                        end
                    end)

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end
                end

                function sectiontypes:Toggle(options)
                    options = utility.table(options)
                    local name = options.name
                    local default = options.default
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local toggleholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 16,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = sectioncontent
                    })

                    local togglething = utility.create("TextButton", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 0, 14),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        TextTransparency = 1,
                        Parent = toggleholder
                    })

                    local icon = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(0, 10, 0, 10),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = icon
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = icon
                    })

                    local enablediconholder = utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = icon
                    })

                    local enabledicongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = enablediconholder
                    })

                    accentobjects.gradient[enabledicongradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = toggleholder
                    })

                    local toggled = false

                    if flag then
                        library.flags[flag] = toggled
                    end

                    local function toggle()
                        if not switchingtabs then
                            toggled = not toggled

                            if flag then
                                library.flags[flag] = toggled
                            end

                            callback(toggled)

                            local enabledtransparency = toggled and 0 or 1
                            utility.tween(enablediconholder, { 0.2 }, { Transparency = enabledtransparency })

                            local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                            utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                            if toggled then
                                table.insert(accentobjects.text, title)
                            elseif table.find(accentobjects.text, title) then
                                table.remove(accentobjects.text, table.find(accentobjects.text, title))
                            end
                        end
                    end

                    togglething.MouseButton1Click:Connect(toggle)

                    local function set(bool)
                        if type(bool) == "boolean" and toggled ~= bool then
                            toggle()
                        end
                    end

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local toggletypes = utility.table()

                    function toggletypes:Toggle(bool)
                        set(bool)
                    end

                    function toggletypes:Colorpicker(newoptions)
                        newoptions = utility.table(newoptions)
                        local name = newoptions.name
                        local default = newoptions.default or Color3.fromRGB(255, 255, 255)
                        local colorpickertype = newoptions.mode
                        local toggleflag = colorpickertype and colorpickertype:lower() == "toggle" and newoptions.togglepointer
                        local togglecallback = colorpickertype and colorpickertype:lower() == "toggle" and newoptions.togglecallback or function() end
                        local flag = newoptions.pointer
                        local callback = newoptions.callback or function() end

                        local colorpickerframe = utility.create("Frame", {
                            ZIndex = 9,
                            Size = UDim2.new(1, -70, 0, 148),
                            Position = UDim2.new(1, -168, 0, 18),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Visible = false,
                            Parent = toggleholder
                        })

                        colorpickerframe.DescendantAdded:Connect(function(descendant)
                            if not opened then
                                task.wait()
                                if not descendant.ClassName:find("UI") then
                                    if descendant.ClassName:find("Text") then
                                        descendant.TextTransparency = descendant.TextTransparency + 1
                                        descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                    end

                                    if descendant.ClassName:find("Image") then
                                        descendant.ImageTransparency = descendant.ImageTransparency + 1
                                    end

                                    descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                                end
                            end
                        end)

                        local bggradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 8,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = colorpickerframe
                        })

                        local blackborder = utility.create("Frame", {
                            ZIndex = 7,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local saturationframe = utility.create("ImageLabel", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 128, 0, 100),
                            BorderColor3 = Color3.fromRGB(50, 50, 50),
                            Position = UDim2.new(0, 6, 0, 6),
                            BorderSizePixel = 0,
                            BackgroundColor3 = default,
                            Image = "http://www.roblox.com/asset/?id=8630797271",
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = saturationframe
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local saturationpicker = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(0, 2, 0, 2),
                            BorderColor3 = Color3.fromRGB(10, 10, 10),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = saturationframe
                        })

                        local hueframe = utility.create("ImageLabel", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 14, 0, 100),
                            Position = UDim2.new(1, -20, 0, 6),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 193, 49),
                            ScaleType = Enum.ScaleType.Crop,
                            Image = "http://www.roblox.com/asset/?id=8630799159",
                            Parent = colorpickerframe
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = hueframe
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local huepicker = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(1, 0, 0, 1),
                            BorderColor3 = Color3.fromRGB(10, 10, 10),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = hueframe
                        })

                        local boxholder = utility.create("Frame", {
                            Size = UDim2.new(1, -8, 0, 17),
                            ClipsDescendants = true,
                            Position = UDim2.new(0, 4, 0, 110),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = colorpickerframe
                        })

                        local box = utility.create("TextBox", {
                            ZIndex = 13,
                            Size = UDim2.new(1, -4, 1, -4),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 2, 0, 2),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextStrokeTransparency = 0,
                            TextSize = 15,
                            TextColor3 = Color3.fromRGB(210, 210, 210),
                            Text = table.concat({ utility.getrgb(default) }, ", "),
                            PlaceholderText = "R, G, B",
                            Font = Enum.Font.Kalam,
                            Parent = boxholder
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = box
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local bg = utility.create("Frame", {
                            ZIndex = 12,
                            Size = UDim2.new(1, 0, 1, 0),
                            BorderColor3 = Color3.fromRGB(35, 35, 35),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = box
                        })

                        utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = bg
                        })

                        local rainbowtoggleholder = utility.create("TextButton", {
                            Size = UDim2.new(1, -8, 0, 14),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 4, 0, 130),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextSize = 16,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            Font = Enum.Font.SourceSans,
                            Parent = colorpickerframe
                        })

                        local toggleicon = utility.create("Frame", {
                            ZIndex = 12,
                            Size = UDim2.new(0, 10, 0, 10),
                            BorderColor3 = Color3.fromRGB(35, 35, 35),
                            Position = UDim2.new(0, 2, 0, 2),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = rainbowtoggleholder
                        })

                        local enablediconholder = utility.create("Frame", {
                            ZIndex = 13,
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = toggleicon
                        })

                        local enabledicongradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                            Parent = enablediconholder
                        })

                        accentobjects.gradient[enabledicongradient] = function(color)
                            return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                        end

                        local grayborder = utility.create("Frame", {
                            ZIndex = 11,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = toggleicon
                        })

                        utility.create("Frame", {
                            ZIndex = 10,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                            Parent = toggleicon
                        })

                        local rainbowtxt = utility.create("TextLabel", {
                            ZIndex = 10,
                            Size = UDim2.new(0, 0, 1, 0),
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 20, 0, 0),
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextStrokeTransparency = 0,
                            TextSize = 15,
                            TextColor3 = Color3.fromRGB(180, 180, 180),
                            Text = "Rainbow",
                            Font = Enum.Font.Kalam,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = rainbowtoggleholder
                        })

                        local colorpicker = utility.create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 14),
                            BackgroundTransparency = 1,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            FontSize = Enum.FontSize.Size14,
                            TextSize = 16,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            Font = Enum.Font.SourceSans,
                            Parent = toggleholder
                        })

                        local icon = utility.create("TextButton", {
                            ZIndex = 9,
                            Size = UDim2.new(0, 18, 0, 10),
                            BorderColor3 = Color3.fromRGB(35, 35, 35),
                            Position = UDim2.new(1, -20, 0, 2),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = colorpicker,
                            Text = ""
                        })

                        local grayborder = utility.create("Frame", {
                            ZIndex = 8,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = icon
                        })

                        utility.create("Frame", {
                            ZIndex = 7,
                            Size = UDim2.new(1, 2, 1, 2),
                            Position = UDim2.new(0, -1, 0, -1),
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                            Parent = grayborder
                        })

                        local icongradient = utility.create("UIGradient", {
                            Rotation = 90,
                            Color = utility.gradient { default, utility.changecolor(default, -200) },
                            Parent = icon
                        })

                        if #sectioncontent:GetChildren() - 1 <= max then
                            sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                        end

                        local colorpickertypes = utility.table()

                        local opened = false
                        local opening = false

                        local function opencolorpicker()
                            if not opening then
                                opening = true

                                opened = not opened

                                if opened then
                                    utility.tween(toggleholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 168) })
                                end

                                local tween = utility.makevisible(colorpickerframe, opened)

                                tween.Completed:Wait()

                                if not opened then
                                    local tween = utility.tween(toggleholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 16) })
                                    tween.Completed:Wait()
                                end

                                opening = false
                            end
                        end

                        icon.MouseButton1Click:Connect(opencolorpicker)

                        local hue, sat, val = default:ToHSV()

                        local slidinghue = false
                        local slidingsaturation = false

                        local hsv = Color3.fromHSV(hue, sat, val)

                        if flag then
                            library.flags[flag] = default
                        end

                        local function updatehue(input)
                            local sizeY = 1 - math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
                            local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y, 0, hueframe.AbsoluteSize.Y - 2)
                            huepicker.Position = UDim2.new(0, 0, 0, posY)

                            hue = sizeY
                            hsv = Color3.fromHSV(sizeY, sat, val)

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        hueframe.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidinghue = true
                                updatehue(input)
                            end
                        end)

                        hueframe.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidinghue = false
                            end
                        end)

                        services.InputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                if slidinghue then
                                    updatehue(input)
                                end
                            end
                        end)

                        local function updatesatval(input)
                            local sizeX = math.clamp((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X, 0, 1)
                            local sizeY = 1 - math.clamp((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y, 0, 1)
                            local posY = math.clamp(((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)
                            local posX = math.clamp(((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X) * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)

                            saturationpicker.Position = UDim2.new(0, posX, 0, posY)

                            sat = sizeX
                            val = sizeY
                            hsv = Color3.fromHSV(hue, sizeX, sizeY)

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        saturationframe.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidingsaturation = true
                                updatesatval(input)
                            end
                        end)

                        saturationframe.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                slidingsaturation = false
                            end
                        end)

                        services.InputService.InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                if slidingsaturation then
                                    updatesatval(input)
                                end
                            end
                        end)

                        local function set(color)
                            if type(color) == "table" then
                                color = Color3.fromRGB(unpack(color))
                            end

                            hue, sat, val = color:ToHSV()
                            hsv = Color3.fromHSV(hue, sat, val)

                            saturationframe.BackgroundColor3 = hsv
                            icon.BackgroundColor3 = hsv
                            saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)), 0, (math.clamp((1 - val) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)))
                            huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4))

                            box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                            if flag then
                                library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                            end

                            callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                        end

                        local toggled = false

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggled then
                                    task.spawn(function()
                                        while toggled do
                                            for i = 0, 1, 0.0015 do
                                                if not toggled then
                                                    return
                                                end

                                                local color = Color3.fromHSV(i, 1, 1)
                                                set(color)

                                                task.wait()
                                            end
                                        end
                                    end)
                                end

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enablediconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(rainbowtxt, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        rainbowtoggleholder.MouseButton1Click:Connect(toggle)

                        box.FocusLost:Connect(function()
                            local _, amount = box.Text:gsub(", ", "")

                            if amount == 2 then
                                local values = box.Text:split(", ")
                                local r, g, b = math.clamp(values[1], 0, 255), math.clamp(values[2], 0, 255), math.clamp(values[3], 0, 255)
                                set(Color3.fromRGB(r, g, b))
                            else
                                rgb.Text = math.floor((hsv.r * 255) + 0.5) .. ", " .. math.floor((hsv.g * 255) + 0.5) .. ", " .. math.floor((hsv.b * 255) + 0.5)
                            end
                        end)

                        if default then
                            set(default)
                        end

                        if flag then
                            flags[flag] = set
                        end

                        local colorpickertypes = utility.table()

                        function colorpickertypes:Set(color)
                            set(color)
                        end
                    end

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    return toggletypes
                end

                function sectiontypes:Box(options)
                    options = utility.table(options)
                    local name = options.name
                    local placeholder = options.placeholder or ""
                    local default = options.default
                    local boxtype = options.type or "string"
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local boxholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 32),
                        ClipsDescendants = true,
                        BorderColor3 = Color3.fromRGB(27, 42, 53),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = boxholder
                    })

                    local box = utility.create("TextBox", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 17),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = "",
                        PlaceholderText = placeholder,
                        Font = Enum.Font.Kalam,
                        Parent = boxholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = box
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = box
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    if flag then
                        library.flags[flag] = default or ""
                    end

                    local function set(str)
                        if boxtype:lower() == "number" then
                            str = str:gsub("%D+", "")
                        end

                        box.Text = str

                        if flag then
                            library.flags[flag] = str
                        end

                        callback(str)
                    end

                    if default then
                        set(default)
                    end

                    if boxtype:lower() == "number" then
                        box:GetPropertyChangedSignal("Text"):Connect(function()
                            box.Text = box.Text:gsub("%D+", "")
                        end)
                    end

                    box.FocusLost:Connect(function()
                        set(box.Text)
                    end)

                    if flag then
                        flags[flag] = set
                    end

                    local boxtypes = utility.table()

                    function boxtypes:Set(str)
                        set(str)
                    end

                    return boxtypes
                end

                function sectiontypes:Slider(options)
                    options = utility.table(options)
                    local name = options.name
                    local min = options.minimum or 0
                    local slidermax = options.maximum or 100
                    local valuetext = options.value or "[value]/" .. slidermax
                    local increment = options.decimals or 0.5
                    local default = options.default and math.clamp(options.default, min, slidermax) or min
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local sliderholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 28),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local slider = utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 9),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 1, -11),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sliderholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = slider
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = slider
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local fill = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new((default - min) / (slidermax - min), 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = slider
                    })

                    local fillgradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = fill
                    })

                    accentobjects.gradient[fillgradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local valuelabel = utility.create("TextLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = valuetext:gsub("%[value%]", tostring(default)),
                        Font = Enum.Font.Kalam,
                        Parent = slider
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = sliderholder
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local sliding = false

                    local function slide(input)
                        local sizeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        local newincrement = (slidermax / ((slidermax - min) / (increment * 4)))
                        local newsizeX = math.floor(sizeX * (((slidermax - min) / newincrement) * 4)) / (((slidermax - min) / newincrement) * 4)

                        utility.tween(fill, { newincrement / 80 }, { Size = UDim2.new(newsizeX, 0, 1, 0) })

                        local value = math.floor((newsizeX * (slidermax - min) + min) * 20) / 20
                        valuelabel.Text = valuetext:gsub("%[value%]", tostring(value))

                        if flag then
                            library.flags[flag] = value
                        end

                        callback(value)
                    end

                    slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = true
                            slide(input)
                        end
                    end)

                    slider.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            sliding = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            if sliding then
                                slide(input)
                            end
                        end
                    end)

                    local function set(value)
                        value = math.clamp(value, min, slidermax)

                        local sizeX = ((value - min)) / (slidermax - min)
                        local newincrement = (slidermax / ((slidermax - min) / (increment * 4)))

                        local newsizeX = math.floor(sizeX * (((slidermax - min) / newincrement) * 4)) / (((slidermax - min) / newincrement) * 4)
                        value = math.floor((newsizeX * (slidermax - min) + min) * 20) / 20

                        fill.Size = UDim2.new(newsizeX, 0, 1, 0)
                        valuelabel.Text = valuetext:gsub("%[value%]", tostring(value))

                        if flag then
                            library.flags[flag] = value
                        end

                        callback(value)
                    end

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local slidertypes = utility.table()

                    function slidertypes:Set(value)
                        set(value)
                    end

                    return slidertypes
                end

                function sectiontypes:Dropdown(options)
                    options = utility.table(options)
                    local name = options.name
                    local content = options["options"]
                    local maxoptions = options.maximum and (options.maximum > 1 and options.maximum)
                    local default = options.default or maxoptions and {}
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    if maxoptions then
                        for i, def in next, default do
                            if not table.find(content, def) then
                                table.remove(default, i)
                            end
                        end
                    else
                        if not table.find(content, default) then
                            default = nil
                        end
                    end

                    local defaulttext = default and ((type(default) == "table" and table.concat(default, ", ")) or default)

                    local opened = false

                    local dropdownholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 32),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = sectioncontent
                    })

                    local dropdown = utility.create("TextButton", {
                        ZIndex = 10,
                        Size = UDim2.new(1, -4, 0, 13),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 17),
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = default and (defaulttext ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(120, 120, 120)) or Color3.fromRGB(120, 120, 120),
                        Text = default and (defaulttext ~= "" and defaulttext or "NONE") or "NONE",
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownholder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, 6, 1, 0),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(0, -6, 0, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = dropdown
                    })

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = bg
                    })

                    local textpadding = utility.create("UIPadding", {
                        PaddingLeft = UDim.new(0, 6),
                        Parent = dropdown
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 8, 1, 2),
                        Position = UDim2.new(0, -7, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = dropdown
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icon = utility.create("TextLabel", {
                        ZIndex = 11,
                        Size = UDim2.new(0, 13, 1, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -13, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size12,
                        TextStrokeTransparency = 0,
                        TextSize = 12,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = "+",
                        Font = Enum.Font.Gotham,
                        Parent = dropdown
                    })

                    utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 13),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownholder
                    })

                    local contentframe = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, -4, 1, -38),
                        Position = UDim2.new(0, 2, 0, 36),
                        BorderSizePixel = 0,
                        Visible = false,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = dropdownholder
                    })

                    local opened = false
                    contentframe.DescendantAdded:Connect(function(descendant)
                        if not opened then
                            task.wait()
                            if not descendant.ClassName:find("UI") then
                                if descendant.ClassName:find("Text") then
                                    descendant.TextTransparency = descendant.TextTransparency + 1
                                    descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                end

                                descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                            end
                        end
                    end)

                    local contentframegradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                        Parent = contentframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = contentframe
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local dropdowncontent = utility.create("Frame", {
                        Size = UDim2.new(1, -2, 1, -2),
                        Position = UDim2.new(0, 1, 0, 1),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = contentframe
                    })

                    local dropdowncontentlist = utility.create("UIListLayout", {
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Padding = UDim.new(0, 2),
                        Parent = dropdowncontent
                    })

                    local option = utility.create("TextButton", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 0, 16),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
                        AutoButtonColor = false,
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                        Text = "",
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left
                    })

                    utility.create("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = option
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local opening = false

                    local function opendropdown()
                        if not opening then
                            opening = true

                            opened = not opened

                            utility.tween(icon, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                icon.Text = opened and "-" or "+"
                            end)

                            if opened then
                                utility.tween(dropdownholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, dropdowncontentlist.AbsoluteContentSize.Y + 40) })
                            end

                            local tween = utility.makevisible(contentframe, opened)

                            tween.Completed:Wait()

                            if not opened then
                                local tween = utility.tween(dropdownholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 32) })
                                tween.Completed:Wait()
                            end

                            utility.tween(icon, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0 })

                            opening = false
                        end
                    end

                    dropdown.MouseButton1Click:Connect(opendropdown)

                    local chosen = maxoptions and {}
                    local choseninstances = {}
                    local optioninstances = {}

                    if flag then
                        library.flags[flag] = default
                    end

                    for _, opt in next, content do
                        if not maxoptions then
                            local optionbtn = option:Clone()
                            optionbtn.Parent = dropdowncontent
                            optionbtn.Text = opt

                            optioninstances[opt] = optionbtn

                            if default == opt then
                                chosen = opt
                                optionbtn.BackgroundTransparency = 0
                                optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                            end

                            optionbtn.MouseButton1Click:Connect(function()
                                if chosen ~= opt then
                                    for _, optbtn in next, dropdowncontent:GetChildren() do
                                        if optbtn ~= optionbtn and optbtn:IsA("TextButton") then
                                            utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        end
                                    end

                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = opt
                                    end)

                                    chosen = opt

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    if flag then
                                        library.flags[flag] = opt
                                    end

                                    callback(opt)
                                else
                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = "NONE"
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    chosen = nil

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    callback(nil)
                                end
                            end)
                        else
                            local optionbtn = option:Clone()
                            optionbtn.Parent = dropdowncontent
                            optionbtn.Text = opt

                            optioninstances[opt] = optionbtn

                            if table.find(default, opt) then
                                chosen = opt
                                optionbtn.BackgroundTransparency = 0
                                optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                            end

                            optionbtn.MouseButton1Click:Connect(function()
                                if not table.find(chosen, opt) then
                                    if #chosen >= maxoptions then
                                        table.remove(chosen, 1)
                                        utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        table.remove(choseninstances, 1)
                                    end

                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    table.insert(chosen, opt)
                                    table.insert(choseninstances, optionbtn)

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = table.concat(chosen, ", ")
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                    if flag then
                                        library.flags[flag] = chosen
                                    end

                                    callback(chosen)
                                else
                                    utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                    table.remove(chosen, table.find(chosen, opt))
                                    table.remove(choseninstances, table.find(choseninstances, optionbtn))

                                    local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                        dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                    end)

                                    tween.Completed:Wait()

                                    utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                    if flag then
                                        library.flags[flag] = chosen
                                    end

                                    callback(chosen)
                                end
                            end)
                        end
                    end

                    local function set(opt)
                        if not maxoptions then
                            if optioninstances[opt] then
                                for _, optbtn in next, dropdowncontent:GetChildren() do
                                    if optbtn ~= optioninstances[opt] and optbtn:IsA("TextButton") then
                                        utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    end
                                end

                                utility.tween(optioninstances[opt], { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = opt
                                end)

                                chosen = opt

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                if flag then
                                    library.flags[flag] = opt
                                end

                                callback(opt)
                            else
                                for _, optbtn in next, dropdowncontent:GetChildren() do
                                    if optbtn:IsA("TextButton") then
                                        utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                    end
                                end

                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = "NONE"
                                end)

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                chosen = nil

                                if flag then
                                    library.flags[flag] = nil
                                end

                                callback(nil)
                            end
                        else
                            table.clear(chosen)
                            table.clear(choseninstances)

                            if not opt then
                                local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                    dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                end)

                                tween.Completed:Wait()

                                utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                if flag then
                                    library.flags[flag] = chosen
                                end

                                callback(chosen)
                            else
                                for _, opti in next, opt do
                                    if optioninstances[opti] then
                                        if #chosen >= maxoptions then
                                            table.remove(chosen, 1)
                                            utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            table.remove(choseninstances, 1)
                                        end

                                        utility.tween(optioninstances[opti], { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if not table.find(chosen, opti) then
                                            table.insert(chosen, opti)
                                        end

                                        if not table.find(choseninstances, opti) then
                                            table.insert(choseninstances, optioninstances[opti])
                                        end

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ")
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    end
                                end
                            end
                        end
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local dropdowntypes = utility.table()

                    function dropdowntypes:Set(option)
                        set(option)
                    end

                    function dropdowntypes:Refresh(content)
                        if maxoptions then
                            table.clear(chosen)
                        end

                        table.clear(choseninstances)
                        table.clear(optioninstances)

                        for _, optbtn in next, dropdowncontent:GetChildren() do
                            if optbtn:IsA("TextButton") then
                                optbtn:Destroy()
                            end
                        end

                        set()

                        for _, opt in next, content do
                            if not maxoptions then
                                local optionbtn = option:Clone()
                                optionbtn.Parent = dropdowncontent
                                optionbtn.BackgroundTransparency = 2
                                optionbtn.Text = opt
                                optionbtn.TextTransparency = 1
                                optionbtn.TextStrokeTransparency = 1

                                optioninstances[opt] = optionbtn

                                optionbtn.MouseButton1Click:Connect(function()
                                    if chosen ~= opt then
                                        for _, optbtn in next, dropdowncontent:GetChildren() do
                                            if optbtn ~= optionbtn and optbtn:IsA("TextButton") then
                                                utility.tween(optbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            end
                                        end

                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = opt
                                        end)

                                        chosen = opt

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = opt
                                        end

                                        callback(opt)
                                    else
                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = "NONE"
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                        chosen = nil

                                        if flag then
                                            library.flags[flag] = nil
                                        end

                                        callback(nil)
                                    end
                                end)
                            else
                                local optionbtn = option:Clone()
                                optionbtn.Parent = dropdowncontent
                                optionbtn.Text = opt

                                optioninstances[opt] = optionbtn

                                if table.find(default, opt) then
                                    chosen = opt
                                    optionbtn.BackgroundTransparency = 0
                                    optionbtn.TextColor3 = Color3.fromRGB(210, 210, 210)
                                end

                                optionbtn.MouseButton1Click:Connect(function()
                                    if not table.find(chosen, opt) then
                                        if #chosen >= maxoptions then
                                            table.remove(chosen, 1)
                                            utility.tween(choseninstances[1], { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })
                                            table.remove(choseninstances, 1)
                                        end

                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        table.insert(chosen, opt)
                                        table.insert(choseninstances, optionbtn)

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ")
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = Color3.fromRGB(210, 210, 210) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    else
                                        utility.tween(optionbtn, { 0.2 }, { BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(150, 150, 150) })

                                        table.remove(chosen, table.find(chosen, opt))
                                        table.remove(choseninstances, table.find(choseninstances, optionbtn))

                                        local tween = utility.tween(dropdown, { 0.2 }, { TextTransparency = 1, TextStrokeTransparency = 1 }, function()
                                            dropdown.Text = table.concat(chosen, ", ") ~= "" and table.concat(chosen, ", ") or "NONE"
                                        end)

                                        tween.Completed:Wait()

                                        utility.tween(dropdown, { 0.2 }, { TextTransparency = 0, TextStrokeTransparency = 0, TextColor3 = table.concat(chosen, ", ") ~= "" and Color3.fromRGB(210, 210, 210) or Color3.fromRGB(150, 150, 150) })

                                        if flag then
                                            library.flags[flag] = chosen
                                        end

                                        callback(chosen)
                                    end
                                end)
                            end
                        end
                    end

                    return dropdowntypes
                end

                function sectiontypes:Multibox(options)
                    local newoptions = {}
                    for i, v in next, options do
                        newoptions[i:lower()] = v
                    end

                    newoptions.maximum = newoptions.maximum or math.huge
                    return sectiontypes:Dropdown(newoptions)
                end

                function sectiontypes:Keybind(options)
                    options = utility.table(options)
                    local name = options.name
                    local keybindtype = options.mode
                    local default = options.default
                    local toggledefault = keybindtype and keybindtype:lower() == "toggle" and options.toggledefault
                    local toggleflag = keybindtype and keybindtype:lower() == "toggle" and options.togglepointer
                    local togglecallback = keybindtype and keybindtype:lower() == "toggle" and options.togglecallback or function() end
                    local holdflag = keybindtype and keybindtype:lower() == "hold" and options.holdflag
                    local holdcallback = keybindtype and keybindtype:lower() == "hold" and options.holdcallback or function() end
                    local blacklist = options.blacklist or {}
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    table.insert(blacklist, Enum.UserInputType.Focus)

                    local keybindholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 16,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = sectioncontent
                    })

                    local icon, grayborder, enablediconholder
                    do
                        if keybindtype and keybindtype:lower() == "toggle" then
                            icon = utility.create("Frame", {
                                ZIndex = 9,
                                Size = UDim2.new(0, 10, 0, 10),
                                BorderColor3 = Color3.fromRGB(35, 35, 35),
                                Position = UDim2.new(0, 2, 0, 2),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = keybindholder
                            })

                            grayborder = utility.create("Frame", {
                                ZIndex = 8,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                                Parent = icon
                            })

                            utility.create("UIGradient", {
                                Rotation = 90,
                                Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                                Parent = icon
                            })

                            utility.create("Frame", {
                                ZIndex = 7,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                                Parent = grayborder
                            })

                            enablediconholder = utility.create("Frame", {
                                ZIndex = 10,
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = icon
                            })

                            local enabledicongradient = utility.create("UIGradient", {
                                Rotation = 90,
                                Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                                Parent = enablediconholder
                            })

                            accentobjects.gradient[enabledicongradient] = function(color)
                                return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                            end
                        end
                    end

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(0, 20, 0, 0) or UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = (keybindtype and keybindtype:lower() == "toggle" and Color3.fromRGB(180, 180, 180)) or Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = keybindholder
                    })

                    local keytext = utility.create(keybindtype and keybindtype:lower() == "toggle" and "TextButton" or "TextLabel", {
                        ZIndex = 7,
                        Size = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(0, 45, 1, 0) or UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = keybindtype and keybindtype:lower() == "toggle" and UDim2.new(1, -45, 0, 0) or UDim2.new(1, 0, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        TextColor3 = Color3.fromRGB(150, 150, 150),
                        Text = "[NONE]",
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        Parent = keybindholder
                    })

                    utility.create("UIPadding", {
                        PaddingBottom = UDim.new(0, 1),
                        Parent = keytext
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local keys = {
                        [Enum.KeyCode.LeftShift] = "L-SHIFT",
                        [Enum.KeyCode.RightShift] = "R-SHIFT",
                        [Enum.KeyCode.LeftControl] = "L-CTRL",
                        [Enum.KeyCode.RightControl] = "R-CTRL",
                        [Enum.KeyCode.LeftAlt] = "L-ALT",
                        [Enum.KeyCode.RightAlt] = "R-ALT",
                        [Enum.KeyCode.CapsLock] = "CAPSLOCK",
                        [Enum.KeyCode.One] = "1",
                        [Enum.KeyCode.Two] = "2",
                        [Enum.KeyCode.Three] = "3",
                        [Enum.KeyCode.Four] = "4",
                        [Enum.KeyCode.Five] = "5",
                        [Enum.KeyCode.Six] = "6",
                        [Enum.KeyCode.Seven] = "7",
                        [Enum.KeyCode.Eight] = "8",
                        [Enum.KeyCode.Nine] = "9",
                        [Enum.KeyCode.Zero] = "0",
                        [Enum.KeyCode.KeypadOne] = "NUM-1",
                        [Enum.KeyCode.KeypadTwo] = "NUM-2",
                        [Enum.KeyCode.KeypadThree] = "NUM-3",
                        [Enum.KeyCode.KeypadFour] = "NUM-4",
                        [Enum.KeyCode.KeypadFive] = "NUM-5",
                        [Enum.KeyCode.KeypadSix] = "NUM-6",
                        [Enum.KeyCode.KeypadSeven] = "NUM-7",
                        [Enum.KeyCode.KeypadEight] = "NUM-8",
                        [Enum.KeyCode.KeypadNine] = "NUM-9",
                        [Enum.KeyCode.KeypadZero] = "NUM-0",
                        [Enum.KeyCode.Minus] = "-",
                        [Enum.KeyCode.Equals] = "=",
                        [Enum.KeyCode.Tilde] = "~",
                        [Enum.KeyCode.LeftBracket] = "[",
                        [Enum.KeyCode.RightBracket] = "]",
                        [Enum.KeyCode.RightParenthesis] = ")",
                        [Enum.KeyCode.LeftParenthesis] = "(",
                        [Enum.KeyCode.Semicolon] = ",",
                        [Enum.KeyCode.Quote] = "'",
                        [Enum.KeyCode.BackSlash] = "\\",
                        [Enum.KeyCode.Comma] = ",",
                        [Enum.KeyCode.Period] = ".",
                        [Enum.KeyCode.Slash] = "/",
                        [Enum.KeyCode.Asterisk] = "*",
                        [Enum.KeyCode.Plus] = "+",
                        [Enum.KeyCode.Period] = ".",
                        [Enum.KeyCode.Backquote] = "`",
                        [Enum.UserInputType.MouseButton1] = "MOUSE-1",
                        [Enum.UserInputType.MouseButton2] = "MOUSE-2",
                        [Enum.UserInputType.MouseButton3] = "MOUSE-3"
                    }

                    local keychosen
                    local isbinding = false

                    local function startbinding()
                        isbinding = true
                        keytext.Text = "[...]"
                        keytext.TextColor3 = Color3.fromRGB(210, 210, 210)

                        local binding
                        binding = services.InputService.InputBegan:Connect(function(input)
                            local key = keys[input.KeyCode] or keys[input.UserInputType]
                            keytext.Text = "[" .. (key or tostring(input.KeyCode):gsub("Enum.KeyCode.", "")) .. "]"
                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                            keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                            keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                task.wait()
                                if not table.find(blacklist, input.KeyCode) then
                                    keychosen = input.KeyCode

                                    if flag then
                                        library.flags[flag] = input.KeyCode
                                    end

                                    binding:Disconnect()
                                else
                                    keychosen = nil
                                    keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                                    keytext.Text = "NONE"

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    binding:Disconnect()
                                end
                            else
                                if not table.find(blacklist, input.UserInputType) then
                                    keychosen = input.UserInputType

                                    if flag then
                                        library.flags[flag] = input.UserInputType
                                    end

                                    binding:Disconnect()
                                else
                                    keychosen = nil
                                    keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                                    keytext.Text = "[NONE]"

                                    keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                                    keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                                    if flag then
                                        library.flags[flag] = nil
                                    end

                                    binding:Disconnect()
                                end
                            end
                        end)
                    end

                    if not keybindtype or keybindtype:lower() == "hold" then
                        keybindholder.MouseButton1Click:Connect(startbinding)
                    else
                        keytext.MouseButton1Click:Connect(startbinding)
                    end

                    local keybindtypes = utility.table()

                    if keybindtype and keybindtype:lower() == "toggle" then
                        local toggled = false

                        if toggleflag then
                            library.flags[toggleflag] = toggled
                        end

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggleflag then
                                    library.flags[toggleflag] = toggled
                                end

                                togglecallback(toggled)

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enablediconholder, { 0.2 }, { Transparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        keybindholder.MouseButton1Click:Connect(toggle)

                        local function set(bool)
                            if type(bool) == "boolean" and toggled ~= bool then
                                toggle()
                            end
                        end

                        function keybindtypes:Toggle(bool)
                            set(bool)
                        end

                        if toggledefault then
                            set(toggledefault)
                        end

                        if toggleflag then
                            flags[toggleflag] = set
                        end

                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    toggle()
                                    callback(keychosen)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    toggle()
                                    callback(keychosen)
                                end
                            end
                        end)
                    end

                    if keybindtype and keybindtype:lower() == "hold" then
                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    callback(keychosen)
                                    holdcallback(true)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    callback(keychosen)
                                    holdcallback(true)
                                end
                            end
                        end)

                        services.InputService.InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    holdcallback(false)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    if holdflag then
                                        library.flags[holdflag] = true
                                    end

                                    holdcallback(false)
                                end
                            end
                        end)
                    end

                    if not keybindtype then
                        services.InputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.Keyboard then
                                if input.KeyCode == keychosen then
                                    callback(keychosen)
                                end
                            else
                                if input.UserInputType == keychosen then
                                    callback(keychosen)
                                end
                            end
                        end)
                    end

                    local function setkey(newkey)
                        if tostring(newkey):find("Enum.KeyCode.") then
                            newkey = Enum.KeyCode[tostring(newkey):gsub("Enum.KeyCode.", "")]
                        else
                            newkey = Enum.UserInputType[tostring(newkey):gsub("Enum.UserInputType.", "")]
                        end

                        if not table.find(blacklist, newkey) then
                            local key = keys[newkey]
                            local text = "[" .. (keys[newkey] or tostring(newkey):gsub("Enum.KeyCode.", "")) .. "]"
                            local sizeX = services.TextService:GetTextSize(text, 8, Enum.Font.Kalam, Vector2.new(1000, 1000)).X

                            keytext.Text = text
                            keytext.Size = UDim2.new(0, sizeX, 1, 0)
                            keytext.Position = UDim2.new(1, -sizeX, 0, 0)

                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)

                            keychosen = newkey

                            if flag then
                                library.flags[flag] = newkey
                            end

                            callback(newkey, true)
                        else
                            keychosen = nil
                            keytext.TextColor3 = Color3.fromRGB(180, 180, 180)
                            keytext.Text = "[NONE]"
                            keytext.Size = UDim2.new(0, keytext.TextBounds.X, 1, 0)
                            keytext.Position = UDim2.new(1, -keytext.TextBounds.X, 0, 0)

                            if flag then
                                library.flags[flag] = nil
                            end

                            callback(newkey, true)
                        end
                    end

                    if default then
                        task.wait()
                        setkey(default)
                    end

                    if flag then
                        flags[flag] = setkey
                    end

                    function keybindtypes:Set(newkey)
                        setkey(newkey)
                    end

                    return keybindtypes
                end

                function sectiontypes:ColorPicker(options)
                    options = utility.table(options)
                    local name = options.name
                    local default = options.default or Color3.fromRGB(255, 255, 255)
                    local colorpickertype = options.mode
                    local toggleflag = colorpickertype and colorpickertype:lower() == "toggle" and options.togglepointer
                    local togglecallback = colorpickertype and colorpickertype:lower() == "toggle" and options.togglecallback or function() end
                    local flag = options.pointer
                    local callback = options.callback or function() end

                    local colorpickerholder = utility.create("Frame", {
                        Size = UDim2.new(1, -5, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 0, 0, 0),
                        Parent = sectioncontent
                    })

                    local enabledcpiconholder
                    do
                        if colorpickertype and colorpickertype:lower() == "toggle" then
                            local togglecpicon = utility.create("Frame", {
                                ZIndex = 9,
                                Size = UDim2.new(0, 10, 0, 10),
                                BorderColor3 = Color3.fromRGB(35, 35, 35),
                                Position = UDim2.new(0, 2, 0, 2),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = colorpickerholder
                            })

                            local grayborder = utility.create("Frame", {
                                ZIndex = 8,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                                Parent = togglecpicon
                            })

                            utility.create("UIGradient", {
                                Rotation = 90,
                                Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25)),
                                Parent = togglecpicon
                            })

                            utility.create("Frame", {
                                ZIndex = 7,
                                Size = UDim2.new(1, 2, 1, 2),
                                Position = UDim2.new(0, -1, 0, -1),
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                                Parent = grayborder
                            })

                            enabledcpiconholder = utility.create("Frame", {
                                ZIndex = 10,
                                Size = UDim2.new(1, 0, 1, 0),
                                BackgroundTransparency = 1,
                                BorderSizePixel = 0,
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                                Parent = togglecpicon
                            })

                            local enabledicongradient = utility.create("UIGradient", {
                                Rotation = 90,
                                Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                                Parent = enabledcpiconholder
                            })

                            accentobjects.gradient[enabledicongradient] = function(color)
                                return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                            end
                        end
                    end

                    local colorpickerframe = utility.create("Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(1, -70, 0, 148),
                        Position = UDim2.new(1, -168, 0, 18),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Visible = false,
                        Parent = colorpickerholder
                    })

                    colorpickerframe.DescendantAdded:Connect(function(descendant)
                        if not opened then
                            task.wait()
                            if not descendant.ClassName:find("UI") then
                                if descendant.ClassName:find("Text") then
                                    descendant.TextTransparency = descendant.TextTransparency + 1
                                    descendant.TextStrokeTransparency = descendant.TextStrokeTransparency + 1
                                end

                                if descendant.ClassName:find("Image") then
                                    descendant.ImageTransparency = descendant.ImageTransparency + 1
                                end

                                descendant.BackgroundTransparency = descendant.BackgroundTransparency + 1
                            end
                        end
                    end)

                    local bggradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = colorpickerframe
                    })

                    local blackborder = utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local saturationframe = utility.create("ImageLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 128, 0, 100),
                        BorderColor3 = Color3.fromRGB(50, 50, 50),
                        Position = UDim2.new(0, 6, 0, 6),
                        BorderSizePixel = 0,
                        BackgroundColor3 = default,
                        Image = "http://www.roblox.com/asset/?id=8630797271",
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = saturationframe
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local saturationpicker = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(0, 2, 0, 2),
                        BorderColor3 = Color3.fromRGB(10, 10, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = saturationframe
                    })

                    local hueframe = utility.create("ImageLabel", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 14, 0, 100),
                        Position = UDim2.new(1, -20, 0, 6),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 193, 49),
                        ScaleType = Enum.ScaleType.Crop,
                        Image = "http://www.roblox.com/asset/?id=8630799159",
                        Parent = colorpickerframe
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = hueframe
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local huepicker = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(1, 0, 0, 1),
                        BorderColor3 = Color3.fromRGB(10, 10, 10),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = hueframe
                    })

                    local boxholder = utility.create("Frame", {
                        Size = UDim2.new(1, -8, 0, 17),
                        ClipsDescendants = true,
                        Position = UDim2.new(0, 4, 0, 110),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = colorpickerframe
                    })

                    local box = utility.create("TextBox", {
                        ZIndex = 13,
                        Size = UDim2.new(1, -4, 1, -4),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 2, 0, 2),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = table.concat({ utility.getrgb(default) }, ", "),
                        PlaceholderText = "R, G, B",
                        Font = Enum.Font.Kalam,
                        Parent = boxholder
                    })

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = box
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local bg = utility.create("Frame", {
                        ZIndex = 12,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = box
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = bg
                    })

                    local toggleholder = utility.create("TextButton", {
                        Size = UDim2.new(1, -8, 0, 14),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 4, 0, 130),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 16,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = colorpickerframe
                    })

                    local toggleicon = utility.create("Frame", {
                        ZIndex = 12,
                        Size = UDim2.new(0, 10, 0, 10),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(0, 2, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleholder
                    })

                    local enablediconholder = utility.create("Frame", {
                        ZIndex = 13,
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = toggleicon
                    })

                    local enabledicongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { library.accent, Color3.fromRGB(25, 25, 25) },
                        Parent = enablediconholder
                    })

                    accentobjects.gradient[enabledicongradient] = function(color)
                        return utility.gradient { color, Color3.fromRGB(25, 25, 25) }
                    end

                    local grayborder = utility.create("Frame", {
                        ZIndex = 11,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = toggleicon
                    })

                    utility.create("Frame", {
                        ZIndex = 10,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { Color3.fromRGB(35, 35, 35), Color3.fromRGB(25, 25, 25) },
                        Parent = toggleicon
                    })

                    local rainbowtxt = utility.create("TextLabel", {
                        ZIndex = 10,
                        Size = UDim2.new(0, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 20, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(180, 180, 180),
                        Text = "Rainbow",
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = toggleholder
                    })

                    local colorpicker = utility.create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 14),
                        BackgroundTransparency = 1,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextSize = 16,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        Font = Enum.Font.SourceSans,
                        Parent = colorpickerholder
                    })

                    local icon = utility.create(colorpickertype and colorpickertype:lower() == "toggle" and "TextButton" or "Frame", {
                        ZIndex = 9,
                        Size = UDim2.new(0, 18, 0, 10),
                        BorderColor3 = Color3.fromRGB(35, 35, 35),
                        Position = UDim2.new(1, -20, 0, 2),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = colorpicker
                    })

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        icon.Text = ""
                    end

                    local grayborder = utility.create("Frame", {
                        ZIndex = 8,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = icon
                    })

                    utility.create("Frame", {
                        ZIndex = 7,
                        Size = UDim2.new(1, 2, 1, 2),
                        Position = UDim2.new(0, -1, 0, -1),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
                        Parent = grayborder
                    })

                    local icongradient = utility.create("UIGradient", {
                        Rotation = 90,
                        Color = utility.gradient { default, utility.changecolor(default, -200) },
                        Parent = icon
                    })

                    local title = utility.create("TextLabel", {
                        ZIndex = 7,
                        Size = UDim2.new(0, 0, 0, 14),
                        BackgroundTransparency = 1,
                        Position = colorpickertype and colorpickertype:lower() == "toggle" and UDim2.new(0, 20, 0, 0) or UDim2.new(0, 1, 0, 0),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        FontSize = Enum.FontSize.Size14,
                        TextStrokeTransparency = 0,
                        TextSize = 15,
                        TextColor3 = Color3.fromRGB(210, 210, 210),
                        Text = name,
                        Font = Enum.Font.Kalam,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = colorpicker
                    })

                    if #sectioncontent:GetChildren() - 1 <= max then
                        sectionholder.Size = UDim2.new(1, -1, 0, sectionlist.AbsoluteContentSize.Y + 28)
                    end

                    local colorpickertypes = utility.table()

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        local toggled = false

                        if toggleflag then
                            library.flags[toggleflag] = toggled
                        end

                        local function toggle()
                            if not switchingtabs then
                                toggled = not toggled

                                if toggleflag then
                                    library.flags[toggleflag] = toggled
                                end

                                togglecallback(toggled)

                                local enabledtransparency = toggled and 0 or 1
                                utility.tween(enabledcpiconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                                local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                                utility.tween(title, { 0.2 }, { TextColor3 = textcolor })

                                if toggled then
                                    table.insert(accentobjects.text, title)
                                elseif table.find(accentobjects.text, title) then
                                    table.remove(accentobjects.text, table.find(accentobjects.text, title))
                                end
                            end
                        end

                        colorpicker.MouseButton1Click:Connect(toggle)

                        local function set(bool)
                            if type(bool) == "boolean" and toggled ~= bool then
                                toggle()
                            end
                        end

                        function colorpickertypes:Toggle(bool)
                            set(bool)
                        end

                        if toggledefault then
                            set(toggledefault)
                        end

                        if toggleflag then
                            flags[toggleflag] = set
                        end
                    end

                    local opened = false
                    local opening = false

                    local function opencolorpicker()
                        if not opening then
                            opening = true

                            opened = not opened

                            if opened then
                                utility.tween(colorpickerholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 168) })
                            end

                            local tween = utility.makevisible(colorpickerframe, opened)

                            tween.Completed:Wait()

                            if not opened then
                                local tween = utility.tween(colorpickerholder, { 0.2 }, { Size = UDim2.new(1, -5, 0, 16) })
                                tween.Completed:Wait()
                            end

                            opening = false
                        end
                    end

                    if colorpickertype and colorpickertype:lower() == "toggle" then
                        icon.MouseButton1Click:Connect(opencolorpicker)
                    else
                        colorpicker.MouseButton1Click:Connect(opencolorpicker)
                    end

                    local hue, sat, val = default:ToHSV()

                    local slidinghue = false
                    local slidingsaturation = false

                    local hsv = Color3.fromHSV(hue, sat, val)

                    if flag then
                        library.flags[flag] = default
                    end

                    local function updatehue(input)
                        local sizeY = 1 - math.clamp((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y, 0, 1)
                        local posY = math.clamp(((input.Position.Y - hueframe.AbsolutePosition.Y) / hueframe.AbsoluteSize.Y) * hueframe.AbsoluteSize.Y, 0, hueframe.AbsoluteSize.Y - 2)
                        huepicker.Position = UDim2.new(0, 0, 0, posY)

                        hue = sizeY
                        hsv = Color3.fromHSV(sizeY, sat, val)

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    hueframe.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidinghue = true
                            updatehue(input)
                        end
                    end)

                    hueframe.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidinghue = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if slidinghue then
                                updatehue(input)
                            end
                        end
                    end)

                    local function updatesatval(input)
                        local sizeX = math.clamp((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X, 0, 1)
                        local sizeY = 1 - math.clamp((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y, 0, 1)
                        local posY = math.clamp(((input.Position.Y - saturationframe.AbsolutePosition.Y) / saturationframe.AbsoluteSize.Y) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)
                        local posX = math.clamp(((input.Position.X - saturationframe.AbsolutePosition.X) / saturationframe.AbsoluteSize.X) * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)

                        saturationpicker.Position = UDim2.new(0, posX, 0, posY)

                        sat = sizeX
                        val = sizeY
                        hsv = Color3.fromHSV(hue, sizeX, sizeY)

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    saturationframe.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidingsaturation = true
                            updatesatval(input)
                        end
                    end)

                    saturationframe.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            slidingsaturation = false
                        end
                    end)

                    services.InputService.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            if slidingsaturation then
                                updatesatval(input)
                            end
                        end
                    end)

                    local function set(color)
                        if type(color) == "table" then
                            color = Color3.fromRGB(unpack(color))
                        end

                        hue, sat, val = color:ToHSV()
                        hsv = Color3.fromHSV(hue, sat, val)

                        saturationframe.BackgroundColor3 = hsv
                        icon.BackgroundColor3 = hsv
                        saturationpicker.Position = UDim2.new(0, (math.clamp(sat * saturationframe.AbsoluteSize.X, 0, saturationframe.AbsoluteSize.X - 4)), 0, (math.clamp((1 - val) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4)))
                        huepicker.Position = UDim2.new(0, 0, 0, math.clamp((1 - hue) * saturationframe.AbsoluteSize.Y, 0, saturationframe.AbsoluteSize.Y - 4))

                        box.Text = math.clamp(math.floor((hsv.R * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.B * 255) + 0.5), 0, 255) .. ", " .. math.clamp(math.floor((hsv.G * 255) + 0.5), 0, 255)

                        if flag then
                            library.flags[flag] = Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255)
                        end

                        callback(Color3.fromRGB(hsv.r * 255, hsv.g * 255, hsv.b * 255))
                    end

                    local toggled = false

                    local function toggle()
                        if not switchingtabs then
                            toggled = not toggled

                            if toggled then
                                task.spawn(function()
                                    while toggled do
                                        for i = 0, 1, 0.0015 do
                                            if not toggled then
                                                return
                                            end

                                            local color = Color3.fromHSV(i, 1, 1)
                                            set(color)

                                            task.wait()
                                        end
                                    end
                                end)
                            end

                            local enabledtransparency = toggled and 0 or 1
                            utility.tween(enablediconholder, { 0.2 }, { BackgroundTransparency = enabledtransparency })

                            local textcolor = toggled and library.accent or Color3.fromRGB(180, 180, 180)
                            utility.tween(rainbowtxt, { 0.2 }, { TextColor3 = textcolor })

                            if toggled then
                                table.insert(accentobjects.text, title)
                            elseif table.find(accentobjects.text, title) then
                                table.remove(accentobjects.text, table.find(accentobjects.text, title))
                            end
                        end
                    end

                    toggleholder.MouseButton1Click:Connect(toggle)

                    box.FocusLost:Connect(function()
                        local _, amount = box.Text:gsub(", ", "")

                        if amount == 2 then
                            local values = box.Text:split(", ")
                            local r, g, b = math.clamp(values[1], 0, 255), math.clamp(values[2], 0, 255), math.clamp(values[3], 0, 255)
                            set(Color3.fromRGB(r, g, b))
                        else
                            rgb.Text = math.floor((hsv.r * 255) + 0.5) .. ", " .. math.floor((hsv.g * 255) + 0.5) .. ", " .. math.floor((hsv.b * 255) + 0.5)
                        end
                    end)

                    if default then
                        set(default)
                    end

                    if flag then
                        flags[flag] = set
                    end

                    local colorpickertypes = utility.table()

                    function colorpickertypes:Set(color)
                        set(color)
                    end
                end

                return sectiontypes
            end

            return pagetypes
        end

        return windowtypes
    end

    function library:Initialize()
        if gethui then
            gui.Parent = gethui()
        elseif syn and syn.protect_gui then
            syn.protect_gui(gui)
            gui.Parent = services.CoreGui
        end
    end

    function library:Init()
        library:Initialize()
    end
end

local V3 = Vector3.new
local V2 = Vector2.new
local inf = math.huge
getgenv().Settings = {
    ["xgredic"] = {
        ["Enabled"] = false,
        ["DOT"] = true,
        ["AIRSHOT"] = false,
        ["Prediction"] = {
            ["Horizontal"] = 0.185,
            ["Vertical"] = 0.1,
        },
        ["CamPrediction"] = {
            ["Prediction"] = {
                ["Horizontal"] = 0.185,
                ["Vertical"] = 0.1,
            },
        },
        ["NOTIF"] = true,
        ["AUTOPRED"] = false,
        ["AdvancedAutoPred"] = false,
        ["FOV"] = inf,
        ["RESOLVER"] = false,
        ["LOCKTYPE"] = "Namecall",
        ["TargetStats"] = false,
        ["Resolver"] = {
              ["Enabled"] = false,
              ["Type"] = "None",
        },
       ["Camera"] = {
        ["Enabled"] = false,
        ["HoodCustomsBypass"] = false,
     },
        ["OnHit"] = {
             ["Enabled"] = true,
             ["Hitchams"] = {
                  ["Enabled"] = false,
                  ["Color"] = Color3.fromRGB(0,255,0),
                  ["Transparency"] = 0,
                  ["Material"] = "ForceField",
             },
            ["Hitsound"] = {
                  ["Enabled"] = false,
                  ["Sound"] = "hitsounds/sparkle.wav",
                  ["Volume"] = 2,
            },
        }
    },
}
getgenv().DistancesMid = 50
getgenv().DistancesClose = 10
getgenv().AimSpeed = 1
getgenv().CAMPREDICTION = 0.185
getgenv().CAMJUMPPREDICTION = 0.1
getgenv().HorizontalSmoothness = 1
getgenv().VerticallSmoothness = 0.5
getgenv().ShakeX = 0
getgenv().ShakeY = 0
getgenv().ShakeZ = 0
getgenv().PREDICTION = 0.185
getgenv().JUMPPREDICTION = 0.1
getgenv().SelectedPart = "HumanoidRootPart" --// LowerTorso, UpperTorso, Head
getgenv().Prediction = "Normal"
getgenv().AutoPredType = "Normal"
getgenv().Resolver = false
local Ranges = {
        Close = 30,
        Mid = 100
}

local Notification = Instance.new("ScreenGui")
local Holder = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TweenService = game:GetService("TweenService")

Notification.Name = "Notification"
Notification.Parent = game.CoreGui
Notification.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Holder.Name = "Holder"
Holder.Parent = Notification
Holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Holder.BackgroundTransparency = 1
Holder.BorderColor3 = Color3.fromRGB(27, 42, 53)
Holder.Position = UDim2.new(0.007, 0, 0.01, 0)
Holder.Size = UDim2.new(0, 243, 0, 240)

UIListLayout.Parent = Holder
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)

function Borg_notify(text, time)
	local Template = Instance.new("Frame")
	local ColorBar = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")

	Template.Name = text
	Template.Parent = Holder
	Template.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	Template.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Template.Size = UDim2.new(0, 0, 0, 0)
	Template.Transparency = 1

	ColorBar.Name = "ColorBar"
	ColorBar.Parent = Template
	ColorBar.BackgroundColor3 = Color3.fromRGB(20, 201, 20)
	ColorBar.BorderSizePixel = 0
	ColorBar.Size = UDim2.new(0, 2, 0, 22)
	ColorBar.Transparency = 1

	TextLabel.Parent = Template
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.new(0, 8, 0, 0)
	TextLabel.Size = UDim2.new(0, 0, 0, 22)
	TextLabel.Font = Enum.Font.Code
	TextLabel.Text = text
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 14
	TextLabel.TextStrokeTransparency = 0
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Transparency = 1

	Template.Size = UDim2.new(0, TextLabel.TextBounds.X + 13, 0, 22)
	local goal2 = {Transparency = 0}
	local tweenInfo2 = TweenInfo.new(0.5)
	local tween1 = TweenService:Create(Template, tweenInfo2, goal2)
	local tween2 = TweenService:Create(ColorBar, tweenInfo2, goal2)
	local tween3 = TweenService:Create(TextLabel, tweenInfo2, goal2)
	tween1:Play()
	tween2:Play()
	tween3:Play()

	delay(time, function()
		local goal = {Transparency = 1}
		local tweenInfo = TweenInfo.new(0.5)
		local tween1 = TweenService:Create(Template, tweenInfo, goal)
		local tween2 = TweenService:Create(ColorBar, tweenInfo, goal)
		local tween3 = TweenService:Create(TextLabel, tweenInfo, goal)
		tween1:Play()
		tween2:Play()
		tween3:Play()
		delay(0.51, function()
			Template:Destroy()
		end)
	end)
end

function SendNotification(text)
    Borg_notify("Locked " .. text, 3)
end

function calculateVelocity(initialPos, finalPos, timeInterval)
    local displacement = finalPos - initialPos
    local velocity = displacement / timeInterval
    return velocity
    end
    game:GetService('RunService').RenderStepped:connect(function(deltaTime)
    if getgenv().Resolver == true and enabled then 
        local character = Plr.Character[getgenv().SelectedPart]
        local lastPosition = character.Position
            task.wait()
        local currentPosition = character.Position
        local velocity = calculateVelocity(lastPosition, currentPosition, deltaTime)
        character.AssemblyLinearVelocity = velocity
        character.Velocity = velocity
            lastPosition = currentPosition
        end
    end)

--// Change Prediction,  AutoPrediction Must Be Off
    local lplr = game.Players.LocalPlayer
    local AnchorCount = 0
    local MaxAnchor = 50
    local CC = game:GetService"Workspace".CurrentCamera
    local Plr;
    local enabled = false
    local mouse = game.Players.LocalPlayer:GetMouse()
    local placemarker = Instance.new("Part", game.Workspace)
    function makemarker(Parent, Adornee, Color, Size, Size2)
        local e = Instance.new("BillboardGui", Parent)
        e.Name = "PP"
        e.Adornee = Adornee
        e.Size = UDim2.new(Size, Size2, Size, Size2)
        e.AlwaysOnTop = getgenv().Settings.xgredic.DOT
        local a = Instance.new("Frame", e)
        if getgenv().Settings.xgredic.DOT == true then
        a.Size = UDim2.new(0.4, 0.4, 0.4, 0.4)
        else
        a.Size = UDim2.new(0, 0, 0, 0)
        end
        if getgenv().Settings.xgredic.DOT == true then
        a.Transparency = 0
        a.BackgroundTransparency = 0
        else
        a.Transparency = 1
        a.BackgroundTransparency = 1
        end
        a.BackgroundColor3 = Color
        local g = Instance.new("UICorner", a)
        if getgenv().Settings.xgredic.DOT == false then
        g.CornerRadius = UDim.new(1, 1)
        else
        g.CornerRadius = UDim.new(1, 1) 
        end
        return(e)
    end
    local data = game.Players:GetPlayers()
    function noob(player)
        local character
        repeat wait() until player.Character
        local handler = makemarker(guimain, player.Character:WaitForChild(SelectedPart), Color3.fromRGB(107, 184, 255), 0.3, 3)
        handler.Name = player.Name
        player.CharacterAdded:connect(function(Char) handler.Adornee = Char:WaitForChild(SelectedPart) end)
 
 
        spawn(function()
            while wait() do
                if player.Character then
                end
            end
        end)
    end
 
    for i = 1, #data do
        if data[i] ~= game.Players.LocalPlayer then
            noob(data[i])
        end
    end
 
    game.Players.PlayerAdded:connect(function(Player)
        noob(Player)
    end)
 
    spawn(function()
        placemarker.Anchored = true
        placemarker.CanCollide = false
        if getgenv().Settings.xgredic.DOT == true then
        placemarker.Size = V3(0, 0, 0)
        else
        placemarker.Size = V3(0, 0, 0)
        end
        placemarker.Transparency = 0.75
        if getgenv().Settings.xgredic.DOT then
        makemarker(placemarker, placemarker, Color3.fromRGB(0,255,0), 1, 0)
        end
    end)
 local Tool = Instance.new("Tool")
Tool.RequiresHandle = false
Tool.Name = "Xgre"
Tool.Parent = game.Players.LocalPlayer.Backpack
local player = game.Players.LocalPlayer
local function connectCharacterAdded()
    player.CharacterAdded:Connect(onCharacterAdded)
end
connectCharacterAdded()
player.CharacterRemoving:Connect(function()
Tool.Parent = game.Players.LocalPlayer.Backpack
end)

Tool.Activated:Connect(function()
if getgenv().Settings.xgredic.Enabled or getgenv().Settings.xgredic.Camera.Enabled then
            if enabled == true then
                enabled = false
                    Plr = LockToPlayer()
                if getgenv().Settings.xgredic.NOTIF == true then 
 SendNotification("Unlocked")
            end
            else
                Plr = LockToPlayer()
                TargetPlayer = tostring(Plr)
                enabled = true
local oldHealt = game.Players[TargetPlayer].Character.Humanoid.Health
                        if getgenv().Settings.xgredic.OnHit.Hitsound.Enabled and Plr ~= nil then

                             game.Players[TargetPlayer].Character.Humanoid.HealthChanged:Connect(function(neHealth)                            
if neHealth < oldHealt then
hitsound()
elseif neHealth > oldHealt then
print("nil")
elseif game.Players[TargetPlayer].Character.Humanoid.Health < 0 then
print("nil")
end
oldHealt = neHealth
end)
end                                      
              
if getgenv().Settings.xgredic.OnHit.Hitchams.Enabled then
   
        if Plr ~= nil then  game.Players[TargetPlayer].Character.Humanoid.HealthChanged:Connect(function(neHealth)
        local Clone = game.Players[TargetPlayer].Character:Clone()
        if neHealth > oldHealt then
            Clone:Destroy()
        end
        if game.Players[TargetPlayer].Character.Humanoid.Health < 0 then
            Clone:Destroy()
        end
        if neHealth < oldHealt then
            -- Main Hit-Chams --
            game.Players[TargetPlayer].Character.Archivable = true
            for _, Obj in next, Clone:GetDescendants() do
                if Obj.Name == "HumanoidRootPart" or Obj:IsA("Humanoid") or Obj:IsA("LocalScript") or Obj:IsA("Script") or Obj:IsA("Decal") then
                    Obj:Destroy()
                elseif Obj:IsA("BasePart") or Obj:IsA("Meshpart") or Obj:IsA("Part") then
                    if Obj.Transparency == 1 then
                        Obj:Destroy()
                    else
                        Obj.CanCollide = false
                        Obj.Anchored = true
                        Obj.Material = getgenv().Settings.xgredic.OnHit.Hitchams.Material
                        Obj.Color = getgenv().Settings.xgredic.OnHit.Hitchams.Color
                        Obj.Transparency = getgenv().Settings.xgredic.OnHit.Hitchams.Transparency
                        Obj.Size = Obj.Size + V3(0.05, 0.05, 0.05)
                    end
                end
           
            end
            Clone.Parent = game.Workspace
            local start = tick()
            local connection
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if tick() - start >= 3 then
                    connection:Disconnect()
                    Clone:Destroy()
                end
            end)
        end

            oldHealt = neHealth

    end)
    end
end
                if getgenv().Settings.xgredic.NOTIF == true then
SendNotification("Target: "..Plr.Character.Humanoid.DisplayName)
                end
            end
   else
  SendNotification("You haven't enabled other features")
        end
    end)
    function LockToPlayer()
        local closestPlayer
        local shortestDistance = getgenv().Settings.xgredic.FOV
        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health ~= 0 and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos = CC:WorldToViewportPoint(v.Character.PrimaryPart.Position)
                local magnitude = (V2(pos.X, pos.Y) - V2(mouse.X, mouse.Y)).magnitude
                if magnitude < shortestDistance then
                    closestPlayer = v
                    shortestDistance = magnitude
                end
            end
        end
        return closestPlayer
    end
 
local Stats = game:GetService("Stats")
local function Predict(Velocity)
    return V3(Velocity.X,math.clamp(Velocity.Y,-5,10),Velocity.Z)
end
local function GetLockPrediction(Part)
    return Part.CFrame + (Predict(Part.Velocity) * getgenv().PREDICTION)
end
local function GetCamPrediction(Part)
    return Part.CFrame + Predict(Part.Velocity) * (getgenv().CAMPREDICTION)
end
    local pingvalue = nil;
    local split = nil;
    local ping = nil;
local LocalHL = Instance.new("Highlight") 
    game:GetService"RunService".Stepped:connect(function()
if getgenv().UnlockOnDeath == true and Plr and Plr.Character:FindFirstChild("Humanoid") then
        if Plr.StarterPlayer.StarterCharacterScripts.BodyEffects['K.O'] then
            AimlockTarget = nil
        end
end
        if enabled and getgenv(). Settings.xgredic.Enabled and Plr.Character ~= nil and Plr.Character:FindFirstChild("HumanoidRootPart") or enabled and getgenv(). Settings.xgredic.Camera.Enabled and Plr.Character ~= nil and Plr.Character:FindFirstChild("HumanoidRootPart") then
if getgenv().Prediction == "Normal" then
            placemarker.CFrame = CFrame.new(GetLockPrediction(Plr.Character[getgenv().SelectedPart]).Position)         
elseif getgenv().Prediction == "Yun" then
            placemarker.CFrame = CFrame.new(Plr.Character[getgenv().SelectedPart].Position+V3(Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.X*getgenv().PREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y*getgenv().JUMPPREDICTION/10,Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Z*getgenv().PREDICTION/10))
end
LocalHL.Parent = Plr.Character
LocalHL.FillTransparency = 0.2
LocalHL.FillColor = Color3.fromRGB(0,255,0)
LocalHL.OutlineColor = Color3.fromRGB(0,255,0)
        else
            placemarker.CFrame = CFrame.new(0, 9999, 0)
          LocalHL.Parent = nil
        end
pingvalue = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
split = string.split(pingvalue,'(')
ping = tonumber(split[1])

if getgenv().Settings.xgredic.AdvancedAutoPred == true and enabled then
    getgenv().CAMJUMPPREDICTION = 0.05
    if ping > 300 then
        getgenv().CAMPREDICTION = 0.434735
    elseif ping > 290 then
        getgenv().CAMPREDICTION = 0.42281
    elseif ping > 280 then
        getgenv().CAMPREDICTION = 0.44820
    elseif ping > 270 then
        getgenv().CAMPREDICTION = 0.4385720
    elseif ping > 260 then
        getgenv().CAMPREDICTION = 0.415892027
    elseif ping > 250 then
        getgenv().CAMPREDICTION = 0.314881017
    elseif ping > 240 then
        getgenv().CAMPREDICTION = 0.3482990
    elseif ping > 230 then
        getgenv().CAMPREDICTION = 0.33829
    elseif ping > 220 then
        getgenv().CAMPREDICTION = 0.30927
    elseif ping > 210 then
        getgenv().CAMPREDICTION = 0.295829
    elseif ping > 200 then
        getgenv().CAMPREDICTION = 0.291582
    elseif ping > 190 then
        getgenv().CAMPREDICTION = 0.291182027272020
    elseif ping > 180 then
        getgenv().CAMPREDICTION = 0.282911983286193
    elseif ping > 180 then
        getgenv().CAMPREDICTION = 0.25291198328827
    elseif ping > 170 then
        getgenv().CAMPREDICTION = 0.2802
    elseif ping > 160 then
        getgenv().CAMPREDICTION = 0.275482
    elseif ping  >150 then
        getgenv().CAMPREDICTION = 0.27192
    elseif ping  >140 then
        getgenv().CAMPREDICTION = 0.2501
       elseif ping > 130 then
        getgenv().CAMPREDICTION = 0.12729057
    elseif ping > 120 then
        getgenv().CAMPREDICTION = 0.1968206
    elseif ping > 110 then
        getgenv().CAMPREDICTION = 0.18820642271
    elseif ping > 100 then
        getgenv().CAMPREDICTION = 0.1892533
    elseif ping > 90 then
        getgenv().CAMPREDICTION = 0.1748209573
    elseif ping > 80 then
        getgenv().CAMPREDICTION = 0.1745027
    elseif ping > 70 then
        getgenv().CAMPREDICTION = 0.164192
    elseif ping > 50 then
        getgenv().CAMPREDICTION = 0.142671
    elseif ping > 40 then
        getgenv().CAMPREDICTION = 0.14298
    elseif ping > 30 then
        getgenv().CAMPREDICTION = 0.131282
   elseif ping > 20 then
        getgenv().CAMPREDICTION = 0.1312910
   elseif ping > 10 then
        getgenv().CAMPREDICTION = 0.1201879
   end
end
if getgenv().Settings.xgredic.AUTOPRED == true then
    if getgenv().AutoPredType == "Normal" then
if ping <200 then
    getgenv().PREDICTION = 0.2198343243234332
    elseif ping < 170 then
        getgenv().PREDICTION = 0.19265713
    elseif ping < 160 then
        getgenv().PREDICTION = 0.18242729
    elseif ping < 150 then
        getgenv().PREDICTION = 0.17580414
    elseif ping < 140 then
        getgenv().PREDICTION = 0.175626432282902
    elseif ping < 130 then
        getgenv().PREDICTION = 0.174382290
    elseif ping < 120 then
        getgenv().PREDICTION = 0.167300
    elseif ping < 110 then
        getgenv().PREDICTION = 0.168502502027
    elseif ping < 100 then
            getgenv().PREDICTION = 0.16382827
        elseif ping < 90 then
            getgenv().PREDICTION = 0.161091
        elseif ping < 80 then
            getgenv().PREDICTION = 0.1582039340
        elseif ping < 70 then
              getgenv().PREDICTION = 0.138682
              elseif ping < 65 then
              getgenv().PREDICTION = 0.126423672
        elseif ping < 50 then
              getgenv().PREDICTION = 0.1354024
        elseif ping < 30 then
     getgenv().PREDICTION = 0.1125247699
        end
    elseif getgenv().AutoPredType == "Math" then       
 if not Plr or Plr == nil then
      return
   end
        local Distance = (game.Players.LocalPlayer.Character.PrimaryPart.Position - Plr.Character.PrimaryPart.Position).Magnitude
        if Distance <= Ranges.Mid then
                getgenv().PREDICTION = 0.1 + (ping * 0.0005675)
        elseif Distance <= Ranges.Close then
                getgenv().PREDICTION = 0.1 + (ping * 0.0007675)
        else
        getgenv().PREDICTION = 0.1 + (ping * 0.0003975)
        end
  end
end

if getgenv().Settings.xgredic.Resolver.Enabled then
if getgenv().Settings.xgredic.Resolver.Type == "Delta Time" then
print("wsg")
end
if getgenv().Settings.xgredic.Resolver.Type == "Recalculator" then
print("wsg")
end
if getgenv().Settings.xgredic.Resolver.Type == "No Y Velocity" then
print("wsg")
end
end
    end)


game:GetService"RunService".Stepped:connect(function()
    if enabled and getgenv().Settings.xgredic.Camera.Enabled then
        if Plr ~= nil then
            local shakeOffset = V3(
                math.random(-getgenv().ShakeX, getgenv().ShakeX),
                math.random(-getgenv().ShakeY, getgenv().ShakeY),
                0
            ) * 0.1
local HorizontalLookPosition = CFrame.new(CC.CFrame.p, GetCamPrediction(Plr.Character[getgenv().SelectedPart]).Position+shakeOffset)
      CC.CFrame = CC.CFrame:Lerp(HorizontalLookPosition, getgenv().HorizontalSmoothness)
    end
end
end)

-- List of Games and Their Configurations
local Games = {
    [16469595315] = {Name = "Del Hood Aim", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17319408836] = {Name = "OG Da Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [14975320521] = {Name = "Ar Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17200018150] = {Name = "Hood Of AR", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [15644861772] = {Name = "Flame Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17723797487] = {Name = "Dee Hood", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [17897702920] = {Name = "Og Da Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17809101348] = {Name = "New Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17344804827] = {Name = "Yeno Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [16435867341] = {Name = "Mad Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [14412601883] = {Name = "Hood Bank", Arg = "MOUSE", Remote = "MAINEVENT"},
    [14412436145] = {Name = "Da Uphill", Arg = "MOUSE", Remote = "MAINEVENT"},
    [14487637618] = {Name = "Da Hood Bot Aim Trainer", Arg = "MOUSE", Remote = "MAINEVENT"},
    [11143225577] = {Name = "1v1 Hood Aim Trainer", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [14413712255] = {Name = "Hood Aim", Arg = "MOUSE", Remote = "MAINEVENT"},
    [12927359803] = {Name = "Dah Aim Trainer", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [12867571492] = {Name = "Katana Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [11867820563] = {Name = "Dae Hood", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [17109142105] = {Name = "Da Battles", Arg = "MoonUpdateMousePos", Remote = "MainEvent"},
    [15186202290] = {Name = "Da Strike", Arg = "MOUSE", Remote = "MAINEVENT"},
    [2788229376]  = {Name = "Da Hood", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [16033173781] = {Name = "Da Hood Macro", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [7213786345]  = {Name = "Da Hood VC", Arg = "UpdateMousePosI", Remote = "MainEvent"},
    [9825515356]  = {Name = "Hood Customs", Arg = "MousePosUpdate", Remote = "MainEvent"},
    [17895632819] = {Name = "Hood Spirit", Arg = "UpdateMousePos", Remote = "MainEvent"},
    [5602055394]  = {Name = "Hood Modded", Arg = "MousePos", Remote = "Bullets"},
    [7951883376]  = {Name = "Hood Modded VC", Arg = "MousePos", Remote = "Bullets"},
    [9183932460]  = {Name = "Untitled Hood", Arg = "UpdateMousePos", Remote = ".gg/untitledhood"},
    [14412355918] = {Name = "Da Downhill", Arg = "MOUSE", Remote = "MAINEVENT"}
}

-- Function to retrieve the configuration for the current game ID
local function getGameConfig(gameId)
    return Games[gameId]
end

-- Get the current game ID and fetch the configuration
local currentGameId = game.PlaceId
local gameConfig = getGameConfig(currentGameId)

if gameConfig then
    -- Apply the configuration from the list
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(...)
        local args = {...}
        local vap = {gameConfig.Arg, "GetMousePos", "MousePos", "MOUSE", "MousePosUpdate"}
        if enabled and getnamecallmethod() == "FireServer" and table.find(vap, args[2]) and getgenv().Settings.xgredic.Enabled and Plr.Character ~= nil and getgenv().Settings.xgredic.LOCKTYPE == "Namecall" then
            if getgenv().Prediction == "Normal" then
                args[3] = Plr.Character[getgenv().SelectedPart].Position + 
                          (Vector3.new(Plr.Character.HumanoidRootPart.Velocity.X, math.clamp(Plr.Character.HumanoidRootPart.Velocity.Y, -1, 9), Plr.Character.HumanoidRootPart.Velocity.Z) * getgenv().PREDICTION)
            elseif getgenv().Prediction == "Yun" then
                args[3] = Plr.Character[getgenv().SelectedPart].Position + 
                          Vector3.new(Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.X * getgenv().PREDICTION / 10, 
                                      Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Y * getgenv().JUMPPREDICTION / 10, 
                                      Plr.Character.HumanoidRootPart.AssemblyLinearVelocity.Z * getgenv().PREDICTION / 10)
            else
                args[3] = Plr.Character[getgenv().SelectedPart].Position
            end
            return old(unpack(args))
        end
        return old(...)
    end)
end

local Hooks = {}
local Client = game.Players.LocalPlayer

Hooks[1] = hookmetamethod(Client:GetMouse(), "__index", newcclosure(function(self, index)
    if index == "Hit" and getgenv().Settings.xgredic.LOCKTYPE == "Index" and enabled and Plr.Character ~= nil and getgenv().Settings.xgredic.Enabled then
            local position = CFrame.new(Plr.Character[getgenv().SelectedPart].Position+(V3(Plr.Character.HumanoidRootPart.Velocity.X,math.clamp(Plr.Character.HumanoidRootPart.Velocity.Y,-1,9),Plr.Character.HumanoidRootPart.Velocity.Z)*getgenv().PREDICTION))
            return position
        
    end
    return Hooks[1](self, index)
end))

getgenv().CFrameDesync = {
           Enabled = false,
           AnglesEnabled = false,
           Type = "Target Strafe",
           Visualize = false,
           VisualizeColor = Color3.fromRGB(30,255,30),
           Random = {
               X = 5,
               Y = 5,
               Z = 5,
               AnglesX = 5,
               AnglesY = 5,
               AnglesZ = 5,
               },
           Custom = {
               X = 5,
               Y = 5,
               Z = 5,
               AnglesX = 5,
               AnglesY = 5,
               AnglesZ = 5,
               },
           TargetStrafe = {
               Speed = 10,
               Height = 10,
               Distance = 7,
               },
}
local straight = {
         Visuals = {},
         Desync = {},
         Hooks = {},
         Connections = {}
}
local RunService = game:GetService("RunService")

task.spawn(function()
straight.Visuals["R6Dummy"] = game:GetObjects("rbxassetid://9474737816")[1]; straight.Visuals["R6Dummy"].Head.Face:Destroy(); for i, v in pairs(straight.Visuals["R6Dummy"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = Color3.fromRGB(0,255,0); v.CanCollide = false; v.Anchored = false end
end)

local Utility = {}

    function Utility:Connection(connectionType, connectionCallback)
        local connection = connectionType:Connect(connectionCallback)
        straight.Connections[#straight.Connections + 1] = connection
        return connection
    end

Utility:Connection(RunService.PostSimulation, function()
if getgenv().CFrameDesync.AnglesEnabled or getgenv().CFrameDesync.Enabled then
        straight.Desync[1] = lplr.Character.HumanoidRootPart.CFrame
        local cframe = lplr.Character.HumanoidRootPart.CFrame
        if getgenv().CFrameDesync.Enabled then
            if getgenv().CFrameDesync.Type == "Random" then
                cframe = cframe * CFrame.new(math.random(-getgenv().CFrameDesync.Random.X, getgenv().CFrameDesync.Random.X), math.random(-getgenv().CFrameDesync.Random.Y, getgenv().CFrameDesync.Random.Y), math.random(-getgenv().CFrameDesync.Random.Z, getgenv().CFrameDesync.Random.Z))
            elseif getgenv().CFrameDesync.Type == "Custom" then
                cframe = cframe * CFrame.new(getgenv().CFrameDesync.Custom.X, getgenv().CFrameDesync.Custom.Y, getgenv().CFrameDesync.Custom.Z)
            elseif getgenv().CFrameDesync.Type == "Mouse" then
                cframe = CFrame.new(lplr:GetMouse().Hit.Position)
            elseif getgenv().CFrameDesync.Type == "Target Strafe" then
            if enabled and Plr ~= nil then
                local currentTime = tick() 
                cframe = CFrame.new(Plr.Character[getgenv().SelectedPart].Position) * CFrame.Angles(0, 2 * math.pi * currentTime * getgenv().CFrameDesync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, getgenv().CFrameDesync.TargetStrafe.Height, getgenv().CFrameDesync.TargetStrafe.Distance)
            elseif getgenv().CFrameDesync.Type == "Local Strafe" then
                local currentTime = tick() 
                cframe = CFrame.new(lplr.Character.HumanoidRootPart.Position) * CFrame.Angles(0, 2 * math.pi * currentTime * getgenv().CFrameDesync.TargetStrafe.Speed % (2 * math.pi), 0) * CFrame.new(0, getgenv().CFrameDesync.TargetStrafe.Height, getgenv().CFrameDesync.TargetStrafe.Distance)
                end
      end

        if getgenv().CFrameDesync.Visualize then
            straight.Visuals["R6Dummy"].Parent = workspace
            straight.Visuals["R6Dummy"].HumanoidRootPart.Velocity = Vector3.new()
            straight.Visuals["R6Dummy"]:SetPrimaryPartCFrame(cframe)
            for i, v in pairs(straight.Visuals["R6Dummy"]:GetChildren()) do v.Transparency = v.Name == "HumanoidRootPart" and 1 or 0.70; v.Material = "Neon"; v.Color = getgenv().CFrameDesync.VisualizeColor; v.CanCollide = false; v.Anchored = false end
        else
            straight.Visuals["R6Dummy"].Parent = nil
        end

        if getgenv().CFrameDesync.AnglesEnabled then
            if getgenv().CFrameDesync.Type == "Random" then
                cframe = cframe * CFrame.Angles(math.rad(math.random(getgenv().CFrameDesync.Random.AnglesX)), math.rad(math.random(getgenv().CFrameDesync.Random.AnglesY)), math.rad(math.random(getgenv().CFrameDesync.Random.AnglesZ)))
            elseif getgenv().CFrameDesync.Type == "Custom" then
                cframe = cframe * CFrame.Angles(math.rad(getgenv().CFrameDesync.Custom.AnglesX), math.rad(getgenv().CFrameDesync.Custom.AnglesY), math.rad(getgenv().CFrameDesync.Custom.AnglesZ))
            end
        end
        lplr.Character.HumanoidRootPart.CFrame = cframe
        RunService.RenderStepped:Wait()
        lplr.Character.HumanoidRootPart.CFrame = straight.Desync[1]
    else
        if straight.Visuals["R6Dummy"].Parent ~= nil then
            straight.Visuals["R6Dummy"].Parent = nil
        end
    end
end
end)

--// Hooks
local MainHookingFunctionsTick = tick()
--
straight.Hooks[1] = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if not checkcaller() then
        if key == "CFrame" and straight.Desync[1] and (getgenv().CFrameDesync.AnglesEnabled or getgenv().CFrameDesync.Enabled) and lplr.Character and lplr.Character:FindFirstChild("HumanoidRootPart") and lplr.Character:FindFirstChild("Humanoid") and lplr.Character:FindFirstChild("Humanoid").Health > 0 then
            if self == lplr.Character.HumanoidRootPart then
                return straight.Desync[1] or CFrame.new()
            elseif self == lplr.Character.Head then
                return straight.Desync[1] and straight.Desync[1] + Vector3.new(0, lplr.Character.HumanoidRootPart.Size / 2 + 0.5, 0) or CFrame.new()
            end
        end
    end
    return straight.Hooks[1](self, key)
end))

isToolActivationEnabled = false -- Set to true to enable tool activation

local function activateTool()
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool and tool:IsA("Tool") then
            tool:Activate()
        end
    end
end

RunService.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")

        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            activateTool()
        end
    end
end)

-- Example of toggling the activation
local function toggleToolActivation()
    isToolActivationEnabled = not isToolActivationEnabled -- Toggle the boolean value
end

local ScriptProperties = {
    ScriptName = "xgre.lol",
    ScriptSizeOne = 450,
    ScriptSizeTwo = 600,
    ScriptAccent = Color3.fromRGB(125, 250, 131),

    UserPanel = {
        Status = "FREE"
    }
}

local LocalPlayer = game.Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Library = library

local Window = Library:New({ Name = ScriptProperties.ScriptName, Accent = Color3.fromRGB(125, 250, 131) })
--
local parts = {
    "Head",
    "UpperTorso",
    "RightUpperArm",
    "RightLowerArm",
    "RightUpperArm",
    "LeftUpperArm",
    "LeftLowerArm",
    "LeftFoot",
    "RightFoot",
    "LowerTorso",
    "LeftHand",
    "RightHand",
    "RightUpperLeg",
    "LeftUpperLeg",
    "LeftLowerLeg",
    "RightLowerLeg"
}
local Pred = 0.14
local Pos = 0
local mouse = game.Players.LocalPlayer:GetMouse()
local Player = game:GetService("Players").LocalPlayer
local runService = game:service("RunService")
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Define Main and Options Tabs
Main = Window:Page({ Name = "Main" })
Options = Window:Page({ Name = "Options" })

local Sections = {
    -- Main Tab Sections
    Configuration = Main:Section({ Name = "Configuration", Side = "Right", Max = 7 }),
    Visuals = Main:Section({ Name = "Visuals", Side = "Left", Max = 7 }),
    Misc = Main:Section({ Name = "Misc", Side = "Right", Max = 7 }),
    Player = Main:Section({ Name = "Player", Side = "Left", Max = 7 }), -- Left empty as requested
    
    -- Options Tab Sections
    Options = {
        Configs = Options:Section({ Name = "Configuration", Side = "Left" }),
        ScriptStuff = Options:Section({ Name = "Utilities", Side = "Right" })
    }
}

-- TargetAim and Aimbot features in Configuration Section of Main Tab
TargetAimToggle = Sections.Configuration:Toggle({
    Name = "Enabled",
    Default = false,
    Pointer = "5",
    callback = function(state)
        getgenv().Settings.xgredic.Enabled = state
    end
})

AimlockMethod = Sections.Configuration:Dropdown({
    Name = "Method",
    Options = { "Namecall", "Index" },
    Default = "Namecall",
    Pointer = "5",
    callback = function(state)
        getgenv().Settings.xgredic.LOCKTYPE = state
    end
})

Sections.Configuration:Box({ Name = "Prediction", Callback = function(text)
    getgenv().PREDICTION = text
end })

AutoPredThing = Sections.Configuration:Toggle({
    Name = "Auto Prediction",
    Default = false,
    Pointer = "5",
    callback = function(state)
        getgenv().Settings.xgredic.AUTOPRED = state
    end
})

AutoPredMethod = Sections.Configuration:Dropdown({
    Name = "AutoPred Type",
    Options = { "Ping Base", "Advance" },
    Default = "Ping Base",
    Pointer = "5",
    callback = function(state)
        getgenv().AutoPredType = state
    end
})

-- Other features (from TargetAim and Aimbot)
CamlockToggle = Sections.Configuration:Toggle({
    Name = "Camera Lock Enabled",
    Default = false,
    Pointer = "5",
    callback = function(state)
        getgenv().Settings.xgredic.Camera.Enabled = state
    end
})

Sections.Configuration:Box({ Name = "Smoothness", Callback = function(text)
    getgenv().HorizontalSmoothness = text
end })

AimPart = Sections.Configuration:Dropdown({
    Name = "AimPart",
    Options = {
        "Head", "UpperTorso", "RightUpperArm", "RightLowerArm", "RightUpperArm",
        "LeftUpperArm", "LeftLowerArm", "LeftFoot", "RightFoot", "LowerTorso",
        "LeftHand", "RightHand", "RightUpperLeg", "LeftUpperLeg", "LeftLowerLeg", "RightLowerLeg"
    },
    Default = "HumanoidRootPart",
    Pointer = "5",
    callback = function(state)
        getgenv().SelectedPart = state
    end
})

-- Visuals Section on Main Tab
LightingSettingsToggle = Sections.Visuals:Toggle({
    Name = "Enable Lighting Settings",
    Default = false,
    Pointer = "LightingEnabled",
    Callback = function(enabled)
        lightingEnabled = enabled
    end
})

TimeOfDaySlider = Sections.Visuals:Slider({
    Name = "Time of Day",
    Minimum = 0,
    Maximum = 24,
    Default = 1,
    Decimals = 0.1,
    Pointer = "TimeOfDay",
    Callback = function(value)
        if lightingEnabled then
            game.Lighting.ClockTime = value
        end
    end
})

-- Other Visuals Sliders and Toggles...
-- Additional Visuals Features in Visuals Section on Main Tab
BrightnessSlider = Sections.Visuals:Slider({
    Name = "Brightness",
    Minimum = 0,
    Maximum = 5,
    Default = 1,
    Decimals = 0.1,
    Pointer = "Brightness",
    Callback = function(value)
        if lightingEnabled then
            game.Lighting.Brightness = value
        end
    end
})

ColorCorrectionToggle = Sections.Visuals:Toggle({
    Name = "Enable Color Correction",
    Default = false,
    Pointer = "ColorCorrectionEnabled",
    Callback = function(enabled)
        if enabled then
            local colorCorrection = Instance.new("ColorCorrectionEffect", game.Lighting)
            colorCorrection.Saturation = 0.2
            colorCorrection.TintColor = Color3.fromRGB(255, 204, 153)
            colorCorrection.Contrast = 0.1
        else
            for _, effect in ipairs(game.Lighting:GetChildren()) do
                if effect:IsA("ColorCorrectionEffect") then
                    effect:Destroy()
                end
            end
        end
    end
})

-- Misc Section on Main Tab
AntiAFKToggle = Sections.Misc:Toggle({
    Name = "Anti-AFK",
    Default = true,
    Pointer = "AntiAFKEnabled",
    Callback = function(enabled)
        getgenv().AntiAFKEnabled = enabled
        if enabled then
            -- Anti-AFK logic
            local VirtualUser = game:GetService("VirtualUser")
            game.Players.LocalPlayer.Idled:connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
})

WalkSpeedSlider = Sections.Misc:Slider({
    Name = "Walk Speed",
    Minimum = 16,
    Maximum = 100,
    Default = 16,
    Pointer = "WalkSpeed",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

JumpPowerSlider = Sections.Misc:Slider({
    Name = "Jump Power",
    Minimum = 50,
    Maximum = 200,
    Default = 50,
    Pointer = "JumpPower",
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

-- Player Section on Main Tab (left empty as requested)
-- Placeholder for any future customization
-- Player Section on Main Tab

-- Body Material Dropdown
BodyMaterialDropdown = Sections.Player:Dropdown({
    Name = "Body Material",
    Options = {
        "Plastic", "Wood", "Slate", "Concrete", "CorrodedMetal", "DiamondPlate",
        "Foil", "Grass", "Ice", "Marble", "Granite", "Brick", "Pebble", "Sand",
        "Fabric", "SmoothPlastic", "Metal", "WoodPlanks", "Cobblestone", "Neon",
        "Glass", "ForceField"
    },
    Default = "Plastic",
    Pointer = "BodyMaterial",
    Callback = function(selectedMaterial)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Material = Enum.Material[selectedMaterial]
            end
        end
    end
})

-- Body Material Color Picker
MaterialColorPicker = Sections.Player:ColorPicker({
    Name = "Material Color",
    Default = Color3.new(1, 1, 1),
    Pointer = "MaterialColor",
    Callback = function(color)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Color = color
            end
        end
    end
})

-- Trail Effect Toggle
TrailEffectToggle = Sections.Player:Toggle({
    Name = "Trail Effect",
    Default = false,
    Pointer = "TrailEffect",
    Callback = function(enabled)
        if enabled then
            local character = game.Players.LocalPlayer.Character
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and not part:FindFirstChild("Trail") then
                    local trail = Instance.new("Trail", part)
                    trail.Attachment0 = Instance.new("Attachment", part)
                    trail.Attachment1 = Instance.new("Attachment", part)
                    trail.Lifetime = 0.5
                    trail.Transparency = NumberSequence.new(0, 1)
                    trail.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(0, 0, 0))
                    trail.Enabled = true
                end
            end
        else
            for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part:FindFirstChild("Trail") then
                    part.Trail:Destroy()
                end
            end
        end
    end
})

-- Body Reflectance Slider
BodyReflectanceSlider = Sections.Player:Slider({
    Name = "Body Reflectance",
    Minimum = 0,
    Maximum = 1,
    Default = 0,
    Decimals = 0.1,
    Pointer = "BodyReflectance",
    Callback = function(value)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Reflectance = value
            end
        end
    end
})

-- Body Transparency Slider
BodyTransparencySlider = Sections.Player:Slider({
    Name = "Body Transparency",
    Minimum = 0,
    Maximum = 1,
    Default = 0,
    Decimals = 0.1,
    Pointer = "BodyTransparency",
    Callback = function(value)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = value
            end
        end
    end
})

-- Glow Effect Toggle
GlowEffectToggle = Sections.Player:Toggle({
    Name = "Glow Effect",
    Default = false,
    Pointer = "GlowEffect",
    Callback = function(enabled)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                if enabled then
                    local highlight = Instance.new("Highlight", part)
                    highlight.FillColor = Color3.new(0.8, 0.8, 0.2)  -- Light yellow glow
                    highlight.OutlineTransparency = 1
                else
                    if part:FindFirstChild("Highlight") then
                        part.Highlight:Destroy()
                    end
                end
            end
        end
    end
})

-- Body Outline Toggle
BodyOutlineToggle = Sections.Player:Toggle({
    Name = "Body Outline",
    Default = false,
    Pointer = "BodyOutline",
    Callback = function(enabled)
        for _, part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                if enabled then
                    local selectionBox = Instance.new("SelectionBox", part)
                    selectionBox.Adornee = part
                    selectionBox.LineThickness = 0.05
                    selectionBox.Color3 = Color3.new(1, 1, 1)  -- White outline
                else
                    if part:FindFirstChild("SelectionBox") then
                        part.SelectionBox:Destroy()
                    end
                end
            end
        end
    end
})

-- Force Field Toggle
ForceFieldToggle = Sections.Player:Toggle({
    Name = "Force Field",
    Default = false,
    Pointer = "ForceField",
    Callback = function(enabled)
        local character = game.Players.LocalPlayer.Character
        if enabled then
            local forceField = Instance.new("ForceField", character)
        else
            if character:FindFirstChildOfClass("ForceField") then
                character:FindFirstChildOfClass("ForceField"):Destroy()
            end
        end
    end
})

-- Humanoid Jump Power Slider
JumpPowerSlider = Sections.Player:Slider({
    Name = "Jump Power",
    Minimum = 50,
    Maximum = 200,
    Default = 50,
    Decimals = 1,
    Pointer = "JumpPower",
    Callback = function(value)
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = value
        end
    end
})

-- Variables to track the current configuration
local currentconfig = ""
local configname = ""

-- Configuration Options Section
ConfigStuff = {
    -- Dropdown for selecting a saved config
    configdropdown = Sections.Options.Configs:Dropdown {
        Name = "Select Config",
        Options = Library:ListConfigs(),
        Callback = function(option)
            currentconfig = option
        end
    },

    -- Text box to enter a new configuration name
    configNameBox = Sections.Options.Configs:Box {
        Name = "Config Name",
        Callback = function(text)
            configname = text
        end
    },

    -- Save button to save current configuration with the entered name
    saveButton = Sections.Options.Configs:Button {
        Name = "Save",
        Callback = function()
            Library:SaveConfig(configname)
            ConfigStuff.configdropdown:Refresh(Library:ListConfigs())
        end
    },

    -- Load button to load the selected configuration
    loadButton = Sections.Options.Configs:Button {
        Name = "Load",
        Callback = function()
            Library:LoadConfig(currentconfig)
        end
    },

    -- Delete button to delete the selected configuration
    deleteButton = Sections.Options.Configs:Button {
        Name = "Delete",
        Callback = function()
            Library:DeleteConfig(currentconfig)
            ConfigStuff.configdropdown:Refresh(Library:ListConfigs())
        end
    }
}

-- ScriptStuff Section for Keybinds and Other Settings in Options Tab
SettingsSection = {
    -- Keybind to toggle the UI
    UiToggle = Sections.Options.ScriptStuff:Keybind {
        Name = "UI Toggle Keybind",
        Default = Enum.KeyCode.RightShift,
        Blacklist = { Enum.UserInputType.MouseButton1 },
        Flag = "UIToggleBind",
        Callback = function(key, fromsetting)
            if not fromsetting then
                Library:Toggle()
            end
        end
    },

    -- Keybind to toggle the watermark display
    WaterMarkToggle = Sections.Options.ScriptStuff:Keybind {
        Name = "Watermark Toggle",
        Default = Enum.KeyCode.RightControl,
        Blacklist = { Enum.UserInputType.MouseButton1 },
        Flag = "WatermarkToggle",
        Callback = function(key, fromsetting)
            if not fromsetting then
                watermark:Toggle()
            end
        end
    },

    -- Toggle for enabling/disabling visual enhancements
    VisualEnhancementsToggle = Sections.Options.ScriptStuff:Toggle {
        Name = "Enable Visual Enhancements",
        Default = false,
        Callback = function(enabled)
            if enabled then
                -- Code to enable visual enhancements
            else
                -- Code to disable visual enhancements
            end
        end
    },

    -- Auto-Save Config Toggle
    AutoSaveToggle = Sections.Options.ScriptStuff:Toggle {
        Name = "Auto-Save Config",
        Default = false,
        Callback = function(enabled)
            print("Auto-Save Config:", enabled)
        end
    },

    -- FPS Display Toggle
    FPSToggle = Sections.Options.ScriptStuff:Toggle {
        Name = "Show FPS Counter",
        Default = false,
        Callback = function(enabled)
            if enabled then
                fpsCounter:Show()
            else
                fpsCounter:Hide()
            end
        end
    },

    -- Theme Selector Dropdown
    ThemeDropdown = Sections.Options.ScriptStuff:Dropdown {
        Name = "Select Theme",
        Options = { "Dark", "Light", "Custom" },
        Default = "Dark",
        Callback = function(selectedTheme)
            Library:ApplyTheme(selectedTheme)
        end
    },

    -- Reset Button for UI and Settings
    ResetUIButton = Sections.Options.ScriptStuff:Button {
        Name = "Reset UI/Settings",
        Callback = function()
            Library:ResetSettings()
        end
    }
}

Library:ChangeAccent(Color3.fromRGB(87, 250, 96))
Library:ChangeOutline { Color3.fromRGB(87, 250, 96), Color3.fromRGB(87, 250, 96) }

Library:Initialize()