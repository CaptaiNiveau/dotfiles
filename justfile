socket := "unix:/tmp/kitty-ssh-grid"

netshoot $container="":
    #!/bin/bash
    container=${container:-$(docker ps --format {{"{{.Names}}"}} | fzf)}
    docker run --rm -it --network container:$container nicolaka/netshoot

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
