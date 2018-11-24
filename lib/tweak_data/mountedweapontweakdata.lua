MountedWeaponTweakData = MountedWeaponTweakData or class()

function MountedWeaponTweakData:init(tweak_data)
	self:_init_data_sherman()
	self:_init_data_tiger()
	self:_init_data_luchs()
end

function MountedWeaponTweakData:_init_data_sherman()
	self.sherman = {
		sound = {
			main_cannon_fire = "Play_sherman_canon",
			main_cannon_fire_hit = ""
		},
		effect = {
			main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
			main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion"
		},
		turret = {
			gun_locator = "anim_gun",
			range = 20000,
			damage = 20,
			locator = "anim_turret",
			damage_radius = 1000,
			traverse_time = 10,
			player_damage = 10,
			armor_piercing = true
		},
		main_cannon_shell_speed = 60000,
		main_cannon_reload_speed = 5
	}
end

function MountedWeaponTweakData:_init_data_tiger()
	self.tiger = {
		sound = {
			main_cannon_fire = "Play_tiger_canon",
			main_cannon_fire_hit = ""
		},
		effect = {
			main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
			main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion"
		},
		turret = {
			gun_locator = "anim_gun",
			range = 20000,
			damage = 50,
			locator = "anim_turret",
			damage_radius = 1000,
			traverse_time = 10,
			player_damage = 10,
			armor_piercing = true
		},
		main_cannon_shell_speed = 60000,
		main_cannon_reload_speed = 5
	}
end

function MountedWeaponTweakData:_init_data_luchs()
	self.luchs = {
		sound = {
			main_cannon_fire = "Play_luchs_canon",
			main_cannon_fire_hit = ""
		},
		effect = {
			main_cannon_fire = "effects/vanilla/explosions/vehicle_explosion",
			main_cannon_fire_hit = "effects/vanilla/explosions/vehicle_explosion"
		},
		turret = {
			gun_locator = "anim_turret_pitch",
			range = 20000,
			damage = 20,
			locator = "anim_turret_heading",
			damage_radius = 1000,
			traverse_time = 10,
			player_damage = 10,
			armor_piercing = true
		},
		main_cannon_shell_speed = 60000,
		main_cannon_reload_speed = 5
	}
end
