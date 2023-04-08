#!/bin/bash

GIT_DIR=$(find $HOME -name "git" -type d)

findGitFile() {
   find $GIT_DIR -name $1 -type f
}

findDir() {
   find $GIT_DIR -name $1 -type d
}

createSymlink () {
   ln -s $(findGitFile $1) $2
}

mkdir $HOME/.clones
mkdir $HOME/.i3
sudo mkdir -p /usr/local/share/lombok
distro=$(grep -E '^(PRETTY_NAME|NAME)=' /etc/os-release)

sudo pacman -S --noconfirm i3 xorg xorg-xinit neovim tmux alacritty ttf-dejavu mpv
sudo pacman -S --noconfirm openjdk17-doc java17-openjfx stack haskell-language-server 
sudo pacman -S --noconfirm fish tree mariadb dbeaver lazygit wget uvicorn unzip
sudo pacman -S --noconfirm github-cli docker docker-compose cabal-install
sudo pacman -S --noconfirm neofetch npm atril deepin-image-viewer deepin-screenshot
sudo pacman -S --noconfirm nvidia xf86-video-amdgpu obs-studio code

if [[ $distro == *'Parabola'* ]]; then
   sudo pacman -S --noconfirm icecat
   echo "bindsym \$mod1+g exec icecat" >> ./.i3/config

elif [[ $distro == *'Arch'* ]]; then
   git clone https://aur.archlinux.org/google-chrome.git $HOME/.clones/google-chrome
   (cd $HOME/.clones/google-chrome && yes | makepkg -si)
   echo "bindsym \$mod1+g exec google-chrome-stable" >> ./.i3/config
fi
echo "exec i3" > $HOME/.xinitrc

pip install mariadb mypy telebot yfinance python-binance 
sudo npm i -g neovim pyright sass node-fetch 

while read repo; do
   dir="$(echo "$repo" | awk -F '/' '{print $NF}')"
   git clone https://github.com/"$repo" "$HOME/.clones/$dir"
done < packages/repos.txt

yes | sh $HOME/.clones/fzf/install
curl -fLo ~/.vim/plug/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo wget https://projectlombok.org/downloads/lombok.jar \
   -O /usr/local/share/lombok/lombok.jar
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

createSymlink ".alacritty.yml" "$HOME"
createSymlink ".gitconfig" "$HOME"
createSymlink ".tmux.conf" "$HOME"
createSymlink ".vimrc" "$HOME"
createSymlink ".gitconfig" "$HOME"
createSymlink "coc-settings.json" "$HOME/.vim"
createSymlink "config.fish" "$HOME/.config/fish"
createSymlink "config" "$HOME/.i3"
createSymlink ".i3status.conf" "$HOME"

# Fish functions link
for fun in $(findDir "functions")/*; do
   ln -s $fun $HOME/.config/fish/functions
done

nvim -u ~/.vimrc -c "PlugInstall" -c "sleep 30" \
   -c "q!" -c "q!"

nvim -u ~/.vimrc -c "autocmd VimEnter * CocInstall coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp | sleep 180 | q! | q!"
