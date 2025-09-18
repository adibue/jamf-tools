# Patch Notification Dismissal Automator

If you track a lot of Patch Definitions in Jamf Pro,
you might know the issue of having an overcrowded
Notification Panel, when you come back from your well
deserved holidays or another leave of absence.

Jamf Pro's Web UI unfortunately does not (yet?) offer
a "Dismiss All" button. That's where this script comes
in handy!

## What it does

It's very straight forward. The Script will guide you through the process.

Just download `dismiss-patch-notifications.zsh`and run it with
`zsh ./dismiss-patch-notifications.zsh` or use the following command in a Terminal to run it:

`curl -fsSL "https://adibue.dev/jp-notif" | zsh`

Happy cleaning! 😁

## Wanna-do's

- [ ] Add a Shortcuts workflow based on [Jamf Actions](https://github.com/Jamf-Concepts/actions)
- [ ] Program a Swift app
