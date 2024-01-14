#!/bin/bash

DISTRO=$(grep -E '^(NAME)=' /etc/os-release)
GIT_DIR=$(find $HOME -name "toolazy" -type d)

mkdir $HOME/.clones; mkdir $HOME/.i3; mkdir -p $HOME/.config/fish/functions; mkdir $HOME/.config/nvim
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


if [[ $distro == *'Ubuntu'* ]]; then
   sudo apt install -y neovim fzf fish mariadb-server mariadb-client nmap npm  \
      openjdk-17-jdk openjdk-17-jre fonts-firacode mpv

elif [[ $distro == *'Arch'* ]]; then
   git clone https://aur.archlinux.org/google-chrome.git $HOME/.clones/google-chrome
   (cd $HOME/.clones/google-chrome; makepkg -si --noconfirm)

   sudo pacman -S --noconfirm xorg xorg-xinit neovim tmux alacritty ttf-fira-code mpv
   sudo pacman -S --noconfirm openjdk17-doc java17-openjfx stack haskell-language-server 
   sudo pacman -S --noconfirm fish tree mariadb dbeaver lazygit wget uvicorn unzip redshift
   sudo pacman -S --noconfirm fzf github-cli docker docker-compose cabal-install acpi
   sudo pacman -S --noconfirm neofetch npm atril deepin-image-viewer deepin-screenshot
   sudo pacman -S --noconfirm nvidia xf86-video-amdgpu obs-studio code python-pip pulseaudio
   sudo pacman -S --noconfirm dotnet-sdk mono nmap jq gridsite-clients

   sudo pacman -S --noconfirm i3 feh pavucontrol picom
   echo "exec i3" > $HOME/.xinitrc
   ln -s $(findGitFile "config" | sed -n '2p') $HOME/.i3
   createSymlink ".i3status.conf" "$HOME"
   createSymlink "script.sh" "$HOME/.i3"
   createSymlink "low_battery.sh" "$HOME/.i3"
   createSymlink "sinking.mp3" "$HOME/.i3"
   createSymlink "capsmap" "$HOME/.i3"
   createSymlink ".picom.conf" "$HOME"
   ln -s .i3/wks-flow.md $HOME

   (cd ~/.clones; git clone https://aur.archlinux.org/mono-msbuild-git.git; \
      cd mono-msbuild-git; makepkg -si --noconfirm)

   sudo wget https://projectlombok.org/downloads/lombok.jar \
      -O /usr/local/share/lombok/lombok.jar

   sh $(findGitFile "services.sh")
fi

sudo npm i -g neovim pyright

while read REPO; do
   DIR="$(echo "$REPO" | awk -F '/' '{print $NF}')"
   git clone https://github.com/"$REPO" "$HOME/.clones/$DIR"
done < packages/repos.txt

curl -fLo ~/.vim/plug/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# standard links
createSymlink ".alacritty.yml" "$HOME"
createSymlink ".gitconfig" "$HOME"
createSymlink ".tmux.conf" "$HOME"
createSymlink ".vimrc" "$HOME"
createSymlink ".gitconfig" "$HOME"
createSymlink "coc-settings.json" "$HOME/.config/nvim"
createSymlink "config.fish" "$HOME/.config/fish"

# Fish functions link
for FUN in $(findDir "functions")/*; do
   ln -s $FUN $HOME/.config/fish/functions
done

nvim -u ~/.vimrc -c "PlugInstall" -c "sleep 30" -c "q!" -c "q!"
nvim -u ~/.vimrc -c "OmniSharpInstall" -c "sleep 30" -c "q!" -c "q!"
nvim -u ~/.vimrc -c "autocmd VimEnter * CocInstall coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp | sleep 180 | q! | q!"

