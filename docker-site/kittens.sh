#!/bin/bash

# Download list of Tor exits
TOREXITLIST=0
TOREXITLIST=$(curl -s https://check.torproject.org/exit-addresses | grep ExitAddress | awk '{print "\t" $2 " 1;"}')

# If the exit list somehow failed to download, echo that fact out and then exit.
if [[ $TOREXITLIST -eq 0 ]]; then echo "Tor exit list could not be downloaded!" && exit 10; fi

# Pipe exit list into nginx-compatible conf file
echo -e "geo \$torExit {
\tdefault 0;
$TOREXITLIST
}" > /etc/nginx/torexits.conf

# Load php-fpm and nginx
php-fpm && nginx -g "daemon off;"
