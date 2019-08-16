FragGrenade = FragGrenade or class(GrenadeBase)
FragGrenade.MAX_CLUSTER_ATTEMPTS = 15

function FragGrenade:_setup_from_tweak_data()
	local grenade_entry = self.name_id
	self._tweak_data = tweak_data.projectiles[grenade_entry]
	self._init_timer = self._tweak_data.init_timer or 2.5
	self._mass_look_up_modifier = self._tweak_data.mass_look_up_modifier
	self._range = self._tweak_data.range

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_GRENADE_RADIUS) then
		self._range = self._range + (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_GRENADE_RADIUS) * 100 or 0)
	end

	self._effect_name = self._tweak_data.effect_name or "effects/vanilla/explosions/exp_hand_grenade_001"
	self._curve_pow = self._tweak_data.curve_pow or 3
	self._killzone_range = self._tweak_data.killzone_range or 0.5
	self._damage = self._tweak_data.damage

	if managers.buff_effect:is_effect_active(BuffEffectManager.EFFECT_GRENADE_DAMAGE) then
		self._damage = self._damage * (managers.buff_effect:get_effect_value(BuffEffectManager.EFFECT_GRENADE_DAMAGE) or 1)
	end

	self._player_damage = self._tweak_data.player_damage
	self._alert_radius = self._tweak_data.alert_radius
	local sound_event = self._tweak_data.sound_event or "grenade_explode"
	self._custom_params = {
		camera_shake_max_mul = 4,
		sound_muffle_effect = true,
		effect = self._effect_name,
		sound_event = sound_event,
		feedback_range = self._range * 2
	}
end

function FragGrenade:set_thrower_unit(unit)
	FragGrenade.super.set_thrower_unit(self, unit)

	self._clusters_to_spawn = 0
	local peer = managers.network:session():peer_by_unit(self._thrower_unit)
	self.cluster_range = self._range
	self.cluster_damage = self._damage

	if peer then
		if peer._id == managers.network:session():local_peer()._id then
			self._clusters_to_spawn = managers.player:upgrade_value("player", "warcry_grenade_clusters", 0)
			self.cluster_range = self.cluster_range * managers.player:upgrade_value("player", "warcry_grenade_cluster_range", self.cluster_range)
			self.cluster_damage = self.cluster_damage * managers.player:upgrade_value("player", "warcry_grenade_cluster_damage", self.cluster_damage)
		else
			self._clusters_to_spawn = managers.warcry:peer_warcry_upgrade_value(peer._id, "player", "warcry_grenade_clusters", 0)
			self.cluster_range = self.cluster_range * managers.warcry:peer_warcry_upgrade_value(peer._id, "player", "warcry_grenade_cluster_range", self.cluster_range)
			self.cluster_damage = self.cluster_damage * managers.warcry:peer_warcry_upgrade_value(peer._id, "player", "warcry_grenade_cluster_damage", self.cluster_damage)
		end
	end

	print("----------Number of Cluster grenades:" .. self._clusters_to_spawn)
end

function FragGrenade:clbk_impact(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	self:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
end

function FragGrenade:_on_collision(col_ray)
	self:_detonate()
end

function FragGrenade:_detonate(tag, unit, body, other_unit, other_body, position, normal, collision_velocity, velocity, other_velocity, new_velocity, direction, damage, ...)
	local pos = self._unit:position()
	local normal = math.UP
	local range = self._range
	local slot_mask = managers.slot:get_mask("explosion_targets")

	managers.explosion:give_local_player_dmg(pos, range, self._player_damage)
	managers.explosion:play_sound_and_effects(pos, normal, range, self._custom_params)

	local hit_units, splinters, results = managers.explosion:detect_and_give_dmg({
		player_damage = 0,
		hit_pos = pos,
		range = range,
		collision_slotmask = slot_mask,
		curve_pow = self._curve_pow,
		damage = self._damage,
		ignore_unit = self._unit,
		alert_radius = self._alert_radius,
		user = self._unit,
		owner = self._unit,
		killzone_range = self._killzone_range
	})
	local thrower_peer_id = self:get_thrower_peer_id()
	local thrower_peer = managers.network:session():peer(thrower_peer_id)

	if thrower_peer_id and results and results.count_cop_kills >= 5 then
		local achievement_id = "ach_kill_enemies_with_single_grenade_5"

		if thrower_peer_id == 1 then
			managers.achievment:award(achievement_id)
		else
			managers.network:session():send_to_peer(thrower_peer, "sync_award_achievement", achievement_id)
		end
	end

	managers.network:session():send_to_peers_synched("sync_unit_event_id_16", self._unit, "base", GrenadeBase.EVENT_IDS.detonate)
	self._unit:set_slot(0)

	if not self._thrower_unit then
		return
	end

	local spawn_attempts = 0

	if self._clusters_to_spawn > 0 then
		local index = tweak_data.blackmarket:get_index_from_projectile_id("cluster")
		local unit_position = self._unit:position()
		unit_position = Vector3(unit_position.x, unit_position.y, unit_position.z + 2)
		local clusters_spawned = 0

		while clusters_spawned < self._clusters_to_spawn do
			local spawn_position = Vector3(unit_position.x + math.random(-30, 30), unit_position.y + math.random(-30, 30), unit_position.z + math.random(20, 50))
			local collision = World:raycast("ray", unit_position, spawn_position, "slot_mask", managers.slot:get_mask("bullet_impact_targets"))

			if not collision then
				local direction = (spawn_position - unit_position):normalized()
				local cluster = ProjectileBase.throw_projectile(index, spawn_position, direction, managers.network:session():local_peer():id(), nil, self.name_id)

				cluster:base():set_range(self.cluster_range)
				cluster:base():set_damage(self.cluster_damage)

				clusters_spawned = clusters_spawned + 1

				Application:debug("FragGrenade -- Spawned cluster @:" .. spawn_position .. ", start pos: " .. pos)
				Application:debug("FragGrenade -- Cluster_range:" .. self.cluster_range .. ", cluster damage: " .. self.cluster_damage)
			else
				Application:debug("[FragGrenade:_detonate] Trying to spawn a cluser, but there is a collision!")
				Application:debug("[FragGrenade:_detonate] Spawn position: \t" .. inspect(spawn_position))
				Application:debug("[FragGrenade:_detonate] Hit position: \t" .. inspect(collision.position))
				Application:debug("[FragGrenade:_detonate] unit position: \t" .. inspect(unit_position))
				Application:debug("[FragGrenade:_detonate] Unit hit: \t\t" .. inspect(collision.unit))

				if FragGrenade.MAX_CLUSTER_ATTEMPTS < spawn_attempts then
					Application:debug("[FragGrenade:_detonate] ----------------------------------------------")
					Application:debug("[FragGrenade:_detonate] Gave up trying to spawn clsuters, reached max munber of attempts")

					return
				end
			end

			spawn_attempts = spawn_attempts + 1
		end
	end
end

function FragGrenade:_detonate_on_client()
	local pos = self._unit:position()
	local range = self._range

	managers.explosion:give_local_player_dmg(pos, range, self._player_damage)
	managers.explosion:explode_on_client(pos, math.UP, nil, self._damage, range, self._curve_pow, self._custom_params)
end

function FragGrenade:bullet_hit()
	if not Network:is_server() then
		return
	end

	print("FragGrenade:bullet_hit()")

	self._timer = nil

	self:_detonate()
end
