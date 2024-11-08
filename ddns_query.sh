#!/bin/bash
# DNS query+log script for A records
# Written by Ryan Lubach

# Hard-coded variables
domain="example.com"
log_file="/root/logs/ddns_query_log.txt"
dns_server="1.1.1.1" # Cloudflare DNS
last_ip=""
last_checked_time=""

# Function to log DNS entries
log_query() {
    # Get current IP and time (ISO 8601-ish)
    current_ip=$(dig @$dns_server +short $domain)
    current_time=$(date '+%Y-%m-%d %H:%M:%S')

    if [ -z "$current_ip" ]; then
        echo "$current_time - Failed to retrieve IP for $domain" >> $log_file
        exit 1
    fi

    # Check if log file exists and set the last known IP if not initialized
    if [ -z "$last_ip" ] && [ -f "$log_file" ]; then
        last_ip=$(grep -oP '(?<=IP: ).*' "$log_file" | tail -n 1)
    fi

    if [ "$last_ip" != "$current_ip" ]; then
        # IP has changed, log the new IP and the current time
        echo "$current_time - Domain: $domain, IP: $current_ip" >> $log_file
        echo "     Last query where IP was unchanged: $current_time" >> $log_file
    else
        # If the IP hasn't changed, update the last checked time in the last line
        sed -i '$ s/.*/Last query where IP was unchanged: '"$current_time"'/' $log_file
    fi

    # Update the last known IP and time
    last_ip="$current_ip"
    last_checked_time="$current_time"
}

# Run the function
log_query
