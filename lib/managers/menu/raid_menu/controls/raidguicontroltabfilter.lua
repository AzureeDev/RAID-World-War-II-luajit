RaidGUIControlTabFilter = RaidGUIControlTabFilter or class(RaidGUIControl)
RaidGUIControlTabFilter.PADDING = 16
RaidGUIControlTabFilter.BOTTOM_LINE_NORMAL_HEIGHT = 2
RaidGUIControlTabFilter.BOTTOM_LINE_ACTIVE_HEIGHT = 5
RaidGUIControlTabFilter.DIVIDER_WIDTH = 2
RaidGUIControlTabFilter.DIVIDER_HEIGHT = 14

function RaidGUIControlTabFilter:init(parent, params)
	RaidGUIControlTabFilter.super.init(self, parent, params)

	self._object = parent:panel({
		name = "tab_panel_" .. self._name,
		x = params.x,
		y = params.y,
		w = params.w,
		h = params.h,
		layer = parent:layer() + 1
	})
	self._tab_label = self._object:label({
		vertical = "center",
		align = "center",
		y = 0,
		x = 0,
		name = "tab_control_label_" .. self._name,
		w = params.w,
		h = params.h,
		text = params.text,
		font = tweak_data.gui.fonts.din_compressed,
		font_size = tweak_data.gui.font_sizes.extra_small,
		color = tweak_data.gui.colors.raid_grey,
		layer = self._object:layer() + 1
	})
	self._callback_param = params.callback_param
	self._tab_select_callback = params.tab_select_callback
	self._selected = false
end

function RaidGUIControlTabFilter:needs_divider()
	return true
end

function RaidGUIControlTabFilter:needs_bottom_line()
	return false
end

function RaidGUIControlTabFilter:set_divider()
	self._divider = self._object:rect({
		x = self._tab_label:right() - RaidGUIControlTabFilter.DIVIDER_WIDTH / 2,
		y = (self._params.h - RaidGUIControlTabFilter.DIVIDER_HEIGHT) / 2,
		w = RaidGUIControlTabFilter.DIVIDER_WIDTH,
		h = RaidGUIControlTabFilter.DIVIDER_HEIGHT,
		color = tweak_data.gui.colors.raid_grey
	})
end

function RaidGUIControlTabFilter:get_callback_param()
	return self._callback_param
end

function RaidGUIControlTabFilter:highlight_on()
end

function RaidGUIControlTabFilter:highlight_off()
end

function RaidGUIControlTabFilter:select()
	self._tab_label:set_color(tweak_data.gui.colors.raid_white)

	self._selected = true
end

function RaidGUIControlTabFilter:unselect()
	self._tab_label:set_color(tweak_data.gui.colors.raid_grey)

	self._selected = false
end

function RaidGUIControlTabFilter:mouse_released(o, button, x, y)
	self:on_mouse_released(button, x, y)

	return true
end

function RaidGUIControlTabFilter:on_mouse_released(button, x, y)
	if self._params.tab_select_callback then
		self._params.tab_select_callback(self._params.tab_idx, self._callback_param)
	end

	return true
end
