#!/bin/zsh

#activate python environment for bscypylgtvcommand
source /home/captain/.local/git/bscpylgtv/venv/bin/activate

ip=$(cat ~/.config/lg/ip)

state=$(bscpylgtvcommand $ip get_power_state| tr "'" '"' | tr "T" "t" | jq ".state")

if [[ $state == '"Active"' ]] then
  bscpylgtvcommand $ip turn_screen_off
else
  bscpylgtvcommand $ip turn_screen_on
fi
