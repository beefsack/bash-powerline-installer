#!/usr/bin/env bash

POWERLINE_PACKAGE=powerline-status
BOLD=$(tput bold)
PLAIN=$(tput sgr0)

echo "${BOLD}Checking if pip is available$PLAIN"
if ! hash pip 2>/dev/null
then
	echo "$BOLD\`pip\` not found, please install python-pip using your package manager$PLAIN"
	exit 1
fi

echo "${BOLD}Installing $POWERLINE_PACKAGE$PLAIN"
sudo pip install --upgrade "$POWERLINE_PACKAGE"
if [ $? -ne 0 ]
then
	echo "${BOLD}Failed to install $POWERLINE_PACKAGE$PLAIN"
fi

PACKAGE_LOCATION=$(pip show "$POWERLINE_PACKAGE" | grep Location: | cut -d ' ' -f 2-)
if [ $? -ne 0 ]
then
	echo "${BOLD}Could not find location of $POWERLINE_PACKAGE"
	exit 2
fi

POWERLINE_CONFIG_DIR="$HOME/.config/powerline"
echo "${BOLD}Creating powerline configs in $HOME$PLAIN"
mkdir -p "$POWERLINE_CONFIG_DIR/themes/shell"
echo "{
	\"ext\": {
		\"shell\": {
			\"theme\": \"default_leftonly\"
		}
	}
}" > "$POWERLINE_CONFIG_DIR/config.json"
echo "{
	\"segment_data\": {
		\"cwd\": {
			\"args\": {
				\"dir_limit_depth\": 1,
				\"ellipsis\": null
			}
		},
		\"branch\": {
			\"args\": {
				\"status_colors\": true
			}
		}
	}
}" > "$POWERLINE_CONFIG_DIR/themes/shell/default_leftonly.json"

echo "${BOLD}Installing new bashrc$PLAIN"
echo "alias ls='ls --color=auto'
powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1
. \"$PACKAGE_LOCATION/powerline/bindings/bash/powerline.sh\"" > $HOME/.bashrc
source "$HOME/.bashrc"
echo "${BOLD}Installation complete, you may want to install a powerline compatible font for your terminal emulator from https://github.com/powerline/fonts$PLAIN"
