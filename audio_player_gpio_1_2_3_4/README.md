# Audio Player with GPIO Button Control

This script is a simple audio player using GPIO buttons for control to play up to 4 different files.

## Overview

The script initializes an audio player and listens for button presses on the GPIO ports. Each button corresponds to a specific audio file. When a button is pressed, the associated audio file is played.

## Components

- `roAudioPlayer`: This object is responsible for playing audio files.
- `roControlPort`: This object is used to listen to button presses from GPIO inputs.
- `roMessagePort`: This object is used to handle communication between different components via messages.

## Button to Audio File Mapping

- Button 0: Plays `1.mp3`
- Button 1: Plays `2.mp3`
- Button 2: Plays `3.mp3`
- Button 3: Plays `4.mp3`

## Requirements

- A BrightSign device with GPIO capabilities.
- Audio files (`1.mp3`, `2.mp3`, `3.mp3`, `4.mp3`) stored on an SD card at the root directory.
- Properly wired GPIO buttons to the BrightSign device.

## Notes

- The script assumes audio files are named sequentially as `1.mp3`, `2.mp3`, etc.
- Ensure that the BrightSign device supports the use of the `roAudioPlayer` and `roControlPort` objects.
- The volume is set to 100. Adjust `SetVolume` if different volume levels are required.
