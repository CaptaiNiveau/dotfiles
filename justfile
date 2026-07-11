socket := "unix:/tmp/kitty-ssh-grid"
dockercmd := "docker"

netshoot $container="":
    #!/bin/bash
    set -euo pipefail
    container=${container:-$(just dockercmd="{{ dockercmd }}" choose-container)}
    state=$({{ dockercmd }} inspect -f '{{"{{.State.Status}}"}}' "$container")

    if [ "$state" = "running" ]; then
        {{ dockercmd }} run --rm -it --network container:"$container" nicolaka/netshoot
        exit 0
    fi

    just dockercmd="{{ dockercmd }}" exec "tail -f /dev/null" "$container" "-i" &
    trap 'jobs -p | xargs -r kill' EXIT # this needs improvement, it doesn't properly kill the container yet
    sleep 5 # maybe some nicer way of waiting till it's up?
    {{ dockercmd }} run --rm -it --network container:exec-"$container" nicolaka/netshoot
    wait

# Enter a container and run a command.
enter $cmd="sh" $container="":
    #!/bin/bash
    set -euo pipefail
    set -x
    container=${container:-$(just dockercmd="{{ dockercmd }}" choose-container)}
    just dockercmd="{{ dockercmd }}" exec "$cmd" "$container"


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


choose-container format="{{.Names}}":
    #!/bin/bash
    set -euo pipefail
    containers=$({{ dockercmd }} ps -a --format "{{ format }}")
    container=$(fzf <<< "$containers")
    echo "$container"

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

synch-panel-send-command command="sudo su dockeruser\ncd ~/Deployment\n": launch-synch-panel
    #!/usr/bin/env bash
    # Send the commands to that specific Kitty instance
    for panel in panel1 panel2 panel3 panel4 panel5 panel6; do
        kitten @ --to "{{ socket }}" send-text --match title:$panel "${commands}"
    done
