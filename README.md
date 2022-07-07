### Note: Tiny Photographer requires root privileges and written by random guy on the internet. Understand the risks before using it.
# Tiny Photographer
## Introduction
Tiny Photographer is a small script that generates and deletes btrfs snapshots. It is fully dependent on the cron that runs on the system and was designed to specifically work with [Awecron](https://github.com/life00/awecron). 
## How it works?
### The goal
The goal was to create a script that would automatically create and delete snapshots. Snapshots would have a "lifetime" and then be replaced with newly created snapshots. There would be multiple such scripts that would have different intervals of creation and deletion. This way even if the wanted snapshot was deleted, there would be another from bigger interval that wasnt.
### The result
To reduce the amount of code and to not reinvent the wheel the Tiny Photographer now relies on the running cron. Every run it would create a new snapshot and check if it is time to delete the oldest snapshot according to the interval.
## Installation
### Dependencies
 * bash
 * GNU date
### How to use?
 * clone the repo
 * copy `main.sh`
 * configure the variables
 * run it using installed cron as root
### Configuration
 * `storage` is where snapshots are being stored
 * `target` is what to snapshot
 * `interval` is the inteval of snapshots deletion/"lifetime"
 * `display` is how the snapshot names would look like using GNU date
### Example
You make the cron run Tiny Photographer every hour and set the interval to 24. This means that if the snapshot was created today at 12:00, it will be deleted tomorrow at 12:00 if cron would run all of the 24 times. It is recommended to set multiple Tiny Photographers on different intervals.

Note: There is a pause feature that allows to stop Tiny Photographer at any time by creating a file or directory with `stop` in the name in the $STORAGE directory.
