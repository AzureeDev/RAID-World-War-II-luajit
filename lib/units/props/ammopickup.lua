AmmoPickup = AmmoPickup or class()

function AmmoPickup:init(unit)
	self._unit = unit
end

function AmmoPickup:set_multiplier(mul)
	self._ammo_mul = mul
end

function AmmoPickup:pickup()
	if self._ammo_mul then
		local player_unit = managers.player:player_unit()

		if player_unit and alive(player_unit) then
			local inventory = player_unit:inventory()

			for id, weapon in pairs(inventory:available_selections()) do
				if weapon.unit:base().add_ammo_ratio and weapon.unit:base():add_ammo_ratio(self._ammo_mul) then
					managers.hud:set_ammo_amount(id, weapon.unit:base():ammo_info())
				end
			end

			return true
		end
	end

	return false
end
