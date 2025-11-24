#!/data/data/com.termux/files/usr/bin/env bash

# red led
LED_ORDER=(9)

connectivity () {
    ping -c 1 teleport.phonkd.net > /dev/null 2>&1
}

set_led() {
    local led=$1
    local brightness=$2
    echo "$led $brightness" > /sys/class/leds/led_strips/single_brightness
}

# Flash LED if ping fails
flash_failure_led() {
    local led=${LED_ORDER[0]}
    for i in {1..32}; do          # flash 4 times
        set_led "$led" 32
        sleep 0.15
        set_led "$led" 0
        sleep 0.15
    done
}

while true; do
    # check connectivity
    if ! connectivity; then
        flash_failure_led
    fi

    sleep 4
done
