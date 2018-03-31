#!/bin/bash


ismuted=$(amixer -c 1 get Front | grep -c1o '[[]on]')


if [ $ismuted -gt 0 ]; then
    echo 'Made it this far'
    amixer -c 1 set Front mute 
    exit
elif [ $ismuted = 0 ]; then
    amixer -c 1 set Front unmute
    amixer -c 1 set Master unmute 
    amixer -c 1 set Headphone unmute 
    exit
fi

