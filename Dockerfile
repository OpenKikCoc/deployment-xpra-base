FROM alpine:3.10

ADD ./scripts /usr/sbin

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main/" \
    >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" \
    >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.10/community/" \
    >> /etc/apk/repositories \
# Deps
    && apk --no-cache upgrade \
    && apk --no-cache add \
    bash \
    curl \
    dbus-x11 \
    inotify-tools \
    ffmpeg \
    gstreamer \
    libvpx \
    libxcomposite \
    libxdamage \
    libxext \
    libxfixes \
    libxkbfile \
    libxrandr \
    libxtst \
    lz4 \
    lzo \
    openrc \
    openssh \
    openssl \
    py-asn1 \
    py-cffi \
    py-cryptography \
    py-dbus \
    py-enum34 \
    py-gobject3 \
    py-gtk \
    py-gtkglext \
    py-idna \
    py-ipaddress \
    py-lz4 \
    py-netifaces \
    py-numpy \
    py-pillow \
    py-rencode \
    py-six \
    py2-pip \
    py2-xxhash \
    shared-mime-info \
    x264 \
    xhost \
    xorg-server \
# Meta build-deps
    && apk --no-cache add --virtual build-deps \
    autoconf \
    automake \
    build-base \
    coreutils \
    cython-dev \
    inotify-tools-dev \
    ffmpeg-dev \
    flac-dev \
    git \
    libc-dev \
    libtool \
    libvpx-dev \
    libxcomposite-dev \
    libxdamage-dev \
    libxext-dev \
    libxfixes-dev \
    libxi-dev \
    libxkbfile-dev \
    libxrandr-dev \
    libxtst-dev \
    linux-headers \
    lz4-dev \
    musl-utils \
    npm \
    opus-dev \
    py-dbus-dev \
    py-gtk-dev \
    py-gtkglext-dev \
    py-numpy-dev \
    py-yuicompressor \
    python-dev \
    util-macros \
    which \
    x264-dev \
    xorg-server-dev \
    xorgproto \
    xvidcore-dev \
    xz \
    && npm install uglify-js@2 -g \
    && pip2 install git+https://github.com/paramiko/paramiko.git \
                    git+https://github.com/Legrandin/pycryptodome.git \
                    git+https://github.com/dsoprea/PyInotify.git \
                    git+https://github.com/novnc/websockify.git \
# Xpra
    && mv /usr/sbin/xpra.tar.xz /tmp \
    && cd /tmp \
    && tar -xf "xpra.tar.xz" \
    && cd "xpra-3.0.1" \
    && echo -e 'Section "Module"\n  Load "fb"\n  EndSection' \
    >> etc/xpra/xorg.conf \
    && python2 setup.py install \
    --verbose \
    --with-Xdummy \
    --with-Xdummy_wrapper \
    --with-bencode \
    --with-clipboard \
    --with-csc_swscale \
    --with-cython_bencode \
    --with-dbus \
    --with-enc_ffmpeg \
    --with-enc_x264 \
    --with-gtk2 \
    --with-gtk_x11 \
    --with-pillow \
    --with-server \
    --with-vpx \
    --with-vsock \
    --with-x11 \
    --without-client \
    --without-csc_libyuv \
    --without-cuda_kernels \
    --without-cuda_rebuild \
    --without-dec_avcodec2 \
    --without-enc_x265 \
    --without-gtk3 \
    --without-mdns \
    --without-opengl \
    --without-printing \
    --without-uinput \
    --without-sound \
    --without-strict \
    --without-webcam \
    && mkdir -p /var/run/xpra/ \
    && cd /tmp \
# su-exec
    && git clone --depth 1 https://github.com/ncopa/su-exec.git \
    /tmp/su-exec \
    && cd /tmp/su-exec \
    && make \
    && chmod 770 su-exec \
    && mv su-exec /usr/sbin/ \
# xf86-video-dummy
    && mv /usr/sbin/patches /tmp \
    && git clone --depth 1 https://github.com/JAremko/xf86-video-dummy.git \
    /tmp/xf86-video-dummy \
    && cd /tmp/xf86-video-dummy \
    && git apply \
     /tmp/patches/Constant-DPI.patch \
     /tmp/patches/fix-pointer-limits.patch \
     /tmp/patches/30-bit-depth.patch \
    && aclocal \
    && autoconf \
    && automake \
    --add-missing \
    --force-missing \
    && ./configure \
    && make \
    && make install \
    && mv /usr/local/lib/xorg/modules/drivers/dummy_drv.so \
    /usr/lib/xorg/modules/drivers/ \
# Cleanup
    && apk del build-deps \
    && rm -rf /var/cache/* /tmp/* /var/log/* ~/.cache \
    && mkdir -p /var/cache/apk \
# SSH
    && mkdir -p /var/run/sshd \
    && chmod 0755 /var/run/sshd \
    && rc-update add sshd \
    && rc-status \
    && touch /run/openrc/softlevel \
    && /etc/init.d/sshd start > /dev/null 2>&1 \
    && /etc/init.d/sshd stop > /dev/null 2>&1

# docker run ... --volumes-from <ME> -e DISPLAY=<MY_DISPLAY> ... firefox
# Mount <some_ssh_key>.pub in here to enable xpra via ssh
VOLUME ["/tmp/.X11-unix", "/etc/pub-keys"]