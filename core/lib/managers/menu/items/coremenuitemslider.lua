core:module("CoreMenuItemSlider")
core:import("CoreMenuItem")

ItemSlider = ItemSlider or class(CoreMenuItem.Item)
ItemSlider.TYPE = "slider"

function ItemSlider:init(data_node, parameters)
	CoreMenuItem.Item.init(self, data_node, parameters)

	self._type = "slider"
	self._min = 0
	self._max = 1
	self._step = 0.1
	self._show_value = false

	if data_node then
		self._min = data_node.min or self._min
		self._max = data_node.max or self._max
		self._step = data_node.step or self._step
		self._show_value = data_node.show_value
		self._show_slider_text = self._show_value or data_node.show_slider_text
	end

	self._min = tonumber(self._min)
	self._max = tonumber(self._max)
	self._step = tonumber(self._step)
	self._value = self._min
end

function ItemSlider:value()
	return self._value
end

function ItemSlider:show_value()
	return self._show_value
end

function ItemSlider:set_value(value)
	self._value = math.min(math.max(self._min, value), self._max)

	self:dirty()
end

function ItemSlider:set_value_by_percentage(percent)
	self:set_value(self._min + (self._max - self._min) * percent / 100)
end

function ItemSlider:set_min(value)
	self._min = value
end

function ItemSlider:set_max(value)
	self._max = value
end

function ItemSlider:set_step(value)
	self._step = value
end

function ItemSlider:increase()
	self:set_value(self._value + self._step)
end

function ItemSlider:decrease()
	self:set_value(self._value - self._step)
end

function ItemSlider:percentage()
	return (self._value - self._min) / (self._max - self._min) * 100
end

function ItemSlider:setup_gui(node, row_item)
	row_item.gui_panel = node.item_panel:panel({
		w = node.item_panel:w()
	})
	row_item.gui_text = node:_text_item_part(row_item, row_item.gui_panel, node:_right_align())

	row_item.gui_text:set_layer(node.layers.items + 1)

	local _, _, w, h = row_item.gui_text:text_rect()

	row_item.gui_panel:set_h(h)

	local bar_w = 192
	row_item.gui_slider_bg = row_item.gui_panel:rect({
		visible = false,
		vertical = "center",
		h = 22,
		align = "center",
		halign = "center",
		x = node:_left_align() - bar_w,
		y = h / 2 - 11,
		w = bar_w,
		color = Color.black:with_alpha(0.5),
		layer = node.layers.items - 1
	})
	row_item.gui_slider_gfx = row_item.gui_panel:gradient({
		vertical = "center",
		align = "center",
		halign = "center",
		orientation = "vertical",
		gradient_points = {
			0,
			_G.tweak_data.screen_colors.button_stage_3,
			1,
			_G.tweak_data.screen_colors.button_stage_3
		},
		x = node:_left_align() - bar_w + 2,
		y = row_item.gui_slider_bg:y() + 2,
		w = (row_item.gui_slider_bg:w() - 4) * 0.23,
		h = row_item.gui_slider_bg:h() - 4,
		blend_mode = node.row_item_blend_mode or "normal",
		color = row_item.color,
		layer = node.layers.items
	})
	row_item.gui_slider = row_item.gui_panel:rect({
		w = 100,
		color = row_item.color:with_alpha(0),
		layer = node.layers.items,
		h = row_item.gui_slider_bg:h() - 4
	})
	row_item.gui_slider_marker = row_item.gui_panel:bitmap({
		texture = "guis/textures/debug_menu_icons",
		visible = false,
		texture_rect = {
			0,
			0,
			24,
			28
		},
		layer = node.layers.items + 2
	})
	local slider_text_align = row_item.align == "left" and "right" or row_item.align == "right" and "left" or row_item.align
	local slider_text_halign = row_item.slider_text_halign == "left" and "right" or row_item.slider_text_halign == "right" and "left" or row_item.slider_text_halign
	local slider_text_vertical = row_item.vertical == "top" and "bottom" or row_item.vertical == "bottom" and "top" or row_item.vertical
	row_item.gui_slider_text = row_item.gui_panel:text({
		y = 0,
		font_size = row_item.font_size or _G.tweak_data.menu.stats_font_size,
		x = node:_right_align(),
		h = h,
		w = row_item.gui_slider_bg:w(),
		align = slider_text_align,
		halign = slider_text_halign,
		vertical = slider_text_vertical,
		valign = slider_text_vertical,
		font = node.font,
		color = row_item.color,
		layer = node.layers.items + 1,
		text = "" .. math.floor(0) .. "%",
		blend_mode = node.row_item_blend_mode or "normal",
		render_template = Idstring("VertexColorTextured"),
		visible = self._show_slider_text
	})

	if row_item.help_text then
		-- Nothing
	end

	self:_layout(node, row_item)

	return true
end

function ItemSlider:reload(row_item, node)
	if not row_item then
		return
	end

	local value = self:show_value() and string.format("%.5f", self:value()) or string.format("%.0f", self:percentage()) .. "%"

	row_item.gui_slider_text:set_text(value)
	row_item.gui_slider_text:set_visible(self._show_slider_text)

	local where = row_item.gui_slider:left() + row_item.gui_slider:w() * self:percentage() / 100

	row_item.gui_slider_marker:set_center_x(where)
	row_item.gui_slider_gfx:set_w(row_item.gui_slider:w() * self:percentage() / 100)

	return true
end

function ItemSlider:highlight_row_item(node, row_item, mouse_over)
	row_item.gui_text:set_color(row_item.color)
	row_item.gui_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_no_outline_id)
	row_item.gui_slider_text:set_color(row_item.color)
	row_item.gui_slider_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_no_outline_id)
	row_item.gui_slider_gfx:set_gradient_points({
		0,
		_G.tweak_data.screen_colors.button_stage_2,
		1,
		_G.tweak_data.screen_colors.button_stage_2
	})

	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(true)
	end

	return true
end

function ItemSlider:fade_row_item(node, row_item)
	row_item.gui_text:set_color(row_item.color)
	row_item.gui_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_id)
	row_item.gui_slider_text:set_color(row_item.color)
	row_item.gui_slider_text:set_font(row_item.font and Idstring(row_item.font) or _G.tweak_data.menu.default_font_id)
	row_item.gui_slider_gfx:set_gradient_points({
		0,
		_G.tweak_data.screen_colors.button_stage_3,
		1,
		_G.tweak_data.screen_colors.button_stage_3
	})

	if row_item.gui_info_panel then
		row_item.gui_info_panel:set_visible(false)
	end

	return true
end

function ItemSlider:_layout(node, row_item)
	local safe_rect = managers.gui_data:scaled_size()

	row_item.gui_text:set_font_size(node.font_size)

	local x, y, w, h = row_item.gui_text:text_rect()
	local bg_pad = 8
	local xl_pad = 64

	row_item.gui_panel:set_height(h)
	row_item.gui_panel:set_width(safe_rect.width - node:_mid_align())
	row_item.gui_panel:set_x(node:_mid_align())

	local sh = h - 2

	row_item.gui_slider_bg:set_h(sh)
	row_item.gui_slider_bg:set_w(row_item.gui_panel:w())
	row_item.gui_slider_bg:set_x(0)
	row_item.gui_slider_bg:set_center_y(h / 2)
	row_item.gui_slider_text:set_font_size(row_item.font_size or _G.tweak_data.menu.stats_font_size)
	row_item.gui_slider_text:set_size(row_item.gui_slider_bg:size())
	row_item.gui_slider_text:set_position(row_item.gui_slider_bg:position())
	row_item.gui_slider_text:set_y(row_item.gui_slider_text:y())

	if row_item.align == "right" then
		row_item.gui_slider_text:set_left(node:_right_align() - row_item.gui_panel:x())
	else
		row_item.gui_slider_text:set_x(row_item.gui_slider_text:x() - node:align_line_padding())
	end

	row_item.gui_slider_gfx:set_h(sh)
	row_item.gui_slider_gfx:set_x(row_item.gui_slider_bg:x())
	row_item.gui_slider_gfx:set_y(row_item.gui_slider_bg:y())
	row_item.gui_slider:set_x(row_item.gui_slider_bg:x())
	row_item.gui_slider:set_y(row_item.gui_slider_bg:y())
	row_item.gui_slider:set_w(row_item.gui_slider_bg:w())
	row_item.gui_slider_marker:set_center_y(h / 2)
	row_item.gui_text:set_width(safe_rect.width / 2)

	if row_item.align == "right" then
		row_item.gui_text:set_right(row_item.gui_panel:w())
	else
		row_item.gui_text:set_left(node:_right_align() - row_item.gui_panel:x())
	end

	row_item.gui_text:set_height(h)

	local node_padding = node:_mid_align()

	if node:_get_node_padding() > 0 then
		node_padding = node:_get_node_padding()
	end

	row_item.gui_panel:set_x(node_padding)
	row_item.gui_text:set_x(0)
end
