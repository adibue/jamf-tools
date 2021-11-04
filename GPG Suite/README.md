# GPG Mail Serializer

This serializer script can be used to easily add license information for GPG Mail
as a postinstall script.

## Usage

Add a new script in Jamf Pro under _"Settings > Computer Management > Scripts"_ and
give it a name, e.g. "gpgMailSerializer.sh".

Under _"Options"_, set "_Priority_" to "_After_", then tag "_Parameter 4_" with
`Activation Mail` and "_Parameter 5_" with `Activation Code`. Don't forget to save.

The result should now look like this:
