core:module("CoreScriptViewport")
core:import("CoreApp")
core:import("CoreMath")
core:import("CoreCode")
core:import("CoreAccessObjectBase")
core:import("CoreEnvironmentFeeder")
core:import("CoreEnvironmentHandler")

_ScriptViewport = _ScriptViewport or class(CoreAccessObjectBase.AccessObjectBase)
DEFAULT_NETWORK_PORT = 31254
DEFAULT_NETWORK_LSPORT = 31255
NETWORK_SLAVE_RECEIVER = Idstring("scriptviewport_slave")
NETWORK_MASTER_RECEIVER = Idstring("scriptviewport_master")

function _ScriptViewport:init(x, y, width, height, vpm, name)
	_ScriptViewport.super.init(self, vpm, name)

	self._vp = Application:create_world_viewport(x, y, width, height)
	self._vpm = vpm
	self._replaced_vp = false
	self._width_mul_enabled = true
	self._render_params = Global.render_debug.render_sky and {
		"World",
		self._vp,
		nil,
		"Underlay",
		self._vp
	} or {
		"World",
		self._vp
	}
	self._env_handler = CoreEnvironmentHandler.EnvironmentHandler:new(vpm:_get_environment_manager(), self == vpm:active_vp())
	self._ref_fov_stack = {}
	self._init_trace = debug.traceback()
end

function _ScriptViewport:enable_slave(port)
	Application:stack_dump_error("Deprecated call")
end

function _ScriptViewport:enable_master(host_name, port, master_listener_port, net_pump)
	Application:stack_dump_error("Deprecated call")
end

function _ScriptViewport:render_params()
	return self._render_params
end

function _ScriptViewport:set_render_params(...)
	self._render_params = {
		...
	}
end

function _ScriptViewport:destroy()
	self:set_active(false)

	local vp = not self._replaced_vp and self._vp

	if CoreCode.alive(vp) then
		Application:destroy_viewport(vp)
	end

	self._vpm:_viewport_destroyed(self)
	self._env_handler:destroy()
end

function _ScriptViewport:set_width_mul_enabled(b)
	self._width_mul_enabled = b
end

function _ScriptViewport:width_mul_enabled()
	return self._width_mul_enabled
end

function _ScriptViewport:set_first_viewport(set_first_viewport)
	self._env_handler:set_first_viewport(set_first_viewport)
end

function _ScriptViewport:get_environment_value(data_path_key)
	return self._env_handler:get_value(data_path_key)
end

function _ScriptViewport:get_environment_path()
	return self._env_handler:get_path()
end

function _ScriptViewport:set_environment(environment_path, blend_duration, blend_bezier_curve, filter_list, unfiltered_environment_path)
	self._env_handler:set_environment(environment_path, blend_duration, blend_bezier_curve, filter_list, unfiltered_environment_path)
end

function _ScriptViewport:set_force_feeder_update()
	self._env_handler:set_force_feeder_update()
end

function _ScriptViewport:on_default_environment_changed(environment_path, blend_duration, blend_bezier_curve)
	self._env_handler:on_default_environment_changed(environment_path, blend_duration, blend_bezier_curve)
end

function _ScriptViewport:create_environment_modifier(data_path_key, is_override, modifier_func)
	return self._env_handler:create_modifier(data_path_key, is_override, modifier_func)
end

function _ScriptViewport:destroy_environment_modifier(data_path_key)
	self._env_handler:destroy_modifier(data_path_key)
end

function _ScriptViewport:update_environment_value(data_path_key)
	return self._env_handler:update_value(data_path_key)
end

function _ScriptViewport:update_environment_area(area_list, position_offset)
	local camera = self._vp:camera()

	if not camera then
		return
	end

	local check_pos = Vector3()

	camera:m_position(check_pos)
	self._env_handler:update_environment_area(check_pos, area_list)
end

function _ScriptViewport:on_environment_area_removed(area)
	self._env_handler:on_environment_area_removed(area)
end

function _ScriptViewport:set_camera(camera)
	self._vp:set_camera(camera)
	self:_set_width_multiplier()
end

function _ScriptViewport:camera()
	return self._vp:camera()
end

function _ScriptViewport:director()
	return self._vp:director()
end

function _ScriptViewport:shaker()
	return self:director():shaker()
end

function _ScriptViewport:vp()
	return self._vp
end

function _ScriptViewport:alive()
	return CoreCode.alive(self._vp)
end

function _ScriptViewport:reference_fov()
	local scene = self._render_params[1]
	local fov = -1
	local sh_pro = self._vp:get_post_processor_effect(scene, Idstring("shadow_processor"), Idstring("shadow_rendering"))

	if sh_pro then
		local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))

		if sh_mod then
			fov = math.deg(sh_mod:reference_fov())
		end
	end

	return fov
end

function _ScriptViewport:push_ref_fov(fov)
	local scene = self._render_params[1]

	if fov < math.rad(self._vp:camera() and self._vp:camera():fov()) then
		return false
	end

	local sh_pro = self._vp:get_post_processor_effect(scene, Idstring("shadow_processor"), Idstring("shadow_rendering"))

	if sh_pro then
		local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))

		if sh_mod then
			table.insert(self._ref_fov_stack, sh_mod:reference_fov())
			sh_mod:set_reference_fov(math.rad(fov))

			return true
		end
	end

	return false
end

function _ScriptViewport:pop_ref_fov()
	local scene = self._render_params[1]
	local sh_pro = self._vp:get_post_processor_effect(scene, Idstring("shadow_processor"), Idstring("shadow_rendering"))

	if sh_pro then
		local sh_mod = sh_pro:modifier(Idstring("shadow_modifier"))

		if sh_mod and #self._ref_fov_stack > 0 then
			local last = self._ref_fov_stack[#self._ref_fov_stack]

			if not self._vp:camera() or math.rad(self._vp:camera():fov()) <= last then
				sh_mod:set_reference_fov(self._ref_fov_stack[#self._ref_fov_stack])
				table.remove(self._ref_fov_stack, #self._ref_fov_stack)

				return true
			end
		end
	end

	return false
end

function _ScriptViewport:set_visualization_mode(effect_name)
	local scene = self._render_params[1]
	local effects = {
		"dof_prepare_post_processor",
		"bloom_combine_post_processor",
		"lens_flare_post_processor",
		"bloom_prepare_post_processor",
		"volumetric_light_scatter",
		"lens_distortion",
		"post_motion_blur",
		"lens_flare_apply_post_processor",
		"color_grading_post",
		"colorblind_correction_post"
	}
	local is_deferred = effect_name == "deferred_lighting"

	for _, effect in ipairs(effects) do
		local effect_interface = self._vp:get_post_processor_effect(scene, Idstring(effect))

		if effect_interface then
			effect_interface:set_visibility(is_deferred)
		end
	end

	self._vp:set_post_processor_effect(scene, Idstring("deferred"), Idstring(effect_name)):set_visibility(true)
end

function _ScriptViewport:is_rendering_scene(scene_name)
	for _, param in ipairs(self:render_params()) do
		if param == scene_name then
			return true
		end
	end

	return false
end

function _ScriptViewport:set_dof(clamp, near_focus_distance_min, near_focus_distance_max, far_focus_distance_min, far_focus_distance_max)
end

function _ScriptViewport:replace_engine_vp(vp)
	self:destroy()

	self._replaced_vp = true
	self._vp = vp
end

function _ScriptViewport:set_environment_editor_callback(env_editor_callback)
	self._env_editor_callback = env_editor_callback
end

function _ScriptViewport:_update(is_first_viewport, t, dt)
	local scene = self._render_params[1]

	self._vp:update()

	if self._env_editor_callback then
		self._env_editor_callback(self._env_handler, self._vp, scene)
	else
		self._env_handler:update(is_first_viewport, self._vp, dt)
	end

	self._env_handler:apply(is_first_viewport, self._vp, scene)
end

function _ScriptViewport:_render(nr)
	if Global.render_debug.render_world then
		Application:render(unpack(self._render_params))
	end
end

function _ScriptViewport:_resolution_changed()
	self:_set_width_multiplier()
end

function _ScriptViewport:_set_width_multiplier()
	local camera = self:camera()

	if CoreCode.alive(camera) and self._width_mul_enabled then
		local screen_res = Application:screen_resolution()
		local screen_pixel_aspect = screen_res.x / screen_res.y
		local rect = self._vp:get_rect()
		local vp_pixel_aspect = screen_pixel_aspect

		if rect.ph > 0 then
			vp_pixel_aspect = rect.pw / rect.ph
		end

		camera:set_width_multiplier(CoreMath.width_mul(self._vpm:aspect_ratio()) * vp_pixel_aspect / screen_pixel_aspect)
	end
end

function _ScriptViewport:set_active(state)
	_ScriptViewport.super.set_active(self, state)

	if alive(self._vp) then
		self._vp:set_LOD_active(state)
	end
end
