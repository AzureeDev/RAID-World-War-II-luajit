ElementGlobalStateFilter = ElementGlobalStateFilter or class(CoreMissionScriptElement.MissionScriptElement)

function ElementGlobalStateFilter:init(...)
	ElementGlobalStateFilter.super.init(self, ...)
end

function ElementGlobalStateFilter:client_on_executed(...)
	self:on_executed(...)
end

function ElementGlobalStateFilter:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	if self._values.flag and self._values.state then
		local flag_state = managers.global_state:flag(self._values.flag)

		if self._values.state == "value" then
			if managers.global_state:check_flag_value(self._values.check_type, self._values.value, flag_state) then
				ElementGlobalStateFilter.super.on_executed(self, instigator)
			end
		else
			local check_state = self._values.state == "set" and true or self._values.state == "cleared" and false

			if flag_state == check_state then
				ElementGlobalStateFilter.super.on_executed(self, instigator)
			end
		end
	else
		Application:error("[ElementGlobalStateFilter:on_executed] Values for the flag or state not selected, check your mission element.")
	end
end
