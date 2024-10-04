#!/bin/bash

# Check if an IP address is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <PLAYER IP_ADDRESS/DNS>"
    exit 1
fi

IP_ADDRESS=$1

# Step 1: Discover the device name using mDNS via `dig`
DEVICE_NAME=$(dig -x $IP_ADDRESS @224.0.0.251 -p 5353 +short | sed 's/.$//')

# Extract only the code after the dash (e.g., X4N64K001244 from BrightSign-X4N64K001244.local.)
DEFAULT_PASSWORD=$(echo "$DEVICE_NAME" | sed -n 's/.*-\(.*\)\.local/\1/p')

if [ -z "$DEFAULT_PASSWORD" ]; then
    echo "Failed to extract the default password. Exiting..."
    exit 1
fi

echo "Discovered default password: $DEFAULT_PASSWORD"

# Step 2: Attempt to remove default password using the old endpoint
echo "Attempting to remove password using the old method..."
OLD_RESPONSE=$(curl --digest -u "admin:$DEFAULT_PASSWORD" -X POST "http://$IP_ADDRESS/clear_password" --data-raw "current_password=$DEFAULT_PASSWORD" -s -o /dev/null -w "%{http_code}")

if [ "$OLD_RESPONSE" -eq 200 ]; then
    echo "Successfully removed the password using the old method."
    exit 0
else
    echo "Old method failed with HTTP code: $OLD_RESPONSE. Trying new method..."
fi

# Step 3: Attempt to remove default password using the new endpoint
NEW_RESPONSE=$(curl --digest -u "admin:$DEFAULT_PASSWORD" -X PUT "http://$IP_ADDRESS/api/v1/control/dws-password" \
    -H 'Content-Type: application/json' \
    --data-raw "{\"previous_password\":\"$DEFAULT_PASSWORD\"}" \
    -s -o /dev/null -w "%{http_code}")

if [ "$NEW_RESPONSE" -eq 200 ]; then
    echo "Successfully removed the password using the new method."
else
    echo "Failed to remove the password using the new method. HTTP code: $NEW_RESPONSE."
    exit 1
fi
