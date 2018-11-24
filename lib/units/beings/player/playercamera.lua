PlayerCamera = PlayerCamera or class()
PlayerCamera.IDS_NOTHING = Idstring("")

function PlayerCamera:init(unit)
	self._unit = unit
	self._m_cam_rot = unit:rotation()
	self._m_cam_pos = unit:position() + math.UP * tweak_data.player.PLAYER_EYE_HEIGHT
	self._m_cam_fwd = self._m_cam_rot:y()
	self._camera_object = World:create_camera()

	self._camera_object:set_near_range(managers.viewport.CAMERA_NEAR_RANGE)
	self._camera_object:set_far_range(managers.viewport.CAMERA_FAR_RANGE)
	self._camera_object:set_fov(75)
	self:spawn_camera_unit()
	self:_setup_sound_listener()

	self._sync_dir = {
		pitch = 0,
		yaw = unit:rotation():yaw()
	}
	self._last_sync_t = 0

	self:setup_viewport(managers.player:viewport_config())
end

function PlayerCamera:setup_viewport(data)
	if self._vp then
		self._vp:destroy()
	end

	local dimensions = data.dimensions
	local name = "player" .. tostring(self._id)
	local vp = managers.viewport:new_vp(dimensions.x, dimensions.y, dimensions.w, dimensions.h, name)
	self._director = vp:director()
	self._shaker = self._director:shaker()

	self._shaker:set_timer(managers.player:player_timer())

	self._camera_controller = self._director:make_camera(self._camera_object, Idstring("fps"))

	self._director:set_camera(self._camera_controller)
	self._director:position_as(self._camera_object)
	self._camera_controller:set_both(self._camera_unit)
	self._camera_controller:set_timer(managers.player:player_timer())

	self._shakers = {
		breathing = self._shaker:play("breathing", 0.3),
		headbob = self._shaker:play("headbob", 0)
	}

	vp:set_camera(self._camera_object)

	self._vp = vp

	if false then
		vp:set_width_mul_enabled()
		vp:camera():set_width_multiplier(CoreMath.width_mul(1.7777777777777777))
		self:_set_dimensions()
	end
end

function PlayerCamera:_set_dimensions()
	self._vp._vp:set_dimensions(0, (1 - RenderSettings.aspect_ratio / 1.7777777777777777) / 2, 1, RenderSettings.aspect_ratio / 1.7777777777777777)
end

function PlayerCamera:spawn_camera_unit()
	local lvl_tweak_data = Global.level_data and Global.level_data.level_id and tweak_data.levels[Global.level_data.level_id]
	self._camera_unit = World:spawn_unit(Idstring("units/vanilla/characters/players/players_default_fps/players_default_fps"), self._m_cam_pos, self._m_cam_rot)
	self._machine = self._camera_unit:anim_state_machine()

	self._unit:link(self._camera_unit)
	self._camera_unit:base():set_parent_unit(self._unit)
	self._camera_unit:base():reset_properties()
	self._camera_unit:base():set_stance_instant("standard")
	managers.controller:add_hotswap_callback("player_camera", callback(self, self, "controller_hotswap_triggered"))
end

function PlayerCamera:controller_hotswap_triggered()
	self._unit:base():_setup_controller()
	self._camera_unit:base():set_parent_unit(self._unit)
end

function PlayerCamera:camera_unit()
	return self._camera_unit
end

function PlayerCamera:anim_state_machine()
	return self._camera_unit:anim_state_machine()
end

function PlayerCamera:play_redirect(redirect_name, speed, offset_time)
	local result = self._camera_unit:base():play_redirect(redirect_name, speed, offset_time)

	return result ~= PlayerCamera.IDS_NOTHING and result
end

function PlayerCamera:play_redirect_timeblend(state, redirect_name, offset_time, t)
	local result = self._camera_unit:base():play_redirect_timeblend(state, redirect_name, offset_time, t)

	return result ~= PlayerCamera.IDS_NOTHING and result
end

function PlayerCamera:play_state(state_name, at_time)
	local result = self._camera_unit:base():play_state(state_name, at_time)

	return result ~= PlayerCamera.IDS_NOTHING and result
end

function PlayerCamera:play_raw(name, params)
	local result = self._camera_unit:base():play_raw(name, params)

	return result ~= PlayerCamera.IDS_NOTHING and result
end

function PlayerCamera:set_speed(state_name, speed)
	self._machine:set_speed(state_name, speed)
end

function PlayerCamera:anim_data()
	return self._camera_unit:anim_data()
end

function PlayerCamera:destroy()
	self._vp:destroy()

	self._unit = nil

	if alive(self._camera_object) then
		World:delete_camera(self._camera_object)
	end

	self._camera_object = nil

	self:remove_sound_listener()
	managers.controller:remove_hotswap_callback("player_camera")
end

function PlayerCamera:remove_sound_listener()
	if not self._listener_id then
		return
	end

	managers.sound_environment:remove_check_object(self._sound_check_object)
	managers.listener:remove_listener(self._listener_id)
	managers.listener:remove_set("player_camera")

	self._listener_id = nil
end

function PlayerCamera:clbk_fp_enter(aim_dir)
	if self._camera_manager_mode ~= "first_person" then
		self._camera_manager_mode = "first_person"
	end
end

function PlayerCamera:_setup_sound_listener()
	self._listener_id = managers.listener:add_listener("player_camera", self._camera_object, self._camera_object, nil, false)

	managers.listener:add_set("player_camera", {
		"player_camera"
	})

	self._listener_activation_id = managers.listener:activate_set("main", "player_camera")
	self._sound_check_object = managers.sound_environment:add_check_object({
		primary = true,
		active = true,
		object = self._unit:orientation_object()
	})
end

function PlayerCamera:set_default_listener_object()
	self:set_listener_object(self._camera_object)
end

function PlayerCamera:set_listener_object(object)
	managers.listener:set_listener(self._listener_id, object, object, nil)
end

function PlayerCamera:position()
	return self._m_cam_pos
end

function PlayerCamera:rotation()
	return self._m_cam_rot
end

function PlayerCamera:forward()
	return self._m_cam_fwd
end

local camera_mvec = Vector3()
local reticle_mvec = Vector3()

function PlayerCamera:position_with_shake()
	self._camera_object:m_position(camera_mvec)

	return camera_mvec
end

function PlayerCamera:forward_with_shake_toward_reticle(reticle_obj)
	reticle_obj:m_position(reticle_mvec)
	self._camera_object:m_position(camera_mvec)
	mvector3.subtract(reticle_mvec, camera_mvec)
	mvector3.normalize(reticle_mvec)

	return reticle_mvec
end

function PlayerCamera:set_position(pos)
	self._camera_controller:set_camera(pos)
	mvector3.set(self._m_cam_pos, pos)
end

local mvec1 = Vector3()

function PlayerCamera:set_rotation(rot)
	mrotation.y(rot, mvec1)
	mvector3.multiply(mvec1, 100000)
	mvector3.add(mvec1, self._m_cam_pos)
	self._camera_controller:set_target(mvec1)
	mrotation.z(rot, mvec1)
	self._camera_controller:set_default_up(mvec1)
	mrotation.set_yaw_pitch_roll(self._m_cam_rot, rot:yaw(), rot:pitch(), rot:roll())
	mrotation.y(self._m_cam_rot, self._m_cam_fwd)

	local t = TimerManager:game():time()
	local sync_dt = t - self._last_sync_t
	local sync_yaw = rot:yaw()
	sync_yaw = sync_yaw % 360

	if sync_yaw < 0 then
		sync_yaw = 360 - sync_yaw
	end

	sync_yaw = math.floor(255 * sync_yaw / 360)
	local sync_pitch = math.clamp(rot:pitch(), -85, 85) + 85
	sync_pitch = math.floor(127 * sync_pitch / 170)
	local angle_delta = math.abs(self._sync_dir.yaw - sync_yaw) + math.abs(self._sync_dir.pitch - sync_pitch)

	if sync_dt > 1 and angle_delta > 0 or angle_delta > 5 then
		self._unit:network():send("set_look_dir", sync_yaw, sync_pitch)

		self._sync_dir.yaw = sync_yaw
		self._sync_dir.pitch = sync_pitch
		self._last_sync_t = t
	end
end

function PlayerCamera:set_FOV(fov_value)
	self._camera_object:set_fov(fov_value)
end

function PlayerCamera:viewport()
	return self._vp
end

function PlayerCamera:set_shaker_parameter(effect, parameter, value)
	if not self._shakers then
		return
	end

	if self._shakers[effect] then
		self._shaker:set_parameter(self._shakers[effect], parameter, value)
	end
end

function PlayerCamera:play_shaker(effect, amplitude, frequency, offset)
	return self._shaker:play(effect, amplitude or 1, frequency or 1, offset or 0)
end

function PlayerCamera:stop_shaker(id)
	self._shaker:stop_immediately(id)
end

function PlayerCamera:shaker()
	return self._shaker
end
