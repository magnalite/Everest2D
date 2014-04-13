--Base mob class, mobs should extend this class

repeat wait() until _G.Import
_G.Import("Import")

Import("Extends")
Import("Item")
Import("SpriteSheet")

do TestStaff = Extends("TestStaff", Item)

	function TestStaff.new(currentStatus)
		local testStaff = Item.new(1, SpriteSheet.BasicSpriteSheet, 31, 31, 4*32 + 1, 0, "TestStaff", "Staff", currentStatus, 1, UDim2.new(1,0,1,0))
		setmetatable(testStaff, TestStaff)
		
		testStaff.isWeapon = true
		
		return testStaff
	end
	
	function TestStaff:render()
		if self.currentStatus == "Inventory" then
			self.frame.Name = "TestStaff"
			self.frame.Parent = _G.localgame.screen.hud.inventory.frame
			self.frame.ZIndex = 10
			self.frame.Size = UDim2.new(1/5,0,1/6,0)
			self.frame.Position = UDim2.new((self.inventorySlot % 5) / 5, 0, math.floor(self.inventorySlot / 5), 0)
		end
	
	end

end
