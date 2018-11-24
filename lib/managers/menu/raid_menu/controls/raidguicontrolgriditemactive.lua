RaidGUIControlGridItemActive = RaidGUIControlGridItemActive or class(RaidGUIControlGridItem)

function RaidGUIControlGridItemActive:init(parent, params, item_data, grid_params)
	RaidGUIControlGridItemActive.super.init(self, parent, params, item_data, grid_params)
end

function RaidGUIControlGridItemActive:active()
	return self._active
end

function RaidGUIControlGridItemActive:activate()
	self._active = true

	self._triangle_markers_panel:show()
end

function RaidGUIControlGridItemActive:deactivate()
	self._active = false

	self._triangle_markers_panel:hide()
end

function RaidGUIControlGridItemActive:select_on()
	self._select_background_panel:show()
end

function RaidGUIControlGridItemActive:select_off()
	self._select_background_panel:hide()
end
