#!/data/data/com.termux/files/usr/bin/bash

termux-wake-lock
sshd
. "$PREFIX/etc/profile" # loads PATH, LD_LIBRARY_PATH, LANG, SVDIR, etc.
export SVDIR="$PREFIX/var/service"

termux-services start   # ensure runsvdir is running; no effect if already started
sleep 10                # wait for storage/network if dockerd needs them
#sudo /data/data/com.termux/files/home/pong-files/network-routes.sh
sv up dockerd
sv up librespot
# cp /data/data/com.termux/files/home/pong-files/boot-startup-scripts.sh /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
