#!/bin/bash

# desk-env
sudo pacman -S pcmanfm openbox lxtask lxsession lxrandr mpv lxlauncher lxinput lxhotkey lxde-common lxappearance lxappearance-obconf gpicview wget xorg-xinit
echo -e "export DESKTOP_SESSION=lxde\nexec startlxde" >> $HOME/.xinitrc

# additional for [de]
sudo pacman -S gtk-engines iceweasel

# serious business
yes | sudo pacman -S npm alacritty tmux neovim fish jdk17-openjdk java17-openjfx jre17-openjdk openjdk17-doc python-pip xsel tree lazygit
sudo archlinux-java set java-17-openjdk

# nvim support
sudo npm i -g neovim 
sudo npm i -g yarn
sudo npm i -g pyright
sudo pip install pynvim 

# creating custom folders here
mkdir $HOME/.clones
mkdir -p $HOME/.config/tmux/plug
mkdir -p $HOME/.config/nvim/settings
mkdir $HOME/.config/nvim/plugs
mkdir $HOME/.config/nvim/keys
mkdir -p $HOME/.config/lxsession/LXDE
mkdir $HOME/.config/openbox
mkdir -p $HOME/.config/pcmanfm/LXDE
mkdir $HOME/.config/autostart
mkdir $HOME/.config/gtk-3.0 

cd $HOME/.clones
repos=("junegunn/fzf"
   "tmux-plugins/tpm"
   "tmux-plugins/tmux-sensible"
   "egel/tmux-gruvbox"
   )
for str in ${repos[@]}; do
   git clone https://github.com/$str
done
cd $HOME/git/toolazy/got

# fzf
if [ -f "/usr/bin/fish" ]; then
   yes | bash $HOME/.clones/fzf/install
else
   yes | sudo pacman -S fish
   yes | bash $HOME/.clones/fzf/install
fi

# TMUX
cp tmux/tmux.conf $HOME/.tmux.conf

# ALACRITTY
cp alacritty-conf.yml $HOME/.alacritty.yml

cd $HOME/.config/nvim/plugs
git clone https://github.com/junegunn/vim-plug
cd $HOME/git/toolazy/got

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

sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/
cp openbox/lxde-rc.xml $HOME/.config/openbox/
cp openbox/lxsession/* $HOME/.config/lxsession/LXDE/
cp openbox/pcmanfm/* $HOME/.config/pcmanfm/LXDE/
cp openbox/autostart/* $HOME/.config/autostart/
cp openbox/settings.ini $HOME/.config/gtk-3.0/
echo -e "\nwallpaper=$HOME/git/toolazy/got/wp.jpg" >> $HOME/.config/pcmanfm/LXDE/desktop-items-0.conf
