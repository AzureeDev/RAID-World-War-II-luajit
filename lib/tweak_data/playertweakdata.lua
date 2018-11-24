PlayerTweakData = PlayerTweakData or class()

function PlayerTweakData:_set_difficulty_1()
	self.damage.automatic_respawn_time = 30
end

function PlayerTweakData:_set_difficulty_2()
	self.damage.automatic_respawn_time = 60
	self.damage.DOWNED_TIME_DEC = 7
	self.damage.DOWNED_TIME_MIN = 5
end

function PlayerTweakData:_set_difficulty_3()
	self.damage.automatic_respawn_time = 90
	self.damage.DOWNED_TIME_DEC = 10
	self.damage.DOWNED_TIME_MIN = 5
end

function PlayerTweakData:_set_difficulty_4()
	self.damage.automatic_respawn_time = 220
	self.damage.DOWNED_TIME_DEC = 15
	self.damage.DOWNED_TIME_MIN = 1
end

function PlayerTweakData:_set_singleplayer()
	self.damage.REGENERATE_TIME = 1.75
end

function PlayerTweakData:_set_multiplayer()
end

function PlayerTweakData:init()
	local is_console = SystemInfo:platform() ~= Idstring("WIN32")
	self.run_move_dir_treshold = 0.7
	self.arrest = {
		aggression_timeout = 60,
		arrest_timeout = 240
	}
	self.put_on_mask_time = 2
	self.damage = {
		DODGE_INIT = 0,
		HEALTH_REGEN = 0,
		ARMOR_STEPS = 1,
		ARMOR_DAMAGE_REDUCTION = 1,
		ARMOR_DAMAGE_REDUCTION_STEPS = {
			1,
			0.6,
			0.7,
			0.8,
			0.9,
			0.95,
			0.96,
			0.97,
			0.98,
			0.99
		}
	}

	if is_console then
		self.damage.REGENERATE_TIME = 2.35
	else
		self.damage.REGENERATE_TIME = 3
	end

	self.damage.REVIVE_HEALTH_STEPS = {
		1
	}
	self.damage.TASED_TIME = 10
	self.damage.TASED_RECOVER_TIME = 1
	self.damage.BLEED_OUT_HEALTH_INIT = 10
	self.damage.DOWNED_TIME = 30
	self.damage.DOWNED_TIME_DEC = 5
	self.damage.DOWNED_TIME_MIN = 10
	self.damage.ARRESTED_TIME = 60
	self.damage.INCAPACITATED_TIME = 30
	self.damage.MIN_DAMAGE_INTERVAL = 0.45
	self.damage.respawn_time_penalty = 30
	self.damage.base_respawn_time_penalty = 5
	self.damage.automatic_assault_ai_trade_time = 120
	self.damage.automatic_assault_ai_trade_time_max = 180
	self.fall_health_damage = 4
	self.fall_damage_alert_size = 250
	self.SUSPICION_OFFSET_LERP = 0.75
	self.long_dis_interaction = {
		intimidate_range_enemies = 1000,
		highlight_range = 3000,
		intimidate_range_civilians = 1000,
		intimidate_strength = 0.5
	}
	self.suppression = {
		receive_mul = 10,
		decay_start_delay = 1,
		spread_mul = 1,
		tolerance = 1,
		max_value = 20,
		autohit_chance_mul = 1
	}
	self.suspicion = {
		range_mul = 1,
		max_value = 8,
		buildup_mul = 1
	}
	self.alarm_pager = {
		first_call_delay = {
			2,
			4
		},
		call_duration = {
			{
				6,
				6
			},
			{
				6,
				6
			}
		},
		nr_of_calls = {
			2,
			2
		},
		bluff_success_chance = {
			1,
			1,
			1,
			1,
			0
		},
		bluff_success_chance_w_skill = {
			1,
			1,
			1,
			1,
			0
		}
	}
	self.max_nr_following_hostages = 1
	self.TRANSITION_DURATION = 0.23
	self.PLAYER_EYE_HEIGHT = 145
	self.PLAYER_EYE_HEIGHT_CROUCH = 75
	self.stances = {
		default = {
			standard = {
				head = {},
				shoulders = {},
				vel_overshot = {}
			},
			crouched = {
				head = {},
				shoulders = {},
				vel_overshot = {}
			},
			steelsight = {
				shoulders = {},
				vel_overshot = {}
			}
		}
	}
	self.stances.default.standard.head.translation = Vector3(0, 0, self.PLAYER_EYE_HEIGHT)
	self.stances.default.standard.head.rotation = Rotation()
	self.stances.default.standard.shakers = {
		breathing = {}
	}
	self.stances.default.standard.shakers.breathing.amplitude = 0.3
	self.stances.default.crouched.shakers = {
		breathing = {}
	}
	self.stances.default.crouched.shakers.breathing.amplitude = 0.25
	self.stances.default.steelsight.shakers = {
		breathing = {}
	}
	self.stances.default.steelsight.shakers.breathing.amplitude = 0.025
	self.stances.default.mask_off = deep_clone(self.stances.default.standard)
	self.stances.default.mask_off.head.translation = Vector3(0, 0, self.PLAYER_EYE_HEIGHT)
	self.stances.default.clean = deep_clone(self.stances.default.mask_off)
	self.stances.default.civilian = deep_clone(self.stances.default.mask_off)
	local pivot_head_translation = Vector3()
	local pivot_head_rotation = Rotation()
	local pivot_shoulder_translation = Vector3()
	local pivot_shoulder_rotation = Rotation()
	self.stances.default.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.default.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.default.standard.vel_overshot.yaw_neg = 6
	self.stances.default.standard.vel_overshot.yaw_pos = -6
	self.stances.default.standard.vel_overshot.pitch_neg = -10
	self.stances.default.standard.vel_overshot.pitch_pos = 10
	self.stances.default.standard.vel_overshot.pivot = Vector3(0, 0, 0)
	self.stances.default.standard.FOV = 60
	self.stances.default.crouched.head.translation = Vector3(0, 0, self.PLAYER_EYE_HEIGHT_CROUCH)
	self.stances.default.crouched.head.rotation = Rotation()
	local pivot_head_translation = Vector3()
	local pivot_head_rotation = Rotation()
	self.stances.default.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.default.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.default.crouched.vel_overshot.yaw_neg = 6
	self.stances.default.crouched.vel_overshot.yaw_pos = -6
	self.stances.default.crouched.vel_overshot.pitch_neg = -10
	self.stances.default.crouched.vel_overshot.pitch_pos = 10
	self.stances.default.crouched.vel_overshot.pivot = Vector3(0, 0, 0)
	self.stances.default.crouched.FOV = self.stances.default.standard.FOV
	local pivot_head_translation = Vector3(0, 0, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.default.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.default.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.default.steelsight.vel_overshot.yaw_neg = 4
	self.stances.default.steelsight.vel_overshot.yaw_pos = -4
	self.stances.default.steelsight.vel_overshot.pitch_neg = -2
	self.stances.default.steelsight.vel_overshot.pitch_pos = 2
	self.stances.default.steelsight.vel_overshot.pivot = pivot_shoulder_translation
	self.stances.default.steelsight.zoom_fov = true
	self.stances.default.steelsight.FOV = self.stances.default.standard.FOV

	self:_init_new_stances()
	self:_init_pistol_stances()
	self:_init_smg_stances()
	self:_init_shotgun_stances()

	self.movement_state = {
		interaction_delay = 1.5
	}
	self.camera = {
		MIN_SENSITIVITY = 0.1,
		MAX_SENSITIVITY = 1.7
	}
	self.fov_multiplier = {
		MIN = 1,
		MAX = 1.83333
	}
	self.omniscience = {
		start_t = 3.5,
		interval_t = 1,
		sense_radius = 1000,
		target_resense_t = 15
	}
	self.damage_indicator_duration = 1

	self:_init_parachute()
	self:_init_class_specific_tweak_data()
	self:_init_team_ai_tweak_data()
end

function PlayerTweakData:get_tweak_data_for_class(class)
	if not class or not self.class_defaults[class] then
		Application:error("[PlayerTweakData] get_tweak_data_for_class(): trying to get tweak data for non-existent class: ", class)
		Application:error(debug.traceback())

		return self.class_defaults.default
	end

	return self.class_defaults[class]
end

function PlayerTweakData:_init_class_specific_tweak_data()
	self.class_defaults = {}

	self:_init_default_class_tweak_data()
	self:_init_recon_tweak_data()
	self:_init_assault_tweak_data()
	self:_init_insurgent_tweak_data()
	self:_init_demolitions_tweak_data()
end

function PlayerTweakData:_init_team_ai_tweak_data()
	self.team_ai = {
		movement = {}
	}
	self.team_ai.movement.speed = {
		WALKING_SPEED = 350
	}
end

function PlayerTweakData:_init_default_class_tweak_data()
	self.class_defaults.default = {
		damage = {}
	}
	self.class_defaults.default.damage.BASE_HEALTH = 90
	self.class_defaults.default.damage.BASE_LIVES = 4
	self.class_defaults.default.damage.BASE_ARMOR = 2
	self.class_defaults.default.damage.DODGE_INIT = 0
	self.class_defaults.default.damage.HEALTH_REGEN = 0
	self.class_defaults.default.damage.FALL_DAMAGE_MIN_HEIGHT = 300
	self.class_defaults.default.damage.FALL_DAMAGE_FATAL_HEIGHT = 1000
	self.class_defaults.default.damage.FALL_DAMAGE_MIN = 4
	self.class_defaults.default.damage.FALL_DAMAGE_MAX = 75
	self.class_defaults.default.stealth = {
		FALL_ALERT_MIN_HEIGHT = 250,
		FALL_ALERT_MAX_HEIGHT = 600,
		FALL_ALERT_MIN_RADIUS = 200,
		FALL_ALERT_MAX_RADIUS = 600
	}
	self.class_defaults.default.movement = {
		speed = {}
	}
	self.class_defaults.default.movement.speed.WALKING_SPEED = 350
	self.class_defaults.default.movement.speed.RUNNING_SPEED = 575
	self.class_defaults.default.movement.speed.CROUCHING_SPEED = 225
	self.class_defaults.default.movement.speed.STEELSIGHT_SPEED = 185
	self.class_defaults.default.movement.speed.AIR_SPEED = 185
	self.class_defaults.default.movement.speed.CLIMBING_SPEED = 200
	self.class_defaults.default.movement.jump_velocity = {
		xy = {},
		z = 500
	}
	self.class_defaults.default.movement.jump_velocity.xy.run = self.class_defaults.default.movement.speed.RUNNING_SPEED
	self.class_defaults.default.movement.jump_velocity.xy.walk = self.class_defaults.default.movement.speed.WALKING_SPEED * 1.2
	self.class_defaults.default.movement.stamina = {
		BASE_STAMINA = 20,
		BASE_STAMINA_REGENERATION_RATE = 3,
		BASE_STAMINA_DRAIN_RATE = 2,
		STAMINA_REGENERATION_DELAY = 2,
		MIN_STAMINA_THRESHOLD = 4,
		JUMP_STAMINA_DRAIN = 2
	}
end

function PlayerTweakData:_init_recon_tweak_data()
	local recon = SkillTreeTweakData.CLASS_RECON
	self.class_defaults[recon] = deep_clone(self.class_defaults.default)
	self.class_defaults[recon].damage.BASE_HEALTH = 80
	self.class_defaults[recon].movement.stamina.BASE_STAMINA = 22
	self.class_defaults[recon].movement.stamina.STAMINA_REGENERATION_DELAY = 3
	self.class_defaults[recon].movement.speed.CROUCHING_SPEED = 247.5
	self.class_defaults[recon].movement.speed.STEELSIGHT_SPEED = 203.5
end

function PlayerTweakData:_init_assault_tweak_data()
	local assault = SkillTreeTweakData.CLASS_ASSAULT
	self.class_defaults[assault] = deep_clone(self.class_defaults.default)
	self.class_defaults[assault].damage.BASE_HEALTH = 100
	self.class_defaults[assault].movement.stamina.STAMINA_REGENERATION_DELAY = 2.2
	self.class_defaults[assault].movement.speed.WALKING_SPEED = 315
	self.class_defaults[assault].movement.speed.RUNNING_SPEED = 517.5
end

function PlayerTweakData:_init_insurgent_tweak_data()
	local insurgent = SkillTreeTweakData.CLASS_INFILTRATOR
	self.class_defaults[insurgent] = deep_clone(self.class_defaults.default)
	self.class_defaults[insurgent].damage.BASE_HEALTH = 85
	self.class_defaults[insurgent].movement.stamina.BASE_STAMINA = 18
	self.class_defaults[insurgent].movement.stamina.STAMINA_REGENERATION_DELAY = 1
	self.class_defaults[insurgent].movement.speed.WALKING_SPEED = 367.5
	self.class_defaults[insurgent].movement.speed.RUNNING_SPEED = 603.75
end

function PlayerTweakData:_init_demolitions_tweak_data()
	local demolitions = SkillTreeTweakData.CLASS_DEMOLITIONS
	self.class_defaults[demolitions] = deep_clone(self.class_defaults.default)
end

function PlayerTweakData:_init_parachute()
	self.freefall = {
		gravity = 982,
		terminal_velocity = 7000,
		movement = {}
	}
	self.freefall.movement.forward_speed = 150
	self.freefall.movement.rotation_speed = 15
	self.freefall.camera = {
		target_pitch = -45,
		limits = {}
	}
	self.freefall.camera.limits.spin = 30
	self.freefall.camera.limits.pitch = 10
	self.freefall.camera.tilt = {
		max = 5,
		speed = 2
	}
	self.freefall.camera.shake = {
		min = 0,
		max = 0.2
	}
	self.parachute = {
		gravity = self.freefall.gravity,
		terminal_velocity = 600,
		movement = {}
	}
	self.parachute.movement.forward_speed = 250
	self.parachute.movement.rotation_speed = 30
	self.parachute.camera = {
		target_pitch = -5,
		limits = {}
	}
	self.parachute.camera.limits.spin = 90
	self.parachute.camera.limits.pitch = 60
	self.parachute.camera.tilt = {
		max = self.freefall.camera.tilt.max,
		speed = self.freefall.camera.shake.max
	}
end

function PlayerTweakData:_init_pistol_stances()
	self.stances.m1911 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.1257, 29.4187, 1.86738)
	local pivot_shoulder_rotation = Rotation(0, 0, 0)
	local pivot_head_translation = Vector3(7.25, 28, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.m1911.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1911.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1911.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.m1911.standard.vel_overshot.yaw_neg = 10
	self.stances.m1911.standard.vel_overshot.yaw_pos = -10
	self.stances.m1911.standard.vel_overshot.pitch_neg = -13
	self.stances.m1911.standard.vel_overshot.pitch_pos = 13
	local pivot_head_translation = Vector3(0, 28, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.m1911.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1911.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1911.steelsight.FOV = self.stances.m1911.standard.FOV
	self.stances.m1911.steelsight.zoom_fov = false
	self.stances.m1911.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.m1911.steelsight.vel_overshot.yaw_neg = 8
	self.stances.m1911.steelsight.vel_overshot.yaw_pos = -8
	self.stances.m1911.steelsight.vel_overshot.pitch_neg = -8
	self.stances.m1911.steelsight.vel_overshot.pitch_pos = 8
	local pivot_head_translation = Vector3(6.25, 25, -3.25)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.m1911.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1911.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1911.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.tt33 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(3.90636, 28.7622, 1.84151)
	local pivot_shoulder_rotation = Rotation(-6.93792e-06, 0.000789135, -0.000147309)
	local pivot_head_translation = Vector3(3.05, 28, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.tt33.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.tt33.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.tt33.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.tt33.standard.vel_overshot.yaw_neg = 10
	self.stances.tt33.standard.vel_overshot.yaw_pos = -10
	self.stances.tt33.standard.vel_overshot.pitch_neg = -13
	self.stances.tt33.standard.vel_overshot.pitch_pos = 13
	local pivot_head_translation = Vector3(0, 28, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.tt33.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.tt33.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.tt33.steelsight.FOV = self.stances.tt33.standard.FOV
	self.stances.tt33.steelsight.zoom_fov = false
	self.stances.tt33.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.tt33.steelsight.vel_overshot.yaw_neg = 8
	self.stances.tt33.steelsight.vel_overshot.yaw_pos = -8
	self.stances.tt33.steelsight.vel_overshot.pitch_neg = -8
	self.stances.tt33.steelsight.vel_overshot.pitch_pos = 8
	local pivot_head_translation = Vector3(2.05, 25, -3.25)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.tt33.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.tt33.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.tt33.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.c96 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.78944, 22.8361, 1.92305)
	local pivot_shoulder_rotation = Rotation(-0.00015875, 0.000630032, -0.000288361)
	local pivot_head_translation = Vector3(9, 28, -4.5)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.c96.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.c96.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.c96.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -50, 0)
	self.stances.c96.standard.vel_overshot.yaw_neg = 10
	self.stances.c96.standard.vel_overshot.yaw_pos = -10
	self.stances.c96.standard.vel_overshot.pitch_neg = -10
	self.stances.c96.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 28, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.c96.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.c96.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.c96.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -58, 0)
	self.stances.c96.steelsight.vel_overshot.yaw_neg = 10
	self.stances.c96.steelsight.vel_overshot.yaw_pos = -10
	self.stances.c96.steelsight.vel_overshot.pitch_neg = -10
	self.stances.c96.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(8, 27, -5.5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.c96.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.c96.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.c96.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -55, 0)
	self.stances.welrod = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.14836, 25.9756, 1.92877)
	local pivot_shoulder_rotation = Rotation(-3.80773e-05, 0.000801948, -0.000620346)
	local pivot_head_translation = Vector3(6, 20, -2)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.welrod.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.welrod.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.welrod.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.welrod.standard.vel_overshot.yaw_neg = 10
	self.stances.welrod.standard.vel_overshot.yaw_pos = -10
	self.stances.welrod.standard.vel_overshot.pitch_neg = -13
	self.stances.welrod.standard.vel_overshot.pitch_pos = 13
	local pivot_head_translation = Vector3(0, 16, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.welrod.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.welrod.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.welrod.steelsight.FOV = self.stances.welrod.standard.FOV
	self.stances.welrod.steelsight.zoom_fov = false
	self.stances.welrod.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.welrod.steelsight.vel_overshot.yaw_neg = -6
	self.stances.welrod.steelsight.vel_overshot.yaw_pos = 4
	self.stances.welrod.steelsight.vel_overshot.pitch_neg = 4
	self.stances.welrod.steelsight.vel_overshot.pitch_pos = -6
	local pivot_head_translation = Vector3(4, 18, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.welrod.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.welrod.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.welrod.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.nagant = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.14841, 33.5584, 1.75919)
	local pivot_shoulder_rotation = Rotation(8.24405e-05, 0.000829823, -0.000204329)
	local pivot_head_translation = Vector3(6, 20, -2)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.nagant.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.nagant.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.nagant.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.nagant.standard.vel_overshot.yaw_neg = 10
	self.stances.nagant.standard.vel_overshot.yaw_pos = -10
	self.stances.nagant.standard.vel_overshot.pitch_neg = -13
	self.stances.nagant.standard.vel_overshot.pitch_pos = 13
	local pivot_head_translation = Vector3(0, 16, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.nagant.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.nagant.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.nagant.steelsight.FOV = self.stances.nagant.standard.FOV
	self.stances.nagant.steelsight.zoom_fov = false
	self.stances.nagant.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.nagant.steelsight.vel_overshot.yaw_neg = -6
	self.stances.nagant.steelsight.vel_overshot.yaw_pos = 4
	self.stances.nagant.steelsight.vel_overshot.pitch_neg = 4
	self.stances.nagant.steelsight.vel_overshot.pitch_pos = -6
	local pivot_head_translation = Vector3(4, 18, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.nagant.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.nagant.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.nagant.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.shotty = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.4127, 15.7764, -5.20036)
	local pivot_shoulder_rotation = Rotation(-0.000176678, 0.000172462, 0.000184415)
	local pivot_head_translation = Vector3(7, 18, -3)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.shotty.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.shotty.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.shotty.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.shotty.standard.vel_overshot.yaw_neg = 10
	self.stances.shotty.standard.vel_overshot.yaw_pos = -10
	self.stances.shotty.standard.vel_overshot.pitch_neg = -10
	self.stances.shotty.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 16, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.shotty.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.shotty.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.shotty.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -18, 0)
	self.stances.shotty.steelsight.vel_overshot.yaw_neg = 10
	self.stances.shotty.steelsight.vel_overshot.yaw_pos = -10
	self.stances.shotty.steelsight.vel_overshot.pitch_neg = -10
	self.stances.shotty.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(6, 17, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.shotty.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.shotty.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.shotty.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -25, 0)
	self.stances.webley = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(7.19268, 24.4376, 4.45431)
	local pivot_shoulder_rotation = Rotation(0.000270585, 8.74022e-05, -0.00120361)
	local pivot_head_translation = Vector3(7, 23, -2)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.webley.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.webley.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.webley.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -50, 0)
	self.stances.webley.standard.vel_overshot.yaw_neg = 10
	self.stances.webley.standard.vel_overshot.yaw_pos = -10
	self.stances.webley.standard.vel_overshot.pitch_neg = -10
	self.stances.webley.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 25, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.webley.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.webley.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.webley.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -58, 0)
	self.stances.webley.steelsight.vel_overshot.yaw_neg = 10
	self.stances.webley.steelsight.vel_overshot.yaw_pos = -10
	self.stances.webley.steelsight.vel_overshot.pitch_neg = -10
	self.stances.webley.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(7, 21, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.webley.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.webley.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.webley.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -55, 0)
end

function PlayerTweakData:_init_smg_stances()
	self.stances.sterling = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(7.98744, 8.04285, -5.10392)
	local pivot_shoulder_rotation = Rotation(-1.64325e-05, 0.000797193, -4.99999)
	local pivot_head_translation = Vector3(6, 11, -5)
	local pivot_head_rotation = Rotation(0, 0, -15)
	self.stances.sterling.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sterling.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sterling.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.sterling.standard.vel_overshot.yaw_neg = 10
	self.stances.sterling.standard.vel_overshot.yaw_pos = -10
	self.stances.sterling.standard.vel_overshot.pitch_neg = -10
	self.stances.sterling.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 16, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.sterling.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sterling.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sterling.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -38, 0)
	self.stances.sterling.steelsight.vel_overshot.yaw_neg = 10
	self.stances.sterling.steelsight.vel_overshot.yaw_pos = -10
	self.stances.sterling.steelsight.vel_overshot.pitch_neg = -10
	self.stances.sterling.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(5, 10, -6)
	local pivot_head_rotation = Rotation(0, 0, -18)
	self.stances.sterling.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sterling.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sterling.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -35, 0)
	self.stances.thompson = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(7.80842, -1.25716, 2.84058)
	local pivot_shoulder_rotation = Rotation(-7.585e-05, 0.000911442, -7.74339e-06)
	local pivot_head_translation = Vector3(9, 8, -5.5)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.thompson.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.thompson.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.thompson.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.thompson.standard.vel_overshot.yaw_neg = -6
	self.stances.thompson.standard.vel_overshot.yaw_pos = 6
	self.stances.thompson.standard.vel_overshot.pitch_neg = 5
	self.stances.thompson.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 12, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.thompson.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.thompson.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.thompson.steelsight.FOV = self.stances.thompson.standard.FOV
	self.stances.thompson.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.thompson.steelsight.vel_overshot.yaw_neg = -2
	self.stances.thompson.steelsight.vel_overshot.yaw_pos = 4
	self.stances.thompson.steelsight.vel_overshot.pitch_neg = 5
	self.stances.thompson.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(6, 6, -4.5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.thompson.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.thompson.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.thompson.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.thompson.crouched.vel_overshot.yaw_neg = -6
	self.stances.thompson.crouched.vel_overshot.yaw_pos = 6
	self.stances.thompson.crouched.vel_overshot.pitch_neg = 5
	self.stances.thompson.crouched.vel_overshot.pitch_pos = -5
	self.stances.sten = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(7.77455, 11.5544, -0.499107)
	local pivot_shoulder_rotation = Rotation(-4.74979e-06, 0.00043329, -0.000178439)
	local pivot_head_translation = Vector3(9, 15, -5.5)
	local pivot_head_rotation = Rotation(0, 0, -12)
	self.stances.sten.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sten.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sten.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.sten.standard.vel_overshot.yaw_neg = -6
	self.stances.sten.standard.vel_overshot.yaw_pos = 6
	self.stances.sten.standard.vel_overshot.pitch_neg = 5
	self.stances.sten.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 15, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.sten.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sten.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sten.steelsight.FOV = self.stances.sten.standard.FOV
	self.stances.sten.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.sten.steelsight.vel_overshot.yaw_neg = -2
	self.stances.sten.steelsight.vel_overshot.yaw_pos = 4
	self.stances.sten.steelsight.vel_overshot.pitch_neg = 5
	self.stances.sten.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(6, 10, -4.5)
	local pivot_head_rotation = Rotation(0, 0, -16)
	self.stances.sten.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.sten.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.sten.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.sten.crouched.vel_overshot.yaw_neg = -6
	self.stances.sten.crouched.vel_overshot.yaw_pos = 6
	self.stances.sten.crouched.vel_overshot.pitch_neg = 5
	self.stances.sten.crouched.vel_overshot.pitch_pos = -5
	self.stances.mp38 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.48655, 26.5318, -3.64956)
	local pivot_shoulder_rotation = Rotation(-0.000111978, 0.000329983, 5.61359e-05)
	local pivot_head_translation = Vector3(8, 23, -4.5)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.mp38.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp38.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp38.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.mp38.standard.vel_overshot.yaw_neg = -6
	self.stances.mp38.standard.vel_overshot.yaw_pos = 6
	self.stances.mp38.standard.vel_overshot.pitch_neg = 5
	self.stances.mp38.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 24, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.mp38.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp38.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp38.steelsight.FOV = self.stances.mp38.standard.FOV
	self.stances.mp38.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.mp38.steelsight.vel_overshot.yaw_neg = -2
	self.stances.mp38.steelsight.vel_overshot.yaw_pos = 4
	self.stances.mp38.steelsight.vel_overshot.pitch_neg = 5
	self.stances.mp38.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(7, 22, -5.5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.mp38.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp38.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp38.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.mp38.crouched.vel_overshot.yaw_neg = -6
	self.stances.mp38.crouched.vel_overshot.yaw_pos = 6
	self.stances.mp38.crouched.vel_overshot.pitch_neg = 5
	self.stances.mp38.crouched.vel_overshot.pitch_pos = -5
end

function PlayerTweakData:_init_shotgun_stances()
	self.stances.geco = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.4127, 15.7764, -5.20036)
	local pivot_shoulder_rotation = Rotation(-0.000176678, 0.000172462, 0.000184415)
	local pivot_head_translation = Vector3(7, 18, -3)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.geco.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.geco.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.geco.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.geco.standard.vel_overshot.yaw_neg = 10
	self.stances.geco.standard.vel_overshot.yaw_pos = -10
	self.stances.geco.standard.vel_overshot.pitch_neg = -10
	self.stances.geco.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 16, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.geco.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.geco.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.geco.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -18, 0)
	self.stances.geco.steelsight.vel_overshot.yaw_neg = 10
	self.stances.geco.steelsight.vel_overshot.yaw_pos = -10
	self.stances.geco.steelsight.vel_overshot.pitch_neg = -10
	self.stances.geco.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(6, 17, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.geco.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.geco.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.geco.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -25, 0)
	self.stances.m1912 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.2001, 15.3999, 2.75509)
	local pivot_shoulder_rotation = Rotation(5.25055e-05, 0.00056349, -0.000322727)
	local pivot_head_translation = Vector3(7, 18, -3)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.m1912.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1912.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1912.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.m1912.standard.vel_overshot.yaw_neg = 10
	self.stances.m1912.standard.vel_overshot.yaw_pos = -10
	self.stances.m1912.standard.vel_overshot.pitch_neg = -10
	self.stances.m1912.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 11, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.m1912.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1912.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1912.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -18, 0)
	self.stances.m1912.steelsight.vel_overshot.yaw_neg = 10
	self.stances.m1912.steelsight.vel_overshot.yaw_pos = -10
	self.stances.m1912.steelsight.vel_overshot.pitch_neg = -10
	self.stances.m1912.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(6, 17, -4)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.m1912.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1912.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1912.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -25, 0)
	self.stances.ithaca = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.2001, 10.9188, 2.99868)
	local pivot_shoulder_rotation = Rotation(0.000153332, 0.000313466, -0.00140905)
	local pivot_head_translation = Vector3(7, 18, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.ithaca.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.ithaca.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.ithaca.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.ithaca.standard.vel_overshot.yaw_neg = 10
	self.stances.ithaca.standard.vel_overshot.yaw_pos = -10
	self.stances.ithaca.standard.vel_overshot.pitch_neg = -10
	self.stances.ithaca.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 15, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.ithaca.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.ithaca.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.ithaca.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -18, 0)
	self.stances.ithaca.steelsight.vel_overshot.yaw_neg = 10
	self.stances.ithaca.steelsight.vel_overshot.yaw_pos = -10
	self.stances.ithaca.steelsight.vel_overshot.pitch_neg = -10
	self.stances.ithaca.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(6, 17, -6)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.ithaca.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.ithaca.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.ithaca.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -25, 0)
	self.stances.browning = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.2002, 5.61833, 3.24215)
	local pivot_shoulder_rotation = Rotation(0.000383849, 0.000530845, -0.000579741)
	local pivot_head_translation = Vector3(7, 18, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.browning.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.browning.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.browning.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.browning.standard.vel_overshot.yaw_neg = 10
	self.stances.browning.standard.vel_overshot.yaw_pos = -10
	self.stances.browning.standard.vel_overshot.pitch_neg = -10
	self.stances.browning.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 15, -1)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.browning.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.browning.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.browning.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -18, 0)
	self.stances.browning.steelsight.vel_overshot.yaw_neg = 10
	self.stances.browning.steelsight.vel_overshot.yaw_pos = -10
	self.stances.browning.steelsight.vel_overshot.pitch_neg = -10
	self.stances.browning.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(6, 17, -6)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.browning.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.browning.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.browning.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -25, 0)
end

function PlayerTweakData:_init_new_stances()
	self.stances.dp28 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(12.6977, 8.57658, -6.68822)
	local pivot_shoulder_rotation = Rotation(-0.0120528, 0.00306297, -0.00256367)
	local pivot_head_translation = Vector3(8, 18, -6)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.dp28.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.dp28.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.dp28.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.dp28.standard.vel_overshot.yaw_neg = -6
	self.stances.dp28.standard.vel_overshot.yaw_pos = 6
	self.stances.dp28.standard.vel_overshot.pitch_neg = 5
	self.stances.dp28.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 18, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.dp28.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.dp28.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.dp28.steelsight.FOV = self.stances.dp28.standard.FOV
	self.stances.dp28.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.dp28.steelsight.vel_overshot.yaw_neg = -6
	self.stances.dp28.steelsight.vel_overshot.yaw_pos = 6
	self.stances.dp28.steelsight.vel_overshot.pitch_neg = 5
	self.stances.dp28.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(8, 16, -8)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.dp28.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.dp28.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.dp28.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.dp28.crouched.vel_overshot.yaw_neg = -6
	self.stances.dp28.crouched.vel_overshot.yaw_pos = 6
	self.stances.dp28.crouched.vel_overshot.pitch_neg = 5
	self.stances.dp28.crouched.vel_overshot.pitch_pos = -5
	self.stances.bren = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.51187, 6.07049, 3.76742)
	local pivot_shoulder_rotation = Rotation(7.29639e-05, 0.000497004, -8.82758e-05)
	local pivot_head_translation = Vector3(6, 18, -6)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.bren.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.bren.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.bren.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.bren.standard.vel_overshot.yaw_neg = -6
	self.stances.bren.standard.vel_overshot.yaw_pos = 6
	self.stances.bren.standard.vel_overshot.pitch_neg = 5
	self.stances.bren.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 14, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.bren.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.bren.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.bren.steelsight.FOV = self.stances.bren.standard.FOV
	self.stances.bren.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.bren.steelsight.vel_overshot.yaw_neg = -6
	self.stances.bren.steelsight.vel_overshot.yaw_pos = 6
	self.stances.bren.steelsight.vel_overshot.pitch_neg = 5
	self.stances.bren.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(5, 16, -8)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.bren.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.bren.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.bren.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.bren.crouched.vel_overshot.yaw_neg = -6
	self.stances.bren.crouched.vel_overshot.yaw_pos = 6
	self.stances.bren.crouched.vel_overshot.pitch_neg = 5
	self.stances.bren.crouched.vel_overshot.pitch_pos = -5
	self.stances.garand = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(10.895, 12.5645, 3.42763)
	local pivot_shoulder_rotation = Rotation(0.000152489, 0.000367234, -0.000803142)
	local pivot_head_translation = Vector3(11, 18, -3.25)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.garand.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.garand.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.garand.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.garand.standard.vel_overshot.yaw_neg = -6
	self.stances.garand.standard.vel_overshot.yaw_pos = 6
	self.stances.garand.standard.vel_overshot.pitch_neg = 5
	self.stances.garand.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 15, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.garand.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.garand.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.garand.steelsight.FOV = self.stances.garand.standard.FOV
	self.stances.garand.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.garand.steelsight.vel_overshot.yaw_neg = -2
	self.stances.garand.steelsight.vel_overshot.yaw_pos = 4
	self.stances.garand.steelsight.vel_overshot.pitch_neg = 5
	self.stances.garand.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(9, 16, -2.5)
	local pivot_head_rotation = Rotation(0, 0, -4)
	self.stances.garand.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.garand.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.garand.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.garand.crouched.vel_overshot.yaw_neg = -6
	self.stances.garand.crouched.vel_overshot.yaw_pos = 6
	self.stances.garand.crouched.vel_overshot.pitch_neg = 5
	self.stances.garand.crouched.vel_overshot.pitch_pos = -5
	self.stances.garand_golden = deep_clone(self.stances.garand)
	self.stances.m1918 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.4138, 7.88427, 2.23107)
	local pivot_shoulder_rotation = Rotation(-4.82672e-05, 0.000440811, -0.000591075)
	local pivot_head_translation = Vector3(9.5, 13, -3)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.m1918.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1918.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1918.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.m1918.standard.vel_overshot.yaw_neg = -6
	self.stances.m1918.standard.vel_overshot.yaw_pos = 6
	self.stances.m1918.standard.vel_overshot.pitch_neg = 5
	self.stances.m1918.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 10, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.m1918.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1918.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1918.steelsight.FOV = self.stances.m1918.standard.FOV
	self.stances.m1918.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.m1918.steelsight.vel_overshot.yaw_neg = -6
	self.stances.m1918.steelsight.vel_overshot.yaw_pos = 6
	self.stances.m1918.steelsight.vel_overshot.pitch_neg = 5
	self.stances.m1918.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(8.5, 12, -2)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.m1918.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1918.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1918.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.m1918.crouched.vel_overshot.yaw_neg = -6
	self.stances.m1918.crouched.vel_overshot.yaw_pos = 6
	self.stances.m1918.crouched.vel_overshot.pitch_neg = 5
	self.stances.m1918.crouched.vel_overshot.pitch_pos = -5
	self.stances.m1903 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.408, 15.8596, 3.03469)
	local pivot_shoulder_rotation = Rotation(0.000389178, 2.90312e-05, 0.000851212)
	local pivot_head_translation = Vector3(10.5, 20, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.m1903.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1903.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1903.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.m1903.standard.vel_overshot.yaw_neg = -6
	self.stances.m1903.standard.vel_overshot.yaw_pos = 6
	self.stances.m1903.standard.vel_overshot.pitch_neg = 5
	self.stances.m1903.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 24, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.m1903.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1903.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1903.steelsight.FOV = self.stances.m1903.standard.FOV
	self.stances.m1903.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -10, 0)
	self.stances.m1903.steelsight.vel_overshot.yaw_neg = -0.4
	self.stances.m1903.steelsight.vel_overshot.yaw_pos = 0.4
	self.stances.m1903.steelsight.vel_overshot.pitch_neg = 0.3
	self.stances.m1903.steelsight.vel_overshot.pitch_pos = -0.3
	self.stances.m1903.steelsight.camera_sensitivity_multiplier = 0.35
	local pivot_head_translation = Vector3(9.5, 17, -3)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.m1903.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.m1903.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.m1903.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.m1903.crouched.vel_overshot.yaw_neg = -6
	self.stances.m1903.crouched.vel_overshot.yaw_pos = 6
	self.stances.m1903.crouched.vel_overshot.pitch_neg = 5
	self.stances.m1903.crouched.vel_overshot.pitch_pos = -5
	self.stances.kar_98k = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.60602, 42.8494, -5.3333)
	local pivot_shoulder_rotation = Rotation(0.000198704, 0.00070511, -0.000360721)
	local pivot_head_translation = Vector3(8, 40, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.kar_98k.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.kar_98k.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.kar_98k.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.kar_98k.standard.vel_overshot.yaw_neg = 6
	self.stances.kar_98k.standard.vel_overshot.yaw_pos = -6
	self.stances.kar_98k.standard.vel_overshot.pitch_neg = -5
	self.stances.kar_98k.standard.vel_overshot.pitch_pos = 5
	local pivot_head_translation = Vector3(0, 46, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.kar_98k.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.kar_98k.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.kar_98k.steelsight.FOV = self.stances.kar_98k.standard.FOV
	self.stances.kar_98k.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -10, 0)
	self.stances.kar_98k.steelsight.vel_overshot.yaw_neg = 0.4
	self.stances.kar_98k.steelsight.vel_overshot.yaw_pos = -0.4
	self.stances.kar_98k.steelsight.vel_overshot.pitch_neg = -0.3
	self.stances.kar_98k.steelsight.vel_overshot.pitch_pos = 0.3
	self.stances.kar_98k.steelsight.camera_sensitivity_multiplier = 0.35
	local pivot_head_translation = Vector3(6, 38, -3)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.kar_98k.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.kar_98k.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.kar_98k.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.kar_98k.crouched.vel_overshot.yaw_neg = 6
	self.stances.kar_98k.crouched.vel_overshot.yaw_pos = -6
	self.stances.kar_98k.crouched.vel_overshot.pitch_neg = -5
	self.stances.kar_98k.crouched.vel_overshot.pitch_pos = 5
	self.stances.lee_enfield = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.60614, 16.0214, -6.65286)
	local pivot_shoulder_rotation = Rotation(6.09262e-05, 0.000580366, -0.000366323)
	local pivot_head_translation = Vector3(6, 16, -3)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.lee_enfield.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.lee_enfield.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.lee_enfield.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.lee_enfield.standard.vel_overshot.yaw_neg = -6
	self.stances.lee_enfield.standard.vel_overshot.yaw_pos = 6
	self.stances.lee_enfield.standard.vel_overshot.pitch_neg = 5
	self.stances.lee_enfield.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 10, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.lee_enfield.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.lee_enfield.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.lee_enfield.steelsight.FOV = self.stances.lee_enfield.standard.FOV
	self.stances.lee_enfield.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -10, 0)
	self.stances.lee_enfield.steelsight.vel_overshot.yaw_neg = -0.4
	self.stances.lee_enfield.steelsight.vel_overshot.yaw_pos = 0.4
	self.stances.lee_enfield.steelsight.vel_overshot.pitch_neg = 0.3
	self.stances.lee_enfield.steelsight.vel_overshot.pitch_pos = -0.3
	self.stances.lee_enfield.steelsight.camera_sensitivity_multiplier = 0.35
	local pivot_head_translation = Vector3(4, 14, -4)
	local pivot_head_rotation = Rotation(0, 0, -5)
	self.stances.lee_enfield.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.lee_enfield.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.lee_enfield.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.lee_enfield.crouched.vel_overshot.yaw_neg = -6
	self.stances.lee_enfield.crouched.vel_overshot.yaw_pos = 6
	self.stances.lee_enfield.crouched.vel_overshot.pitch_neg = 5
	self.stances.lee_enfield.crouched.vel_overshot.pitch_pos = -5
	self.stances.mp44 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(9.24702, 24.6789, 4.17833)
	local pivot_shoulder_rotation = Rotation(7.08942e-05, 0.000256452, -0.000318031)
	local pivot_head_translation = Vector3(9, 35, -4)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.mp44.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp44.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp44.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.mp44.standard.vel_overshot.yaw_neg = -6
	self.stances.mp44.standard.vel_overshot.yaw_pos = 6
	self.stances.mp44.standard.vel_overshot.pitch_neg = 5
	self.stances.mp44.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 24, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.mp44.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp44.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp44.steelsight.FOV = self.stances.mp44.standard.FOV
	self.stances.mp44.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.mp44.steelsight.vel_overshot.yaw_neg = -2
	self.stances.mp44.steelsight.vel_overshot.yaw_pos = 4
	self.stances.mp44.steelsight.vel_overshot.pitch_neg = 5
	self.stances.mp44.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(8, 34, -5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.mp44.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mp44.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mp44.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.mp44.crouched.vel_overshot.yaw_neg = -6
	self.stances.mp44.crouched.vel_overshot.yaw_pos = 6
	self.stances.mp44.crouched.vel_overshot.pitch_neg = 5
	self.stances.mp44.crouched.vel_overshot.pitch_pos = -5
	self.stances.carbine = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(11.6025, 13.9854, -1.89422)
	local pivot_shoulder_rotation = Rotation(0.575351, 0.652872, 1.56912)
	local pivot_head_translation = Vector3(6, 21, -4)
	local pivot_head_rotation = Rotation(0, 0, -1)
	self.stances.carbine.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.carbine.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.carbine.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.carbine.standard.vel_overshot.yaw_neg = -6
	self.stances.carbine.standard.vel_overshot.yaw_pos = 6
	self.stances.carbine.standard.vel_overshot.pitch_neg = 5
	self.stances.carbine.standard.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(0, 8, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.carbine.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.carbine.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.carbine.steelsight.FOV = self.stances.carbine.standard.FOV
	self.stances.carbine.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -7, 0)
	self.stances.carbine.steelsight.vel_overshot.yaw_neg = -2
	self.stances.carbine.steelsight.vel_overshot.yaw_pos = 4
	self.stances.carbine.steelsight.vel_overshot.pitch_neg = 5
	self.stances.carbine.steelsight.vel_overshot.pitch_pos = -5
	local pivot_head_translation = Vector3(5, 20, -5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.carbine.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.carbine.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.carbine.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -20, 0)
	self.stances.carbine.crouched.vel_overshot.yaw_neg = -6
	self.stances.carbine.crouched.vel_overshot.yaw_pos = 6
	self.stances.carbine.crouched.vel_overshot.pitch_neg = 5
	self.stances.carbine.crouched.vel_overshot.pitch_pos = -5
	self.stances.mg42 = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(12.6956, 27.455, -4.0325)
	local pivot_shoulder_rotation = Rotation(9.77319e-06, 0.00058889, -0.000360292)
	local pivot_head_translation = Vector3(8, 32, -4)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.mg42.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mg42.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mg42.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -50, 0)
	self.stances.mg42.standard.vel_overshot.yaw_neg = 10
	self.stances.mg42.standard.vel_overshot.yaw_pos = -10
	self.stances.mg42.standard.vel_overshot.pitch_neg = -10
	self.stances.mg42.standard.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(0, 28, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.mg42.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mg42.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mg42.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -58, 0)
	self.stances.mg42.steelsight.vel_overshot.yaw_neg = 10
	self.stances.mg42.steelsight.vel_overshot.yaw_pos = -10
	self.stances.mg42.steelsight.vel_overshot.pitch_neg = -10
	self.stances.mg42.steelsight.vel_overshot.pitch_pos = 10
	local pivot_head_translation = Vector3(7, 31, -5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.mg42.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mg42.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mg42.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -55, 0)
	self.stances.mg42.bipod = {
		shoulders = {},
		vel_overshot = {}
	}
	local pivot_head_translation = Vector3(0, 0, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.mg42.bipod.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mg42.bipod.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mg42.bipod.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -0, 0)
	self.stances.mg42.bipod.vel_overshot.yaw_neg = 0
	self.stances.mg42.bipod.vel_overshot.yaw_pos = 0
	self.stances.mg42.bipod.vel_overshot.pitch_neg = 0
	self.stances.mg42.bipod.vel_overshot.pitch_pos = 0
	self.stances.mg42.bipod.FOV = 50
	self.stances.mosin = deep_clone(self.stances.default)
	local pivot_shoulder_translation = Vector3(8.60685, 34.9764, -4.03669)
	local pivot_shoulder_rotation = Rotation(-6.75058e-05, 0.000460611, -0.000241724)
	local pivot_head_translation = Vector3(8, 32, -4)
	local pivot_head_rotation = Rotation(0, 0, -1.5)
	self.stances.mosin.standard.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mosin.standard.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mosin.standard.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -50, 0)
	self.stances.mosin.standard.vel_overshot.yaw_neg = 15
	self.stances.mosin.standard.vel_overshot.yaw_pos = -15
	self.stances.mosin.standard.vel_overshot.pitch_neg = -15
	self.stances.mosin.standard.vel_overshot.pitch_pos = 15
	local pivot_head_translation = Vector3(0, 35, 0)
	local pivot_head_rotation = Rotation(0, 0, 0)
	self.stances.mosin.steelsight.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mosin.steelsight.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mosin.steelsight.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -10, 0)
	self.stances.mosin.steelsight.vel_overshot.yaw_neg = 1
	self.stances.mosin.steelsight.vel_overshot.yaw_pos = -1
	self.stances.mosin.steelsight.vel_overshot.pitch_neg = -0.9
	self.stances.mosin.steelsight.vel_overshot.pitch_pos = 0.9
	self.stances.mosin.steelsight.camera_sensitivity_multiplier = 0.45
	local pivot_head_translation = Vector3(7, 31, -5)
	local pivot_head_rotation = Rotation(0, 0, -6)
	self.stances.mosin.crouched.shoulders.translation = pivot_head_translation - pivot_shoulder_translation:rotate_with(pivot_shoulder_rotation:inverse()):rotate_with(pivot_head_rotation)
	self.stances.mosin.crouched.shoulders.rotation = pivot_head_rotation * pivot_shoulder_rotation:inverse()
	self.stances.mosin.crouched.vel_overshot.pivot = pivot_shoulder_translation + Vector3(0, -30, 0)
	self.stances.m24 = deep_clone(self.stances.default)
	self.stances.m3 = deep_clone(self.stances.default)
end
