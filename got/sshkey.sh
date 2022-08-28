#!/bin/bash
# ssh public key script
echo -n "Enter your user "
read user
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

echo "Your user is [$user] and key is [$key], right?"
select opt in "Yes" "No"; do
   case $opt in
      Yes )
         if [ -f "/home/$user/.ssh/id_$key.pub" ]; then
            cp /home/$user/.ssh/id_$key.pub /home/douglas/sshkey.txt
            echo "Your ssh public key is on home, named as \"sshkey\""
            echo "do it: https://github.com/settings/ssh/new"
         else
            ssh-keygen -t $key -b 4096 -C $email
            eval "$(ssh-agent -s)"
            ssh-add /home/$user/.ssh/id_$key
            cp /home/$user/.ssh/id_$key.pub /home/douglas/sshkey.txt
            echo "Your ssh public key is on home, named as \"sshkey\""
            echo "do it: https://github.com/settings/ssh/new"
         fi
         break;;
      No ) echo "NOOB!"
         exit;;
   esac
done
