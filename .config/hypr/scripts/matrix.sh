#!/bin/zsh
set -e

matrix_size=3

##Utility functions

matrix_max=$(($matrix_size - 1))

function clamp() {
    n=$(($1 < 0 ? 0 : $1))
    n=$(($n > $matrix_max ? $matrix_max : $n))
    echo $n
}

function cycle() {
    echo $((($1 + $matrix_size) % $matrix_size))
}

## Get active workspace, and translate to rows and cols
active_ws=$(hyprctl monitors -j | jq '.[] | select (.focused==true) | .activeWorkspace.id')

row=$((($active_ws - 1) / $matrix_size))
col=$((($active_ws - 1) % $matrix_size))

## parantheses to create arrays
othermonitors_ws="($(hyprctl monitors -j | jq '.[] | select (.focused==false) | .activeWorkspace.id'))"
allused_ws="($(hyprctl monitors -j | jq '.[].activeWorkspace.id'))"

echo "$row : $col"

##Apply transformation
## change "cycle" to "clamp" to change the behavior

# todo could automatically pick this up using hyprctl
anim="workspaces,1,5,overshot,slide"
defaultanim=$anim
vertanim="${anim}vert"

case $1 in
"up") row=$(clamp $(($row - 1))) anim=$vertanim ;;
"down") row=$(clamp $(($row + 1))) anim=$vertanim ;;
"left") col=$(clamp $(($col - 1))) ;;
*) col=$(clamp $(($col + 1))) ;;
esac

case $2 in
"drag") dispatcher=movetoworkspace ;;
*) dispatcher=workspace ;;
esac

## translate col+row back to workspace number and apply
echo "$row : $col"
ws=$(($row * matrix_size + $col + 1))

## don't apply if there's already a monitor on that workspace
if (($allused_ws[(Ie)$ws])) then exit; fi

echo $allused_ws[(Ie)$ws]
echo $ws
echo $anim
hyprctl keyword animation $anim
hyprctl dispatch $dispatcher $ws
hyprctl keyword animation $defaultanim
