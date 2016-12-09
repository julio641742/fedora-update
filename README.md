# fedora-update
Update indicator for Fedora Linux and GNOME Shell

## Features
- Optional update count display on panel
- Optional notification on new updates (defaults to off)
- Launcher for your favorite update command
- Comes in English, French, Czech, German, Spanish, Brazilian Portuguese, Italian, Polish, Romanian, Arabic, Slovak, Chinese, Serbian, Norwegian Bokmal, Russian languages. (Thanks translators !)

## One-click install
It's on extensions.gnome.org :
https://extensions.gnome.org/extension/???

## Without Password Prompt

The authorization is done by pkexec. Therefore if you would like to be able to start dnf services without getting prompted for a password, you will have to configure a polkit policy. The policy file org.freedesktop.policykit.pkexec.fedora-update.policy would allow the execution of dnf [check-update|list updates] without a password confirmation. Just copy the file in your polkit policy folder (usually: /usr/share/polkit-1/actions).

## Manual install
To install, simply download as zip and unzip contents in ~/.local/share/gnome-shell/extensions/fedora-update@julio641742
To install, simply download and execute "make install"

## Changes

### v1
First version

## Credits
Forked from https://github.com/RaphaelRochet/arch-update

