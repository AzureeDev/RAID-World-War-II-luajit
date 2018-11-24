RaidGUIControlCardBase = RaidGUIControlCardBase or class(RaidGUIControl)
RaidGUIControlCardBase.TITLE_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlCardBase.TITLE_TEXT_SIZE = 20
RaidGUIControlCardBase.TITLE_PADDING = 0.08
RaidGUIControlCardBase.TITLE_Y = 0.86
RaidGUIControlCardBase.TITLE_CENTER_Y = 0.92
RaidGUIControlCardBase.TITLE_H = 0.11
RaidGUIControlCardBase.DESCRIPTION_Y = 0.6494
RaidGUIControlCardBase.DESCRIPTION_H = 0.15
RaidGUIControlCardBase.DESCRIPTION_TEXT_SIZE = 14
RaidGUIControlCardBase.XP_BONUS_X = 0.03
RaidGUIControlCardBase.XP_BONUS_Y = 0.015
RaidGUIControlCardBase.XP_BONUS_W = 0.3394
RaidGUIControlCardBase.XP_BONUS_H = 0.09
RaidGUIControlCardBase.XP_BONUS_FONT = tweak_data.gui.fonts.din_compressed
RaidGUIControlCardBase.XP_BONUS_FONT_SIZE = tweak_data.gui.font_sizes.size_46
RaidGUIControlCardBase.XP_BONUS_LABEL_FONT_SIZE = RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * 0.5
RaidGUIControlCardBase.ICON_H = 0.0853
RaidGUIControlCardBase.ICON_RIGHT_PADDING = 0.0627
RaidGUIControlCardBase.ICON_DOWN_PADDING = 0.0482
RaidGUIControlCardBase.ICON_LEFT_PADDING = 0.085
RaidGUIControlCardBase.ICON_TOP_PADDING = 0.045
RaidGUIControlCardBase.ICON_DISTANCE = 0

function RaidGUIControlCardBase:init(parent, params, item_data, grid_params)
	RaidGUIControlCardBase.super.init(self, parent, params)

	self._card_panel = nil
	local card = "ra_on_the_scrounge"
	self._grid_params = grid_params
	self._item_data = item_data

	if params.panel then
		self._card_panel = params.panel
	else
		local card_rarity = tweak_data.challenge_cards:get_card_by_key_name(card).rarity
		local card_rect = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_rect
		local params_card_panel = {
			halign = "center",
			name = "card_panel",
			valign = "center",
			x = params.x or 0,
			y = params.y or 0,
			h = params.item_h or self._panel:h(),
			w = params.item_w or self._panel:h() * card_rect[3] / card_rect[4]
		}
		self._card_panel = self._panel:panel(params_card_panel)
	end

	self._object = self._card_panel
	local card_data = tweak_data.challenge_cards:get_card_by_key_name(card)
	local card_rarity = card_data.rarity
	local card_texture = tweak_data.challenge_cards.challenge_card_texture_path .. "cc_raid_common_on_the_scrounge_hud"
	local card_texture_rect = tweak_data.challenge_cards.challenge_card_texture_rect
	local card_rect = {}

	if self._params.card_image_params and self._params.card_image_params.x then
		card_rect.x = self._params.card_image_params.x
	end

	if self._params.card_image_params and self._params.card_image_params.y then
		card_rect.y = self._params.card_image_params.y
	end

	if self._params.card_image_params and self._params.card_image_params.w then
		card_rect.w = self._params.card_image_params.w
	end

	if self._params.card_image_params and self._params.card_image_params.h then
		card_rect.h = self._params.card_image_params.h
	end

	local params_card_image = {
		name = "card_image",
		layer = 100,
		x = card_rect.x or 0,
		y = card_rect.y or 0,
		w = card_rect.w or self._card_panel:w(),
		h = card_rect.h or self._card_panel:h(),
		texture = card_texture,
		texture_rect = card_texture_rect
	}
	self._card_image = self._card_panel:bitmap(params_card_image)
	local title_h = self._card_image:h() * RaidGUIControlCardBase.TITLE_H
	local title_font_size = math.ceil(RaidGUIControlCardBase.TITLE_TEXT_SIZE * self._card_image:h() / 255)
	local params_card_title = {
		name = "card_title",
		wrap = true,
		align = "center",
		vertical = "center",
		blend_mode = "normal",
		w = self._card_image:w() * (1 - 2 * RaidGUIControlCardBase.TITLE_PADDING),
		h = title_h,
		x = self._card_image:x() + self._card_image:w() * RaidGUIControlCardBase.TITLE_PADDING,
		font = RaidGUIControlCardBase.TITLE_FONT,
		font_size = title_font_size,
		text = utf8.to_upper(tweak_data.challenge_cards:get_card_by_key_name(card).name),
		layer = self._card_image:layer() + 10,
		color = Color.white
	}
	self._card_title = self._card_panel:label(params_card_title)

	self._card_title:set_center_y(self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.TITLE_CENTER_Y)

	local _, _, w, h = self._card_title:text_rect()

	if title_h < h then
		self:_refit_card_title_text(title_font_size)
	end

	local params_card_description = {
		w = 0,
		name = "card_description",
		h = 0,
		wrap = true,
		align = "left",
		visible = false,
		y = 0,
		x = 0,
		font = RaidGUIControlCardBase.TITLE_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.DESCRIPTION_TEXT_SIZE * self._card_image:h() / 255),
		layer = self._card_image:layer() + 1,
		color = Color.black,
		text = tweak_data.challenge_cards:get_card_by_key_name(card).description
	}
	self._card_description = self._card_panel:label(params_card_description)
	local params_xp_bonus = {
		name = "xp_bonus",
		vertical = "center",
		align = "center",
		x = 0,
		y = self._card_image:y() + self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_Y,
		w = self._card_image:w() * RaidGUIControlCardBase.XP_BONUS_W,
		h = self._card_image:h() * RaidGUIControlCardBase.XP_BONUS_H,
		font = RaidGUIControlCardBase.XP_BONUS_FONT,
		font_size = math.ceil(RaidGUIControlCardBase.XP_BONUS_FONT_SIZE * self._card_image:h() * 0.0015),
		text = tweak_data.challenge_cards:get_card_by_key_name(card).bonus_xp,
		color = tweak_data.gui.colors.raid_white,
		layer = self._card_image:layer() + 1
	}
	self._xp_bonus = self._card_panel:label(params_xp_bonus)
	local card_rarity_icon_texture = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_path_icon
	local card_rarity_icon_texture_rect = tweak_data.challenge_cards.rarity_definition[card_rarity].texture_rect_icon
	local card_rarity_h = self._card_image:h() * RaidGUIControlCardBase.ICON_H
	local card_rarity_w = card_rarity_h * card_rarity_icon_texture_rect[3] / card_rarity_icon_texture_rect[4]
	local params_card_rarity = {
		name = "card_rarity_icon",
		w = card_rarity_w,
		h = card_rarity_h,
		x = self._card_image:w() - card_rarity_w - self._card_image:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self._card_image:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
		texture = card_rarity_icon_texture,
		texture_rect = card_rarity_icon_texture_rect,
		layer = self._card_image:layer() + 1
	}
	self._card_rarity_icon = self._card_panel:image(params_card_rarity)
	local card_type = tweak_data.challenge_cards:get_card_by_key_name(card).card_type
	local card_type_icon_texture = tweak_data.challenge_cards.type_definition[card_type].texture_path
	local card_type_icon_texture_rect = tweak_data.challenge_cards.type_definition[card_type].texture_rect
	local card_type_h = card_rarity_h
	local card_type_w = card_type_h * card_type_icon_texture_rect[3] / card_type_icon_texture_rect[4]
	local params_card_type = {
		name = "card_type_icon",
		w = card_type_w,
		h = card_type_h,
		x = self._card_image:w() * RaidGUIControlCardBase.ICON_LEFT_PADDING,
		y = self._card_image:h() * RaidGUIControlCardBase.ICON_TOP_PADDING,
		texture = card_type_icon_texture,
		texture_rect = card_type_icon_texture_rect,
		layer = self._card_image:layer() + 1
	}
	self._card_type_icon = self._card_panel:image(params_card_type)

	if self._params and self._params.item_clicked_callback then
		self._on_click_callback = self._params.item_clicked_callback
	end

	if self._params and self._params.item_selected_callback then
		self._on_selected_callback = self._params.item_selected_callback
	end

	local image_size_multiplier = self._card_image:w() / tweak_data.challenge_cards.challenge_card_texture_rect[3]
	self._card_stackable_image = self._object:bitmap({
		visible = false,
		x = self._card_image:x(),
		y = self._card_image:y(),
		layer = self._card_image:layer() - 1,
		w = self._card_image:w(),
		h = self._card_image:h(),
		texture = tweak_data.challenge_cards.challenge_card_stackable_2_texture_path,
		texture_rect = tweak_data.challenge_cards.challenge_card_stackable_2_texture_rect
	})
	self._card_amount_background = self._card_panel:image({
		name = "card_amount_background",
		visible = false,
		layer = self._card_image:layer() + 1,
		x = self._card_image:w() * 0.145,
		y = self._card_image:h() * 0.84,
		w = tweak_data.gui.icons.card_counter_bg_large.texture_rect[3] * image_size_multiplier,
		h = tweak_data.gui.icons.card_counter_bg_large.texture_rect[4] * image_size_multiplier,
		texture = tweak_data.gui.icons.card_counter_bg_large.texture,
		texture_rect = tweak_data.gui.icons.card_counter_bg_large.texture_rect
	})
	self._card_amount_label = self._card_panel:label({
		name = "card_amount_label",
		vertical = "center",
		visible = false,
		align = "center",
		text = "",
		layer = self._card_amount_background:layer() + 1,
		w = self._card_amount_background:w(),
		h = self._card_amount_background:h(),
		x = self._card_amount_background:x(),
		y = self._card_amount_background:y()
	})

	if self._params and self._params.show_amount then
		self._card_amount_background:show()
		self._card_amount_label:show()
	end

	self._card_panel:set_visible(false)
end

function RaidGUIControlCardBase:_refit_card_title_text(original_font_size)
	local font_sizes = {}

	for index, size in pairs(tweak_data.gui.font_sizes) do
		if size < original_font_size then
			table.insert(font_sizes, size)
		end
	end

	table.sort(font_sizes)

	for i = #font_sizes, 1, -1 do
		self._card_title:set_font_size(font_sizes[i])

		local _, _, w, h = self._card_title:text_rect()

		if h <= self._card_title:h() and w <= self._card_title:w() then
			break
		end
	end
end

function RaidGUIControlCardBase:get_data()
	return self._item_data
end

function RaidGUIControlCardBase:set_card(card_data)
	self._item_data = card_data

	if self._item_data then
		local card_rarity = self._item_data.rarity
		local rarity_definition = tweak_data.challenge_cards.rarity_definition[card_rarity]
		local card_type = self._item_data.card_type
		local type_definition = tweak_data.challenge_cards.type_definition[card_type]
		local empty_slot_texture = tweak_data.gui.icons.cc_empty_slot_small
		local card_texture = empty_slot_texture.texture
		local card_texture_rect = empty_slot_texture.texture_rect

		if not self._item_data.title_in_texture then
			self._card_title:set_text(self:translate(self._item_data.name, true))

			local title_font_size = math.ceil(RaidGUIControlCardBase.TITLE_TEXT_SIZE * self._card_image:h() / 255)

			self._card_title:set_font_size(title_font_size)

			local _, _, w, h = self._card_title:text_rect()

			if self._card_title:h() < h then
				self:_refit_card_title_text(title_font_size)
			end

			self._card_title:show()
		else
			self._card_title:set_text("")
			self._card_title:hide()
		end

		if rarity_definition.color then
			-- Nothing
		end

		self._card_description:set_text(self:translate(self._item_data.description))
		self._card_description:hide()

		local bonus_xp_reward = managers.challenge_cards:get_card_xp_label(self._item_data.key_name)

		self._xp_bonus:set_text(bonus_xp_reward)

		local x1, y1, w1, h1 = self._xp_bonus:text_rect()

		self._xp_bonus:set_w(w1)
		self._xp_bonus:set_h(h1)
		self._xp_bonus:set_center_x(self._card_image:w() / 2)

		if self._item_data.card_category == ChallengeCardsTweakData.CARD_CATEGORY_BOOSTER then
			self._xp_bonus:set_visible(false)
		else
			self._xp_bonus:set_visible(true)
		end

		if rarity_definition.color then
			-- Nothing
		end

		if self._item_data.key_name ~= ChallengeCardsManager.CARD_PASS_KEY_NAME then
			card_texture = tweak_data.challenge_cards.challenge_card_texture_path .. card_data.texture
			card_texture_rect = tweak_data.challenge_cards.challenge_card_texture_rect

			self._card_rarity_icon:show()
			self._card_rarity_icon:set_image(rarity_definition.texture_path_icon)
			self._card_rarity_icon:set_texture_rect(rarity_definition.texture_rect_icon)
			self._card_type_icon:show()
			self._card_type_icon:set_image(type_definition.texture_path)
			self._card_type_icon:set_texture_rect(type_definition.texture_rect)
		else
			self._card_rarity_icon:hide()
			self._card_type_icon:hide()
			self._card_title:hide()
		end

		self._card_image:set_image(card_texture)
		self._card_image:set_texture_rect(unpack(card_texture_rect))
		self._card_image:show()

		if self._item_data.steam_instance_ids and #self._item_data.steam_instance_ids > 1 then
			self._card_amount_label:set_text(#self._item_data.steam_instance_ids)
			self._card_amount_label:show()
			self._card_amount_background:show()

			local stacking_texture, stacking_texture_rect = managers.challenge_cards:get_cards_stacking_texture(self._item_data)

			if stacking_texture and stacking_texture_rect then
				self._card_stackable_image:set_image(stacking_texture, unpack(stacking_texture_rect))
				self._card_stackable_image:set_visible(true)
			end
		else
			self._card_amount_label:set_text("")
			self._card_amount_label:hide()
			self._card_amount_background:hide()
		end

		self._card_panel:set_visible(true)
	end
end

function RaidGUIControlCardBase:set_card_image(texture, texture_rect)
	Application:trace("[RaidGUIControlCardBase:set_card_image]")
	self._card_image:set_image(texture)
	self._card_image:set_texture_rect(texture_rect)
end

function RaidGUIControlCardBase:set_title(title)
	self._card_title:set_text(title)
end

function RaidGUIControlCardBase:set_description(description)
	self._card_description:set_text(description)
end

function RaidGUIControlCardBase:set_xp_bonus(xp_bonus)
	self._xp_bonus:set_text(xp_bonus)
end

function RaidGUIControlCardBase:set_color(color)
	self._card_title:set_color(color)
	self._xp_bonus:set_color(color)
end

function RaidGUIControlCardBase:set_title_visible(flag)
	self._card_title:set_visible(flag)
end

function RaidGUIControlCardBase:set_description_visible(flag)
	self._card_description:set_visible(flag)
end

function RaidGUIControlCardBase:set_xp_bonus_visible(flag)
	self._xp_bonus:set_visible(flag)
end

function RaidGUIControlCardBase:set_rarity_icon_visible(flag)
	self._card_type_icon:set_visible(flag)
end

function RaidGUIControlCardBase:set_type_icon_visible(flag)
	self._card_rarity_icon:set_visible(flag)
end

function RaidGUIControlCardBase:set_visible(flag)
	self._card_image:set_visible(flag)
	self:set_title_visible(flag)
	self:set_rarity_icon_visible(flag)
	self:set_type_icon_visible(flag)
end

function RaidGUIControlCardBase:show_card_only()
	self._card_image:set_visible(true)
	self:set_title_visible(false)
	self:set_xp_bonus_visible(false)
	self:set_rarity_icon_visible(false)
	self:set_type_icon_visible(false)
end

function RaidGUIControlCardBase:mouse_released(o, button, x, y)
	self:on_mouse_released(button, x, y)

	return true
end

function RaidGUIControlCardBase:on_mouse_released(button, x, y)
	if self._on_click_callback then
		self._on_click_callback(button, self, self._item_data)
	end
end

function RaidGUIControlCardBase:selected()
	return self._selected
end

function RaidGUIControlCardBase:select()
	self._selected = true
end

function RaidGUIControlCardBase:unselect()
	self._selected = false
end

function RaidGUIControlCardBase:w()
	return self._card_image:w()
end

function RaidGUIControlCardBase:h()
	return self._card_image:h()
end

function RaidGUIControlCardBase:left()
	return self._card_image:x()
end

function RaidGUIControlCardBase:right()
	return self:left() + self:w()
end

function RaidGUIControlCardBase:set_center_x(x)
	self._object:set_center_x(x)
end
