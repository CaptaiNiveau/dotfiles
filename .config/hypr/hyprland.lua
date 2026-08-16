local hostname = io.popen("hostname"):read("*l")

require("./hyprland/*")
require("./hyprland-" .. hostname .. "/*")
