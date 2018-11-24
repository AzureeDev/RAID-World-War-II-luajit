core:import("CoreMissionScriptElement")

ElementVariableSet = ElementVariableSet or class(CoreMissionScriptElement.MissionScriptElement)

function ElementVariableSet:init(...)
	ElementVariableSet.super.init(self, ...)
end

function ElementVariableSet:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementVariableSet.super.on_executed(self, instigator)
end

function ElementVariableSet:client_on_executed(...)
	self:on_executed(...)
end
