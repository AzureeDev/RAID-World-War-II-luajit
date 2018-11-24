core:module("CoreElementUnitSequence")
core:import("CoreMissionScriptElement")
core:import("CoreCode")
core:import("CoreUnit")

ElementUnitSequence = ElementUnitSequence or class(CoreMissionScriptElement.MissionScriptElement)

function ElementUnitSequence:init(...)
	ElementUnitSequence.super.init(self, ...)

	self._unit = CoreUnit.safe_spawn_unit("core/units/run_sequence_dummy/run_sequence_dummy", self._values.position)

	self._mission_script:worlddefinition():add_trigger_sequence(self._unit, self._values.trigger_list)
end

function ElementUnitSequence:on_script_activated()
	self._mission_script:add_save_state_cb(self._id)
end

function ElementUnitSequence:client_on_executed(...)
	self:on_executed(...)
end

function ElementUnitSequence:on_executed(instigator)
	if not self._values.enabled or not alive(self._unit) then
		return
	end

	if not self._unit:damage() then
		_G.debug_pause("[ElementUnitSequence:on_executed] Trying to run sequnce on a unit that has no damage extension. Editor name of the mission element:", self._editor_name)
	end

	self._unit:damage():run_sequence_simple("run_sequence")
	ElementUnitSequence.super.on_executed(self, instigator)
end

function ElementUnitSequence:destroy()
	self._unit:set_slot(0)
end

function ElementUnitSequence:stop_simulation(...)
	self:destroy()
end
