netshoot $container="":
    #!/bin/bash
    container=${container:-$(docker ps --format {{"{{.Names}}"}} | fzf)}
    docker run --rm -it --network container:$container nicolaka/netshoot
