local spaces = require('hs.spaces')

-- Switch to WezTerm
hs.hotkey.bind({'cmd'}, '§', function ()
  local APP_NAME = 'WezTerm'
  function moveWindow(wezterm, mainScreen)
    local win = wezterm:mainWindow()
    local space = hs.spaces.activeSpaceOnScreen()
    hs.spaces.moveWindowToSpace(win:id(), space)
    win:focus()
  end
  local wezterm = hs.application.get(APP_NAME)
  if wezterm ~= nil and wezterm:isFrontmost() then
    wezterm:hide()
  else
    local mainScreen = hs.screen.mainScreen()
    if wezterm == nil and hs.application.launchOrFocus(APP_NAME) then
      local appWatcher = nil
      appWatcher = hs.application.watcher.new(function(name, event, app)
        if event == hs.application.watcher.launched and name == APP_NAME then
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
end)
