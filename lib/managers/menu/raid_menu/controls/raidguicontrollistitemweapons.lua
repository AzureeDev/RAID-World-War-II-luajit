RaidGUIControlListItemWeapons = RaidGUIControlListItemWeapons or class(RaidGUIControlListItemMenu)

function RaidGUIControlListItemWeapons:_get_font_desc()
	return tweak_data.gui.fonts.lato, tweak_data.gui.font_sizes.size_24
end
