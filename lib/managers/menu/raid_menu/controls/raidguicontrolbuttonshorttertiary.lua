RaidGUIControlButtonShortTertiary = RaidGUIControlButtonShortTertiary or class(RaidGUIControlButton)
RaidGUIControlButtonShortTertiary.ICON = "btn_tetriary_192"
RaidGUIControlButtonShortTertiary.HOVER_ICON = "btn_tetriary_192_hover"
RaidGUIControlButtonShortTertiary.W = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.ICON].texture_rect[3]
RaidGUIControlButtonShortTertiary.H = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.ICON].texture_rect[4]

function RaidGUIControlButtonShortTertiary:init(parent, params)
	if not params then
		Application:error("Trying to create a short tertiary button without parameters!", debug.traceback())

		return
	end

	params.font = params.font or tweak_data.gui.fonts.din_compressed
	params.font_size = params.font_size or tweak_data.gui.font_sizes.medium
	params.align = "center"
	params.vertical = "center"
	params.color = tweak_data.gui.colors.raid_grey
	params.highlight_color = tweak_data.gui.colors.raid_grey
	params.texture = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.ICON].texture
	params.texture_rect = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.ICON].texture_rect
	params.texture_color = Color.white
	params.highlight_texture = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.HOVER_ICON].texture
	params.highlight_texture_rect = tweak_data.gui.icons[RaidGUIControlButtonShortTertiary.HOVER_ICON].texture_rect
	params.texture_highlight_color = Color.white
	params.w = RaidGUIControlButtonShortTertiary.W
	params.h = RaidGUIControlButtonShortTertiary.H

	RaidGUIControlButtonShortTertiary.super.init(self, parent, params)
end
