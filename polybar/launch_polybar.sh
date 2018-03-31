if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload -c ~/etc/polybar.new test &
  done
else
  polybar --reload -c ~/etc/polybar.new test &
fi
