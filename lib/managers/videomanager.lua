VideoManager = VideoManager or class()

function VideoManager:init()
	self._videos = {}
	self._updators = {}
end

function VideoManager:add_video(video)
	local volume = managers.user:get_setting("master_volume")

	video:set_volume_gain(volume / 100)
	table.insert(self._videos, video)
end

function VideoManager:remove_video(video)
	table.delete(self._videos, video)
end

function VideoManager:volume_changed(volume)
	for _, video in ipairs(self._videos) do
		video:set_volume_gain(volume)
	end
end

function VideoManager:add_updator(id, callback)
	self._updators[id] = callback
end

function VideoManager:remove_updator(id)
	self._updators[id] = nil
end

function VideoManager:update(t, dt)
	for _, cb in pairs(self._updators) do
		cb(t, dt)
	end
end
