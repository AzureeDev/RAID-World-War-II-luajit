WeaponSecondSight = WeaponSecondSight or class(WeaponGadgetBase)
WeaponSecondSight.GADGET_TYPE = "second_sight"

function WeaponSecondSight:init(unit)
	WeaponSecondSight.super.init(self, unit)
end

function WeaponSecondSight:_check_state(...)
	WeaponSecondSight.super._check_state(self, ...)
end

function WeaponSecondSight:toggle_requires_stance_update()
	return true
end

function WeaponSecondSight:destroy(unit)
	WeaponSecondSight.super.destroy(self, unit)
end
