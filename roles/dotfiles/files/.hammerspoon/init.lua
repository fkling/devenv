local leader = {"cmd", "alt", "ctrl"}

hs.window.animationDuration = 0

--
-- Window management
--

-- Align left
hs.hotkey.bind(leader, "Left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Align right
hs.hotkey.bind(leader, "Right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

-- Fullscreen
hs.hotkey.bind(leader, "f", function()
  local win = hs.window.focusedWindow()
  win:fullscreen()
end)

-- Center
hs.hotkey.bind(leader, "c", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = max.w * 0.65
  f.h = max.h * 0.8
  f.x = ((max.w - f.w) / 2)
  f.y = ((max.h - f.h) / 2)
  win:setFrame(f)
end)

-- Hide all
hs.hotkey.bind(leader, "h", function()
  apps = hs.application.runningApplications()
  for _,v in pairs(apps) do
    v:hide()
  end
end)

--
-- Computer management
--

-- Lock screen
hs.hotkey.bind(leader, 'l', function()
  hs.caffeinate.startScreensaver()
end)

local openAll = {
  MailMate = 'MailMate',
  ['Fantastical'] = 'Fantastical 2',
  iTerm2 = 'iTerm',
  ['Textual IRC Client'] = 'Textual 5',
  ['iA Writer'] = 'iA Writer'
}

hs.hotkey.bind(leader, "O", function()
  hs.alert.show("Opening")
  local apps = hs.application.runningApplications()
  apps = hs.fnutils.map(apps, function(app)
    return app:name()
  end)

  for k,v in pairs(openAll) do
    if not has_value(apps, k) then
      hs.alert.show(v)
      hs.application.open(v)
    end
  end
end)



-------------------------
---- HERE BE DRAGONS ----
-------------------------

function hs.window.fullscreen(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end

function has_value (tab, val)
  for index, value in ipairs (tab) do
    if value == val then
      return true
    end
  end

  return false
end
