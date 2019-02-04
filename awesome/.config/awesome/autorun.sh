#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run xset m 00 r rate 250 25
run setxkbmap -model pc104 -layout us,ru -variant qwerty -option grp:alt_shift_toggle -option caps:ctrl_modifier
# run compton
run nvidia-settings --load-config-only
run redshift -x && sleep 0.075 && redshift -O 4500
