core:import("CoreMissionScriptElement")

ElementVehicleSpawner = ElementVehicleSpawner or class(CoreMissionScriptElement.MissionScriptElement)

function ElementVehicleSpawner:init(...)
	ElementVehicleSpawner.super.init(self, ...)

	self._vehicles = {}

	for k, v in pairs(tweak_data.vehicle) do
		if v.unit then
			self._vehicles[k] = v.unit
		end
	end

	self._vehicle_units = {}
end

function ElementVehicleSpawner:value(name)
	return self._values[name]
end

function ElementVehicleSpawner:client_on_executed(...)
	if not self._values.enabled then
		return
	end
end

function ElementVehicleSpawner:on_executed(instigator)
	if not self._values.enabled then
		return
	end

	local vehicle = safe_spawn_unit(self._vehicles[self._values.vehicle], self._values.position, self._values.rotation)

	table.insert(self._vehicle_units, vehicle)
	print("[ElementVehicleSpawner] Spawned vehicle", vehicle)
	ElementVehicleSpawner.super.on_executed(self, self._unit or instigator)
end

function ElementVehicleSpawner:unspawn_all_units()
	for _, vehicle_unit in ipairs(self._vehicle_units) do
		if alive(vehicle_unit) then
			managers.vehicle:remove_vehicle(vehicle_unit)
		end
	end
end

function ElementVehicleSpawner:stop_simulation(...)
	self:unspawn_all_units()
end
