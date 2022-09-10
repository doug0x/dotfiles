#!/bin/bash
echo "++++ STARTING ++++"
echo ""
echo ""
echo -n "Enter your user: "
read user

sudo pacman -Sy
yes | sudo pacman -S xorg-server nvidia xf86-video-amdgpu sddm
sudo systemctl enable sddm
sudo pacman -S plasma

# normal use apps
yes | sudo pacman -S atril unzip gedit deepin-screenshot deepin-image-viewer wget obs-studio

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
mkdir /home/$user/.clones
mkdir /home/$user/git

cd /home/$user/.clones
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
   yes | bash /home/$user/.clones/fzf/install
else
   yes | sudo pacman -S fish
   yes | bash /home/$user/.clones/fzf/install
fi

# TMUX
mkdir /home/$user/.config/tmux
mkdir /home/$user/.config/tmux/plug
mkdir /home/$user/.config/fish/conf.d

cp tmux.conf /home/$user/.tmux.conf
touch /home/$user/.config/fish/conf.d/tmux.fish

echo "
if not set -q TMUX
    set -g TMUX tmux new-session -d -s develop
    eval $TMUX
    tmux attach-session -d -t develop
end" >> /home/$user/.config/fish/conf.d/tmux.fish

# ALACRITTY
cp alacritty-conf.yml /home/$user/.alacritty.yml
echo ""
echo ""
echo "++++ STARTING NVIM CONFIG ++++"
echo ""
echo ""
mkdir /home/$user/.config/nvim
mkdir /home/$user/.config/nvim/settings
mkdir /home/$user/.config/nvim/plugs
mkdir /home/$user/.config/nvim/keys

cd /home/$user/.config/nvim/plugs
git clone https://github.com/junegunn/vim-plug
cd /home/toolazy/got

sudo mkdir /usr/local/share/lombok
sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar

cp kglobalshortcutsrc /home/$user/.config/kglobalshortcutsrc
cp nvim/plugins.vim /home/$user/.config/nvim/plugs/
cp nvim/settings.vim /home/$user/.config/nvim/settings/
cp nvim/mappings.vim /home/$user/.config/nvim/keys/
cp nvim/coc.vim /home/$user/.config/nvim/plugs/
cp nvim/init.vim /home/$user/.config/nvim/
cp nvim/coc-settings.json /home/$user/.config/nvim/
cp fish/config.fish /home/$user/.config/fish/
cp fish/functions/* /home/$user/.config/fish/functions/

cd /home/$user/.clones
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -s
gg=$(find -name "*.zst")
yes | sudo pacman -U $gg
cd /home/toolazy/got
echo ""
echo ""
echo "===>DONE"
sudo systemctl reboot
