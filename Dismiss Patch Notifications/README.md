# Dismiss Patch Notifications
If you track a lot of Patch Definitions in Jamf Pro, 
you might know the issue of having an overcrowded
Notification Panel, when you come back from your well
deserved holidays or another leave of absence.

Jamf Pro's Web UI unfortunately does not (yet?) offer
a "Dismiss All" button. That's where this script comes
in handy!

## What it does
The script will first ask for the name of your
Jamf Cloud hosted instance of Jamf Pro.
Only the name is required. You can leave out
the ".jamfcloud.com"-part.

After that, it will ask for user credentials.
Make sure the user you choose has permissions to
delete notifications.

The script will now request a bearer token,
parse all `PATCH_UPDATE` type notification ID's
into a file and loop through this generated list
of notification ID's to remove them from Jamf Pro.

Since this has to be done for every ID individually,
this step might take a minute or so to finish,
if you have hundreds of notifications.

## Wanna-do's
- [ ] Add a Shortcuts workflow based on [Jamf Actions](https://github.com/Jamf-Concepts/actions)
- [ ] Program a Swift app
