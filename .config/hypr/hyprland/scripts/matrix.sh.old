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

##Get active workspace, and translate to rows and cols

active_ws=$(hyprctl monitors | grep "focused: yes" -B 10 | grep "active workspace" | awk -F': ' '{print $2}' | cut -d' ' -f1)
row=$((($active_ws - 1) / $matrix_size))
col=$((($active_ws - 1) % $matrix_size))

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
echo $ws
echo $anim
hyprctl keyword animation $anim
hyprctl dispatch $dispatcher $ws
hyprctl keyword animation $defaultanim
