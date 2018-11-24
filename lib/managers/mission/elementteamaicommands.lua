core:import("CoreMissionScriptElement")

ElementTeamAICommands = ElementTeamAICommands or class(CoreMissionScriptElement.MissionScriptElement)

function ElementTeamAICommands:init(...)
	ElementTeamAICommands.super.init(self, ...)
end

function ElementTeamAICommands:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementTeamAICommands.super.on_executed(self, instigator)
end

function ElementTeamAICommands:client_on_executed(...)
	self:on_executed(...)
end
