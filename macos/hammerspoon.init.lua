-- https://github.com/asmagill/hs._asm.undocumented.spaces
local spaces = require('hs._asm.undocumented.spaces')

-- Switch alacritty
hs.hotkey.bind({'cmd'}, '§', function ()
  local APP_NAME = 'Alacritty'
  function moveWindow(alacritty, space, mainScreen)
    -- move to main space
    local win = nil
    while win == nil do
      win = alacritty:mainWindow()
    end
    winFrame = win:frame()
    win:setFrame(winFrame, 0)
    win:spacesMoveTo(space)
    win:focus()
  end
  local alacritty = hs.application.get(APP_NAME)
  if alacritty ~= nil and alacritty:isFrontmost() then
    alacritty:hide()
  else
    local space = spaces.activeSpace()
    local mainScreen = hs.screen.find(spaces.mainScreenUUID())
    if alacritty == nil and hs.application.launchOrFocus(APP_NAME) then
      local appWatcher = nil
      appWatcher = hs.application.watcher.new(function(name, event, app)
        if event == hs.application.watcher.launched and name == APP_NAME then
          app:hide()
          moveWindow(app, space, mainScreen)
          appWatcher:stop()
        end
      end)
      appWatcher:start()
    end
    if alacritty ~= nil then
      moveWindow(alacritty, space, mainScreen)
    end
  end
end)
