PlayerParachuting = PlayerParachuting or class(PlayerStandard)

function PlayerParachuting:init(unit)
	PlayerParachuting.super.init(self, unit)

	self._tweak_data = tweak_data.player.parachute
end

function PlayerParachuting:enter(state_data, enter_data)
	print("[PlayerParachuting:enter]", "Enter parachuting state")
	PlayerParachuting.super.enter(self, state_data, enter_data)

	if self._state_data.ducking then
		self:_end_action_ducking()
	end

	self._original_damping = self._unit:mover():damping()

	self._unit:mover():set_damping(self._tweak_data.gravity / self._tweak_data.terminal_velocity)
	self._unit:sound():play("parachute_open", nil, false)
end

function PlayerParachuting:_enter(enter_data)
	if not self._unit:camera():anim_data().equipped then
		self._unit:camera():play_redirect(self.IDS_EQUIP)
		self._unit:inventory():show_equipped_unit()
	end

	self._unit:movement().fall_rotation = self._unit:movement().fall_rotation or Rotation(0, 0, 0)

	self:_pitch_up()
	self:_set_camera_limits()
end

function PlayerParachuting:exit(state_data, new_state_name)
	print("[PlayerParachuting:exit]", "Exiting parachuting state")
	PlayerParachuting.super.exit(self, state_data)
	self._unit:mover():set_damping(self._original_damping or 1)
	self:_remove_camera_limits()

	self._state_data.in_air = false

	self._unit:sound():play("parachute_landing", nil, false)
end

function PlayerParachuting:interaction_blocked()
	return true
end

function PlayerParachuting:bleed_out_blocked()
	return true
end

function PlayerParachuting:update(t, dt)
	PlayerParachuting.super.update(self, t, dt)
end

function PlayerParachuting:_update_movement(t, dt)
	local direction = self._controller:get_input_axis("move")

	if not self._gnd_ray then
		self._camera_unit:base():update_tilt_smooth(direction.x, self._tweak_data.camera.tilt.max, self._tweak_data.camera.tilt.speed, dt)
	end

	local current_rot = self._unit:movement().fall_rotation
	local new_rot = nil
	local delta = self._tweak_data.movement.rotation_speed * dt

	if direction.x > 0 then
		local yaw = current_rot:yaw() - delta
		new_rot = Rotation(yaw, current_rot:pitch(), current_rot:roll())
		self._unit:movement().fall_rotation = new_rot
	elseif direction.x < 0 then
		local yaw = current_rot:yaw() + delta
		new_rot = Rotation(yaw, current_rot:pitch(), current_rot:roll())
		self._unit:movement().fall_rotation = new_rot
	end

	if direction.y > 0 and self._move_dir then
		local old_pos = self._unit:position()

		self._unit:set_position(old_pos + self._move_dir:normalized() * self._tweak_data.movement.forward_speed * dt)
		self._ext_movement:set_m_pos(self._unit:position())
	end

	local pos = self._unit:position()

	if t - self._last_sent_pos_t > 0.2 then
		self._ext_network:send("sync_fall_position", pos, self._camera_unit:rotation())

		self._last_sent_pos_t = t
	end
end

function PlayerParachuting:_update_check_actions(t, dt)
	local input = self:_get_input(t, dt)
	self._stick_move = self._controller:get_input_axis("move")

	if mvector3.length(self._stick_move) < 0.1 then
		self._move_dir = nil
	else
		self._move_dir = mvector3.copy(self._stick_move)
		local cam_flat_rot = Rotation(self._cam_fwd_flat, math.UP)

		mvector3.rotate_with(self._move_dir, cam_flat_rot)
	end

	local projectile_entry = managers.blackmarket:equipped_projectile()

	if tweak_data.projectiles[projectile_entry].is_a_grenade then
		self:_update_throw_grenade_timers(t, input)
	else
		self:_update_throw_projectile_timers(t, input)
	end

	self:_update_reload_timers(t, dt, input)
	self:_update_melee_timers(t, input)
	self:_update_charging_weapon_timers(t, input)
	self:_update_equip_weapon_timers(t, input)

	if self._change_item_expire_t and self._change_item_expire_t <= t then
		self._change_item_expire_t = nil
	end

	if self._change_weapon_pressed_expire_t and self._change_weapon_pressed_expire_t <= t then
		self._change_weapon_pressed_expire_t = nil
	end

	self:_update_steelsight_timers(t, dt)
	self:_check_stats_screen(t, dt, input)
	self:_update_foley(t, input)

	local new_action = nil
	local anim_data = self._ext_anim
	new_action = new_action or self:_check_action_weapon_gadget(t, input)
	new_action = new_action or self:_check_action_weapon_firemode(t, input)

	if not new_action then
		-- Nothing
	end

	new_action = new_action or self:_check_action_reload(t, input)
	new_action = new_action or self:_check_change_weapon(t, input)
	new_action = new_action or self:_check_action_primary_attack(t, input)
	new_action = new_action or self:_check_action_equip(t, input)

	if not new_action then
		local projectile_entry = managers.blackmarket:equipped_projectile()

		if tweak_data.projectiles[projectile_entry].is_a_grenade then
			new_action = self:_check_action_throw_grenade(t, input)
		else
			new_action = self:_check_action_throw_projectile(t, input)
		end
	end

	self:_check_action_steelsight(t, input)
end

function PlayerParachuting:_get_walk_headbob()
	return 0
end

function PlayerParachuting:_set_camera_limits()
	self._camera_unit:base():set_pitch(self._tweak_data.camera.target_pitch)
	self._camera_unit:base():set_limits(self._tweak_data.camera.limits.spin, self._tweak_data.camera.limits.pitch)
end

function PlayerParachuting:_remove_camera_limits()
	self._camera_unit:base()._p_exit = true

	self._camera_unit:base():remove_limits()
	self._camera_unit:base():set_target_tilt(0)
end

function PlayerParachuting:_check_action_interact(t, input)
	local new_action = nil
	local interaction_wanted = input.btn_interact_press

	if interaction_wanted then
		local action_forbidden = self:chk_action_forbidden("interact")

		if not action_forbidden then
			self:_start_action_state_standard(t)
		end
	end

	return new_action
end

function PlayerParachuting:_update_foley(t, input)
	if self._gnd_ray then
		self._camera_unit:base():set_target_tilt(0)
		self._ext_camera:play_shaker("player_land", 1.5)
		managers.rumble:play("hard_land")
		managers.player:set_player_state("standard")
	end
end

function PlayerParachuting:_pitch_up()
	local t = Application:time()

	self._camera_unit:base():animate_pitch(t, nil, self._tweak_data.camera.target_pitch, 1.7)
end
