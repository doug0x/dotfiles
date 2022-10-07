#!/bin/bash
echo -e "\n++++ STARTING ++++\n"

sudo pacman -Sy
yes | sudo pacman -S xorg-server xorg-xinit nvidia xf86-video-amdgpu
echo -e "export DESKTOP_SESSION=plasma\nexec startplasma-x11" >> $HOME/.xinitrc

# normal use apps
yes | sudo pacman -S atril unzip gedit deepin-screenshot deepin-image-viewer wget obs-studio openssh

# serious business apps
yes | sudo pacman -S neovim github-cli jdk17-openjdk java17-openjfx jre17-openjdk python-pip xsel alacritty kitty tmux npm fish swi-prolog unixodbc

# more packages
yes | sudo pacman -S docker docker-compose git-lfs
# texstudio texlive-most code

# nvim support
sudo npm i -g neovim 
sudo npm i -g yarn
sudo npm i -g pyright
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
cd $HOME/git/toolazy/got

# fzf
if [ -f "/usr/bin/fish" ]; then
   yes | bash $HOME/.clones/fzf/install
else
   yes | sudo pacman -S fish
   yes | bash $HOME/.clones/fzf/install
fi

# TMUX
mkdir -p $HOME/.config/tmux/plug
cp tmux/tmux.conf $HOME/.tmux.conf

# ALACRITTY
cp alacritty-conf.yml $HOME/.alacritty.yml

mkdir -p $HOME/.config/nvim/settings
mkdir $HOME/.config/nvim/plugs
mkdir $HOME/.config/nvim/keys

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
cp kde/* $HOME/.config/

echo -e "\n[Containments][22][Wallpaper][org.kde.image][General]\n
Image=file://$HOME/git/toolazy/got/wp.jpg\n
SlidePaths=$HOME/.local/share/wallpapers,/usr/share/wallpapers\n" >> $HOME/.config/plasma-org.kde.plasma.desktop-appletsrc

echo -e "\n[Wallpapers]\nusersWallpapers=$HOME/git/toolazy/got/wp.jpg" >> $HOME/.config/plasmarc

echo -e "\nMenuBar=Disabled\nToolBarsMovable=Disabled" >> $HOME/.config/systemsettingsrc

cd $HOME/.clones
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -si
sudo systemctl reboot
