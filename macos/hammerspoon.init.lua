local spaces = require('hs.spaces')

-- Switch alacritty
hs.hotkey.bind({'cmd'}, '§', function ()
  local APP_NAME = 'Alacritty'
  function moveWindow(alacritty, mainScreen)
    local win = nil
    while win == nil do
      win = alacritty:mainWindow()
    end
    winFrame = win:frame()
    win:setFrame(winFrame, 0)
    win:moveToScreen(mainScreen)
    win:focus()
  end
  local alacritty = hs.application.get(APP_NAME)
  if alacritty ~= nil and alacritty:isFrontmost() then
    alacritty:hide()
  else
    local mainScreen = hs.screen.mainScreen()
    if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
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
    if alacritty ~= nil then
      moveWindow(alacritty, mainScreen)
    end
  end
end)
