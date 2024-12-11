#!/bin/bash

# pong (it's like ping)
# A command for checking network connectivity.
# Can check once or continuously on a time interval.
# Written by Ryan Lubach


# Flag for automatically fetching default gateway.
# (set to FALSE for WSL or container)
use_auto_gateway=true

# Internet query server and preset default gateway.
internet_query="1.1.1.1" # Cloudflare
preset_gateway="10.0.0.1" # Hard-coded default gateway

# Default interval for continuous execution.
# (Every 'n' seconds with 'pong -c n'):
interval=0


# Parse input options and throw any errors:
while getopts "c:" opt; do
    case $opt in
        c)
            interval=$OPTARG
            ;;
        *)
            echo -e "\nUsage: pong every n seconds (integers only): ./pong.sh [-c n]\n"
            exit 1
            ;;
    esac
done


# Function to check connectivity:
do_pong() {
    # Set default gateway address automatically or use hardcoded value:
    if [ $use_auto_gateway = true ]; then
        def_gateway=$(ip route | awk '/default/ {print $3}') # Auto gateway
    else
        def_gateway="$preset_gateway"
    fi

    # Ping the default gateway
    ping -c 2 "$def_gateway" > /dev/null 2>&1

    # Check default gateway connectivity
    if [ $? -ne 0 ]; then
            if [ "$interval" -gt 0 ]; then
            clear
            echo -e "\nRunning pong every $interval seconds..."
        fi
        echo -e "\n    \033[1;33mGATEWAY ERROR"
        echo -e "    \033[1;33m> \e[39m$(date '+%-I:%M:%S %p, %a %m/%y')\n"
    else
        # Good default gateway, ping outbound:
        ping -c 2 "$internet_query" > /dev/null 2>&1

        if [ $? -ne 0 ]; then
            # Can't reach internet query server:
                        if [ "$interval" -gt 0 ]; then
                clear
                echo -e "\nRunning pong every $interval seconds..."
            fi
            echo -e "\n    \033[1;31mNO INTERNET"
            echo -e "    \033[1;31m> \e[39m$(date '+%-I:%M:%S %p, %a %m/%y')\n"
        else
            # Able to reach  internet query server:
                        if [ "$interval" -gt 0 ]; then
                clear
                echo -e "\nRunning pong every $interval seconds..."
            fi
            echo -e "\n    \033[1;32mCONNECTED"
            echo -e "    \033[1;32m> \e[39m$(date '+%-I:%M:%S %p, %a %m/%y')\n"
        fi
    fi
}


# Check for continous mode and run pong function:
if [ "$interval" -gt 0 ]; then
    while true; do
        do_pong
        echo -e "(To exit script, press Ctrl+C)"
        sleep "$interval"
    done
else
    do_pong
fi


# EXAMPLE OUTPUT:
#
#      NO INTERNET
#      > 1:46:59 PM, Mon 01/31

