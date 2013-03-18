---
-- Overrides for mainline Lua WML actions.
---

local engine_muf = wesnoth.wml_actions.move_unit_fake

-- The lock_view option first appeared on 1.11.0.
-- Previous versions do not need this workaround.
if wesnoth.compare_versions(wesnoth.game_config.version, ">=", "1.11.0") then
	function wesnoth.wml_actions.move_unit_fake(cfg)
		--
		-- Due to an oversight of mine when implementing the lock_view/unlock_view
		-- feature, unit movement is affected by the lock_view option similarly to
		-- disabling "Follow unit actions" in Advanced Preferences.
		--
		-- In order to allow [move_unit_fake] and [move_unit] (which is implemented
		-- using [move_unit_fake]) to scroll the viewport as necessary when the
		-- lock_view option is enabled, we temporarily unset that option before
		-- passing control to the mainline (C++) implementation of the WML action.
		--

		local need_relock = false

		if wesnoth.view_locked then
			wesnoth.lock_view(false)
			need_relock = true
		end

		-- Back to C++
		engine_muf(cfg)

		if need_relock then
			wesnoth.lock_view(true)
		end
	end
end