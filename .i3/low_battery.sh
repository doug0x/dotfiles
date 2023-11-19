#!/bin/bash

check_charging() {
   while true; do
      charging=$(cat /sys/class/power_supply/BAT0/status)
      sleep 2
      if [ "$charging" == "Charging" ]; then
         pkill -f mpv
         break
      fi
      sleep 5
   done
}

while true; do
   battery=$(cat /sys/class/power_supply/BAT0/capacity)
   if [ "$battery" -le "7" ]; then
      mpv $HOME/.i3/sinking.mp3 & check_charging
      battery_update=$(cat /sys/class/power_supply/BAT0/capacity)
      if [ "$battery_update" -ge "5" ]; then
         sleep 200
         continue
      else
        sudo systemctl poweroff
      fi
   fi
   sleep 30
done
