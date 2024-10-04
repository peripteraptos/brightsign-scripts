#!/bin/bash

# Check if the required arguments are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <IP_ADDRESS> <FILE_1> [<FILE_2> ... <FILE_N>]"
    exit 1
fi

IP_ADDRESS=$1
shift  # Shift the arguments to remove the IP address from the list

# Function to upload files using the old method
upload_old_method() {
    local file=$1
    local encoded_file=$(echo "$file" | sed 's/\//%2F/g')  # Encode filename for URL (e.g., sd%2Fautorun.brs)

    # Try deleting the old file and uploading the new one using the old endpoint
    curl -m1 "http://$IP_ADDRESS/delete?filename=sd%2F${encoded_file}&delete=Delete" -s -o /dev/null -w "%{http_code}"
    UPLOAD_RESPONSE=$(curl -m1 "http://$IP_ADDRESS/uploads.html?rp=sd" -X POST -F "datafile[]=@${file}" -s -o /dev/null -w "%{http_code}")
    echo $UPLOAD_RESPONSE  # Return the HTTP code from the upload attempt
}

# Function to upload files using the new method
upload_new_method() {
    local file=$1

    # Try uploading using the new method endpoint
    NEW_UPLOAD_RESPONSE=$(curl "http://$IP_ADDRESS/api/v1/files/sd" -X PUT -F "files[]=@${file}" -s -o /dev/null -w "%{http_code}")
    echo $NEW_UPLOAD_RESPONSE  # Return the HTTP code from the new upload attempt
}

# Iterate through each file and attempt to upload
for file in "$@"; do
    echo "Processing file: $file"

    # Attempt to upload using the old method first
    OLD_METHOD_RESPONSE=$(upload_old_method "$file")

    if [ "$OLD_METHOD_RESPONSE" == "200" ]; then
        echo "Successfully uploaded $file using the old method."
    else
        echo "Old method failed for $file with HTTP code: $OLD_METHOD_RESPONSE. Trying the new method..."
        
        # If the old method fails, try using the new method
        NEW_METHOD_RESPONSE=$(upload_new_method "$file")

        if [ "$NEW_METHOD_RESPONSE" == "200" ]; then
            echo "Successfully uploaded $file using the new method."
        else
            echo "Failed to upload $file using both methods. HTTP code: $NEW_METHOD_RESPONSE."
            exit 1
        fi
    fi
done

echo "All files processed successfully."

