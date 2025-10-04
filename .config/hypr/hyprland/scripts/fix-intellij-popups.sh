#!/usr/bin/env zsh
# match-triplet.zsh  –  waits for the three events that belong together
#
# Example event:
### openwindow>>5caba8fa37c0,8,jetbrains-rider,
### activewindow>>jetbrains-rider,
### activewindowv2>>5caba8fa37c0

typeset -A seen
socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" |
while read -r line; do
  case $line in
    openwindow\>\>*)
      seen=(); seen[open]=${${line#openwindow>>}%,*,*,}; echo "open $seen";;
    activewindow\>\>jetbrains-rider,)
      seen[active]=1 && echo "active $seen";;
    activewindowv2\>*)
      seen[activev2]=${line#activewindowv2>>} && echo "activev2 $seen";;
  esac

  # all three present and window-addr matches?
  if [[ -n $seen[open] && $seen[active] && $seen[activev2] == $seen[open] ]]; then
    print -l "Triplet matched for window ${seen[open]}"
    seen=()

    sleep .01
    hyprctl dispatch resizeactive exact 1400 800
    hyprctl dispatch centerwindow
  fi
done
