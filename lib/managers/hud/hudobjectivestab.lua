HUDObjectivesTab = HUDObjectivesTab or class(HUDObjectives)

function HUDObjectivesTab:init(panel)
	HUDObjectivesTab.super.init(self, panel)

	self._show_objective_descriptions = true
end
