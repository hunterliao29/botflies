#!/bin/sh

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/opt/homebrew/bin/brew shellenv)"

git clone --bare https://github.com/hunterliao29/dotfiles.git $HOME/.dotfiles
/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME config --local status.showUntrackedFiles no
/usr/bin/git --git-dir=$HOME/.config/ --work-tree=$HOME checkout

brew tap FelixKratz/formulae
brew tap koekeishiya/formulae
brew tap hunterliao29/formulae

brew install hunterliao29/formulae/skhd --HEAD
brew install koekeishiya/formulae/yabai
brew install FelixKratz/formulae/sketchybar
brew install FelixKratz/formulae/borders

brew install fish
brew install zoxide
brew install git
brew install lazygit
brew install neovim
brew install wezterm
brew install git
brew install jq
brew install fzf
brew install yazi
brew install bat
brew install eza
brew install ffmpegthumbnailer
brew install sevenzip
brew install poppler
brew install fd
brew install ripgrep
brew install imagemagick
brew install --cask font-symbols-only-nerd-font
brew install --cask sf-symbols

# set up fish shell as defautl shell
echo "/opt/homebrew/bin/fish" | sudo tee -a /etc/shells
chsh -s $(which fish)

(git clone https://github.com/FelixKratz/SbarLua.git /tmp/SbarLua && cd /tmp/SbarLua/ && make install && rm -rf /tmp/SbarLua/)
tempfile=$(mktemp) &&
  curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo &&
  tic -x -o ~/.terminfo $tempfile &&
  rm $tempfile
bat cache --build

# start service
skhd --start-service
yabai --start-service
brew services start sketchybar
brew services start borders
