# deployment-xpra-base
Docker deployment for xpra-base.

## 0. Prepare

1.  Docker env.

2.  Config the Dockerfile such as:

    ```Dockerfile
    FROM binacslee/xpra-base

    # ============ Mount the volume if you need ============
    # docker run ... --volumes-from <ME> -e DISPLAY=<MY_DISPLAY> ... firefox
    # Mount <some_ssh_key>.pub in here to enable xpra via ssh
    VOLUME ["/tmp/.X11-unix", "/etc/pub-keys"]
    ```
3.  Build images:

    ```sh
    build -t foo/bar:tag .
    ```


## 1. For multi-architecture docker images

More details at `workspace-docker.sh` .