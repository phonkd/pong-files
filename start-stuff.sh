#!/data/data/com.termux/files/usr/bin/bash
# copy this into /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
termux-wake-lock
sshd
. "$PREFIX/etc/profile" # loads PATH, LD_LIBRARY_PATH, LANG, SVDIR, etc.
export SVDIR="$PREFIX/var/service"

termux-services start   # ensure runsvdir is running; no effect if already started           # wait for storage/network if dockerd needs them
#sudo /data/data/com.termux/files/home/pong-files/network-routes.sh
sleep 10
#sv up librespot
# cp /data/data/com.termux/files/home/pong-files/boot-startup-scripts.sh /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
# disabled dont need /data/data/com.termux/files/home/pong-files/lights/batlighsgpt.sh &
sudo /data/data/com.termux/files/home/pong-files/lights/cpulights.sh &
sudo /data/data/com.termux/files/home/pong-files/lights/dockerlight.sh &
sudo /data/data/com.termux/files/home/pong-files/lights/connectivitylight.sh &
sudo /data/data/com.termux/files/home/pong-files/fix_docker_network.sh
sv up dockerd
