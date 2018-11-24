RaidGUIControlBranchingBarSkilltreePath = RaidGUIControlBranchingBarSkilltreePath or class(RaidGUIControlBranchingBarPath)
RaidGUIControlBranchingBarSkilltreePath.COLOR_ACTIVE = Color.white:with_alpha(0)
RaidGUIControlBranchingBarSkilltreePath.COLOR_FILL = tweak_data.gui.colors.raid_red:with_alpha(0)
RaidGUIControlBranchingBarSkilltreePath.COLOR_LOCKED = tweak_data.gui.colors.raid_red:with_alpha(0)
RaidGUIControlBranchingBarSkilltreePath.COLOR_DISABLED = Color(0.34509803921568627, 0.34509803921568627, 0.34509803921568627):with_alpha(0)

function RaidGUIControlBranchingBarSkilltreePath:init(parent, params)
	RaidGUIControlBranchingBarSkilltreePath.super.init(self, parent, params)

	local line_width = params.line_width or 3
	local layer = params.layer or self._panel:layer() + 1
	self._line = self._panel:polyline({
		self.COLOR_ACTIVE,
		line_width = line_width,
		layer = layer
	})
	self._active_line = self._panel:polyline({
		line_width = line_width,
		color = self.COLOR_FILL,
		layer = layer + 1
	})
	local points = {}

	table.insert(points, self._starting_point)
	self._active_line:set_points(points)
	table.insert(points, self._ending_point)
	self._line:set_points(points)
	self:_init_state_data()

	if self._state ~= self.STATE_ACTIVE then
		self:init_to_state(self._state)
	end

	self._object = self._line
end

function RaidGUIControlBranchingBarSkilltreePath:_init_state_data()
	self._state_data = {
		STATE_ACTIVE = {}
	}
	self._state_data.STATE_ACTIVE.line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_ACTIVE
	self._state_data.STATE_ACTIVE.active_line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_ACTIVE
	self._state_data.STATE_FULL = {
		line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_FILL,
		line_points = {
			self._starting_point,
			self._ending_point
		},
		active_line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_FILL,
		active_line_points = {
			self._starting_point
		}
	}
	self._state_data.STATE_LOCKED = {
		line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_LOCKED,
		line_points = {
			self._starting_point,
			self._ending_point
		},
		active_line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_LOCKED,
		active_line_points = {
			self._starting_point
		}
	}
	self._state_data.STATE_DISABLED = {
		line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_DISABLED,
		line_points = {
			self._starting_point,
			self._ending_point
		},
		active_line_color = RaidGUIControlBranchingBarSkilltreePath.COLOR_DISABLED,
		active_line_points = {
			self._starting_point
		}
	}
end

function RaidGUIControlBranchingBarSkilltreePath:set_active()
	self._state = self.STATE_ACTIVE

	self:init_to_state(self._state)
end

function RaidGUIControlBranchingBarSkilltreePath:set_locked()
	self._state = self.STATE_LOCKED

	self:init_to_state(self._state)
end

function RaidGUIControlBranchingBarSkilltreePath:set_full()
	self._state = self.STATE_FULL

	self:init_to_state(self._state)
end

function RaidGUIControlBranchingBarSkilltreePath:set_disabled()
	self._state = self.STATE_DISABLED

	self:init_to_state(self._state)
end

function RaidGUIControlBranchingBarSkilltreePath:set_progress(progress)
	RaidGUIControlBranchingBarSkilltreePath.super.set_progress(self, progress)

	local points = {}

	table.insert(points, self._starting_point)

	local second_point = Vector3(math.lerp(self._starting_point.x, self._ending_point.x, progress), math.lerp(self._starting_point.y, self._ending_point.y, progress), 0)

	table.insert(points, second_point)
	self._active_line:set_points(points)
end

function RaidGUIControlBranchingBarSkilltreePath:init_to_state(state)
	local state_data = self._state_data[state]

	self._line:set_color(state_data.line_color)
	self._active_line:set_color(state_data.active_line_color)

	if state_data.line_points then
		self._line:set_points(state_data.line_points)
	end

	if state_data.active_line_points then
		self._active_line:set_points(state_data.active_line_points)
	end
end
