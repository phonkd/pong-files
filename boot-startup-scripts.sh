#!/data/data/com.termux/files/usr/bin/sh
/data/data/com.termux/files/usr/bin/sv up sshd
/data/data/com.termux/files/usr/bin/sv up dockerd
/data/data/com.termux/files/home/pong-files/network-routes.sh
# ln -s /data/data/com.termux/files/home/pong-files/boot-startup-scripts.sh /data/data/com.termux/files/home/.termux/boot/start-stuff.sh
