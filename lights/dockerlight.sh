#!/data/data/com.termux/files/usr/bin/env bash

# red led
LED_ORDER=(13)

check_docker() {
    DOCKER_HOST="unix:///data/docker/run/docker.sock" docker ps >/dev/null 2>&1
}

set_led() {
    local led=$1
    local brightness=$2
    echo "$led $brightness" > /sys/class/leds/led_strips/single_brightness
}

flash_failure_led() {
    local led=${LED_ORDER[0]}
    for i in {1..12}; do
        set_led "$led" 127     # dim
        sleep 0.5
        set_led "$led" 0      # off
        sleep 0.5
    done
}

led=${LED_ORDER[0]}

while true; do
    set_led "$led" 0

    if ! check_docker; then
        flash_failure_led
    fi

    sleep 3
done
