core:import("CoreWorldDefinition")

WorldDefinition = WorldDefinition or class(CoreWorldDefinition.WorldDefinition)

function WorldDefinition:init(...)
	WorldDefinition.super.init(self, ...)
end

CoreClass.override_class(CoreWorldDefinition.WorldDefinition, WorldDefinition)
