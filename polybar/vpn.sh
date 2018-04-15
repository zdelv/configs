#!/bin/bash

opvn='/bin/openvpn'

result=$(ps -u root | grep -c openvpn)

if [ $result -gt 0 ]; then
    (gksudo pkill openvpn)
else
    (cd /etc/openvpn && gksudo $opvn /etc/openvpn/US\ East.ovpn &)
fi
