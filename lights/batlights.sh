#!/data/data/com.termux/files/usr/bin/env bash

# ordered LED list
LED_ORDER=(21 33 10 22 34 11 23 35)
NUM_LEDS=${#LED_ORDER[@]}

bat_usage() {
    cat /sys/class/power_supply/battery/capacity
}

# map bat% (0–100) to LED count (0–NUM_LEDS)
map_bat_to_leds() {
    local usage=$1
    echo $(( usage * NUM_LEDS / 100 ))
}

set_led() {
    local led=$1
    local brightness=$2
    echo "$led $brightness" > /sys/class/leds/led_strips/single_brightness
}

current_count=0   # how many LEDs are lit right now

while true; do
    usage=$(bat_usage)
    target_count=$(map_bat_to_leds "$usage")

    echo "bat: $usage% | LEDs: $current_count → $target_count"

    if (( current_count < target_count )); then
        # turn ON next LED
        led_index=$current_count
        led_id=${LED_ORDER[$led_index]}
        set_led "$led_id" 32
        ((current_count++))

    elif (( current_count > target_count )); then
        # turn OFF highest-lit LED
        ((current_count--))
        led_index=$current_count
        led_id=${LED_ORDER[$led_index]}
        set_led "$led_id" 0
    fi

    sleep 0.5  # smoothness speed
done
