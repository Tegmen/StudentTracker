# StudentTracker

StudentTracker is a lightweight activity tracking program for Windows laptops, designed specifically for use in educational settings. It allows teachers to monitor student activity on school laptops, ensuring that the devices are used appropriately during school hours.

## Features

- **Activity Tracking**:
  - Logs the active program name and window title.
  - Tracks clipboard changes (text and basic objects).
  - Displays the last two hours of activity.

- **Transparency**:
  - Students can view their own activity logs by pressing `Ctrl + Alt + Y`.

- **Installer/Uninstaller**:
  - Easy installation to the user's AppData folder.
  - Uninstallation requires a password for security.

- **No Admin Rights Required**:
  - Designed to run without administrative privileges.

- **Privacy-Conscious**:
  - No data is sent to external servers.
  - Logs are stored only in memory and displayed locally in a browser.

## Requirements

- Windows 10 or later
- Default browser (Edge, Chrome, or Firefox)

## Installation

1. Run the `StudentTracker.exe` file.
2. If this is the first time running the program:
   - The installer will copy the program to the `AppData\Roaming\StudentTracker` folder.
   - It will create shortcuts:
     - **Startup folder**: To launch the program on system boot.
     - **Desktop**: For quick access.
   - A disclaimer page will display informing students about what is tracked.
3. The program will then start running in the background.

## Usage

### Key Combinations
- **`Ctrl + Alt + Y`**: View the activity and clipboard logs in your browser.
- **`Ctrl + Alt + X`**: Exit StudentTracker (requires a password).

## Uninstallation

1. Run the `StudentTracker.exe` file again.
2. If the program is already installed, you will be prompted to uninstall.
3. Enter the uninstallation password (`byebye` by default) to proceed.

## Privacy Policy

- **What is Tracked**:
  - Active programs and window titles.
  - Clipboard content (text and simple objects).
- **What is NOT Tracked**:
  - File contents or personal data outside the clipboard.
  - Passwords or sensitive information.
  - Data is never sent to external servers or stored permanently.
- **Transparency**:
  - Students can view their own logs at any time.

## Limitations

- The program relies on Windows APIs and may not work properly on non-standard configurations.
- Logs are stored only temporarily and are cleared automatically after two hours.

## Contribution

Contributions are welcome! If you encounter any issues or have feature requests, feel free to submit an issue or pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
