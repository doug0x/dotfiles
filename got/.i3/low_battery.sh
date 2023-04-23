#!/bin/bash

while true; do
   battery=$(cat /sys/class/power_supply/BAT0/capacity)

   if [ "$battery" -le "5" ]; then
      mpv ~/.i3/sinking.mp3
      sleep 180
      battery_update=$(cat /sys/class/power_supply/BAT0/capacity)
      if [ "$battery_update" -ge "5" ]; then
         continue
      else
         systemctl poweroff
      fi
   fi
   sleep 30
done
