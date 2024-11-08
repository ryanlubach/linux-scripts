#!/bin/bash
# Script for displaying basic Plex server information.
# Written by Ryan Lubach

# Print Plex logo
# (find it at https://github.com/laidbackcoder/PlexServer_SSH_AsciiArt)
echo
/root/scripts/plexlogo.sh

# Print location of PMS library files (not dynamically updated).
echo -ne "Plex Media Server library files are \nlocated in "
echo -ne "\033[1;32m/var/lib/plexmediaserver"
echo -ne "\033[1;37m."

# Print current LAN IP address.
ip_address=$(hostname -I | awk '{print $1}')
echo -ne "\n\nCurrent IP address: "
#echo -ne "$ip_address"
echo -ne "\033[1;32m$ip_address"
echo -ne "\033[1;37m."

# Keep at end of script to prevent clutter.
echo
echo
