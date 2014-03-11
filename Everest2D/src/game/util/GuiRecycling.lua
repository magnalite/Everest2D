_G.GuiRecycling = {}

_G.GuiRecycling.Guis = {}

function _G.GuiRecycling.addGui(gui)
	table.insert(_G.GuiRecycling.Guis, gui)
	gui.Parent = nil
end

function _G.GuiRecycling.getGui()
	if #_G.GuiRecycling.Guis > 1 then
		local gui = _G.GuiRecycling.Guis[#_G.GuiRecycling.Guis]
		gui.Image = ""
		table.remove(_G.GuiRecycling.Guis, #_G.GuiRecycling.Guis)
		return gui
	else
		return Instance.new("ImageLabel")
	end
end