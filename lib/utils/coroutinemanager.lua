CoroutineManager = CoroutineManager or class()
CoroutineManager.Size = 16

function CoroutineManager:init()
	self._coroutines = {}
	self._buffer = {}
	local size = CoroutineManager.Size

	for i = 1, size do
		table.insert(self._coroutines, {})
	end
end

function CoroutineManager:update(t, dt)
	self:_add()

	local size = #self._coroutines

	for i = 1, size do
		for key, value in pairs(self._coroutines[i]) do
			if value then
				local result = coroutine.resume(value.co, unpack(value.arg))
				local status = coroutine.status(value.co)

				if status == "dead" then
					print("[CoroutineManager:update] ", value, " has ended ", result)

					self._coroutines[i][key] = nil
				end
			end
		end
	end
end

function CoroutineManager:add_coroutine(name, func, ...)
	local arg = {
		...
	}
	local priority = func.Priority

	if not self._coroutines[priority][name] and not self._buffer[name] then
		self._buffer[name] = {
			name = name,
			func = func,
			arg = arg
		}
	end
end

function CoroutineManager:add_and_run_coroutine(name, func, ...)
	local arg = {
		...
	}
	local co = coroutine.create(func.Function)
	local result = coroutine.resume(co, unpack(arg))
	local status = coroutine.status(co)

	if status ~= "dead" then
		self._coroutines[func.Priority][name] = {
			co = co,
			arg = arg
		}
	end
end

function CoroutineManager:_add()
	for key, value in pairs(self._buffer) do
		local co = coroutine.create(value.func.Function)
		self._coroutines[value.func.Priority][value.name] = {
			co = co,
			arg = value.arg
		}
		self._buffer[key] = nil
	end

	self._buffer = nil
	self._buffer = {}
end

function CoroutineManager:is_running(name)
	if self._buffer[name] then
		return true
	end

	local size = #self._coroutines

	for i = 1, size do
		if self._coroutines[i][name] then
			return true
		end
	end

	return false
end
