LevelsTweakData = LevelsTweakData or class()

function LevelsTweakData:init()
	self.altitude_difference_limit = 300
	self.editor_level = "zone_germany_park"
	self.streaming_level = {
		name_id = "menu_stream",
		world_name = "vanilla/streaming_level",
		cube = "cube_apply_heist_bank"
	}
	self.camp = {
		name_id = "menu_camp_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/germany_camp",
		cube = "cube_apply_heist_bank"
	}
	self.tutorial = {
		name_id = "menu_tutorial_hl",
		briefing_id = "menu_tutorial_briefing",
		world_name = "vanilla/zone_germany_tutorial",
		predefined_world = "tutorial",
		package = {
			"packages/zone_germany"
		},
		cube = "cube_apply_heist_bank"
	}
	self.flakturm = {
		name_id = "menu_ger_miss_01_hl",
		briefing_id = "menu_ger_miss_01_desc",
		world_name = "vanilla/flakturm",
		predefined_world = "germany_flakturm",
		cube = "cube_apply_heist_bank"
	}
	self.gold_rush = {
		name_id = "menu_ger_miss_03_ld_hl",
		briefing_id = "menu_ger_miss_03_ld_desc",
		world_name = "vanilla/gold_rush",
		predefined_world = "germany_gold_rush",
		cube = "cube_apply_heist_bank"
	}
	self.train_yard = {
		name_id = "menu_ger_miss_04_hl",
		briefing_id = "menu_ger_miss_04_desc",
		world_name = "vanilla/train_yard",
		predefined_world = "germany_train_yard",
		cube = "cube_apply_heist_bank"
	}
	self.ger_bridge = {
		name_id = "menu_ger_bridge_00_hl",
		briefing_id = "menu_ger_bridge_00_desc",
		world_name = "vanilla/bridge",
		predefined_world = "germany_bridge",
		cube = "cube_apply_heist_bank"
	}
	self.ger_bridge_operation = {
		name_id = "menu_ger_bridge_00_hl",
		briefing_id = "menu_ger_bridge_00_desc",
		world_name = "vanilla/bridge",
		predefined_world = "germany_bridge_operation",
		cube = "cube_apply_heist_bank"
	}
	self.radio_defense = {
		name_id = "menu_afr_miss_04_hl",
		briefing_id = "menu_afr_miss_04_desc",
		world_name = "vanilla/radio_defense",
		predefined_world = "germany_radio",
		cube = "cube_apply_heist_bank"
	}
	self.settlement = {
		name_id = "menu_afr_miss_05_hl",
		briefing_id = "menu_afr_miss_05_desc",
		world_name = "vanilla/castle",
		predefined_world = "germany_castle",
		cube = "cube_apply_heist_bank"
	}
	self.forest_gumpy = {
		name_id = "forest_gumpy",
		briefing_id = "tank_radio_test_briefing",
		world_name = "vanilla/forest_gumpy",
		predefined_world = "forest_gumpy",
		cube = "cube_apply_heist_bank"
	}
	self.zone_germany_park = {
		name_id = "menu_germany_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/zone_germany_park",
		predefined_world = "zone_germany_park",
		cube = "cube_apply_heist_bank",
		floor_coordinates = {
			-10000
		},
		map = {
			texture = "map",
			base_icon = "map_camp",
			base_location = {
				x = -200,
				y = -2850
			},
			world_borders = {
				down = -28846,
				up = 23122,
				left = -29736,
				right = 34700
			},
			panel_shape = {
				w = 885,
				h = 710,
				x = 105,
				y = 220
			}
		}
	}
	self.zone_germany_destroyed = {
		name_id = "menu_germany_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/zone_germany_destroyed",
		predefined_world = "zone_germany_destroyed",
		cube = "cube_apply_heist_bank",
		floor_coordinates = {
			-10000
		},
		map = {
			texture = "map",
			base_icon = "map_camp",
			base_location = {
				x = -200,
				y = -2850
			},
			world_borders = {
				down = -28846,
				up = 23122,
				left = -29736,
				right = 34700
			},
			panel_shape = {
				w = 885,
				h = 710,
				x = 105,
				y = 220
			}
		}
	}
	self.zone_germany_destroyed_fuel = {
		name_id = "menu_germany_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/zone_germany_destroyed_fuel",
		predefined_world = "zone_germany_destroyed_fuel",
		cube = "cube_apply_heist_bank",
		floor_coordinates = {
			-10000
		},
		map = {
			texture = "map",
			base_icon = "map_camp",
			base_location = {
				x = -200,
				y = -2850
			},
			world_borders = {
				down = -28846,
				up = 23122,
				left = -29736,
				right = 34700
			},
			panel_shape = {
				w = 885,
				h = 710,
				x = 105,
				y = 220
			}
		}
	}
	self.zone_germany_roundabout = {
		name_id = "menu_germany_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/zone_germany_roundabout",
		predefined_world = "zone_germany_roundabout",
		cube = "cube_apply_heist_bank",
		floor_coordinates = {
			-10000
		},
		map = {
			texture = "map",
			base_icon = "map_camp",
			base_location = {
				x = -200,
				y = -2850
			},
			world_borders = {
				down = -28846,
				up = 23122,
				left = -29736,
				right = 34700
			},
			panel_shape = {
				w = 885,
				h = 710,
				x = 105,
				y = 220
			}
		}
	}
	self.zone_germany_roundabout_fuel = {
		name_id = "menu_germany_hl",
		briefing_id = "menu_germany_desc",
		world_name = "vanilla/zone_germany_roundabout_fuel",
		predefined_world = "zone_germany_roundabout_fuel",
		cube = "cube_apply_heist_bank",
		floor_coordinates = {
			-10000
		},
		map = {
			texture = "map",
			base_icon = "map_camp",
			base_location = {
				x = -200,
				y = -2850
			},
			world_borders = {
				down = -28846,
				up = 23122,
				left = -29736,
				right = 34700
			},
			panel_shape = {
				w = 885,
				h = 710,
				x = 105,
				y = 220
			}
		}
	}
	self.bunker_test = {
		name_id = "bunker_test",
		briefing_id = "bunker_test_briefing",
		world_name = "vanilla/bunker_test",
		cube = "cube_apply_heist_bank",
		predefined_world = "bunker_test"
	}
	self.tnd = {
		name_id = "tnd",
		briefing_id = "tnd_briefing",
		world_name = "vanilla/tnd",
		cube = "cube_apply_heist_bank",
		predefined_world = "tnd"
	}
	self.hunters = {
		name_id = "hunters",
		briefing_id = "hunters_briefing",
		world_name = "vanilla/hunters",
		cube = "cube_apply_heist_bank",
		predefined_world = "hunters"
	}
	self.convoy = {
		name_id = "convoy",
		briefing_id = "convoy_briefing",
		world_name = "vanilla/convoy",
		cube = "cube_apply_heist_bank",
		predefined_world = "convoy"
	}
	self.spies_test = {
		name_id = "spies_test",
		briefing_id = "spies_test_briefing",
		world_name = "vanilla/spies_test_layout",
		cube = "cube_apply_heist_bank",
		predefined_world = "spies_test"
	}
	self.sto = {
		name_id = "sto",
		briefing_id = "sto_briefing",
		world_name = "vanilla/sto",
		cube = "cube_apply_heist_bank",
		predefined_world = "sto"
	}
	self.silo = {
		name_id = "silo",
		briefing_id = "silo_briefing",
		world_name = "upg_002/silo/silo_start",
		packages = {
			"packages/zone_germany"
		},
		cube = "cube_apply_heist_bank",
		predefined_world = "silo"
	}
	self.kelly = {
		name_id = "kelly",
		briefing_id = "kelly_briefing",
		world_name = "upg_003/kelly",
		packages = {
			"packages/zone_germany"
		},
		cube = "cube_apply_heist_bank",
		predefined_world = "kelly"
	}
	self._level_index = {
		"streaming_level",
		"germany_zone",
		"zone_germany",
		"flakturm",
		"gold_rush",
		"train_yard",
		"ger_bridge",
		"ger_bridge_operation",
		"radio_defense",
		"settlement",
		"forest_gumpy",
		"tutorial",
		"bunker_test",
		"tnd",
		"hunters",
		"convoy",
		"spies_test",
		"sto",
		"silo",
		"kelly"
	}
	self.escape_levels = {}
end

function LevelsTweakData:get_level_index()
	return self._level_index
end

function LevelsTweakData:get_world_name_from_index(index)
	if not self._level_index[index] then
		return
	end

	return self[self._level_index[index]].world_name
end

function LevelsTweakData:get_level_name_from_index(index)
	return self._level_index[index]
end

function LevelsTweakData:get_index_from_world_name(world_name)
	for index, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
			return index
		end
	end
end

function LevelsTweakData:get_index_from_level_id(level_id)
	for index, entry_name in ipairs(self._level_index) do
		if entry_name == level_id then
			return index
		end
	end
end

function LevelsTweakData:requires_dlc(level_id)
	return self[level_id].dlc
end

function LevelsTweakData:requires_dlc_by_index(index)
	return self[self._level_index[index]].dlc
end

function LevelsTweakData:get_level_name_from_world_name(world_name)
	for _, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
			return entry_name
		end
	end
end

function LevelsTweakData:get_localized_level_name_from_world_name(world_name)
	for _, entry_name in ipairs(self._level_index) do
		if world_name == self[entry_name].world_name then
			return managers.localization:text(self[entry_name].name_id)
		end
	end
end

function LevelsTweakData:get_localized_level_name_from_level_id(level_id)
	for _, entry_name in ipairs(self._level_index) do
		if level_id == entry_name then
			return managers.localization:text(self[entry_name].name_id)
		end
	end
end

function LevelsTweakData:get_default_team_ID(type)
	local lvl_tweak = self[Global.level_data.level_id]

	if lvl_tweak and lvl_tweak.default_teams and lvl_tweak.default_teams[type] then
		if lvl_tweak.teams[lvl_tweak.default_teams[type]] then
			return lvl_tweak.default_teams[type]
		else
			debug_pause("[LevelsTweakData:get_default_player_team_ID] Team not defined ", lvl_tweak.default_teams[type], "in", Global.level_data.level_id)
		end
	end

	if type == "player" then
		return "criminal1"
	elseif type == "combatant" then
		return "law1"
	elseif type == "non_combatant" then
		return "neutral1"
	else
		return "mobster1"
	end
end

function LevelsTweakData:get_team_setup()
	local lvl_tweak = nil
	lvl_tweak = (not Application:editor() or not managers.editor or self[managers.editor:layer("Level Settings"):get_setting("simulation_level_id")]) and Global.level_data and Global.level_data.level_id and self[Global.level_data.level_id]
	local teams = lvl_tweak and lvl_tweak.teams

	if teams then
		teams = deep_clone(teams)
	else
		teams = {
			criminal1 = {
				foes = {
					law1 = true,
					mobster1 = true
				}
			},
			law1 = {
				foes = {
					converted_enemy = true,
					criminal1 = true,
					mobster1 = true
				}
			},
			mobster1 = {
				foes = {
					converted_enemy = true,
					law1 = true,
					criminal1 = true
				}
			},
			converted_enemy = {
				foes = {
					law1 = true,
					mobster1 = true
				}
			},
			neutral1 = {
				foes = {}
			},
			hacked_turret = {
				foes = {
					law1 = true,
					mobster1 = true
				}
			}
		}

		for id, team in pairs(teams) do
			team.id = id
		end
	end

	return teams
end

function LevelsTweakData:get_default_team_IDs()
	local lvl_tweak = nil
	lvl_tweak = (not Application:editor() or not managers.editor or self[managers.editor:layer("Level Settings"):get_setting("simulation_level_id")]) and Global.level_data and Global.level_data.level_id and self[Global.level_data.level_id]
	local default_team_IDs = lvl_tweak and lvl_tweak.default_teams
	default_team_IDs = default_team_IDs or {
		player = self:get_default_team_ID("player"),
		combatant = self:get_default_team_ID("combatant"),
		non_combatant = self:get_default_team_ID("non_combatant"),
		gangster = self:get_default_team_ID("gangster")
	}

	return default_team_IDs
end

function LevelsTweakData:get_team_names_indexed()
	local teams_index = self._teams_index

	if not teams_index then
		teams_index = {}
		local teams = self:get_team_setup()

		for team_id, team_data in pairs(teams) do
			table.insert(teams_index, team_id)
		end

		table.sort(teams_index)

		self._teams_index = teams_index
	end

	return teams_index
end

function LevelsTweakData:get_team_index(team_id)
	local teams_index = self:get_team_names_indexed()

	for index, test_team_id in ipairs(teams_index) do
		if team_id == test_team_id then
			return index
		end
	end
end
