#!/bin/bash
if [[ $ACTION = "add" ]]; then
	su kyle -c 'notify-send "Wii/3DS/Wii U SD card device added, adding MEGA syncronization."'
	su kyle -c 'mega-sync /run/media/kyle/SD\ CARD /SD\ Card\ Backup'

elif [[ $ACTION = "remove" ]]; then
	su kyle -c 'notify-send "Wii/3DS/Wii U SD card device removed, adding MEGA syncronization."'
	su kyle -c 'mega-sync -d "/run/media/kyle/SD CARD"'
fi
