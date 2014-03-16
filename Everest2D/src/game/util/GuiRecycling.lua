_G.GuiRecycling = {}

_G.GuiRecycling.Guis = {}

function _G.GuiRecycling.addGui(gui)
	table.insert(_G.GuiRecycling.Guis, gui)
	gui.Parent = nil
end

function _G.GuiRecycling.getGui()
	if #_G.GuiRecycling.Guis > 50 then
		local gui = _G.GuiRecycling.Guis[1]
		table.remove(_G.GuiRecycling.Guis, 1)
		gui.Image = ""
		return gui
	else
		return Instance.new("ImageLabel")
	end
end