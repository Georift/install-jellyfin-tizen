#!/bin/bash

if [ -z "$1" ]; then
    echo "Please pass the IP address of your Samsung TV as part of the commandline arguments for this script.";
		exit 1;
fi

echo ""
echo ""
echo "	Thanks to https://github.com/jeppevinkel for providing the pre-packaged jellyfin-tizen builds!";
echo "	These builds can be found at https://github.com/jeppevinkel/jellyfin-tizen-builds";
echo ""
echo ""

TV_IP="$1";

echo "Attempting to connect to Samsung TV at IP address $TV_IP"
sdb connect $1

# work out the TV name by connecting to $TV_IP:8001/api/v2/ and getting .device.modelName with jq
echo "Attempting to get the TV name..."
TV_NAME=$(curl -s http://$TV_IP:8001/api/v2/ | jq -r '.device.modelName')

if [ -z "$TV_NAME" ]; then
    echo "We were unable to find the TV name.";
		exit 1;
fi
echo "Found TV name: $TV_NAME"

echo "Attempting to install jellyfin-tizen-builds version:"
curl -v location: https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-05-04-1137 2>&1 | \
	grep "< location:" | \
	sed -e 's/< location: //g'

wget -q --show-progress https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/download/2024-05-04-1137/Jellyfin.wgt

tizen install -n Jellyfin.wgt -t "$TV_NAME"
