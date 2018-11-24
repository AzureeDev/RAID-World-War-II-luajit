core:import("CoreMissionScriptElement")

ElementCarry = ElementCarry or class(CoreMissionScriptElement.MissionScriptElement)

function ElementCarry:init(...)
	ElementCarry.super.init(self, ...)
end

function ElementCarry:on_executed(instigator)
	if not self._values.enabled or not alive(instigator) then
		return
	end

	if self._values.type_filter and self._values.type_filter ~= "none" then
		local carry_ext = instigator:carry_data()

		if not carry_ext then
			debug_pause_unit(instigator, "[ElementCarry:on_executed] instigator missing carry_data extension", instigator)

			return
		end

		local carry_id = carry_ext:carry_id()

		if carry_id ~= self._values.type_filter then
			return
		end
	end

	if self._values.operation == "remove" then
		if Network:is_server() then
			instigator:set_slot(0)
		end
	elseif self._values.operation == "add_to_respawn" then
		if Network:is_server() then
			local carry_ext = instigator:carry_data()
			local carry_id = carry_ext:carry_id()
			local multiplier = carry_ext:multiplier()

			managers.loot:add_to_respawn(carry_id, multiplier)
			instigator:set_slot(0)
		end
	elseif self._values.operation == "freeze" then
		if instigator:damage():has_sequence("freeze") then
			instigator:damage():run_sequence_simple("freeze")
		else
			debug_pause("[ElementCarry:on_executed] instigator missing freeze sequence", instigator)
		end
	elseif self._values.operation == "secure" or self._values.operation == "secure_silent" then
		if instigator:carry_data() then
			local carry_ext = instigator:carry_data()

			carry_ext:disarm()

			if Network:is_server() then
				local silent = self._values.operation == "secure_silent"
				local carry_id = carry_ext:carry_id()
				local multiplier = carry_ext:multiplier()

				managers.loot:secure(carry_id, multiplier, silent)
			end

			carry_ext:set_value(0)

			if instigator:damage():has_sequence("secured") then
				instigator:damage():run_sequence_simple("secured")
			else
				debug_pause("[ElementCarry:on_executed] instigator missing secured sequence", instigator)
			end
		else
			debug_pause("[ElementCarry:on_executed] instigator missing carry_data extension", instigator)
		end
	end

	ElementCarry.super.on_executed(self, instigator)
end

function ElementCarry:client_on_executed(...)
	self:on_executed(...)
end
