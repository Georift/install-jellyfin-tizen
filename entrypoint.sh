#!/bin/bash

# Function to display help message
print_help() {
  echo "Usage: $0 --ip <TV_IP> [--build <BUILD_OPTION>] [--tag <TAG_URL>] [--oneui8 --device-id <DEVICE_ID> --email <EMAIL>] [--cert-password <PASSWORD>]"
  echo ""
  echo "Options:"
  echo "  --ip <TV_IP>           IP address of your Samsung TV (required)"
  echo "  --build <BUILD_OPTION>  Build option (default: Jellyfin)"
  echo "  --tag <TAG_URL>        URL of the release tag (optional, latest if omitted)"
  echo "  --oneui8               Enable One UI 8 mode"
  echo "  --device-id <DEVICE_ID> Device ID for One UI 8 (required if --oneui8 is used)"
  echo "  --email <EMAIL>       Email for One UI 8 (required if --oneui8 is used)"
  echo "  --cert-password <PASSWORD> Password for the certificate (optional)"
  exit 1
}

# Initialize variables
TV_IP=""
JELLYFIN_BUILD_OPTION="Jellyfin"
TAG_URL="https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/latest"
ONEUI8_MODE=false
DEVICE_ID=""
EMAIL=""
CERTIFICATE_PASSWORD=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --ip) TV_IP="$2"; shift 2 ;;
    --build) JELLYFIN_BUILD_OPTION="$2"; shift 2 ;;
    --tag) TAG_URL="$2"; shift 2 ;;
    --oneui8) ONEUI8_MODE=true; shift 1 ;;
    --device-id) DEVICE_ID="$2"; shift 2 ;;
    --email) EMAIL="$2"; shift 2 ;;
    --cert-password) CERTIFICATE_PASSWORD="$2"; shift 2 ;;
    --help) print_help; exit 0 ;;
    *) echo "Invalid option: $1"; print_help; exit 1 ;;
  esac
done

# Check if required --ip argument is provided
if [ -z "$TV_IP" ]; then
  echo "Error: --ip <TV_IP> is required."
  print_help
fi

# One UI 8 mode checks
if $ONEUI8_MODE; then
  if [ -z "$DEVICE_ID" ] || [ -z "$EMAIL" ]; then
    echo "Error: --device-id and --email are required for One UI 8 mode."
    print_help
  fi
fi

# Tag URL handling
if [ "$TAG_URL" = "https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/latest" ]; then
  FULL_TAG_URL=$(curl -sLI "$TAG_URL" | grep -i 'location:' | sed -e 's/^[Ll]ocation: //g' | tr -d '\r')

  if [ -z "$FULL_TAG_URL" ]; then
    echo "Error: Could not fetch the latest tag URL from $TAG_URL"
    exit 1
  fi

  TAG=$(basename "$FULL_TAG_URL")
  echo "Using the latest available version: $TAG"
else
  TAG=$(basename "$TAG_URL")
  if [ -z "$TAG" ]; then
    echo "Error: Could not extract the tag from the provided URL $TAG_URL"
    echo "Please provide a URL to the full release, for example: https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/tag/2024-11-24-0431"
    exit 1
  fi
fi

# Certificate handling
if [ -n "$CERTIFICATE_PASSWORD" ]; then
  if ! [ -f /certificates/author.p12 ] || ! [ -f /certificates/distributor.p12 ]; then
    echo "Error: Certificate files not found."
    exit 1
  fi
else
  echo "Using default dev certificate."
fi

DOWNLOAD_URL="https://github.com/jeppevinkel/jellyfin-tizen-builds/releases/download/${TAG}/${JELLYFIN_BUILD_OPTION}.wgt"

echo ""
echo ""
echo " Thanks to https://github.com/jeppevinkel for providing the pre-packaged jellyfin-tizen builds!"
echo " These builds can be found at https://github.com/jeppevinkel/jellyfin-tizen-builds"
echo ""
echo " Using Jellyfin Tizen Build $JELLYFIN_BUILD_OPTION.wgt"
echo " from release: $TAG"
echo ""
echo ""

echo "Attempting to connect to Samsung TV at IP address $TV_IP"
sdb connect "$TV_IP"

echo "Attempting to get the TV name..."
TV_NAME=$(sdb devices | grep -E 'device\s+\w+[-]?\w+' -o | sed 's/device//' - | xargs)

if [ -z "$TV_NAME" ]; then
  echo "We were unable to find the TV name."
  exit 1
fi
echo "Found TV name: $TV_NAME"

echo "Downloading jellyfin-tizen-builds $JELLYFIN_BUILD_OPTION.wgt from release: $TAG"
wget -q --show-progress "$DOWNLOAD_URL"; echo ""

if $ONEUI8_MODE; then
  echo "Starting the certificate generation server..."
  pip install -r requirements.txt
  python cert_server.py --tv --device-id="$DEVICE_ID" --email="$EMAIL" &
  CERT_SERVER_PID=$!
  echo "Certificate generation server started. Please visit the web interface to generate your certificate."
  read -p "Press Enter after you have completed the certificate generation..."
  kill "$CERT_SERVER_PID"
fi

if [ -n "$CERTIFICATE_PASSWORD" ]; then
  echo "Attempting to sign package using provided certificate"
  sed -i "s/_CERTIFICATEPASSWORD_/$CERTIFICATE_PASSWORD/" profile.xml
  sed -i '/<\/profile>/ r profile.xml' /home/developer/tizen-studio-data/profile/profiles.xml
  tizen package -t wgt -s custom -- "$JELLYFIN_BUILD_OPTION.wgt"
fi

echo "Attempting to install jellyfin-tizen-builds $JELLYFIN_BUILD_OPTION.wgt from release: $TAG"
tizen install -n "$JELLYFIN_BUILD_OPTION.wgt" -t "$TV_NAME"