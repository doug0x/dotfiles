#!/bin/bash

while true; do
   battery=$(cat /sys/class/power_supply/BAT0/capacity)

   if [ "$battery" -le "7" ]; then
      mpv ~/.i3/sinking.mp3
      battery_update=$(cat /sys/class/power_supply/BAT0/capacity)
      if [ "$battery_update" -ge "7" ]; then
         continue
      else
        sudo systemctl poweroff
      fi
   fi
   sleep 30
done
