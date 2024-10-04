# Audio Player with GPIO Button Controls

This script provides audio playback from files stored on the card, with navigation controlled through GPIO buttons. The function of the script is to load audio files, play them sequentially, and allowing users to navigate to the next or previous track using two gpio buttons.

## Features

- **Audio Playback**: Plays audio files from an SD card.
- **GPIO Control**: Use GPIO buttons to navigate through tracks.
- **Looping**: Automatically loops back to the start of the playlist after the last track.
- **Supports Multiple Formats**: Compatible with `.wav` and `.mp3` file formats.

## Prerequisites

- BrightSign device
- SD card with compatible audio files in the specified directory (the SD card root, by default)
- Correct GPIO wiring for button inputs

## Customization

- **File Path**: The SD card path is initially set to "SD:/" and can be customized by adjusting the `m.sdCardPath` within the script.
- **Volume Control**: Playback volume is initialized to 100 by default. This can be changed by modifying the `m.volume` variable within the script before the audio player is configured. It allows values between 0 and 100.