--Heads up display

repeat wait() until _G.Import
_G.Import("Import")

Import("Class")

do Inventory = Class("Inventory")
	
	function Inventory.new(hud)
		local inventory = {}
		setmetatable(inventory, Inventory)
		
		inventory.frame = Instance.new("Frame", hud.frame)
		inventory.frame.Size = UDim2.new(0,250,0,300)
		inventory.frame.Position = UDim2.new(1,-250,1,-370)
		inventory.frame.BackgroundTransparency = 0.7
		inventory.frame.BorderColor3 = Color3.new(0,0,0)
		inventory.frame.BorderSizePixel = 3
		inventory.frame.ZIndex = 10
		inventory.frame.Visible = false
		
		return inventory
	end
	
	function Inventory:hide()
		self.frame.Visible = false
	end
	
	function Inventory:show()
		self.frame.Visible = true
	end
	
	function Inventory:toggleVisibility()
		if self.frame.Visible == false then
			self.frame.Visible = true
		else
			self.frame.Visible = false
		end
	end
	
end