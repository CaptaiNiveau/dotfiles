local hostname = io.popen("hostname"):read("*l")

require("./hyprland/*")
require("./hyprland-" .. hostname .. "/*")

hl.window_rule({
  match = {
    class = ".*"
  },
  suppress_event = "maximize"
});
