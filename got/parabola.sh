#!/bin/bash

# desk-env
sudo pacman -S pcmanfm openbox lxtask lxsession lxrandr lxmusic lxlauncher lxinput lxhotkey lxdm lxde-common lxappearance lxappearance-obconf gpicview
sudo systemctl enable lxdm

# additional for de
sudo pacman -S gtk-engines iceweasel

# serious business
yes | sudo pacman -S npm alacritty tmux neovim fish jdk17-openjdk java17-openjfx jre17-openjdk python-pip xsel

sudo npm i -g neovim 

# for coc
sudo npm i -g yarn
sudo npm i -g pyright

# nvim python support
sudo pip install pynvim 

# creating custom folders here
mkdir $HOME/.clones

cd $HOME/.clones
repos=("junegunn/fzf"
   "tmux-plugins/tpm"
   "tmux-plugins/tmux-sensible"
   "egel/tmux-gruvbox"
   )
for str in ${repos[@]}; do
   git clone https://github.com/$str
done
cd $HOME/git

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
cd $HOME/git

sudo mkdir /usr/local/share/lombok
sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar

cp nvim/plugins.vim $HOME/.config/nvim/plugs/
cp nvim/settings.vim $HOME/.config/nvim/settings/
cp nvim/mappings.vim $HOME/.config/nvim/keys/
cp nvim/coc.vim $HOME/.config/nvim/plugs/
cp nvim/init.vim $HOME/.config/nvim/
cp nvim/coc-settings.json $HOME/.config/nvim/
cp fish/config.fish $HOME/.config/fish/
cp fish/functions/* $HOME/.config/fish/functions/

cp openbox/30-touchpad.conf /etc/X11/xorg.conf.d/
cp openbox/lxde-rc.xml $HOME/.config/openbox/
cp openbox/lxsession/* $HOME/.config/lxsession/LXDE/
cp openbox/pcmanfm/* $HOME/.config/pcmanfm/LXDE/
cp openbox/autostart/* $HOME/.config/autostart/
cp openbox/settings.ini $HOME/.config/gtk-3.0/
