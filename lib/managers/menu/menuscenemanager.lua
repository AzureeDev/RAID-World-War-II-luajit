MenuSceneManager = MenuSceneManager or class()

function MenuSceneManager:init()
	self._fullscreen_workspace = managers.gui_data:create_fullscreen_workspace()
end
