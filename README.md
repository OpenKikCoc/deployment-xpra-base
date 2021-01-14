# deployment-xpra-base
Docker deployment for xpra-base.

## 0. Prepare

1.  Docker env.

2.  Config the Dockerfile such as:

    ```Dockerfile
    FROM binacslee/xpra-base

    # MODE more at http://xpra.org/trac/wiki/Usage
    ENV MODE="tcp"               \
        DISPLAY=":99"            \
        SHELL="/bin/bash"        \
        SSHD_PORT="22"           \
        START_XORG="yes"         \
        XPRA_PASSWORD=123        \
        XPRA_HTML="yes"          \
        XPRA_MODE="start"        \
        XPRA_READONLY="no"       \
        XORG_DPI="96"            \
        XPRA_COMPRESS="0"        \
        XPRA_DPI="0"             \
        XPRA_ENCODING="rgb"      \
        XPRA_HTML_DPI="96"       \
        XPRA_KEYBOARD_SYNC="yes" \
        XPRA_MMAP="yes"          \
        XPRA_SHARING="yes"       \
        XPRA_TCP_PORT="10000"

    ENV GID="1000"         \
        GNAME="xpra"       \
        SHELL="/bin/bash"  \
        UHOME="/home/xpra" \
        UID="1000"         \
        UNAME="xpra"

    # ============ Mount the volume if you need ============
    # docker run ... --volumes-from <ME> -e DISPLAY=<MY_DISPLAY> ... firefox
    # Mount <some_ssh_key>.pub in here to enable xpra via ssh
    VOLUME ["/tmp/.X11-unix", "/etc/pub-keys"]

    CMD ["entry", "$ARGS"]
    ```
3.  Build images:

    ```sh
    build -t foo/bar:tag .
    ```


## 1. For multi-architecture docker images

More details at `workspace-docker.sh` .
