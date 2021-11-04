#!/bin/bash

#variable for storing the current users name
currentuser=`stat -f "%Su" /dev/console`

#substituting as user stored in variable to modify plist
su "$currentuser" -c "defaults write org.gpgtools.gpgmail SupportPlanActivationEmail $4"
su "$currentuser" -c "defaults write org.gpgtools.gpgmail SupportPlanActivationCode $5"
su "$currentuser" -c "defaults write org.gpgtools.updater SUEnableAutomaticChecks NO"

exit 0
