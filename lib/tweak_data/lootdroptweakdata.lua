LootDropTweakData = LootDropTweakData or class()
LootDropTweakData.REWARD_XP = "xp"
LootDropTweakData.REWARD_CARD_PACK = "card_pack"
LootDropTweakData.REWARD_CUSTOMIZATION = "customization"
LootDropTweakData.REWARD_WEAPON_POINT = "weapon_point"
LootDropTweakData.REWARD_MELEE_WEAPON = "melee_weapon"
LootDropTweakData.REWARD_GOLD_BARS = "gold_bars"
LootDropTweakData.REWARD_HALLOWEEN_2017 = "halloween_2017"
LootDropTweakData.RARITY_ALL = "loot_rarity_all"
LootDropTweakData.RARITY_DEFAULT = "loot_rarity_default"
LootDropTweakData.RARITY_COMMON = "loot_rarity_common"
LootDropTweakData.RARITY_UNCOMMON = "loot_rarity_uncommon"
LootDropTweakData.RARITY_RARE = "loot_rarity_rare"
LootDropTweakData.RARITY_NONE = "loot_rarity_none"
LootDropTweakData.RARITY_HALLOWEEN_2017 = "loot_rarity_haloween"
LootDropTweakData.LOOT_VALUE_TYPE_SMALL_AMOUNT = 1
LootDropTweakData.LOOT_VALUE_TYPE_MEDIUM_AMOUNT = 4
LootDropTweakData.LOOT_VALUE_TYPE_BIG_AMOUNT = 5
LootDropTweakData.TOTAL_LOOT_VALUE_DEFAULT = 35
LootDropTweakData.BRONZE_POINT_REQUIREMENT = 0.1
LootDropTweakData.SILVER_POINT_REQUIREMENT = 0.4
LootDropTweakData.GOLD_POINT_REQUIREMENT = 0.8
LootDropTweakData.POINT_REQUIREMENTS = {
	LootDropTweakData.BRONZE_POINT_REQUIREMENT,
	LootDropTweakData.SILVER_POINT_REQUIREMENT,
	LootDropTweakData.GOLD_POINT_REQUIREMENT
}

function LootDropTweakData:init(tweak_data)
	self:_payday_init(tweak_data)
	self:_init_xp_packs()
	self:_init_card_packs()
	self:_init_customization_rewards()
	self:_init_gold_bar_rewards()
	self:_init_categories()
	self:_init_groups()
	self:_init_loot_values()
	self:_init_dog_tag_stats()
end

function LootDropTweakData:_init_xp_packs()
	self.xp_packs = {
		tiny = {
			xp_min = 50,
			xp_max = 100,
			reward_type = LootDropTweakData.REWARD_XP
		},
		small = {
			xp_min = 120,
			xp_max = 300,
			reward_type = LootDropTweakData.REWARD_XP
		},
		medium = {
			xp_min = 350,
			xp_max = 600,
			reward_type = LootDropTweakData.REWARD_XP
		},
		large = {
			xp_min = 700,
			xp_max = 900,
			reward_type = LootDropTweakData.REWARD_XP
		}
	}
end

function LootDropTweakData:_init_card_packs()
	self.card_packs = {
		regular = {
			reward_type = LootDropTweakData.REWARD_CARD_PACK,
			pack_type = ChallengeCardsTweakData.PACK_TYPE_REGULAR
		}
	}
end

function LootDropTweakData:_init_customization_rewards()
	self.customization_rewards = {
		common = {
			reward_type = LootDropTweakData.REWARD_CUSTOMIZATION,
			rarity = LootDropTweakData.RARITY_COMMON
		},
		uncommon = {
			reward_type = LootDropTweakData.REWARD_CUSTOMIZATION,
			rarity = LootDropTweakData.RARITY_UNCOMMON
		},
		rare = {
			reward_type = LootDropTweakData.REWARD_CUSTOMIZATION,
			rarity = LootDropTweakData.RARITY_RARE
		}
	}
end

function LootDropTweakData:_init_gold_bar_rewards()
	self.gold_bar_rewards = {
		small = {
			gold_bars_max = 2,
			gold_bars_min = 1,
			reward_type = LootDropTweakData.REWARD_GOLD_BARS
		},
		medium = {
			gold_bars_max = 3,
			gold_bars_min = 2,
			reward_type = LootDropTweakData.REWARD_GOLD_BARS
		},
		large = {
			gold_bars_max = 4,
			gold_bars_min = 3,
			reward_type = LootDropTweakData.REWARD_GOLD_BARS
		}
	}
end

function LootDropTweakData:_init_categories()
	self.loot_categories = {
		category_xp_min = {}
	}
	self.loot_categories.category_xp_min[1] = {
		chance = 100,
		value = self.xp_packs.tiny
	}
	self.loot_categories.category_xp_low = {
		{
			chance = 100,
			value = self.xp_packs.small
		}
	}
	self.loot_categories.category_xp_mid = {
		{
			chance = 100,
			value = self.xp_packs.medium
		}
	}
	self.loot_categories.category_xp_high = {
		{
			chance = 100,
			value = self.xp_packs.large
		}
	}
	self.loot_categories.category_gold_low = {
		{
			chance = 75,
			value = self.gold_bar_rewards.small
		},
		{
			chance = 25,
			value = self.gold_bar_rewards.medium
		}
	}
	self.loot_categories.category_gold_mid = {
		{
			chance = 25,
			value = self.gold_bar_rewards.small
		},
		{
			chance = 50,
			value = self.gold_bar_rewards.medium
		},
		{
			chance = 25,
			value = self.gold_bar_rewards.large
		}
	}
	self.loot_categories.category_gold_high = {
		{
			chance = 50,
			value = self.gold_bar_rewards.medium
		},
		{
			chance = 50,
			value = self.gold_bar_rewards.large
		}
	}
	self.loot_categories.category_melee = {
		{
			chance = 100,
			value = {
				reward_type = LootDropTweakData.REWARD_MELEE_WEAPON
			}
		}
	}
	self.loot_categories.category_cards_low = {
		{
			chance = 100,
			value = self.card_packs.regular
		}
	}
	self.loot_categories.category_cards_mid = {
		{
			chance = 100,
			value = self.card_packs.regular
		}
	}
	self.loot_categories.category_cards_high = {
		{
			chance = 100,
			value = self.card_packs.regular
		}
	}
	self.loot_categories.category_custom_low = {
		{
			chance = 75,
			value = self.customization_rewards.common
		},
		{
			chance = 25,
			value = self.customization_rewards.uncommon
		}
	}
	self.loot_categories.category_custom_mid = {
		{
			chance = 50,
			value = self.customization_rewards.common
		},
		{
			chance = 25,
			value = self.customization_rewards.uncommon
		},
		{
			chance = 25,
			value = self.customization_rewards.rare
		}
	}
	self.loot_categories.category_custom_high = {
		{
			chance = 50,
			value = self.customization_rewards.uncommon
		},
		{
			chance = 50,
			value = self.customization_rewards.rare
		}
	}
	self.loot_categories.category_halloween_2017 = {
		{
			chance = 100,
			value = {
				weapon_id = "lc14b",
				reward_type = LootDropTweakData.REWARD_HALLOWEEN_2017
			}
		}
	}
end

function LootDropTweakData:_init_groups()
	self.loot_groups = {
		loot_group_basic = {}
	}
	self.loot_groups.loot_group_basic[1] = {
		chance = 20,
		value = self.loot_categories.category_xp_min
	}
	self.loot_groups.loot_group_basic[2] = {
		chance = 40,
		value = self.loot_categories.category_cards_low
	}
	self.loot_groups.loot_group_basic[3] = {
		chance = 5,
		value = self.loot_categories.category_custom_low
	}
	self.loot_groups.loot_group_basic[4] = {
		chance = 35,
		value = self.loot_categories.category_gold_low
	}
	self.loot_groups.loot_group_bronze = {
		{
			chance = 20,
			value = self.loot_categories.category_xp_low
		},
		{
			chance = 30,
			value = self.loot_categories.category_gold_low
		},
		{
			chance = 25,
			value = self.loot_categories.category_cards_low
		},
		{
			chance = 15,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 5,
			value = self.loot_categories.category_custom_low
		},
		{
			chance = 2.5,
			value = self.loot_categories.category_custom_mid
		},
		{
			chance = 2.5,
			value = self.loot_categories.category_melee
		}
	}
	self.loot_groups.loot_group_silver = {
		{
			chance = 20,
			value = self.loot_categories.category_xp_mid
		},
		{
			chance = 27,
			value = self.loot_categories.category_gold_mid
		},
		{
			chance = 40,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 10,
			value = self.loot_categories.category_custom_mid
		},
		{
			chance = 3,
			value = self.loot_categories.category_melee
		}
	}
	self.loot_groups.loot_group_gold = {
		{
			chance = 10,
			value = self.loot_categories.category_xp_high
		},
		{
			chance = 15,
			value = self.loot_categories.category_gold_high
		},
		{
			chance = 15,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 35,
			value = self.loot_categories.category_cards_high
		},
		{
			chance = 10,
			value = self.loot_categories.category_custom_mid
		},
		{
			chance = 10,
			value = self.loot_categories.category_custom_high
		},
		{
			chance = 5,
			value = self.loot_categories.category_melee
		}
	}
	self.loot_groups.loot_group_halooween_2017 = {
		{
			chance = 100,
			value = self.loot_categories.category_halloween_2017
		}
	}
	self.loot_groups_doubles_fallback = {
		loot_group_basic = {}
	}
	self.loot_groups_doubles_fallback.loot_group_basic[1] = {
		chance = 45,
		value = self.loot_categories.category_gold_low
	}
	self.loot_groups_doubles_fallback.loot_group_basic[2] = {
		chance = 45,
		value = self.loot_categories.category_xp_min
	}
	self.loot_groups_doubles_fallback.loot_group_basic[3] = {
		chance = 10,
		value = self.loot_categories.category_cards_low
	}
	self.loot_groups_doubles_fallback.loot_group_bronze = {
		{
			chance = 40,
			value = self.loot_categories.category_gold_low
		},
		{
			chance = 5,
			value = self.loot_categories.category_gold_mid
		},
		{
			chance = 15,
			value = self.loot_categories.category_cards_low
		},
		{
			chance = 5,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 30,
			value = self.loot_categories.category_xp_low
		}
	}
	self.loot_groups_doubles_fallback.loot_group_silver = {
		{
			chance = 38,
			value = self.loot_categories.category_gold_mid
		},
		{
			chance = 7,
			value = self.loot_categories.category_gold_high
		},
		{
			chance = 20,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 35,
			value = self.loot_categories.category_xp_mid
		}
	}
	self.loot_groups_doubles_fallback.loot_group_gold = {
		{
			chance = 35,
			value = self.loot_categories.category_gold_high
		},
		{
			chance = 10,
			value = self.loot_categories.category_cards_mid
		},
		{
			chance = 20,
			value = self.loot_categories.category_cards_high
		},
		{
			chance = 35,
			value = self.loot_categories.category_xp_high
		}
	}
end

function LootDropTweakData:_init_loot_values()
	self.loot_groups.loot_group_basic.min_loot_value = -1000000
	self.loot_groups.loot_group_basic.max_loot_value = LootDropTweakData.BRONZE_POINT_REQUIREMENT
	self.loot_groups.loot_group_bronze.min_loot_value = LootDropTweakData.BRONZE_POINT_REQUIREMENT
	self.loot_groups.loot_group_bronze.max_loot_value = LootDropTweakData.SILVER_POINT_REQUIREMENT
	self.loot_groups.loot_group_silver.min_loot_value = LootDropTweakData.SILVER_POINT_REQUIREMENT
	self.loot_groups.loot_group_silver.max_loot_value = LootDropTweakData.GOLD_POINT_REQUIREMENT
	self.loot_groups.loot_group_gold.min_loot_value = LootDropTweakData.GOLD_POINT_REQUIREMENT
	self.loot_groups.loot_group_gold.max_loot_value = 1000000
	self.loot_groups.loot_group_halooween_2017.min_loot_value = -1
	self.loot_groups.loot_group_halooween_2017.max_loot_value = -1
	self.loot_groups_doubles_fallback.loot_group_basic.min_loot_value = self.loot_groups.loot_group_basic.min_loot_value
	self.loot_groups_doubles_fallback.loot_group_basic.max_loot_value = self.loot_groups.loot_group_basic.max_loot_value
	self.loot_groups_doubles_fallback.loot_group_bronze.min_loot_value = self.loot_groups.loot_group_bronze.min_loot_value
	self.loot_groups_doubles_fallback.loot_group_bronze.max_loot_value = self.loot_groups.loot_group_bronze.max_loot_value
	self.loot_groups_doubles_fallback.loot_group_silver.min_loot_value = self.loot_groups.loot_group_silver.min_loot_value
	self.loot_groups_doubles_fallback.loot_group_silver.max_loot_value = self.loot_groups.loot_group_silver.max_loot_value
	self.loot_groups_doubles_fallback.loot_group_gold.min_loot_value = self.loot_groups.loot_group_gold.min_loot_value
	self.loot_groups_doubles_fallback.loot_group_gold.max_loot_value = self.loot_groups.loot_group_gold.max_loot_value
end

function LootDropTweakData:_init_dog_tag_stats()
	self.dog_tag = {
		loot_value = 50
	}
end

function LootDropTweakData:_payday_init(tweak_data)
	self.PC_STEP = 10
	self.no_drop = {
		BASE = 35,
		HUMAN_STEP_MODIFIER = 10
	}
	self.joker_chance = 0
	self.level_limit = 1
	self.risk_pc_multiplier = {
		0,
		0,
		0,
		0
	}
	self.risk_infamous_multiplier = {
		1,
		2,
		3,
		5
	}
	self.PC_CHANCE = {
		0.7,
		0.7,
		0.7,
		0.7,
		0.9,
		0.91,
		0.92,
		0.93,
		0.94,
		0.95
	}
	self.STARS = {
		{
			pcs = {
				10,
				10
			}
		},
		{
			pcs = {
				20,
				20
			}
		},
		{
			pcs = {
				30,
				30
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		},
		{
			pcs = {
				40,
				40
			}
		}
	}
	self.STARS_CURVES = {
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1,
		1
	}
	self.WEIGHTED_TYPE_CHANCE = {}
	local min = 10
	local max = 100
	local range = {
		cash = {
			20,
			5
		},
		weapon_mods = {
			50,
			45
		},
		colors = {
			6,
			11
		},
		textures = {
			7,
			12
		},
		materials = {
			7,
			12
		},
		masks = {
			10,
			15
		},
		xp = {
			8,
			0
		}
	}

	for i = min, max, 10 do
		local cash = math.lerp(range.cash[1], range.cash[2], i / max)
		local weapon_mods = math.lerp(range.weapon_mods[1], range.weapon_mods[2], i / max)
		local colors = math.lerp(range.colors[1], range.colors[2], i / max)
		local textures = math.lerp(range.textures[1], range.textures[2], i / max)
		local materials = math.lerp(range.materials[1], range.materials[2], i / max)
		local masks = math.lerp(range.masks[1], range.masks[2], i / max)
		local xp = math.lerp(range.xp[1], range.xp[2], i / max)
		self.WEIGHTED_TYPE_CHANCE[i] = {
			cash = cash,
			weapon_mods = weapon_mods,
			colors = colors,
			textures = textures,
			materials = materials,
			masks = masks,
			xp = xp
		}
	end

	self.DEFAULT_WEIGHT = 1
	self.got_item_weight_mod = 0.5
	self.type_weight_mod_funcs = {
		weapon_mods = function (global_value, category, id)
			local weapons = managers.weapon_factory:get_weapons_uses_part(id) or {}
			local primaries = managers.blackmarket:get_crafted_category("primaries") or {}
			local secondaries = managers.blackmarket:get_crafted_category("secondaries") or {}
			local crafted_weapons = {}

			for _, weapon in pairs(primaries) do
				table.insert(crafted_weapons, weapon.factory_id)
			end

			for _, weapon in pairs(secondaries) do
				table.insert(crafted_weapons, weapon.factory_id)
			end

			table.list_union(crafted_weapons)

			for _, factory_id in pairs(weapons) do
				if table.contains(crafted_weapons, factory_id) then
					return 2
				end
			end

			return 1
		end
	}
	self.global_value_category = {
		normal = {}
	}
	self.global_value_category.normal.name_id = "bm_global_value_normal"
	self.global_value_category.normal.sort_number = 0
	self.global_value_category.dlc = {
		name_id = "bm_menu_dlc",
		sort_number = 10
	}
	self.global_value_category.global_event = {
		name_id = "bm_menu_global_event",
		sort_number = 20
	}
	self.global_value_category.infamous = {
		name_id = "bm_global_value_infamous",
		sort_number = 30
	}
	self.global_value_category.collaboration = {
		name_id = "bm_global_value_collaboration",
		sort_number = 25
	}
	self.global_values = {
		normal = {}
	}
	self.global_values.normal.name_id = "bm_global_value_normal"
	self.global_values.normal.desc_id = "menu_l_global_value_normal"
	self.global_values.normal.color = Color.white
	self.global_values.normal.dlc = false
	self.global_values.normal.chance = 0.84
	self.global_values.normal.value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "normal")
	self.global_values.normal.durability_multiplier = 1
	self.global_values.normal.drops = true
	self.global_values.normal.track = false
	self.global_values.normal.sort_number = 0
	self.global_values.normal.category = "normal"
	self.global_values.superior = {
		name_id = "bm_global_value_superior",
		desc_id = "menu_l_global_value_superior",
		color = Color.blue,
		dlc = false,
		chance = 0.1,
		value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "superior"),
		durability_multiplier = 1.5,
		drops = false,
		track = false,
		sort_number = 25,
		category = nil
	}
	self.global_values.exceptional = {
		name_id = "bm_global_value_exceptional",
		desc_id = "menu_l_global_value_exceptional",
		color = Color.yellow,
		dlc = false,
		chance = 0.05,
		value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "exceptional"),
		durability_multiplier = 2.25,
		drops = false,
		track = false,
		sort_number = 26,
		category = nil
	}
	self.global_values.infamous = {
		name_id = "bm_global_value_infamous",
		desc_id = "menu_l_global_value_infamous",
		color = Color(1, 0.1, 1),
		dlc = false,
		chance = 0.05,
		value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "infamous"),
		durability_multiplier = 3,
		drops = true,
		track = false,
		sort_number = 30,
		category = "infamous"
	}
	self.global_values.infamy = {
		name_id = "bm_global_value_infamous",
		desc_id = "menu_l_global_value_infamous",
		color = Color(1, 0.1, 1),
		dlc = false,
		chance = 0.05,
		value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "infamous"),
		durability_multiplier = 3,
		drops = false,
		track = false,
		sort_number = 35,
		hide_unavailable = true,
		category = "infamous"
	}
	self.global_values.preorder = {
		name_id = "bm_global_value_preorder",
		desc_id = "menu_l_global_value_preorder",
		color = Color(255, 255, 212, 0) / 255,
		dlc = true,
		chance = 1,
		value_multiplier = tweak_data:get_value("money_manager", "global_value_multipliers", "preorder"),
		durability_multiplier = 1,
		drops = false,
		track = true,
		sort_number = -10,
		hide_unavailable = true
	}

	if SystemInfo:platform() == Idstring("PS3") then
		-- Nothing
	elseif SystemInfo:platform() == Idstring("X360") then
		-- Nothing
	elseif SystemInfo:platform() == Idstring("PS4") then
		-- Nothing
	elseif SystemInfo:platform() == Idstring("XB1") then
		-- Nothing
	end

	self.global_value_list_index = {
		"normal"
	}

	self:_create_global_value_list_map()
end

function LootDropTweakData:_create_global_value_list_map()
	self.global_value_list_map = {}

	for i, d in ipairs(self.global_value_list_index) do
		self.global_value_list_map[d] = i
	end
end
