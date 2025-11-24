#!/data/data/com.termux/files/usr/bin/env bash

# ordered LED list
LED_ORDER=(2 3 4 5 6 7 8 14 15 16 17 18 19 20 26 27)
NUM_LEDS=${#LED_ORDER[@]}

cpu_usage() {
    read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$idle
    sleep 0.1
    read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$idle
    echo $((100 * ( (total2-total1) - (idle2-idle1) ) / (total2-total1) ))
}

# map CPU% (0–100) to LED count (0–NUM_LEDS)
map_cpu_to_leds() {
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
    usage=$(cpu_usage)
    target_count=$(map_cpu_to_leds "$usage")

    echo "cpu: $usage% | LEDs: $current_count → $target_count"

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
