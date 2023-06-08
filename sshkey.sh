#!/bin/bash
# ssh public key script
echo -n "Enter your github email "
read email
if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
   cat $HOME/.ssh/id_rsa.pub
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
else
   ssh-keygen -t rsa -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add $HOME/.ssh/id_rsa
   cat $HOME/.ssh/id_rsa.pub
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
fi
