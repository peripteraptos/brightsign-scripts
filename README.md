# BrightSign Scripts Repository

This repository contains a collection of scripts to be used with BrightSign Players. The scripts are organized into various directories.

## Directory Structure

- **audio_player_gpio_1_2_3_4/**: Contains a script for playing audio files using GPIO button controls. Each button is mapped to a specific audio file.

- **audio_player_gpio_next_prev/**: A script for sequential audio playback with navigation controlled by GPIO buttons. Users can move to the next or previous track using these controls.

- **video_player_simple_ptp_sync/**: A script for synchronized video playback across multiple devices using Precision Time Protocol (PTP). Supports both leader and follower modes for coordinated playback.

- **management_scripts/**: Provides scripts for managing device operations such as rebooting, removing passwords, and uploading files to BrightSign devices. Utilizes APIs for interaction.

## General Requirements

- A BrightSign device compatible with the features used within the scripts.
- Tools such as `curl` and `dig` installed on the system for management scripts.

## Usage

- Each script comes with its own README.md providing detailed instructions on usage, prerequisites, and any configuration specifics.

## Contribution

- If you wish to contribute to this repository, feel free to submit pull requests for improvements or additional functionality and scripts.