#!/bin/bash

command='/bin/openvpn'

result=$(ps -u root | grep -c openvpn)

if [ $result -gt 0 ]; then
    echo "%{F#0f0}vpn%{F-}"
else
    echo "%{F#f00}vpn%{F-}"
fi
