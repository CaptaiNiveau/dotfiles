hl.bind("SUPER + CTRL + backspace", function() hl.plugin.hyprtasking.toggle("cursor") end)
hl.bind("SUPER + CTRL + return", function() hl.plugin.hyprtasking.toggle("all") end)

-- escape closes the overview if it's open
hl.bind("escape", function()
  if hl.plugin.hyprtasking.is_active() then
    hl.plugin.hyprtasking.toggle('all')
  end
end, { non_consuming = true })

hl.bind("SUPER + C", function() hl.plugin.hyprtasking.killhovered() end)

local left = "left"
local right = "right"
local up = "up"
local down = "down"
local pos1 = "home"
local endkey = "end"
--$aux1  = XF86AudioPrev
local aux1 = "XF86AudioLowerVolume"
local aux2 = "XF86AudioPlay"
--$aux3  = XF86AudioNext
local aux3 = "XF86AudioRaiseVolume"

--hl.bind("SUPER + H", function() hl.plugin.hyprtasking.move("left") end)
--hl.bind("SUPER + J", function() hl.plugin.hyprtasking.move("down") end)
--hl.bind("SUPER + K", function() hl.plugin.hyprtasking.move("up") end)
--hl.bind("SUPER + L", function() hl.plugin.hyprtasking.move("right") end)

--### Move workspace relative ####

hl.bind("SUPER + CTRL + " .. left,  function() hl.plugin.hyprtasking.move("left") end)
hl.bind("SUPER + CTRL + " .. down,  function() hl.plugin.hyprtasking.move("down") end)
hl.bind("SUPER + CTRL + " .. up,    function() hl.plugin.hyprtasking.move("up") end)
hl.bind("SUPER + CTRL + " .. right, function() hl.plugin.hyprtasking.move("right") end)
hl.bind("SUPER + CTRL + " .. aux3,  function() hl.plugin.hyprtasking.move("out") end)

--### \Move workspace relative ####

--### Drag window relative ####

hl.bind("SUPER + SHIFT + CTRL + " .. left,  function() hl.plugin.hyprtasking.movewindow("left") end)
hl.bind("SUPER + SHIFT + CTRL + " .. down,  function() hl.plugin.hyprtasking.movewindow("down") end)
hl.bind("SUPER + SHIFT + CTRL + " .. up,    function() hl.plugin.hyprtasking.movewindow("up") end)
hl.bind("SUPER + SHIFT + CTRL + " .. right, function() hl.plugin.hyprtasking.movewindow("right") end)
hl.bind("SUPER + SHIFT + CTRL + " .. aux3,  function() hl.plugin.hyprtasking.movewindow("out") end)

--hl.bind("SUPER + CTRL + " .. left,  function() hl.plugin.hyprtasking.move("left") end, { repeating = true })
--hl.bind("SUPER + CTRL + " .. down,  function() hl.plugin.hyprtasking.move("down") end, { repeating = true })
--hl.bind("SUPER + CTRL + " .. up,    function() hl.plugin.hyprtasking.move("up") end, { repeating = true })
--hl.bind("SUPER + CTRL + " .. right, function() hl.plugin.hyprtasking.move("right") end, { repeating = true })
--hl.bind("SUPER + CTRL + " .. aux3,  function() hl.plugin.hyprtasking.move("out") end, { repeating = true })
--
----### \Move workspace relative ####
--
----### Drag window relative ####
--
--hl.bind("SUPER + SHIFT + CTRL + " .. left,  function() hl.plugin.hyprtasking.movewindow("left") end, { repeating = true })
--hl.bind("SUPER + SHIFT + CTRL + " .. down,  function() hl.plugin.hyprtasking.movewindow("down") end, { repeating = true })
--hl.bind("SUPER + SHIFT + CTRL + " .. up,    function() hl.plugin.hyprtasking.movewindow("up") end, { repeating = true })
--hl.bind("SUPER + SHIFT + CTRL + " .. right, function() hl.plugin.hyprtasking.movewindow("right") end, { repeating = true })
--hl.bind("SUPER + SHIFT + CTRL + " .. aux3,  function() hl.plugin.hyprtasking.movewindow("out") end, { repeating = true })

--### \Drag window relative ####

hl.bind("SUPER + CTRL + F7", function() hl.plugin.hyprtasking.setlayer(1) end)
hl.bind("SUPER + CTRL + F8", function() hl.plugin.hyprtasking.setlayer(2) end)

hl.config({
  plugin = {
    hyprtasking = {
      layout = "grid",

      gap_size = 10,
      bg_color = 0xff26233a,
      border_size = 2,
      exit_on_hovered = false,
      warp_on_move_window = 1,
      close_overview_on_reload = false,

      -- for other mouse buttons see <linux/input-event-codes.h>
      drag_button = 0x110,   -- left mouse button
      select_button = 0x111, -- right mouse button

--      jump = {
--        enabled = false,
--        label_color = 0xffffffff,
--        label_background = 0x000000cc,
--        label_size = 32,
--      },

      gestures = {
        enabled = true,
        move_fingers = 3,
        move_distance = 150,
        open_fingers = 4,
        open_distance = 100,
        open_positive = true,
      },

      grid = {
        rows = 3,
        cols = 3,
        loop = false,
        layers = 2,
        loop_layers = true,
        gaps_use_aspect_ratio = true,
      },
    }
  },
})
