#!/bin/bash
echo -e "\n++++ STARTING ++++\n"

sudo pacman -Sy
yes | sudo pacman -S xorg-server nvidia xf86-video-amdgpu
sudo pacman -S sddm plasma
sudo systemctl enable sddm

# normal use apps
yes | sudo pacman -S atril unzip gedit deepin-screenshot deepin-image-viewer wget obs-studio openssh

# serious business apps
yes | sudo pacman -S neovim github-cli jdk17-openjdk java17-openjfx jre17-openjdk python-pip xsel alacritty tmux npm fish swi-prolog unixodbc

# more packages
yes | sudo pacman -S docker docker-compose git-lfs
# texstudio texlive-most code

# node support
sudo npm i -g neovim 

# for coc
sudo npm i -g yarn
sudo npm i -g pyright

# nvim python support
sudo pip install pynvim 

# creating custom folders here
mkdir $HOME/.clones
mkdir $HOME/git

cd $HOME/.clones
repos=("junegunn/fzf"
   "tmux-plugins/tpm"
   "tmux-plugins/tmux-sensible"
   "egel/tmux-gruvbox"
   )
for str in ${repos[@]}; do
   git clone https://github.com/$str
done
cd /home/toolazy/got

# fzf
if [ -f "/usr/bin/fish" ]; then
   yes | bash $HOME/.clones/fzf/install
else
   yes | sudo pacman -S fish
   yes | bash $HOME/.clones/fzf/install
fi

# TMUX
mkdir $HOME/.config/tmux
mkdir $HOME/.config/tmux/plug
cp tmux/tmux.conf  $HOME/.tmux.conf

# ALACRITTY
cp alacritty-conf.yml $HOME/.alacritty.yml

mkdir $HOME/.config/nvim
mkdir $HOME/.config/nvim/settings
mkdir $HOME/.config/nvim/plugs
mkdir $HOME/.config/nvim/keys

cd $HOME/.config/nvim/plugs
git clone https://github.com/junegunn/vim-plug
cd /home/toolazy/got

sudo mkdir /usr/local/share/lombok
sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar

cp kglobalshortcutsrc $HOME/.config/kglobalshortcutsrc
cp nvim/plugins.vim $HOME/.config/nvim/plugs/
cp nvim/settings.vim $HOME/.config/nvim/settings/
cp nvim/mappings.vim $HOME/.config/nvim/keys/
cp nvim/coc.vim $HOME/.config/nvim/plugs/
cp nvim/init.vim $HOME/.config/nvim/
cp nvim/coc-settings.json $HOME/.config/nvim/
cp fish/config.fish $HOME/.config/fish/
cp fish/functions/* $HOME/.config/fish/functions/

cd $HOME/.clones
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -si
sudo systemctl reboot
