#!/bin/bash
echo "++++ STARTING ++++"
sudo pacman -Sy
sudo pacman -S xorg-server nvidia xf86-video-amdgpu sddm

sudo systemctl enable sddm

sudo pacman -S plasma mpv atril neovim gedit deepin-screenshot fzf deepin-image-viewer python-pip xsel alacritty tmux npm fish wget obs
# swi-prolog unixodbc texstudio texlive-most code

# node support
sudo npm i -g neovim 

# for coc
sudo npm i -g yarn
sudo npm i -g pyright

# python support
sudo pip install pynvim 

# hidden folders are here
mkdir /home/douglas/.config
mkdir /home/douglas/.clones

cd /home/douglas/.clones
repos=("Prayag2/kde_onedark"
   "junegunn/fzf"
   "tmux-plugins/tpm"
   "tmux-plugins/tmux-sensible"
   "egel/tmux-gruvbox"
   )
for str in ${repos[@]}; do
   git clone https://github.com/$str
done
cd /home/toolazy/got

# TERMINAL
mkdir /home/douglas/git

# fzf
bash /home/douglas/.clones/fzf/install

# TMUX
mkdir /home/douglas/.config/tmux
mkdir /home/douglas/.config/tmux/plug
mkdir /home/douglas/.config/fish/conf.d

cp tmux-conf.txt /home/douglas/.tmux.conf
touch /home/douglas/.config/fish/conf.d/tmux.fish

echo "
if not set -q TMUX
    set -g TMUX tmux new-session -d -s develop
    eval $TMUX
    tmux attach-session -d -t develop
end" > /home/douglas/.config/fish/conf.d/tmux.fish

# ALACRITTY
cp alacritty-conf.txt /home/douglas/.alacritty.yml

# bashrc and bash_profile
echo "
alias up='sudo pacman -Syyu'
alias vv='nvim'" > /home/douglas/.bashrc

echo "
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8

# Git branch in prompt.
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1=\"\W\[\033[31m\]\$(parse_git_branch)\[\033[00m\]  \"" > /home/douglas/.bash_profile


echo "++++ STARTING NVIM CONFIG ++++"

mkdir /home/douglas/.config/nvim
mkdir /home/douglas/.config/nvim/settings
mkdir /home/douglas/.config/nvim/plugs
mkdir /home/douglas/.config/nvim/keys

cd /home/douglas/.config/nvim/plugs

# nvim-cmp plugins
repos=("junegunn/vim-plug"
      "hrsh7th/cmp-buffer"
      "neovim/nvim-lspconfig"
      "hrsh7th/cmp-nvim-lsp"
      "hrsh7th/cmp-path"
      "hrsh7th/cmp-cmdline"
      "hrsh7th/nvim-cmp"
      "hrsh7th/cmp-vsnip"
      "hrsh7th/vim-vsnip"
      "nvim-treesitter/nvim-treesitter")
for str in ${repos[@]}; do
   git clone https://github.com/$str
done
cd /home/toolazy/got

sudo mkdir /usr/local/share/lombok
sudo wget https://projectlombok.org/downloads/lombok.jar -O /usr/local/share/lombok/lombok.jar

cp kglobalshortcutsrc /home/douglas/.config kglobalshortcutsrc
cp plugin.vim /home/douglas/.config/nvim/plugs/plugin-config.vim
cp settings.vim /home/douglas/.config/nvim/settings/settings.vim
cp mappings.vim /home/douglas/.config/nvim/keys/mappings.vim
cp coc.vim /home/douglas/.config/nvim/plugs/coc.vim
cp init.vim /home/douglas/.config/nvim/init.vim

cd /home/douglas/.clones
git clone https://aur.archlinux.org/google-chrome.git
cd google-chrome/
makepkg -s
cd /home/toolazy/got

echo ""
echo ""
echo "===>DONE"
