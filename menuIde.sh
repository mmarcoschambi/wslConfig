#!/bin/bash

#Display a dialog box to select the IDE
#dialog --menu "Select IDE" 10 40 2 1 "VSC" 2 "WEBSTORM" 2>/tmp/ide_choice

dialog --backtitle "Select IDE" --title "Select IDE" --menu "Choose IDE:" 10 40 2 1 "VSC" 2 "WEBSTORM" 2>/tmp/ide_choice



# Read the user's choice from the temporary file
IDE_CHOICE=$(cat /tmp/ide_choice)

# Open the selected IDE using "code ." command
case $IDE_CHOICE in
	  1) code . ;;
	  2) webstorm . ;;
esac
	    
# Remove the temporary file
	    rm /tmp/ide_choice


