#!/bin/bash

GIT_DIR=$(find $HOME -name "denv" -type d)

findGitFile() {
   find $GIT_DIR -name $1 -type f
}

#feh --bg-fill $(findGitFile "see.jpg")
xinput set-prop 13 "libinput Tapping Enabled" 1
xinput set-prop 17 "libinput Tapping Enabled" 1
picom
