#!/bin/bash
# ssh public key script
echo -n "Enter your github email "
read email
echo "Which ssh key do you want?"
select key in "rsa" "ed25519"; do
   case $key in
      rsa )
         key=rsa break;;
      ed25519 )
         key=ed25519 break;;
   esac
done
if [ -f "$HOME/.ssh/id_$key.pub" ]; then
   echo $(cat $HOME/.ssh/id_$key.pub)
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
else
   ssh-keygen -t $key -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add $HOME/.ssh/id_$key
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
fi
