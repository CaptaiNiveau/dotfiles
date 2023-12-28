#!/bin/zsh

#activate python environment for bscypylgtvcommand
source /home/captain/.local/git/bscpylgtv/venv/bin/activate

minBrightness=$(cat ~/.config/lg/min_brightness)
maxBrightness=$(cat ~/.config/lg/max_brightness)
stepSize="${2:=$(cat ~/.config/lg/step_size)}"
ip=$(cat ~/.config/lg/ip)

if (($stepSize < 0))
then
  echo "Step size shouldn't be negative: $stepSize"
  exit
fi

# targetBrightness=$(bscpylgtvcommand $(cat ~/.config/lg/ip) get_picture_settings "[\"backlight\"]" true | jq '.backlight') 
# targetBrightness=$(expr $targetBrightness - $stepSize) 

if [[ $1 == "up" ]] 
then
  targetBrightness=$(expr $(cat ~/.config/lg/brightness) + $stepSize) 
elif [[ $1 == "down" ]] 
then
  targetBrightness=$(expr $(cat ~/.config/lg/brightness) - $stepSize) 
else 
  echo -e "Use this script either with up or down and an optional step size: changeBrightness.zsh up 10"
  exit
fi


if (($targetBrightness < $minBrightness)); 
  then targetBrightness=$minBrightness;
elif (($targetBrightness > $maxBrightness)); 
  then targetBrightness=$maxBrightness;
fi; 

# write first so that button can be spammed
echo $targetBrightness > ~/.config/lg/brightness

dunstify "LG TV" "Brightness set to $targetBrightness" -h string:x-dunst-stack-tag:brightness
bscpylgtvcommand $ip set_current_picture_settings "{\"backlight\": $targetBrightness}"
