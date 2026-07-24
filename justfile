socket := "unix:/tmp/kitty-ssh-grid"
dockercmd := "docker"

[default]
list:
    @just --list

[group: 'docker']
netshoot $container="":
    #!/bin/bash
    set -euo pipefail
    container=${container:-$(just dockercmd="{{ dockercmd }}" choose-container)}
    state=$({{ dockercmd }} inspect -f '{{"{{.State.Status}}"}}' "$container")

    if [ "$state" = "running" ]; then
        {{ dockercmd }} run --rm -it --network container:"$container" nicolaka/netshoot
        exit 0
    fi

    helper="netshoot-helper-$container"
    helper_img="enter-$container-netshoot"

    cleanup() {
        {{ dockercmd }} rm -f "$helper" >/dev/null 2>&1 || true
        {{ dockercmd }} rmi "$helper_img" >/dev/null 2>&1 || true
    }
    trap cleanup EXIT

    # Clean up any leftovers from a previously aborted run
    cleanup

    # Start a detached clone of the stopped container
    just dockercmd="{{ dockercmd }}" _exec-daemon "$container" "$helper" "$helper_img"

    # Wait for the helper to be running (up to ~30s), failing fast if it dies
    i=0
    helper_state="missing"
    while [ $i -lt 60 ]; do
        helper_state=$({{ dockercmd }} inspect -f '{{"{{.State.Status}}"}}' "$helper" 2>/dev/null || echo "missing")
        case "$helper_state" in
            running) break ;;
            exited|dead)
                echo "Helper container $helper failed (state: $helper_state)" >&2
                exit 1
                ;;
        esac
        sleep 0.5
        i=$((i + 1))
    done

    if [ "$helper_state" != "running" ]; then
        echo "Helper container $helper did not start in time" >&2
        exit 1
    fi

    {{ dockercmd }} run --rm -it --network container:"$helper" nicolaka/netshoot


# Enter a container and run a command.
[group: 'docker']
enter $cmd="sh" $container="":
    #!/bin/bash
    set -euo pipefail
    set -x
    container=${container:-$(just dockercmd="{{ dockercmd }}" choose-container)}
    just dockercmd="{{ dockercmd }}" exec "$cmd" "$container"


[group: 'docker']
exec $cmd="sh" $container="" $flags="-it":
    #!/bin/bash
    set -euo pipefail
    set -x
    container=${container:-$(just dockercmd="{{ dockercmd }}" choose-container)}
    state=$({{ dockercmd }} inspect -f '{{"{{.State.Status}}"}}' "$container")

    if [ "$state" = "running" ]; then
        {{ dockercmd }} exec {{ flags }} "$container" {{cmd}}
        exit 0
    fi

    tmpimg="enter-${container}-$(date +%s)"
    {{ dockercmd }} commit "$container" "$tmpimg"
    trap '{{ dockercmd }} rmi "$tmpimg" >/dev/null 2>&1 || true' EXIT

    entrypoint="${cmd%% *}"
    args="${cmd#* }"
    [ "$entrypoint" = "$cmd" ] && args=""

    # --volumes-from keeps the same volume view as the original container
    {{ dockercmd }} run --rm {{ flags }} \
        --volumes-from "$container" \
        --name "exec-$container" \
        --entrypoint "$entrypoint" \
        "$tmpimg" \
        $args


# Internal helper: start a detached clone of a stopped container.
[group: 'docker']
_exec-daemon $container $name $image:
    #!/bin/bash
    set -euo pipefail
    state=$({{ dockercmd }} inspect -f '{{"{{.State.Status}}"}}' "$container")

    if [ "$state" = "running" ]; then
        echo "Container $container is already running" >&2
        exit 1
    fi

    {{ dockercmd }} commit "$container" "$image"
    {{ dockercmd }} run -d \
        --volumes-from "$container" \
        --name "$name" \
        --entrypoint tail \
        "$image" \
        -f /dev/null


[group: 'docker']
choose-container format="{{.Names}}":
    #!/bin/bash
    set -euo pipefail
    containers=$({{ dockercmd }} ps -a --format "{{ format }}")
    container=$(fzf <<< "$containers")
    echo "$container"

[group: 'kitty']
[group: 'work']
launch-synch-panel-different:
    #!/usr/bin/env bash
    
    # Start Kitty with remote control enabled on a known socket
    kitty --listen-on {{ socket }} --session ~/.config/kitty/ssh-grid.session &
    
    # Wait for windows to be ready
    sleep 2
    
    # Map each panel title to its command sequence
    declare -A commands
    commands[panel1]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    commands[panel2]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    commands[panel3]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    commands[panel4]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    commands[panel5]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    commands[panel6]=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /\nls\n'
    
    # Send the commands to that specific Kitty instance
    for panel in panel1 panel2 panel3 panel4 panel5 panel6; do
        kitten @ --to {{ socket }} send-text --match title:$panel "${commands[$panel]}"
    done

[group: 'kitty']
[group: 'work']
launch-synch-panel:
    #!/usr/bin/env bash
    if [ -S /tmp/kitty-ssh-grid ] && kitten @ --to "{{ socket }}" ls >/dev/null 2>&1; then
        echo "Session exists"
    else
        rm -f /tmp/kitty-ssh-grid
        kitty --listen-on "{{ socket }}" --session ~/.config/kitty/ssh-grid.session &

        # Wait for windows to be ready
        sleep 1
    fi

    #commands=$'sudo su dockeruser\ncd ~/Deployment\ndocker exec -it synch-backend bash\ncd /DI-Synch-Solutions/Synchonefsi\nls \n'

[group: 'kitty']
[group: 'work']
synch-panel-send-command command="sudo su dockeruser\ncd ~/Deployment\n": launch-synch-panel
    #!/usr/bin/env bash
    # Send the commands to that specific Kitty instance
    for panel in panel1 panel2 panel3 panel4 panel5 panel6; do
        kitten @ --to "{{ socket }}" send-text --match title:$panel "${commands}"
    done

#todo make variadic (accept more than one input) so that globs work?
#todo needs better parsing of filenames and also maybe flags to replace original files or at least change the output naming
[arg('file', pattern='.*\.pdf')]
[group: 'pdf']
[group: 'university']
invertpdflow file:
    gs -o dark-{{ file }} \
       -sDEVICE=pdfwrite \
       -c "{1 exch sub 0.8 mul 0.1 add}{1 exch sub 0.8 mul 0.1 add}{1 exch sub 0.8 mul 0.1 add}{1 exch sub 0.8 mul 0.1 add} setcolortransfer" \
       -f {{ file }}

[group: 'utility']
calweek year week:
    #!/usr/bin/env bash
    week_to_range() {
        local year=$1
        local week=$2
        # Find Monday of week 1 (last Monday on or before Jan 4)
        local jan4_day=$(date -d "$year-01-04" +%u)  # 1=Mon, 7=Sun
        local monday_week1=$(date -d "$year-01-04 -$((jan4_day - 1)) days" +%F)
        # Add weeks
        local monday=$(date -d "$monday_week1 +$((week - 1)) weeks" +%F)
        local sunday=$(date -d "$monday +6 days" +%F)
        echo "$monday to $sunday"
    }

    week_to_range {{ year }} {{ week }}
