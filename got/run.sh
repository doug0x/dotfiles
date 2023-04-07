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

sudo pacman -S i3 xorg xorg-xinit neovim tmux alacritty ttf-dejavu \ 
   mpv nvidia xf86-video-amdgpu npm atril deepin-image-viewer deepin-screenshot \ 
   openjdk17-doc java17-openjfx maven stack haskell-language-server stack \ 
   docker docker-compose fish tree mariadb dbeaver lazygit wget uvicorn unzip \
   obs-studio code github-cli neofetch --noconfirm 
echo "exec i3" >> $HOME/.xinitrc

pip install mariadb mypy telebot yfinance python-binance 
sudo npm i -g neovim pyright sass node-fetch 

while read repo; do
   dir="$(echo "$repo" | awk -F '/' '{print $NF}')"
   git clone https://github.com/"$repo" "$HOME/.clones/$dir"
done < packages/repos.txt

git clone https://aur.archlinux.org/google-chrome.git $HOME/.clones/google-chrome
(cd $HOME/.clones/google-chrome && yes | makepkg -si)

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

# Fish functions link
for fun in $(findDir "functions")/*; do
   ln -s $fun $HOME/.config/fish/functions
done

nvim -u ~/.vimrc -c "PlugInstall" -c "sleep 15" \
   -c "q!" -c "q!"

nvim -u ~/.vimrc \ 
   -c "CocInstall coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp coc-texlab" \
   -c "sleep 35" -c "q!" -c "q!"
