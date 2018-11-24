local production = rawget(_G, "LUA_PRODUCTION", false)

if production then
	rawset(_G, "SOME_DLC_OR_FEATURE", true)
end
