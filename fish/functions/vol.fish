function vol
   pactl set-sink-volume @DEFAULT_SINK@ +5% $argv
end
