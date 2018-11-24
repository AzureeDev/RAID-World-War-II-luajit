GroupAIStateRaid = GroupAIStateRaid or class(GroupAIStateBesiege)

function GroupAIStateRaid:init()
	GroupAIStateRaid.super.init(self)

	self._tweak_data = tweak_data.group_ai.raid
end

function GroupAIStateRaid:nav_ready_listener_key()
	return "GroupAIStateRaid"
end
