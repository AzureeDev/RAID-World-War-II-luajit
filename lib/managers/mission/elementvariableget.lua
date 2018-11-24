core:import("CoreMissionScriptElement")

ElementVariableGet = ElementVariableGet or class(CoreMissionScriptElement.MissionScriptElement)

function ElementVariableGet:init(...)
	ElementVariableGet.super.init(self, ...)
end

function ElementVariableGet:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	ElementVariableGet.super.on_executed(self, instigator)
end

function ElementVariableGet:client_on_executed(...)
	self:on_executed(...)
end
