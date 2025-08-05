--- @meta
hs = hs or {}

-- [[ App shortcuts ]]
hs.hotkey.bind({ "cmd" }, "f1", function()
  hs.application.launchOrFocus("Ghostty")
end)
hs.hotkey.bind({ "cmd" }, "f2", function()
  hs.application.launchOrFocus("Firefox")
end)
hs.hotkey.bind({ "cmd" }, "f3", function()
  hs.application.launchOrFocus("Microsoft Teams")
end)
hs.hotkey.bind({ "cmd" }, "f4", function()
  hs.application.launchOrFocus("Microsoft Outlook")
end)

-- [[ Maximize ]]
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "M", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = max.h
  win:setFrame(f)
end)

-- [[ Left half ]]
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "[", function()
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

-- [[ Right half ]]
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "]", function()
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

hs.alert.show("{^_^}")
