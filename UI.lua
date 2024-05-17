
local Services = setmetatable({}, {__index = function(Self, Index)
	return game:GetService(Index)
end})


local Players = Services.Players
local UserInputService = Services.UserInputService
local RunService = Services.RunService
local ts = Services.TweenService
local localPlayer = Players.LocalPlayer

local Mouse = localPlayer:GetMouse();
local INew = Instance.new;
local colorNew, color3RGB = Color3.new, Color3.fromRGB;

local Library, Utility = {
	Keybind = Enum.KeyCode.LeftControl,
	Connections = {},
	InstanceStorage = {}
}, {

	Theme = {
		Accent = color3RGB(81, 208, 26),
    RiskyText = color3RGB(255,0,0),
		Background = color3RGB(6, 4, 6),
		Light_Text = color3RGB(255, 255, 255),
		Dark_Text =color3RGB(160, 160, 160),
    darkIndication =color3RGB(180, 180, 180),
		Bar = color3RGB(8, 9, 14),
		Outline = Color3.fromRGB(48, 48, 48) 
	}
}
function Utility:convert_number_range(value: number, min_old: number, max_old: number, min_new: number, max_new: number)
	return (((value - min_old) * (max_new - min_new)) / (max_old - min_old)) + min_new
end

function Utility:UpdateObject(Object, Property, Value)
	if not Library.InstanceStorage[Object] then
		Library.InstanceStorage[Object] = {
			[Property] = Value
		}
	else
		Library.InstanceStorage[Object][Property] = Value
	end
end
function Utility:SetTheme(Theme, Color)
	if Utility.Theme[Theme] ~= Color then
		Utility.Theme[Theme] = Color
		--
		for Index, Value in pairs(Library.InstanceStorage) do
			for Index2, Value2 in pairs(Value) do
				if Value2 == Theme then
					Index[Index2] = Color
				end
			end
		end
	end
end

function Utility:MakeDraggable(Object)

end
function Utility:Render(ObjectType, Properties,Children)
	local obj = {}
	local Passed, Statement = pcall(function()
		local Object = INew(ObjectType)

		for Property, Value in pairs(Properties) do
			if string.find(Property,"Color") and ObjectType ~="UIGradient" then 
				local Theme = self.Theme[Value]
				self:UpdateObject(Object, Property, Value)
				Object[Property] = Theme

			else 
				Object[Property] = Value
			end 

		end
		if Children then
			for Index, Child in pairs(Children) do
				Child.Parent = Object
			end
		end
		table.insert(Library.InstanceStorage,Object)

		return Object
	end)


	if Passed then
		return Statement
	else
		warn("Failed to render object: " .. tostring(ObjectType), tostring(Statement))
		return nil
	end
end

function Utility:Tween(Object, Properties, Duration, ...)
	local Arguments = {...};
	local Tween;
	local Passed, Statement = pcall(function()
		if Library.Animation then
			Tween = ts:Create(Object, TweenInfo.new(Duration, unpack(Arguments)), Properties);
			Tween:Play();
		else
			for Property, Value in pairs(Properties) do
				Object[Property] = Value;
			end
		end
	end)
	if Passed then
		return Tween;
	else
		warn(Statement);
	end
end
function Utility:CopyTable(tbl)
	local newtbl = {}
	for i, v in pairs(tbl) do
		table.insert(newtbl,tostring(v))
	end
	return newtbl
end

function Utility:Signal(Event, Function)
	local Connection;
	local Passed, Statement = pcall(function()
		Connection = Event:Connect(Function);
	end)
	if Passed then
		table.insert(Library.Connections, Connection);
		return Connection;
	else
		warn(Event, Statement);
		return nil;
	end
end

function Utility:Thread(Function, ...)
	local Arguments = {...};
	local Thread;
	local Passed, Statement = pcall(function()
		coroutine.wrap(Function)(unpack(Arguments));
	end)
	if Passed then
		return Statement;
	else
		warn(Statement);
	end
end

function ripple(button, x, y)
	Utility:Thread(function()
		button.ClipsDescendants = true

		local Circle = Instance.new("ImageLabel")
		Circle.ScaleType = Enum.ScaleType.Stretch
		Circle.Parent = button
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 1.000
		Circle.ZIndex = 10
		Circle.Image = "rbxassetid://266543268"
		Circle.ImageColor3 = Color3.fromRGB(210,210,210)
		Circle.ImageTransparency = 0.4
		local uiCorner =   Utility:Render("UICorner", {
			CornerRadius = UDim.new(0, 4),
			Parent = Circle

		})
		local new_x = x - Circle.AbsolutePosition.X
		local new_y = y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, new_x, 0, new_y)

		local size = 0
		if button.AbsoluteSize.X > button.AbsoluteSize.Y then
			size = button.AbsoluteSize.X * 1.5
		elseif button.AbsoluteSize.X < button.AbsoluteSize.Y then
			size = button.AbsoluteSize.Y * 1.5
		elseif button.AbsoluteSize.X == button.AbsoluteSize.Y then
			size = button.AbsoluteSize.X * 1.5
		end

		Circle:TweenSizeAndPosition(UDim2.new(0, size, 0, size), UDim2.new(0.5, -size / 2, 0.5, -size / 2), "Out", "Quad", 0.5, false, nil)
		ts:Create(Circle, TweenInfo.new(0.6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { ImageTransparency = 1}):Play()
		wait(0.6)
		Circle:Destroy()
	end)
end


function Library:Window(Properties)
          local window = {}
         local SCREENGUI = Utility:Render("ScreenGui",{Parent = gethui()})
      local mainFrame = Utility:Render("Frame", {
        BackgroundColor3 = "Background",
        BorderSizePixel = 0,
        Position = UDim2.new(0.149, 0, 0.154, 0),
        Size = UDim2.new(0, 571, 0, 420),
        Parent = SCREENGUI
      })
       local uICorner = Utility:Render("UICorner", {
          CornerRadius = UDim.new(0, 6),
          Parent = mainFrame
        })
    
       local topBar = Utility:Render("Frame", {
          BackgroundColor3 = Color3.fromRGB(10, 9, 10),
          BorderSizePixel = 0,
          Size = UDim2.new(0, 571, 0, 37),
          Parent = mainFrame
        })
        local uICornerOverlayE = Utility:Render("Frame", {
            BackgroundColor3 = "Bar",
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0.5, 0),
            Parent = topBar
          })
    
          local uICorner1 = Utility:Render("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = topBar
          })
    
          local uiTItle = Utility:Render("TextLabel", {
            FontFace = Font.new(
              "rbxassetid://12187365364",
              Enum.FontWeight.Bold,
              Enum.FontStyle.Normal
            ),
            Text = "Qwerty",
            TextColor3 = "Accent",
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 94, 1, 0),
            Parent = topBar
          })
          local uIPadding = Utility:Render("UIPadding", {
              PaddingLeft = UDim.new(0, 6),
              Parent = topBar
            })
        
    
            local topBarline = Utility:Render("Frame", {
            BackgroundColor3 = "Outline",
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 1, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Parent = topBar
          })
    
          local tabs = Utility:Render("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.XY,
            CanvasSize = UDim2.new(2, 0, 0, 0),
            ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.X,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.422, 0, 0, 0),
            Size = UDim2.new(0, 329, 0, 42),
            Parent = topBar
          })
          local uIListLayout = Utility:Render("UIListLayout", {
              FillDirection = Enum.FillDirection.Horizontal,
              SortOrder = Enum.SortOrder.LayoutOrder,
              VerticalAlignment = Enum.VerticalAlignment.Center,
              Parent = tabs
            })
            local bottomBar = Utility:Render("Frame", {
          AnchorPoint = Vector2.new(0, 1),
          BackgroundColor3 = "Bar",
          BorderSizePixel = 0,
          Position = UDim2.new(0, 0, 1, 0),
          Size = UDim2.new(0, 571, 0, 42),
          Parent = mainFrame
        })
        local  uICornerOverlayE1 = Utility:Render("Frame", {
          BackgroundColor3 = "Bar",
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0.5, 0),
            Parent = bottomBar
          })
    
          local uICorner2 = Utility:Render("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = bottomBar
          })
    
          local gameTItle = Utility:Render("TextLabel", {
            FontFace = Font.new(
              "rbxassetid://12187365364",
              Enum.FontWeight.Bold,
              Enum.FontStyle.Normal
            ),
            Text = "Blox Fruits",
            TextColor3 = Color3.fromRGB(81, 208, 26),
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 94, 0, 42),
            Parent = bottomBar
          })
          local uIPadding1 = Utility:Render("UIPadding", {
              PaddingLeft = UDim.new(0, 6),
              Parent = bottomBar
            })
    
            local bottomLine = Utility:Render("Frame", {
            BackgroundColor3 = "Outline",
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
          })
    
          local  user = Utility:Render("TextLabel", {
            FontFace = Font.new(
              "rbxassetid://12187365364",
              Enum.FontWeight.Medium,
              Enum.FontStyle.Normal
            ),
            RichText = true,
            Text = "<font color=\"rgb(81,208,26)\">Welcome,</font> MasterfuII",
            TextColor3 = "Dark_Text",
            TextDirection = Enum.TextDirection.RightToLeft,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Right,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.835, 0, 0.0238, 0),
            Size = UDim2.new(0, 94, 0, 42),
            Parent = bottomBar
          })
          local  uIPadding2 = Utility:Render("UIPadding", {
              PaddingRight = UDim.new(0, 6),
              Parent = user
            })
            local subTabBar = Utility:Render("Frame", {
          BackgroundColor3 = "Bar",
          BorderSizePixel = 0,
          Position = UDim2.new(0, 0, 0.0903, 0),
          Size = UDim2.new(0, 571, 0, 37),
          Parent = mainFrame
        })
        local subTab = Utility:Render("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasSize = UDim2.new(2, 0, 0, 0),
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.X,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = subTabBar
          })
          local  uIListLayout1 = Utility:Render("UIListLayout", {
              FillDirection = Enum.FillDirection.Horizontal,
              SortOrder = Enum.SortOrder.LayoutOrder,
              VerticalAlignment = Enum.VerticalAlignment.Center,
              Parent = subTab
            })
    
            local tabContainer = Utility:Render("Frame", {
          BackgroundTransparency = 1,
          BorderSizePixel = 0,
          Position = UDim2.new(0, 0, 0.207, 0),
          Size = UDim2.new(0, 571, 0, 291),
          Parent = mainFrame
        })
        local  tab = Utility:Render("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.X,
            CanvasPosition = Vector2.new(450, 0),
            CanvasSize = UDim2.new(2, 0, 0, 0),
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.X,
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = tabContainer
          })
          local  uIListLayout2 = Utility:Render("UIListLayout", {
              FillDirection = Enum.FillDirection.Horizontal,
              HorizontalAlignment = Enum.HorizontalAlignment.Center,
              SortOrder = Enum.SortOrder.LayoutOrder,
              VerticalAlignment = Enum.VerticalAlignment.Center,
              Parent = tab
            })
            return window
end
        return Library
