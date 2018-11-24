HUDTeammateAI = HUDTeammateAI or class(HUDTeammateBase)
HUDTeammateAI.PADDING_DOWN = 18
HUDTeammateAI.DEFAULT_X = 0
HUDTeammateAI.DEFAULT_H = 46
HUDTeammateAI.LEFT_PANEL_W = 56
HUDTeammateAI.RIGHT_PANEL_X = 62
HUDTeammateAI.PLAYER_NAME_FONT = "din_compressed_outlined_22"
HUDTeammateAI.PLAYER_NAME_FONT_SIZE = 22
HUDTeammateAI.INTERACTION_METER_BG = "player_panel_ai_downed_and_objective_countdown_bg"
HUDTeammateAI.INTERACTION_METER_FILL = "teammate_interact_fill_large"
HUDTeammateAI.TIMER_BG = "player_panel_ai_downed_and_objective_countdown_bg"
HUDTeammateAI.TIMER_ICON = "teammate_circle_fill_small"
HUDTeammateAI.TIMER_FONT = "din_compressed_outlined_24"
HUDTeammateAI.TIMER_FONT_SIZE = 24
HUDTeammateAI.MOUNTED_WEAPON_ICON = "player_panel_status_mounted_weapon"
HUDTeammateAI.DEAD_ICON = "player_panel_status_dead_ai"
HUDTeammateAI.STATES = {
	{
		id = "dead",
		control = "dead_icon"
	},
	{
		id = "downed",
		control = "timer_panel"
	},
	{
		id = "interaction",
		control = "interaction_meter_panel"
	},
	{
		id = "mounted_weapon",
		control = "mounted_weapon_icon"
	},
	{
		id = "normal",
		control = "nationality_icon"
	}
}

function HUDTeammateAI:init(i, teammates_panel, params)
	self._id = i
	self._states = HUDTeammateAI.STATES
	self._displayed_state = self._states[#self._states]
	self._active_states = {}

	self:_add_active_state(self._displayed_state.id)
	self:_create_panel(teammates_panel)
	self:_create_left_panel()
	self:_create_status_panel()
	self:_create_nationality_icon()
	self:_create_mounted_weapon_icon()
	self:_create_dead_icon()
	self:_create_interaction_meter()
	self:_create_timer()
	self:_create_right_panel()
	self:_create_player_name()
end

function HUDTeammateAI:_create_panel(teammates_panel)
	local panel_params = {
		visible = false,
		halign = "left",
		valign = "top",
		x = HUDTeammateAI.DEFAULT_X,
		w = teammates_panel:w(),
		h = HUDTeammateAI.DEFAULT_H,
		layer = tweak_data.gui.PLAYER_PANELS_LAYER
	}
	self._object = teammates_panel:panel(panel_params)
end

function HUDTeammateAI:_create_left_panel()
	local left_panel_params = {
		name = "left_panel",
		y = 0,
		x = 0,
		w = HUDTeammateAI.LEFT_PANEL_W,
		h = self._object:h()
	}
	self._left_panel = self._object:panel(left_panel_params)
end

function HUDTeammateAI:_create_status_panel()
	local status_panel_params = {
		name = "status_panel",
		y = 0,
		x = 0,
		w = self._left_panel:w(),
		h = self._left_panel:h()
	}
	self._status_panel = self._left_panel:panel(status_panel_params)
end

function HUDTeammateAI:_create_nationality_icon()
	local nationality = "german"
	local nationality_icon = "player_panel_nationality_" .. tostring(nationality)
	local nationality_icon_params = {
		name = "nationality_icon",
		halign = "center",
		valign = "center",
		texture = tweak_data.gui.icons[nationality_icon].texture,
		texture_rect = tweak_data.gui.icons[nationality_icon].texture_rect
	}
	self._nationality_icon = self._status_panel:bitmap(nationality_icon_params)

	self._nationality_icon:set_center_x(self._status_panel:w() / 2)
	self._nationality_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammateAI:_create_interaction_meter()
	local interaction_meter_panel_params = {
		layer = 4,
		name = "interaction_meter_panel",
		halign = "left",
		alpha = 0,
		valign = "center"
	}
	self._interaction_meter_panel = self._status_panel:panel(interaction_meter_panel_params)
	local interaction_meter_background_params = {
		name = "interaction_meter_background",
		halign = "scale",
		layer = 1,
		valign = "scale",
		texture = tweak_data.gui.icons[HUDTeammateAI.INTERACTION_METER_BG].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammateAI.INTERACTION_METER_BG].texture_rect
	}
	local interaction_meter_background = self._interaction_meter_panel:bitmap(interaction_meter_background_params)

	interaction_meter_background:set_center_x(self._interaction_meter_panel:w() / 2)
	interaction_meter_background:set_center_y(self._interaction_meter_panel:h() / 2)

	local interaction_meter_params = {
		name = "interaction_meter",
		layer = 2,
		position_z = 0,
		halign = "scale",
		render_template = "VertexColorTexturedRadial",
		valign = "scale",
		texture = tweak_data.gui.icons[HUDTeammateAI.INTERACTION_METER_FILL].texture,
		texture_rect = {
			tweak_data.gui:icon_w(HUDTeammateAI.INTERACTION_METER_FILL),
			0,
			-tweak_data.gui:icon_w(HUDTeammateAI.INTERACTION_METER_FILL),
			tweak_data.gui:icon_h(HUDTeammateAI.INTERACTION_METER_FILL)
		},
		w = interaction_meter_background:w() + 8,
		h = interaction_meter_background:h() + 8,
		color = tweak_data.gui.colors.teammate_interaction_bar
	}
	self._interaction_meter = self._interaction_meter_panel:bitmap(interaction_meter_params)

	self._interaction_meter:set_center_x(self._interaction_meter_panel:w() / 2)
	self._interaction_meter:set_center_y(self._interaction_meter_panel:h() / 2)
end

function HUDTeammateAI:_create_timer()
	local timer_panel_params = {
		halign = "left",
		name = "timer_panel",
		layer = 5,
		y = 0,
		alpha = 0,
		x = 0,
		valign = "center"
	}
	self._timer_panel = self._status_panel:panel(timer_panel_params)
	local timer_background_params = {
		name = "timer_background",
		halign = "scale",
		layer = 1,
		valign = "scale",
		texture = tweak_data.gui.icons[HUDTeammateAI.TIMER_BG].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammateAI.TIMER_BG].texture_rect
	}
	local timer_background = self._timer_panel:bitmap(timer_background_params)

	timer_background:set_center_x(self._timer_panel:w() / 2)
	timer_background:set_center_y(self._timer_panel:h() / 2)

	local timer_bar_params = {
		name = "timer_bar",
		layer = 2,
		halign = "scale",
		render_template = "VertexColorTexturedRadial",
		valign = "scale",
		texture = tweak_data.gui.icons[HUDTeammateAI.TIMER_ICON].texture,
		texture_rect = {
			tweak_data.gui:icon_w(HUDTeammateAI.TIMER_ICON),
			0,
			-tweak_data.gui:icon_w(HUDTeammateAI.TIMER_ICON),
			tweak_data.gui:icon_h(HUDTeammateAI.TIMER_ICON)
		},
		w = tweak_data.gui:icon_w(HUDTeammateAI.TIMER_ICON),
		h = tweak_data.gui:icon_h(HUDTeammateAI.TIMER_ICON)
	}
	self._timer_bar = self._timer_panel:bitmap(timer_bar_params)

	self._timer_bar:set_center_x(self._timer_panel:w() / 2)
	self._timer_bar:set_center_y(self._timer_panel:h() / 2)

	local timer_text_params = {
		name = "timer_text",
		vertical = "center",
		align = "center",
		text = "23",
		y = 0,
		x = 0,
		layer = 3,
		w = self._timer_panel:w(),
		h = self._timer_panel:h(),
		font = tweak_data.gui.fonts[HUDTeammateAI.TIMER_FONT],
		font_size = HUDTeammateAI.TIMER_FONT_SIZE
	}
	self._timer_text = self._timer_panel:text(timer_text_params)
	local _, _, _, h = self._timer_text:text_rect()

	self._timer_text:set_h(h)
	self._timer_text:set_center_y(self._timer_panel:h() / 2 - 2)
end

function HUDTeammateAI:_create_dead_icon()
	local dead_icon_params = {
		name = "dead_icon",
		halign = "center",
		alpha = 0,
		valign = "center",
		texture = tweak_data.gui.icons[HUDTeammateAI.DEAD_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammateAI.DEAD_ICON].texture_rect
	}
	self._dead_icon = self._status_panel:bitmap(dead_icon_params)

	self._dead_icon:set_center_x(self._status_panel:w() / 2)
	self._dead_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammateAI:_create_mounted_weapon_icon()
	local mounted_weapon_icon_params = {
		name = "mounted_weapon_icon",
		halign = "center",
		alpha = 0,
		valign = "center",
		texture = tweak_data.gui.icons[HUDTeammateAI.MOUNTED_WEAPON_ICON].texture,
		texture_rect = tweak_data.gui.icons[HUDTeammateAI.MOUNTED_WEAPON_ICON].texture_rect
	}
	self._mounted_weapon_icon = self._status_panel:bitmap(mounted_weapon_icon_params)

	self._mounted_weapon_icon:set_center_x(self._status_panel:w() / 2)
	self._mounted_weapon_icon:set_center_y(self._status_panel:h() / 2)
end

function HUDTeammateAI:_create_right_panel()
	local right_panel_params = {
		name = "right_panel",
		y = 0,
		x = HUDTeammateAI.RIGHT_PANEL_X,
		w = self._object:w() - HUDTeammateAI.RIGHT_PANEL_X,
		h = self._object:h()
	}
	self._right_panel = self._object:panel(right_panel_params)
end

function HUDTeammateAI:_create_player_name()
	local player_name_params = {
		name = "player_name",
		vertical = "center",
		align = "left",
		text = "TEST",
		y = 0,
		x = 0,
		w = self._right_panel:w(),
		h = self._right_panel:h(),
		font = tweak_data.gui.fonts[HUDTeammateAI.PLAYER_NAME_FONT],
		font_size = HUDTeammateAI.PLAYER_NAME_FONT_SIZE
	}
	self._player_name = self._right_panel:text(player_name_params)
	local _, _, _, h = self._player_name:text_rect()

	self._player_name:set_h(h)
	self._player_name:set_center_y(self._right_panel:h() / 2 - 2)
	self._player_name:set_y(math.ceil(self._player_name:y() - 0.5))
end

function HUDTeammateAI:padding_down()
	return HUDTeammateAI.PADDING_DOWN
end

function HUDTeammateAI:is_ai()
	return true
end

function HUDTeammateAI:set_name(name)
	self._player_name:set_text(utf8.to_upper(name))

	local _, _, _, h = self._player_name:text_rect()

	self._player_name:set_h(h)
	self._player_name:set_center_y(self._right_panel:h() / 2 - 2)
	self._player_name:set_center_y(self._right_panel:h() / 2 - 2)
	self._player_name:set_y(math.ceil(self._player_name:y() - 0.5))
end

function HUDTeammateAI:set_nationality(nationality)
	local nationality_icon = "player_panel_nationality_" .. tostring(nationality)

	self._nationality_icon:set_image(tweak_data.gui.icons[nationality_icon].texture)
	self._nationality_icon:set_texture_rect(unpack(tweak_data.gui.icons[nationality_icon].texture_rect))
	self._nationality_icon:set_center_x(self._left_panel:w() / 2)
	self._nationality_icon:set_center_y(self._left_panel:h() / 2)
end

function HUDTeammateAI:show_turret_icon()
	self:_add_active_state("mounted_weapon")
end

function HUDTeammateAI:hide_turret_icon()
	self:_remove_active_state("mounted_weapon")
end

function HUDTeammateAI:start_timer(time, current)
	HUDTeammateAI.super.start_timer(self, time, current)
end

function HUDTeammateAI:stop_timer()
	HUDTeammateAI.super.stop_timer(self)
end

function HUDTeammateAI:set_condition(icon_data, text)
	if icon_data == self._state then
		return
	end

	if icon_data == "mugshot_in_custody" then
		self:_set_status_icon(self._dead_icon)
	elseif icon_data == "mugshot_turret" then
		self:_set_status_icon(self._mounted_weapon_icon)
	else
		self:_set_status_icon(self._nationality_icon)
	end

	self._state = icon_data
end

function HUDTeammateAI:reset_state()
	self._status_panel:child(self._displayed_state.control):set_alpha(0)

	self._displayed_state = self._states[#self._states]
	self._active_states = {}

	self:_add_active_state(self._displayed_state.id)
	self._status_panel:child(self._displayed_state.control):set_alpha(1)
end

function HUDTeammateAI:start_interact(timer)
	self:_add_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_interact"), timer)
end

function HUDTeammateAI:cancel_interact()
	self:_remove_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_cancel_interact"))
end

function HUDTeammateAI:complete_interact()
	self:_remove_active_state("interaction")
	self._interaction_meter:stop()
	self._interaction_meter:animate(callback(self, self, "_animate_complete_interact"))
end

function HUDTeammateAI:_animate_interact(interact_image, duration)
	local t = 0

	self._interaction_meter:set_position_z(0)
	self._interaction_meter:set_rotation(0)

	while t < duration do
		local dt = coroutine.yield()
		t = t + dt
		local current_progress = Easing.linear(t, 0, 1, duration)

		self._interaction_meter:set_position_z(current_progress)

		self._current_progress = current_progress
	end

	self._interaction_meter:set_position_z(1)
end

function HUDTeammateAI:_animate_cancel_interact()
	local duration = 0.2
	local t = nil

	if not self._current_progress then
		t = duration
	else
		t = (1 - self._current_progress) * duration
	end

	self._current_progress = 0

	while t < duration do
		local dt = coroutine.yield()
		t = t + dt
		local current_progress = Easing.linear(t, 1, -1, duration)

		self._interaction_meter:set_position_z(current_progress)
	end

	self._interaction_meter:set_position_z(0)
end

function HUDTeammateAI:_animate_complete_interact()
	local size_decrease_duration = 0.18
	local duration = 0.2
	local t = 0
	self._current_progress = 0

	self._interaction_meter:set_position_z(1)
	self._interaction_meter:set_rotation(0)

	while t < duration do
		local dt = coroutine.yield()
		t = t + dt
		local current_progress = Easing.linear(t, 1, -1, duration)

		self._interaction_meter:set_position_z(current_progress)

		local current_rotation = Easing.linear(t, 360, -360, duration)

		self._interaction_meter:set_rotation(current_rotation)
	end

	self._interaction_meter:set_position_z(0)
	self._interaction_meter:set_rotation(0)
end
