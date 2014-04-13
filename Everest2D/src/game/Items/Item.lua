--Base entity class, should not really be used for anything other than setting up other classes

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Item = Class("Item")

	Item.itemList = {}

	function Item.new(id, spriteSheet, spriteSizeX, spriteSizeY, spritePosX, spritePosY, name, type, currentStatus, maxStack, renderSize)
		item = {}
		setmetatable(item, Item)
		
		table.insert(Item.itemList, item)
		item.id = id
		item.type = type
		item.name = name
		item.currentStatus = currentStatus
		item.maxStack = maxStack
		item.renderSize = renderSize
		item.spriteSheet = spriteSheet
		item.spritePosX = spritePosX
		item.spritePosY = spritePosY
		
		item.frame = Instance.new("ImageButton")
		item.frame.BackgroundTransparency = 1
		item.frame.Image = spriteSheet.url
		item.frame.ImageRectSize = Vector2.new(spriteSizeX, spriteSizeY)
		item.frame.ImageRectOffset = Vector2.new(spritePosX, spritePosY)
		item.frame.MouseEnter:connect(item.mouseEntered)
		item.frame.MouseLeave:connect(item.mouseLeft)
		item.frame.MouseMoved:connect(item.mouseMoved)
		
		item.toolTip = Instance.new("TextLabel", item.frame)
		item.toolTip.Text = name
		item.toolTip.BackgroundTransparency = 1
		item.toolTip.TextColor3 = Color3.new(1,1,1)
		item.toolTip.TextStrokeTransparency = 0
		item.toolTip.ZIndex = 10
		item.toolTip.Visible = false
		
		return item
	end

	function Item:render()
		--Items should have their own render function due to graphical diversity
		error("Attempted to render base item")
	end	
	
	function Item:mouseEntered()
		self.toolTip.Visible = true
	end
	
	function Item:mouseLeft()
		self.toolTip.Visible = false
	end
	
	function Item:mouseMoved(x,y)
		self.toolTip.Position = UDim2.new(0, x, 0, y)
	end
	
end