#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CLONES_DIR="${CLONES_DIR:-$HOME/.clones}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.config/dotfiles/backups/$(date +%Y%m%d-%H%M%S)}"

PROFILE="core"
INSTALL_PACKAGES=1
INSTALL_REPOS=1
INSTALL_PLUGINS=1
SET_FISH_SHELL=0
DRY_RUN=0

usage() {
   cat <<'USAGE'
Usage: ./run.sh [options]

Profiles:
  --profile core       Terminal dev setup: nvim, fish, tmux, alacritty, git tools.
  --profile desktop    Core setup plus i3, picom, feh, redshift, audio helpers.
  --profile full       Desktop setup plus optional workstation extras.

Supported distros: Ubuntu and Arch Linux.

Options:
  --no-packages        Only link dotfiles and run config steps.
  --no-repos           Skip cloning repositories from packages/repos.txt.
  --no-plugins         Skip vim-plug, Neovim plugins, Coc extensions, npm globals.
  --set-shell          Change the login shell to fish when possible.
  --dry-run            Print what would happen without making changes.
  -h, --help           Show this help.

Examples:
  ./run.sh
  ./run.sh --profile desktop --set-shell
  ./run.sh --profile core --no-packages
USAGE
}

log() {
   printf '\033[1;34m==>\033[0m %s\n' "$*"
}

warn() {
   printf '\033[1;33mwarn:\033[0m %s\n' "$*" >&2
}

die() {
   printf '\033[1;31merror:\033[0m %s\n' "$*" >&2
   exit 1
}

run() {
   if (( DRY_RUN )); then
      printf 'dry-run:'
      printf ' %q' "$@"
      printf '\n'
   else
      "$@"
   fi
}

need_command() {
   command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

parse_args() {
   while (($#)); do
      case "$1" in
         --profile)
            shift
            [[ $# -gt 0 ]] || die "--profile requires a value"
            PROFILE="$1"
            ;;
         --profile=*)
            PROFILE="${1#*=}"
            ;;
         --no-packages)
            INSTALL_PACKAGES=0
            ;;
         --no-repos)
            INSTALL_REPOS=0
            ;;
         --no-plugins)
            INSTALL_PLUGINS=0
            ;;
         --set-shell)
            SET_FISH_SHELL=1
            ;;
         --dry-run)
            DRY_RUN=1
            ;;
         -h|--help)
            usage
            exit 0
            ;;
         *)
            die "Unknown option: $1"
            ;;
      esac
      shift
   done

   case "$PROFILE" in
      core|desktop|full) ;;
      *) die "Invalid profile '$PROFILE'. Use core, desktop, or full." ;;
   esac
}

detect_distro() {
   [[ -r /etc/os-release ]] || die "Cannot detect distro because /etc/os-release is missing"
   # shellcheck disable=SC1091
   source /etc/os-release

   case "${ID:-}" in
      ubuntu)
         DISTRO_ID="ubuntu"
         ;;
      arch)
         DISTRO_ID="arch"
         ;;
      *)
         die "Unsupported distro '${PRETTY_NAME:-unknown}'. This installer supports only Ubuntu and Arch Linux."
         ;;
   esac
}

package_manifest() {
   local name="$1"
   printf '%s/packages/%s.%s.txt' "$DOTFILES_DIR" "$DISTRO_ID" "$name"
}

read_manifest() {
   local file="$1"
   [[ -f "$file" ]] || return 0
   sed -E 's/[[:space:]]*#.*$//' "$file" | awk 'NF {print $1}'
}

install_packages() {
   (( INSTALL_PACKAGES )) || {
      log "Skipping OS packages"
      return 0
   }

   local manifests=()
   manifests+=("$(package_manifest core)")

   case "$PROFILE" in
      desktop|full)
         manifests+=("$(package_manifest desktop)")
         ;;
   esac

   case "$PROFILE" in
      full)
         manifests+=("$(package_manifest full)")
         ;;
   esac

   local packages=()
   local manifest package
   for manifest in "${manifests[@]}"; do
      [[ -f "$manifest" ]] || continue
      while IFS= read -r package; do
         packages+=("$package")
      done < <(read_manifest "$manifest")
   done

   ((${#packages[@]})) || {
      warn "No packages found for $DISTRO_ID/$PROFILE"
      return 0
   }

   log "Installing ${DISTRO_ID} packages for '$PROFILE'"
   case "$DISTRO_ID" in
      ubuntu)
         run sudo apt-get update
         run sudo apt-get install -y "${packages[@]}"
         ;;
      arch)
         run sudo pacman -Syu --needed --noconfirm "${packages[@]}"
         ;;
   esac
}

link_path() {
   local source="$1"
   local target="$2"

   [[ -e "$source" ]] || die "Source path does not exist: $source"
   run mkdir -p "$(dirname "$target")"

   if [[ -L "$target" ]]; then
      local current
      current="$(readlink "$target")"
      if [[ "$current" == "$source" ]]; then
         log "Already linked: $target"
         return 0
      fi
   fi

   if [[ -e "$target" || -L "$target" ]]; then
      local backup="$BACKUP_DIR/${target#$HOME/}"
      log "Backing up $target to $backup"
      run mkdir -p "$(dirname "$backup")"
      run mv "$target" "$backup"
   fi

   log "Linking $target"
   run ln -s "$source" "$target"
}

link_dotfiles() {
   log "Linking terminal dotfiles"

   link_path "$DOTFILES_DIR/.vim/.vimrc" "$HOME/.vimrc"
   link_path "$DOTFILES_DIR/.vim/.vimrc" "$HOME/.config/nvim/init.vim"
   link_path "$DOTFILES_DIR/.vim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"

   link_path "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
   run mkdir -p "$HOME/.config/fish/functions"
   local function_file
   for function_file in "$DOTFILES_DIR"/fish/functions/*.fish; do
      link_path "$function_file" "$HOME/.config/fish/functions/$(basename "$function_file")"
   done

   link_path "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
   link_path "$DOTFILES_DIR/alacritty/.alacritty.yml" "$HOME/.alacritty.yml"
   link_path "$DOTFILES_DIR/alacritty/.alacritty.yml" "$HOME/.config/alacritty/alacritty.yml"

   case "$PROFILE" in
      desktop|full)
         log "Linking desktop dotfiles"
         link_path "$DOTFILES_DIR/.i3/config" "$HOME/.config/i3/config"
         link_path "$DOTFILES_DIR/.i3/.i3status.conf" "$HOME/.i3status.conf"
         link_path "$DOTFILES_DIR/.i3/.picom.conf" "$HOME/.picom.conf"
         link_path "$DOTFILES_DIR/.i3/script.sh" "$HOME/.config/i3/script.sh"
         link_path "$DOTFILES_DIR/.i3/low_battery.sh" "$HOME/.config/i3/low_battery.sh"
         link_path "$DOTFILES_DIR/.i3/capsmap" "$HOME/.config/i3/capsmap"
         link_path "$DOTFILES_DIR/.i3/sinking.mp3" "$HOME/.config/i3/sinking.mp3"
         link_path "$DOTFILES_DIR/.i3/wks-flow.md" "$HOME/wks-flow.md"
         write_xinitrc
         ;;
   esac
}

write_xinitrc() {
   local target="$HOME/.xinitrc"

   if [[ -e "$target" || -L "$target" ]]; then
      local backup="$BACKUP_DIR/${target#$HOME/}"
      log "Backing up $target to $backup"
      run mkdir -p "$(dirname "$backup")"
      run mv "$target" "$backup"
   fi

   log "Writing $target"
   if (( DRY_RUN )); then
      printf 'dry-run: write %q with exec i3\n' "$target"
   else
      printf 'exec i3\n' > "$target"
   fi
}

clone_repos() {
   (( INSTALL_REPOS )) || {
      log "Skipping repository clones"
      return 0
   }

   local manifest="$DOTFILES_DIR/packages/repos.txt"
   [[ -f "$manifest" ]] || return 0

   log "Cloning/updating repositories in $CLONES_DIR"
   run mkdir -p "$CLONES_DIR"

   local repo name dest
   while IFS= read -r repo; do
      repo="${repo%%#*}"
      repo="${repo//[[:space:]]/}"
      [[ -n "$repo" ]] || continue

      name="${repo##*/}"
      name="${name%.git}"
      dest="$CLONES_DIR/$name"

      if [[ -d "$dest/.git" ]]; then
         log "Updating $repo"
         run git -C "$dest" pull --ff-only
      elif [[ -e "$dest" ]]; then
         warn "Skipping $repo because $dest exists and is not a git repository"
      else
         log "Cloning $repo"
         run git clone "https://github.com/$repo" "$dest"
      fi
   done < "$manifest"
}

install_npm_tools() {
   (( INSTALL_PLUGINS )) || return 0

   local manifest="$DOTFILES_DIR/packages/npm.txt"
   [[ -f "$manifest" ]] || return 0

   command -v npm >/dev/null 2>&1 || {
      warn "npm is not available; skipping npm global tools"
      return 0
   }

   local packages=()
   local package
   while IFS= read -r package; do
      packages+=("$package")
   done < <(read_manifest "$manifest")

   ((${#packages[@]})) || return 0
   log "Installing npm global tools"
   run sudo npm install -g "${packages[@]}"
}

install_vim_plug() {
   (( INSTALL_PLUGINS )) || {
      log "Skipping editor/plugin setup"
      return 0
   }

   command -v curl >/dev/null 2>&1 || {
      warn "curl is not available; skipping vim-plug install"
      return 0
   }

   log "Installing vim-plug"
   run mkdir -p "$HOME/.vim/plug"
   run curl -fLo "$HOME/.vim/plug/plug.vim" \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_neovim_plugins() {
   (( INSTALL_PLUGINS )) || return 0

   command -v nvim >/dev/null 2>&1 || {
      warn "nvim is not available; skipping Neovim plugin install"
      return 0
   }

   log "Installing Neovim plugins"
   if (( DRY_RUN )); then
      printf 'dry-run: nvim --headless -u %q +PlugInstall +qa\n' "$HOME/.config/nvim/init.vim"
      printf 'dry-run: nvim --headless -u %q "+CocInstall -sync ..." +qa\n' "$HOME/.config/nvim/init.vim"
      return 0
   fi

   nvim --headless -u "$HOME/.config/nvim/init.vim" +PlugInstall +qa || \
      warn "PlugInstall failed; open nvim and run :PlugInstall manually"

   nvim --headless -u "$HOME/.config/nvim/init.vim" \
      "+CocInstall -sync coc-tsserver coc-java coc-json coc-pyright coc-git coc-sh coc-html coc-css coc-snippets coc-vimlsp" \
      +qa || warn "CocInstall failed; open nvim and run :CocInstall manually"
}

set_fish_shell() {
   (( SET_FISH_SHELL )) || {
      if command -v fish >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v fish)" ]]; then
         warn "fish is installed. Run './run.sh --set-shell' if you want it as your login shell."
      fi
      return 0
   }

   command -v fish >/dev/null 2>&1 || {
      warn "fish is not available; cannot change shell"
      return 0
   }

   local fish_path
   fish_path="$(command -v fish)"

   if ! grep -qxF "$fish_path" /etc/shells; then
      log "Adding $fish_path to /etc/shells"
      if (( DRY_RUN )); then
         printf 'dry-run: append %q to /etc/shells\n' "$fish_path"
      else
         printf '%s\n' "$fish_path" | sudo tee -a /etc/shells >/dev/null
      fi
   fi

   log "Changing login shell to fish"
   run chsh -s "$fish_path"
}

main() {
   parse_args "$@"
   detect_distro

   log "Using dotfiles from $DOTFILES_DIR"
   log "Profile: $PROFILE"

   install_packages
   if (( INSTALL_REPOS )); then
      need_command git
   fi
   clone_repos
   link_dotfiles
   install_npm_tools
   install_vim_plug
   install_neovim_plugins
   set_fish_shell

   log "Done. Restart the terminal, then run tmux prefix + I to install tmux plugins if needed."
}

main "$@"
