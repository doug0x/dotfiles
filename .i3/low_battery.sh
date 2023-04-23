#!/bin/bash

check_charging() {
   while true; do
      charging=$(cat /sys/class/power_supply/BAT0/status)
      sleep 5
      if [ "$charging" == "Charging" ]; then
         pkill mpv
         sleep 10
         break
      fi
      sleep 5
   done
}

while true; do
   battery=$(cat /sys/class/power_supply/BAT0/capacity)

   if [ "$battery" -le "7" ]; then
      mpv ~/.i3/sinking.mp3 & check_charging
      battery_update=$(cat /sys/class/power_supply/BAT0/capacity)
      if [ "$battery_update" -ge "6" ]; then
         continue
      else
        sudo systemctl poweroff
      fi
   fi
   sleep 30
done
