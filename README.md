
# BatMon -- Laptop battery charge minder for Ubuntu and friends.

## Introduction

BatMon is a bash shell script that checks the battery variables under the `/sys` filesystem and gives audio-visual notification to toggle your laptop battery charger.  It has been tested for Ubuntu 16.04 and the Gnome desktop.

## Usage

Before starting to use BatMon, you can test it using its test mode.  Run `batmon.sh test` on a command line.  You should be able to review and verify the audio-visual notifications.  On successful review/verification, proceed to the following step. 

Copy batmon.sh to `/usr/local/bin` (or to `~/bin`).  Start it as follows:

``` code
daemon -n BatMon </full/path/to/batmon.sh>
```
Ideally, you should start BatMon using the _Startup Application_ facility of your GUI/Desktop to get all notifications correctly.

To check the status of the BatMon service, and to stop it, respectively -- issue the following commands:

``` code
daemon -n BatMon --verbose --running

daemon -n BatMon --verbose --stop
```
## Modifying BatMon

Some suggestions:

* Localize the notification text.
* Change the battery charge limits.
* Change the notification mechanism to suit your Desktop/Distribution.

