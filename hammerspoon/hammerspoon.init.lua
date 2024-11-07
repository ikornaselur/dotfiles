local spaces = require('hs.spaces')

-- Function to switch to app
function switchToApp(app_name)
  function moveWindow(wezterm, mainScreen)
    local win = wezterm:mainWindow()
    local space = hs.spaces.activeSpaceOnScreen()
    hs.spaces.moveWindowToSpace(win:id(), space)
    win:focus()
  end
  local wezterm = hs.application.get(app_name)
  if wezterm ~= nil and wezterm:isFrontmost() then
    wezterm:hide()
  else
    local mainScreen = hs.screen.mainScreen()
    if wezterm == nil and hs.application.launchOrFocus(app_name) then
      local appWatcher = nil
      appWatcher = hs.application.watcher.new(function(name, event, app)
        if event == hs.application.watcher.launched and name == app_name then
          app:hide()
          moveWindow(app, mainScreen)
          appWatcher:stop()
        end
      end)
      appWatcher:start()
    end
    if wezterm ~= nil then
      moveWindow(wezterm, mainScreen)
    end
  end
end



-- Switch to WezTerm
hs.hotkey.bind({'cmd'}, '`', function ()
  switchToApp('WezTerm')
end)

hs.hotkey.bind({'cmd'}, '§', function ()
  switchToApp('WezTerm')
end)
