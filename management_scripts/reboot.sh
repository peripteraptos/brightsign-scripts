#!/bin/bash

# Check if an IP address is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <PLAYER IP_ADDRESS/DNS>"
    exit 1
fi

IP_ADDRESS=$1

# Function to reboot using the old method
reboot_old_method() {
    # Try rebooting using the old method and return only the HTTP code
    curl "http://$IP_ADDRESS/action.html?reboot=Reboot" -s -o /dev/null -w "%{http_code}"
}

# Function to reboot using the new method
reboot_new_method() {
    # Try rebooting using the new method and return only the HTTP code
    curl "http://$IP_ADDRESS/api/v1/control/reboot" -X PUT -s -o /dev/null -w "%{http_code}"
}

echo "Starting reboot process for device at IP: $IP_ADDRESS"

# Attempt to reboot using the old method first
OLD_METHOD_RESPONSE=$(reboot_old_method)

if [ "$OLD_METHOD_RESPONSE" == "200" ]; then
    echo "✅ Successfully rebooted using the old method."
else
    echo "❌ Old method failed with HTTP code: $OLD_METHOD_RESPONSE. Trying the new method..."

    # If the old method fails, try using the new method
    NEW_METHOD_RESPONSE=$(reboot_new_method)

    if [ "$NEW_METHOD_RESPONSE" == "200" ]; then
        echo "✅ Successfully rebooted using the new method."
    else
        echo "❌ Failed to reboot using both methods. HTTP code: $NEW_METHOD_RESPONSE."
        exit 1
    fi
fi

echo "Reboot process completed successfully."

