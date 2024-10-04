# BrightSign Management Scripts

This repository contains a set of scripts designed to manage BrightSign devices. Each script is tailored for specific tasks such as rebooting the device, removing passwords, and uploading files.

## Scripts Overview

### 1. `reboot.sh`

This script reboots a specified BrightSign device.

- **Usage**: `./reboot.sh <PLAYER IP_ADDRESS/DNS>`
  
- **Functionality**:
  - Attempts to reboot the device using two different methods.
  - Firstly, it attempts the old reboot method by sending a request to `http://<IP_ADDRESS>/action.html?reboot=Reboot`.
  - If the old method fails, it tries the new method via a `PUT` request to `http://<IP_ADDRESS>/api/v1/control/reboot`.
  - Reports success or failure of each method with corresponding HTTP response codes.

### 2. `removepassword.sh`

This script attempts to remove the default password from a specified BrightSign device.

- **Usage**: `./removepassword.sh <PLAYER IP_ADDRESS/DNS>`
  
- **Functionality**:
  - Discovers the device's default password using mDNS.
  - Attempts to clear the password using two different methods.
  - Firstly, it tries the old endpoint at `http://<IP_ADDRESS>/clear_password`.
  - If the old method fails, it attempts the new endpoint using a `PUT` request to `http://<IP_ADDRESS>/api/v1/control/dws-password`.
  - Provides feedback based on the HTTP response code of each method.

### 3. `uploadfiles.sh`

This script uploads files to a specified BrightSign device.

- **Usage**: `./uploadfiles.sh <IP_ADDRESS> <FILE_1> [<FILE_2> ... <FILE_N>]`
  
- **Functionality**:
  - Uploads files to the device using two different methods.
  - Firstly, it tries the old method by posting files to `http://<IP_ADDRESS>/uploads.html?rp=sd`.
  - If the old method fails, it attempts the new method using a `PUT` request to `http://<IP_ADDRESS>/api/v1/files/sd`.
  - Provides status updates for each file upload attempt, indicating success or failure with HTTP response codes.

## General Information

- All scripts require a valid IP address or DNS of the target BrightSign device.
- Scripts use `curl` to interact with the device's API.
- Scripts try to be fault-tolerant and alternate methods if the preferred method fails.

## Prerequisites

- Ensure `curl` and `dig` are installed and accessible from the command line.
- Ensure execution permissions for the scripts: `chmod +x script_name.sh`.