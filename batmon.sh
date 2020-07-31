#!/bin/bash
# <BatMon - Laptop Battery Charge Minder for Ubuntu/Linux>
# Copyright (C) <2020>  <Author: github.com/prog-veda>
# SPDX-License-Identifier: GPL-3.0-or-later
# https://www.gnu.org/licenses/gpl-3.0.html

# Uses battery status variables to prompt for toggling the charger.
# Prompts you with audio-visual notifications to toggle battery charger.

# Copy this to /usr/local/bin.
# Start this as a daemon with the following command:
#   /usr/bin/daemon -n BatMon  /usr/local/bin/batmon.sh
# To check the status of the battery monitor:
#   /usr/bin/daemon -n BatMon --verbose --running


# ------- Battery Variables
BatCapPath="/sys/class/power_supply/BAT0/capacity"  ## Path for battery info
BatStatPath="/sys/class/power_supply/BAT0/status"   
ChargingFlag="Charging"
DischargingFlag="Discharging"
HiLim=70   # Charge limits
LoLim=45

# ------- Notification command, etc to suit your Desktop
notify_command="/usr/bin/notify-send BatMon"
audio_player="/usr/bin/paplay"
polling_interval=180

# ------- Notification messages and sounds
switch_off_msg="SWITCH **OFF** CHARGER"
switch_on_msg="SWITCH **ON** CHARGER"
up_msg="Battery Monitor is UP"
switch_off_sound=/usr/share/sounds/freedesktop/stereo/complete.oga
switch_on_sound=/usr/share/sounds/freedesktop/stereo/bell.oga

# ------- Test Mode and Help --------------------------
if [ "$1" =  "test" ] ; then
	echo "[TEST] Running."
	${notify_command} "${up_msg}"
	/bin/sleep 5
	echo "[TEST] You should now note the switch-on notification and sound."
	${notify_command} "${switch_on_msg}"
	${audio_player} ${switch_on_sound}
	/bin/sleep 5
	echo "[TEST] You should now note the switch-off notification and sound."
	${notify_command} "${switch_off_msg}"
	${audio_player} ${switch_off_sound}
	/bin/sleep 5
	BatCap=`head ${BatCapPath}`        ## Current capacity %
	BatStatus="`head ${BatStatPath}`"  ## Current status dis/charging
	echo "[TEST] Battery charge is: ${BatCap}(+/-1)%. Status is: ${BatStatus}."
	echo "[TEST] Is this correct?  Toggle charger and rerun this test if necessary".
	echo "[TEST] End."
	exit
elif [ "$1" = "help" ] ; then
	_prog_name=${0##*/}
	echo "Usage 1: ${_prog_name} test  to exercise the test mode."
	echo "Usage 2: daemon -n BatMon `pwd`/${_prog_name}  to start this as a daemon."
	echo "Usage 3: ${_prog_name} help  to print this help message."
	exit
fi

/bin/sleep ${polling_interval}  ## Time for user GUI session to settle down.
${notify_command} "${up_msg}"

# ------- Main loop in polling mode
while [ 1 ] ; do

	BatCap=`head ${BatCapPath}`        ## Current capacity %
	BatStatus="`head ${BatStatPath}`"  ## Current status dis/charging

	if [ $BatCap -gt $HiLim ] && [ $BatStatus = ${ChargingFlag} ] ; then
		#echo "Switch **OFF** Charger."
		${notify_command} "${switch_off_msg}"
		${audio_player} ${switch_off_sound}
		${audio_player} ${switch_off_sound}
	elif [ $BatCap -lt $LoLim ] && [ $BatStatus = ${DischargingFlag} ] ; then
		#echo "Switch **ON** Charger."
		${notify_command} "${switch_on_msg}"
		${audio_player} ${switch_on_sound}
		${audio_player} ${switch_on_sound}
	fi
	
	/bin/sleep ${polling_interval}  ## Sleep until next poll
done
	
