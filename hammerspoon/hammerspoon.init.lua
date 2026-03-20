-- Switch to app, or hide it if already focused.
-- NOTE: Moving windows across spaces is broken since macOS Sequoia.
-- Apple NOP'd the private APIs that hs.spaces.moveWindowToSpace relied on.
-- See: https://github.com/Hammerspoon/hammerspoon/issues/3698
function switchToApp(app_name)
	local app = hs.application.get(app_name)
	if app ~= nil and app:isFrontmost() then
		app:hide()
	else
		hs.application.launchOrFocus(app_name)
	end
end

-- Switch to WezTerm
hs.hotkey.bind({ "cmd" }, "`", function()
	switchToApp("WezTerm")
end)

hs.hotkey.bind({ "cmd" }, "§", function()
	switchToApp("WezTerm")
end)
