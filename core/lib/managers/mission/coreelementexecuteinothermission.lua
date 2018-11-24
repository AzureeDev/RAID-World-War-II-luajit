core:module("CoreElementExecuteInOtherMission")
core:import("CoreMissionScriptElement")

ElementExecuteInOtherMission = ElementExecuteInOtherMission or class(CoreMissionScriptElement.MissionScriptElement)

function ElementExecuteInOtherMission:init(...)
	ElementExecuteInOtherMission.super.init(self, ...)
end

function ElementExecuteInOtherMission:client_on_executed(...)
	self:on_executed(...)
end

function ElementExecuteInOtherMission:get_mission_element(id)
	local mission = self._sync_id ~= 0 and managers.worldcollection:mission_by_id(self._sync_id) or managers.mission

	for name, script in pairs(mission:scripts()) do
		if script:element(id) then
			return script:element(id)
		end
	end
end
