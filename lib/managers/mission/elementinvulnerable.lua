core:import("CoreMissionScriptElement")

ElementInvulnerable = ElementInvulnerable or class(CoreMissionScriptElement.MissionScriptElement)

function ElementInvulnerable:init(...)
	ElementInvulnerable.super.init(self, ...)
end

function ElementInvulnerable:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	for _, id in ipairs(self._values.elements) do
		local element = self:get_mission_element(id)

		for _, unit in ipairs(element:units()) do
			if alive(unit) and unit:character_damage() then
				unit:character_damage():set_invulnerable(self._values.invulnerable)
				unit:character_damage():set_immortal(self._values.immortal)
			end
		end
	end

	ElementInvulnerable.super.on_executed(self, instigator)
end
