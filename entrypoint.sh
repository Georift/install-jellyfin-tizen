#!/bin/bash

if [ -z "$1" ]; then
    echo "Please pass the IP address of your Samsung TV as part of the commandline arguments for this script.";
		exit 1;
fi

JELLYFIN_BUILD_OPTION="${2:-Jellyfin}";
TAG_URL="${3:-https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/latest}";

if [ -z "$2" ]; then
    echo "Build option not provided, using default one: $JELLYFIN_BUILD_OPTION";
	echo "You can change it by passing option name as second argument for this script.";
fi

if [ -z "$3" ]; then
	REAL_TAG_URL=$(curl -v location: $TAG_URL 2>&1 | grep "< location:" | sed -e 's/< location: //g' | tr -d '\r');
	TAG=$(echo $REAL_TAG_URL | sed 's#.*/##');
    echo "Tag URL not provided, using latest available version: $TAG";
	echo "You can change it by passing tag URL as third argument for this script.";
else
	TAG=$(echo $TAG_URL | sed 's#.*/##');
fi

DOWNLOAD_URL=$(echo https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/download/${TAG}/${JELLYFIN_BUILD_OPTION}.wgt);

echo ""
echo ""
echo "	Thanks to https://github.com/jeppevinkel for providing the pre-packaged jellyfin-tizen builds!";
echo "	These builds can be found at https://github.com/jeppevinkel/jellyfin-tizen-builds";
echo ""
echo "	Using Jellyfin Tizen Build $JELLYFIN_BUILD_OPTION.wgt";
echo "	from release: $TAG";
echo ""
echo ""

TV_IP="$1";

echo "Attempting to connect to Samsung TV at IP address $TV_IP"
sdb connect $1

echo "Attempting to get the TV name..."
TV_NAME=$(sdb devices | grep -E 'device\s+\w+[-]?\w+' -o | sed 's/device//' - | xargs)

if [ -z "$TV_NAME" ]; then
    echo "We were unable to find the TV name.";
		exit 1;
fi
echo "Found TV name: $TV_NAME"

echo "Attempting to install jellyfin-tizen-builds $JELLYFIN_BUILD_OPTION.wgt from release: $TAG"
echo "$DOWNLOAD_URL"

wget -q --show-progress "$DOWNLOAD_URL"

tizen install -n $JELLYFIN_BUILD_OPTION.wgt -t "$TV_NAME"
