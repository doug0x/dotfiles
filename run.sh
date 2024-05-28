#!/bin/bash

DISTRO=$(grep -E '^(NAME)=' /etc/os-release)
GIT_DIR=$(find $HOME -name "denv" -type d)

mkdir $HOME/.clones; mkdir -p $HOME/.config/fish/functions; mkdir $HOME/.config/nvim
sudo mkdir -p /usr/local/share/lombok

findGitFile() {
   find $GIT_DIR -name $1 -type f
}

findDir() {
   find $GIT_DIR -name $1 -type d
}

createSymlink () {
   ln -s $(findGitFile $1) $2
}

if [[ $DISTRO == *'Arch'* ]]; then
   mkdir $HOME/.i3

   echo "exec i3" > $HOME/.xinitrc
   ln -s $(findGitFile "config" | sed -n '2p') $HOME/.i3
   createSymlink ".i3status.conf" $HOME
   createSymlink "script.sh" $HOME/.i3
   createSymlink "low_battery.sh" $HOME/.i3
   createSymlink "sinking.mp3" $HOME/.i3
   createSymlink "capsmap" $HOME/.i3
   createSymlink ".picom.conf" $HOME
   ln -s .i3/wks-flow.md $HOME

   sh $(findGitFile "services.sh")
fi

sudo update-alternatives --set java /usr/lib/jvm/java-1.$JAVA_VERSION.0-openjdk-amd64/bin/java
sudo update-alternatives --set javac /usr/lib/jvm/java-1.$JAVA_VERSION.0-openjdk-amd64/bin/javac
sudo npm i -g neovim pyright

while read REPO; do
   DIR="$(echo "$REPO" | awk -F '/' '{print $NF}')"
   git clone https://github.com/$REPO $HOME/.clones/$DIR
done < packages/repos.txt

sudo wget https://projectlombok.org/downloads/lombok.jar \
   -O /usr/local/share/lombok/lombok.jar
curl -fLo ~/.vim/plug/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# standard links
createSymlink ".alacritty.toml" $HOME
createSymlink ".tmux.conf" $HOME
createSymlink ".vimrc" $HOME
createSymlink "coc-settings.json" $HOME/.config/nvim
createSymlink "config.fish" $HOME/.config/fish

# Fish functions link
for FUN in $(findDir "functions")/*; do
   ln -s $FUN $HOME/.config/fish/functions
done

nvim -u ~/.vimrc -c "PlugInstall" -c "sleep 30" -c "q!" -c "q!"
nvim -u ~/.vimrc -c "autocmd VimEnter * CocInstall coc-tsserver coc-java coc-json coc-pyright \
   coc-git coc-sh coc-git coc-html coc-css coc-snippets coc-vimlsp | sleep 180 | q! | q!"

