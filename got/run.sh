#!/bin/bash

GIT_DIR=$(find $HOME -name "git" -type d)

findGitFile() {
   find $GIT_DIR -name $1
}

findDir() {
   find $GIT_DIR -name $1 -type d
}

createSymlink () {
   ln -s $(findGitFile $1) $2
}

mkdir $HOME/.clones
sudo mkdir -p /usr/local/share/lombok

sudo pacman -S plasma mpv wget xorg-xinit xorg-server nvidia xf86-video-amdgpu npm
echo -e "export DESKTOP_SESSION=plasma\nexec startplasma-x11" >> $HOME/.xinitrc

while read package; do
   yes | sudo pacman -S "$package"
done < packages/os_packages.txt
while read package; do
   pip install "$package"
done < packages/pip_packages.txt
while read package; do
   sudo npm i -g "$package"
done < packages/npm_packages.txt
while read repo; do
   dir="$(echo "$repo" | awk -F '/' '{print $NF}')"
   git clone https://github.com/"$repo" "$HOME/.clones/$dir"
done < packages/repos.txt

git clone https://aur.archlinux.org/google-chrome.git $HOME/.clones/google-chrome
(cd $HOME/.clones/google-chrome && yes | makepkg -si)

yes | sh $HOME/.clones/fzf/install
yes | sh $HOME/.clones/kde_onedark/install
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

# Fish functions link
for fun in $(findDir "functions")/*; do
   ln -s $fun $HOME/.config/fish/functions
done

nvim -u ~/.vimrc -c "PlugInstall" -c "sleep 15" \
   -c "q!" -c "q!"

nvim -u ~/.vimrc \ 
   -c "CocInstall coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp coc-texlab" \
   -c "sleep 35" -c "q!" -c "q!"

# Packages
# pacman -Qent | grep -o '^[^ ]*' > packages/os_packages.txt
# pip list --user | awk '{print $1}' > packages/pip_packages.txt
# npm list -g --depth=0 | grep -o '^[^@]*' | awk -F/ '{print $NF}' > packages/npm_packages.txt
