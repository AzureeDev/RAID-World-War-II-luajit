CarryData = CarryData or class()
CarryData.EVENT_IDS = {
	explode = 2,
	will_explode = 1
}

function CarryData:init(unit)
	self._unit = unit
	self._dye_initiated = false
	self._has_dye_pack = false
	self._dye_value_multiplier = 100
	self._value = 0

	if self._disable_update then
		Application:debug("CarryData:init disabled!")
		self._unit:set_extension_update_enabled(Idstring("carry_data"), false)
	end
end

function CarryData:set_mission_element(mission_element)
	self._mission_element = mission_element
end

function CarryData:trigger_load(instigator)
	if not self._mission_element then
		return
	end

	self._mission_element:trigger("load", instigator)
end

function CarryData:update(unit, t, dt)
	if not Network:is_server() then
		return
	end

	if self._explode_t and self._explode_t < t then
		self._explode_t = nil

		self:_explode()
	end
end

function CarryData:_check_dye_explode()
	return

	local chance = math.rand(1)

	if chance < 0.25 then
		self._dye_risk = nil

		self:_dye_exploded()

		return
	end

	self._dye_risk.next_t = Application:time() + 2 + math.random(3)
end

function CarryData:sync_dye_exploded()
	self:_dye_exploded()
end

function CarryData:_dye_exploded()
	return

	print("CarryData DYE BOOM")

	self._value = self._value * (1 - self._dye_value_multiplier / 100)
	self._value = math.round(self._value)
	self._has_dye_pack = false
end

function CarryData:check_explodes_on_impact(velocity, air_time)
	if not Network:is_server() then
		return
	end

	if self._explode_t then
		return
	end

	if self:can_explode() then
		if air_time < 0.5 then
			return
		end

		local vel = mvector3.length(velocity)
		local vel_limit = 500

		if vel < vel_limit then
			return
		end

		local chance = math.lerp(0, 0.9, math.min((vel - vel_limit) / (1200 - vel_limit), 1))

		if math.rand(1) <= chance then
			self:start_explosion()

			return true
		end
	end
end

function CarryData:explode_sequence_started()
	return self._explode_t and true or false
end

function CarryData:can_explode()
	if self._disarmed then
		return false
	end

	local tweak_info = tweak_data.carry[self._carry_id]

	return tweak_data.carry.types[tweak_info.type].can_explode
end

function CarryData:start_explosion()
	if self._explode_t then
		return
	end

	if not self:can_explode() then
		return
	end

	self:_unregister_steal_SO()
	self:_start_explosion()
	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "carry_data", CarryData.EVENT_IDS.will_explode)

	self._explode_t = Application:time() + 1 + math.rand(3)
end

function CarryData:_start_explosion()
	self._unit:interaction():set_active(false)
end

function CarryData:disarm()
	self._explode_t = nil
	self._disarmed = true
end

function CarryData:bullet_hit()
	if self:can_explode() then
		self:_explode()
	end
end

CarryData.EXPLOSION_SETTINGS = {
	damage = 40,
	range = 1000,
	curve_pow = 3,
	player_damage = 20,
	effect = "effects/vanilla/explosions/exp_bag_explosion_001"
}
CarryData.EXPLOSION_CUSTOM_PARAMS = {
	camera_shake_mul = 4,
	effect = CarryData.EXPLOSION_SETTINGS.effect
}
local mvec1 = Vector3()

function CarryData:_explode()
	managers.mission:call_global_event("loot_exploded")

	local pos = self._unit:position()
	local normal = math.UP
	local range = CarryData.EXPLOSION_SETTINGS.range
	local effect = CarryData.EXPLOSION_SETTINGS.effect
	local slot_mask = managers.slot:get_mask("explosion_targets")

	self:_local_player_explosion_damage()
	managers.explosion:play_sound_and_effects(pos, normal, range, CarryData.EXPLOSION_CUSTOM_PARAMS)

	local hit_units, splinters = managers.explosion:detect_and_give_dmg({
		player_damage = 0,
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = CarryData.EXPLOSION_SETTINGS.curve_pow,
		damage = CarryData.EXPLOSION_SETTINGS.damage,
		ignore_unit = self._unit
	})

	for _, unit in pairs(hit_units) do
		if unit ~= self._unit and unit:carry_data() then
			mvector3.set(mvec1, unit:position())

			local distance = mvector3.distance(pos, mvec1)
			local chance = math.lerp(1, 0, math.max(distance - range / 2, 0) / range)

			if math.rand(1) < chance then
				for i_splinter, s_pos in ipairs(splinters) do
					local ray_hit = not World:raycast("ray", s_pos, mvec1, "slot_mask", slot_mask, "ignore_unit", {
						self._unit,
						unit
					}, "report")

					if ray_hit then
						unit:carry_data():start_explosion(0)

						break
					end
				end
			end
		end
	end

	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "carry_data", CarryData.EVENT_IDS.explode)
	self._unit:set_slot(0)
end

function CarryData:_local_player_explosion_damage()
	local pos = self._unit:position()
	local range = CarryData.EXPLOSION_SETTINGS.range

	managers.explosion:give_local_player_dmg(pos, range, CarryData.EXPLOSION_SETTINGS.player_damage)
end

function CarryData:sync_net_event(event_id)
	if event_id == CarryData.EVENT_IDS.explode then
		local range = CarryData.EXPLOSION_SETTINGS.range

		self:_local_player_explosion_damage()
		managers.explosion:explode_on_client(self._unit:position(), math.UP, nil, CarryData.EXPLOSION_SETTINGS.damage, range, CarryData.EXPLOSION_SETTINGS.curve_pow, CarryData.EXPLOSION_CUSTOM_PARAMS)
	elseif event_id == CarryData.EVENT_IDS.will_explode then
		self:_start_explosion()
	end
end

function CarryData:clbk_out_of_world()
	if self._bodies_to_revert then
		for i_body, body in ipairs(self._bodies_to_revert) do
			body:set_dynamic()
		end

		self._bodies_to_revert = nil
		self._register_out_of_world_dynamic_clbk_id = nil

		return
	elseif self._unit:position().z < PlayerMovement.OUT_OF_WORLD_Z then
		self._bodies_to_revert = {}
		local bodies = self._unit:num_bodies()

		for i_body = 0, bodies - 1, 1 do
			local body = self._unit:body(i_body)

			if body:enabled() and body:dynamic() then
				table.insert(self._bodies_to_revert, body)
				body:set_keyframed()
			end
		end

		local tracker = managers.navigation:create_nav_tracker(self._unit:position(), false)

		self._unit:set_position(tracker:field_position())
		managers.navigation:destroy_nav_tracker(tracker)

		self._register_out_of_world_dynamic_clbk_id = "BagOutOfWorldDynamic" .. tostring(self._unit:key())

		managers.enemy:add_delayed_clbk(self._register_out_of_world_dynamic_clbk_id, callback(self, self, "clbk_out_of_world"), TimerManager:game():time() + 0.2)

		self._register_out_of_world_clbk_id = nil

		return
	end

	managers.enemy:add_delayed_clbk(self._register_out_of_world_clbk_id, callback(self, self, "clbk_out_of_world"), TimerManager:game():time() + 2)
end

function CarryData:carry_id()
	return self._carry_id
end

function CarryData:set_carry_id(carry_id)
	self._carry_id = carry_id
	self._register_steal_SO_clbk_id = "CarryDataregiserSO" .. tostring(self._unit:key())

	managers.enemy:add_delayed_clbk(self._register_steal_SO_clbk_id, callback(self, self, "clbk_register_steal_SO"), 0)
end

function CarryData:clbk_register_steal_SO(carry_id)
	self._register_steal_SO_clbk_id = nil

	self:_chk_register_steal_SO()
end

function CarryData:set_dye_initiated(initiated)
	self._dye_initiated = initiated
end

function CarryData:dye_initiated()
	return self._dye_initiated
end

function CarryData:has_dye_pack()
	return self._has_dye_pack
end

function CarryData:dye_value_multiplier()
	return self._dye_value_multiplier
end

function CarryData:set_dye_pack_data(dye_initiated, has_dye_pack, dye_value_multiplier)
	self._dye_initiated = dye_initiated
	self._has_dye_pack = has_dye_pack
	self._dye_value_multiplier = dye_value_multiplier

	if not Network:is_server() then
		return
	end

	if self._has_dye_pack then
		self._dye_risk = {
			next_t = Application:time() + 2 + math.random(3)
		}
	end
end

function CarryData:dye_pack_data()
	return self._dye_initiated, self._has_dye_pack, self._dye_value_multiplier
end

function CarryData:_disable_dye_pack()
	self._dye_risk = false
end

function CarryData:value()
	return self._value
end

function CarryData:set_value(value)
	self._value = value
end

function CarryData:multiplier()
	return self._multiplier
end

function CarryData:set_multiplier(multiplier)
	self._multiplier = multiplier
end

function CarryData:sequence_clbk_secured()
	self:_disable_dye_pack()
end

function CarryData:_unregister_steal_SO()
	if not self._steal_SO_data then
		return
	end

	if self._steal_SO_data.SO_registered then
		managers.groupai:state():remove_special_objective(self._steal_SO_data.SO_id)
		managers.groupai:state():unregister_loot(self._unit:key())
	elseif self._steal_SO_data.thief then
		local thief = self._steal_SO_data.thief
		self._steal_SO_data.thief = nil

		if self._steal_SO_data.picked_up then
			self:unlink()
		end

		if alive(thief) then
			thief:brain():set_objective(nil)
		end
	end

	self._steal_SO_data = nil
end

function CarryData:_chk_register_steal_SO()
	local body = self._unit:body("hinge_body_1") or self._unit:body(0)

	if not self._has_body_activation_clbk then
		self._has_body_activation_clbk = {
			[body:key()] = true
		}

		self._unit:add_body_activation_callback(callback(self, self, "clbk_body_active_state"))
		body:set_activate_tag(Idstring("bag_moving"))
		body:set_deactivate_tag(Idstring("bag_still"))
	end

	if not Network:is_server() or not managers.navigation:is_data_ready() then
		return
	end

	local tweak_info = tweak_data.carry[self._carry_id]
	local AI_carry = tweak_info.AI_carry

	if not AI_carry then
		return
	end

	if self._steal_SO_data then
		return
	end

	local is_body_active = body:active()

	if is_body_active then
		return
	end

	local SO_category = AI_carry.SO_category
	local SO_filter = managers.navigation:convert_SO_AI_group_to_access(SO_category)
	local tracker_pickup = managers.navigation:create_nav_tracker(self._unit:position(), false)
	local pickup_nav_seg = tracker_pickup:nav_segment()
	local pickup_pos = tracker_pickup:field_position()
	local pickup_area = managers.groupai:state():get_area_from_nav_seg_id(pickup_nav_seg)

	managers.navigation:destroy_nav_tracker(tracker_pickup)

	if pickup_area.enemy_loot_drop_points then
		return
	end

	local drop_pos, drop_nav_seg, drop_area = nil
	local drop_point = managers.groupai:state():get_safe_enemy_loot_drop_point(pickup_nav_seg)

	if drop_point then
		drop_pos = mvector3.copy(drop_point.pos)
		drop_nav_seg = drop_point.nav_seg
		drop_area = drop_point.area
	elseif not self._register_steal_SO_clbk_id then
		self._register_steal_SO_clbk_id = "CarryDataregiserSO" .. tostring(self._unit:key())

		managers.enemy:add_delayed_clbk(self._register_steal_SO_clbk_id, callback(self, self, "clbk_register_steal_SO"), TimerManager:game():time() + 10)

		return
	end

	local drop_objective = {
		type = "act",
		interrupt_health = 0.9,
		action_duration = 2,
		haste = "walk",
		pose = "crouch",
		interrupt_dis = 700,
		nav_seg = drop_nav_seg,
		pos = drop_pos,
		area = drop_area,
		fail_clbk = callback(self, self, "on_secure_SO_failed"),
		complete_clbk = callback(self, self, "on_secure_SO_completed"),
		action = {
			variant = "untie",
			align_sync = true,
			body_part = 1,
			type = "act"
		}
	}
	local pickup_objective = {
		destroy_clbk_key = false,
		type = "act",
		haste = "run",
		interrupt_health = 0.9,
		pose = "crouch",
		interrupt_dis = 700,
		nav_seg = pickup_nav_seg,
		area = pickup_area,
		pos = pickup_pos,
		fail_clbk = callback(self, self, "on_pickup_SO_failed"),
		complete_clbk = callback(self, self, "on_pickup_SO_completed"),
		action = {
			variant = "untie",
			align_sync = true,
			body_part = 1,
			type = "act"
		},
		action_duration = math.lerp(1, 2.5, math.random()),
		followup_objective = drop_objective
	}
	local so_descriptor = {
		interval = 0,
		base_chance = 1,
		chance_inc = 0,
		usage_amount = 1,
		objective = pickup_objective,
		search_pos = pickup_objective.pos,
		verification_clbk = callback(self, self, "clbk_pickup_SO_verification"),
		AI_group = AI_carry.SO_category,
		admin_clbk = callback(self, self, "on_pickup_SO_administered")
	}
	local so_id = "carrysteal" .. tostring(self._unit:key())
	self._steal_SO_data = {
		SO_registered = true,
		picked_up = false,
		SO_id = so_id,
		pickup_area = pickup_area,
		pickup_objective = pickup_objective
	}

	managers.groupai:state():add_special_objective(so_id, so_descriptor)
	managers.groupai:state():register_loot(self._unit, pickup_area)
end

function CarryData:clbk_pickup_SO_verification(candidate_unit)
	if not self._steal_SO_data or not self._steal_SO_data.SO_id then
		debug_pause_unit(self._unit, "[CarryData:clbk_pickup_SO_verification] SO is not registered", self._unit, candidate_unit, inspect(self._steal_SO_data))

		return
	end

	if candidate_unit:movement():cool() then
		return
	end

	local nav_seg = candidate_unit:movement():nav_tracker():nav_segment()

	if not self._steal_SO_data.pickup_area.nav_segs[nav_seg] then
		return
	end

	if not candidate_unit:base():char_tweak().steal_loot then
		return
	end

	return true
end

function CarryData:on_pickup_SO_administered(thief)
	if self._steal_SO_data.thief then
		debug_pause("[CarryData:on_pickup_SO_administered] Already had a thief!!!!", thief, self._steal_SO_data.thief)
	end

	self._steal_SO_data.thief = thief
	self._steal_SO_data.SO_registered = false

	managers.groupai:state():unregister_loot(self._unit:key())
end

function CarryData:on_pickup_SO_completed(thief)
	if thief ~= self._steal_SO_data.thief then
		debug_pause_unit(thief, "[CarryData:on_pickup_SO_completed] idiot thinks he is stealing", thief)

		return
	end

	self._steal_SO_data.picked_up = true

	self:link_to(thief)
end

function CarryData:on_pickup_SO_failed(thief)
	if not self._steal_SO_data.thief then
		return
	end

	if thief ~= self._steal_SO_data.thief then
		debug_pause_unit(thief, "[CarryData:on_pickup_SO_failed] idiot thinks he is stealing", thief)

		return
	end

	self._steal_SO_data = nil

	self:_chk_register_steal_SO()
end

function CarryData:on_secure_SO_completed(thief)
	if thief ~= self._steal_SO_data.thief then
		debug_pause_unit(sympathy_civ, "[CarryData:on_secure_SO_completed] idiot thinks he is stealing", thief)

		return
	end

	self._steal_SO_data = nil

	managers.mission:call_global_event("loot_lost")

	self._steal_SO_data = nil

	self:unlink()
end

function CarryData:on_secure_SO_failed(thief)
	if not self._steal_SO_data.thief then
		return
	end

	if thief ~= self._steal_SO_data.thief then
		debug_pause_unit(thief, "[CarryData:on_pickup_SO_failed] idiot thinks he is stealing", thief)

		return
	end

	self._steal_SO_data = nil

	self:_chk_register_steal_SO()
	self:unlink()
end

function CarryData:link_to(parent_unit)
	local body = self._unit:body("hinge_body_1") or self._unit:body(0)

	body:set_keyframed()

	local parent_obj_name = Idstring("Neck")

	parent_unit:link(parent_obj_name, self._unit)

	local parent_obj = parent_unit:get_object(parent_obj_name)
	local parent_obj_rot = parent_obj:rotation()
	local world_pos = parent_obj:position() - parent_obj_rot:z() * 30 - parent_obj_rot:y() * 10

	self._unit:set_position(world_pos)

	local world_rot = Rotation(parent_obj_rot:x(), -parent_obj_rot:z())

	self._unit:set_rotation(world_rot)

	self._disabled_collisions = {}
	local nr_bodies = self._unit:num_bodies()

	for i_body = 0, nr_bodies - 1, 1 do
		local body = self._unit:body(i_body)

		if body:collisions_enabled() then
			table.insert(self._disabled_collisions, body)
			body:set_collisions_enabled(false)
		end
	end

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("loot_link", self._unit, parent_unit)
	end
end

function CarryData:unlink()
	self._unit:unlink()

	local body = self._unit:body("hinge_body_1") or self._unit:body(0)

	body:set_dynamic()

	if self._disabled_collisions then
		for _, body in ipairs(self._disabled_collisions) do
			body:set_collisions_enabled(true)
		end

		self._disabled_collisions = nil
	end

	if Network:is_server() then
		managers.network:session():send_to_peers_synched("loot_link", self._unit, self._unit)
	end
end

function CarryData:clbk_body_active_state(tag, unit, body, activated)
	if not self._has_body_activation_clbk[body:key()] then
		return
	end

	if activated then
		if not self._steal_SO_data or not self._steal_SO_data.picked_up then
			self:_unregister_steal_SO()
		end

		if not self._register_out_of_world_clbk_id then
			self._register_out_of_world_clbk_id = "BagOutOfWorld" .. tostring(self._unit:key())

			managers.enemy:add_delayed_clbk(self._register_out_of_world_clbk_id, callback(self, self, "clbk_out_of_world"), TimerManager:game():time() + 2)
		end
	else
		self:_chk_register_steal_SO()

		if self._register_out_of_world_clbk_id then
			managers.enemy:remove_delayed_clbk(self._register_out_of_world_clbk_id)

			self._register_out_of_world_clbk_id = nil
		end
	end
end

function CarryData:clbk_send_link()
	if alive(self._unit) and self._steal_SO_data and self._steal_SO_data.thief and self._steal_SO_data.picked_up then
		managers.network:session():send_to_peers_synched("loot_link", self._unit, self._steal_SO_data.thief)
	end
end

function CarryData:set_zipline_unit(zipline_unit)
	self._zipline_unit = zipline_unit

	if not Network:is_server() then
		return
	end

	if self._zipline_unit and self._zipline_unit:zipline():ai_ignores_bag() then
		if self._unit:attention() then
			self._saved_attention_data = deep_clone(self._unit:attention():attention_data())

			for attention_id, _ in pairs(self._saved_attention_data) do
				self._unit:attention():remove_attention(attention_id)
			end
		end
	elseif not self._zipline_unit and self._saved_attention_data then
		for attention_id, attention_data in pairs(self._saved_attention_data) do
			self._unit:attention():add_attention(attention_data)
		end

		self._saved_attention_data = nil
	end
end

function CarryData:is_attached_to_zipline_unit()
	return self._zipline_unit and true
end

function CarryData:_on_load_attach_to_zipline(zipline_unit)
	if alive(zipline_unit) then
		zipline_unit:zipline():attach_bag(self._unit)
	end
end

function CarryData:on_thrown()
end

function CarryData:on_pickup()
end

function CarryData:save(data)
	local state = {
		carry_id = self._carry_id,
		value = self._value,
		dye_initiated = self._dye_initiated,
		has_dye_pack = self._has_dye_pack,
		dye_value_multiplier = self._dye_value_multiplier
	}

	if self._steal_SO_data and self._steal_SO_data.picked_up then
		managers.enemy:add_delayed_clbk("send_loot_link" .. tostring(self._unit:key()), callback(self, self, "clbk_send_link"), TimerManager:game():time() + 0.1)
	end

	data.zip_line_unit_id = self._zipline_unit and self._zipline_unit:editor_id()
	data.CarryData = state
end

function CarryData:load(data)
	local state = data.CarryData
	self._carry_id = state.carry_id
	self._value = state.value
	self._dye_initiated = state.dye_initiated
	self._has_dye_pack = state.has_dye_pack
	self._dye_value_multiplier = state.dye_value_multiplier

	if data.zip_line_unit_id then
		local worlddefinition = managers.worldcollection and managers.worldcollection:get_worlddefinition_by_unit_id(data.zip_line_unit_id) or managers.worlddefinition
		local original_unit_id = worlddefinition:get_original_unit_id(data.zip_line_unit_id)

		self:_on_load_attach_to_zipline(worlddefinition:get_unit_on_load(original_unit_id, callback(self, self, "_on_load_attach_to_zipline")))
	end
end

function CarryData:destroy()
	if self._register_steal_SO_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_steal_SO_clbk_id)

		self._register_steal_SO_clbk_id = nil
	end

	if self._register_out_of_world_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_clbk_id)

		self._register_out_of_world_clbk_id = nil
	end

	if self._register_out_of_world_dynamic_clbk_id then
		managers.enemy:remove_delayed_clbk(self._register_out_of_world_dynamic_clbk_id)

		self._register_out_of_world_dynamic_clbk_id = nil
	end

	self:_unregister_steal_SO()
end

function CarryData:set_latest_peer_id(peer_id)
	self._latest_peer_id = peer_id
end

function CarryData:latest_peer_id()
	return self._latest_peer_id
end
