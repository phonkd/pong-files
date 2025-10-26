#!/data/data/com.termux/files/usr/bin/sh
termux-wake-lock
sshd
#/data/data/com.termux/files/usr/bin/sv up sshd
export SVDIR="$PREFIX/var/service"

termux-services start   # ensure runsvdir is running; no effect if already started
sleep 10                # wait for storage/network if dockerd needs them

sv up dockerd
/data/data/com.termux/files/home/pong-files/network-routes.sh
# cp /data/data/com.termux/files/home/pong-files/boot-startup-scripts.sh /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
