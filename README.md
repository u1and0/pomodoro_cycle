## Overview

`pomodoro.sh` is a simple pomodoro timer that runs in the terminal. Based on the Pomodoro Technique, it sets work time, break time, and the number of cycles, displays a timer, and notifies you of work and break timings. It uses `termdown` and `notify-send` (optionally `lolcat`) to provide visual timers and notifications.

## Requirements

*   `termdown` (required): Used to display the timer in the terminal.
    *   Debian/Ubuntu based systems: `sudo snap install termdown`
    *   macOS (Homebrew): `brew install termdown`
*   `notify-send` (optional): Used to send desktop notifications. If not installed, a message will be displayed in the terminal.
    *   Debian/Ubuntu based systems: `sudo apt-get install libnotify-bin`
*   `lolcat` (optional): Used to colorize the timer output.
    *   Debian/Ubuntu based systems: `sudo apt-get install lolcat`
    *   macOS (Homebrew): `brew install lolcat`

## Installation

1.  Download the script or copy and paste it and save it as `pomodoro.sh`.
2.  Give the script execute permissions:

```bash
chmod +x pomodoro.sh
```

3.  Add the script to a path that's executable. For example, if you save it to the `~/bin` directory, add the following to your `.bashrc` or `.zshrc` file:

```bash
export PATH="$PATH:$HOME/bin"
```

After updating the `.bashrc` or `.zshrc` file, restart the terminal or run the following command to apply the changes:

```bash
source ~/.bashrc
# or
source ~/.zshrc
```

## Usage

Run the `pomodoro_cycle` command in the terminal:

```bash
pomodoro_cycle
```

This will start the Pomodoro timer with default settings (25 minutes of work, 5 minutes of short break, 15 minutes of long break, and 4 cycles).

### Options

You can customize the timer settings using the following options:

*   `-w, --work TIME`: Sets the work time. (e.g., `45m` is 45 minutes)
*   `-s, --short TIME`: Sets the short break time. (e.g., `10m` is 10 minutes)
*   `-l, --long TIME`: Sets the long break time. (e.g., `30m` is 30 minutes)
*   `-c, --cycles NUM`: Sets the number of cycles. (e.g., `3` is 3 cycles)
*   `-a, --alert NUM`: Sets the alert time (e.g. `30` is 30 seconds. This is used for termdown's alert display).
*   `-z, --sleep NUM`: Sets the wait time between notifications. (e.g. `2` is 2 seconds)
*   `-h, --help`: Displays the help message.

#### Examples

*   Start a Pomodoro timer with 45 minutes of work, 10 minutes of short break, 30 minutes of long break, and 3 cycles:

```bash
pomodoro_cycle -w 45m -s 10m -l 30m -c 3
# or
pomodoro_cycle --work 45m --short 10m --long 30m --cycles 3
```

*   Display the help message:

```bash
pomodoro_cycle -h
# or
pomodoro_cycle --help
```

## Details

The script performs the following processes:

1.  Defines the default Pomodoro timer settings (work time, short break time, long break time, number of cycles).
2.  Checks if the `notify-send` command is available, and if so, defines the `_notify()` function to send desktop notifications. If not available, it prints a message to the terminal.
3.  Defines the `_pomo_timer()` function to display the timer using `termdown`. If `lolcat` is installed, it colorizes the output.
4.  The `pomodoro_cycle()` function parses the optional arguments, updates the settings, and executes the work and break time timers for the specified number of cycles.
5.  Displays messages at the start and end of each cycle.
6.  Displays a completion message when all cycles are complete.
