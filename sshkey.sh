#!/bin/bash
# ssh public key script
echo -n "Enter your github email "
read email

echo -n "Pastebin api key "
read key

paste_code=$(<$HOME/.ssh/id_rsa.pub)
enconded_paste_code=$(printf %s "$paste_code" | jq -s -R -r @uri)

if [ -f "$HOME/.ssh/id_rsa.pub" ]; then
   cat $HOME/.ssh/id_rsa.pub
   echo -e "\n\n" && curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "api_dev_key=$key&api_option=paste&api_paste_code=$enconded_paste_code&api_paste_private=1" https://pastebin.com/api/api_post.php && echo -e "\n\n"
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
else
   ssh-keygen -t rsa -b 4096 -C $email
   eval "$(ssh-agent -s)"
   ssh-add $HOME/.ssh/id_rsa
   cat $HOME/.ssh/id_rsa.pub
   echo -e "\n\n" && curl -X POST -H "Content-Type: application/x-www-form-urlencoded" -d "api_dev_key=$key&api_option=paste&api_paste_code=$enconded_paste_code&api_paste_private=1" https://pastebin.com/api/api_post.php && echo -e "\n\n"
   echo -e "\n ====> https://github.com/settings/ssh/new \n"
fi
