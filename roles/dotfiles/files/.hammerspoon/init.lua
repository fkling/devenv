local leader = {"cmd", "alt", "ctrl"}

hs.grid.setGrid('8x8');
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.window.animationDuration = 0

local grid = {
  rightHalf = '4,0 4x8',
  leftHalf = '0,0 4x8',
  fullScreen = '0,0 8x8',
  centered = '1,1 6x6',
}

--
-- Window management
--

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    local win = hs.window.frontmostWindow()
    local id = win:id()
    local now = hs.timer.secondsSinceEpoch()
    local screen = win:screen()

    if
      lastSeenChain ~= movements or
      lastSeenAt < now - chainResetInterval or
      lastSeenWindow ~= id
    then
      sequenceNumber = 1
      lastSeenChain = movements
    elseif (sequenceNumber == 1) then
      -- At end of chain, restart chain on next screen.
      screen = screen:next()
    end
    lastSeenAt = now
    lastSeenWindow = id

    hs.grid.set(win, movements[sequenceNumber], screen)
    sequenceNumber = sequenceNumber % cycleLength + 1
  end
end

-- Align left
hs.hotkey.bind(leader, "Left", chain({
	grid.leftHalf,
}))

-- Align right
hs.hotkey.bind(leader, "Right", chain({
	grid.rightHalf,
}))

-- Fullscreen / center
hs.hotkey.bind(leader, "f", chain({
  grid.fullScreen,
  grid.centered,
}))

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

function has_value (tab, val)
  for index, value in ipairs (tab) do
    if value == val then
      return true
    end
  end

  return false
end
