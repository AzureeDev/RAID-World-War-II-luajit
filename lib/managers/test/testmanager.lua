TestManager = TestManager or class()

require("lib/managers/test/TestPhysXCrashRandom")
require("lib/managers/test/TestPhysXCrash")
require("lib/managers/test/TestUtilities")

local tests = {
	PhysX = TestPhysXCrash,
	PhysXRandom = TestPhysXCrashRandom
}
local active_tests = {}
local utils = nil

function TestManager:init()
	self.utils = TestUtilities:new()
end

function TestManager:update(t, dt)
	for test, value in pairs(active_tests) do
		active_tests[test]:update(t, dt)
	end
end

function TestManager:toggleTest(test_name)
	if tests[test_name] then
		if active_tests[test_name] then
			active_tests[test_name].toggleTest()
		else
			active_tests[test_name] = tests[test_name]:new()
		end
	end
end
