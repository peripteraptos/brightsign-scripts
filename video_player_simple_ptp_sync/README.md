# Simple Video Player with PTP Sync

**This script is not heavily tested**. However, it should do synchronized video playback across multiple devices using Precision Time Protocol (PTP). It leverages BrightSigns frame-accurate `roSyncManager` for synchronization.

### Core Functionalities:

1. **Automatic Video Playback**: Automatically plays the first `.mp4` file found on the SD card.

2. **Leader/Follower Mode**:
   - **Leader Mode**: If a file named `master` is found on the SD card, the player enters the leader mode and starts video playback.
   - **Follower Mode**: If the `master` file is absent, the player waits to receive a sync message from a leader device to start video playback.

3. **DHCP Configuration**:
   - **DHCP Server**: If a file named `dhcp_server` exists on the SD card, the player will act as a DHCP server. Note that this feature is not compatible with older players. For those, an external DHCP server will be required, or the script will need to be adapted to use static IPs.
   - **DHCP Client**: In the absence of the `dhcp_server` file, the player operates as a DHCP client.

### Additional Details:

- **PTP Configuration**: This script sets the PTP domain for synchronization. If the current PTP domain does not match the specified domain ("0"), the script will update the domain setting and reboot the system. If you want to have multiple different syncronized playbacks on the same network, you have to adjust this number, or update `m.syncDomain` in the script.