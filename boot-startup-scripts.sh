#!/data/data/com.termux/files/usr/bin/sh
sv up sshd
sv up dockerd
/data/data/com.termux/files/home/pong-files/network-routes.sh
# ln -s /data/data/com.termux/files/home/pong-files/boot-startup-scripts.sh /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
