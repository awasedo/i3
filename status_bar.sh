#!/bin/bash

year_and_date() {
        echo "$(date +"%Y-%m-%d")"
}

current_time() {
        echo "$(date +"%H:%M")"
}

ram_usage() {
        ram_used=$(free | awk 'NR==2{printf "%.0f\n", $3/$2*10}')
        echo $(printf '█%.0s' $(seq 1 $ram_used))$(printf '░%.0s' $(seq $ram_used 8))
}

updates_available() {
        echo "$(xbps-install -Mun | awk "END {print NR}") updates"
}

cpu_temperature() {
        echo " $(awk '{printf "%.0f\n", $1/1000}' /sys/devices/platform/eeepc-wmi/hwmon/hwmon3/subsystem/hwmon2/temp1_input)°C"
}

wifi_bars() {
        wifi_signal=$(iw dev wlp5s0 station dump | grep signal: | awk '{print $2*-1}')

        bars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "▉")

        # Half-up rounding wifi_str/12
        wifi_eight=$(( ($wifi_signal + 12 / 2 ) / 12 ))

        wifi=${bars[$wifi_eight]}

        for i in {1..8}; do
                if (($wifi_eight-$i < 0)); then
                        wifi+=${bars[0]}
                else
                        wifi+=${bars[$wifi_eight-$i]}
                fi
        done

        echo $wifi
}

echo "$(updates_available) $(cpu_temperature) $(year_and_date) $(current_time) $(ram_usage) $(wifi_bars) "
