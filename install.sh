#!/usr/bin/env bash

DOTFILES_ROOT=$(exec 2>/dev/null;cd -- $(dirname "$0"); unset PWD; /usr/bin/pwd || /bin/pwd || pwd)

# Helper function
generic_install() {
  (which brew > /dev/null && brew install "$1") || sudo apt install -o DPkg::Options::="--force-confnew" -y "$1"
}

echo "Installing zsh..."
which zsh || generic_install zsh

echo "Installing oh-my-zsh..."
if [[ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]]; then
  if [[ -d ~/.oh-my-zsh ]]; then
    rm -rf ~/.oh-my-zsh
  fi
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Install zsh-syntax-highlighting"
if [[ ! -d ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "Linking dotfiles into $HOME"

rm $HOME/.zshrc
ln -s $DOTFILES_ROOT/zsh/zshrc $HOME/.zshrc
printf "$DOTFILES_ROOT/zsh/zshrc linked to $HOME/.zshrc\n"

rm -rf $HOME/.zsh && mkdir $HOME/.zsh 
cd $HOME/.zsh
ln -s $DOTFILES_ROOT/zsh/aliases.zsh $HOME/.zsh/aliases.zsh
ln -s $DOTFILES_ROOT/zsh/plugins.zsh $HOME/.zsh/plugins.zsh


echo "Adding global gitignore"
rm $HOME/.gitignore_global
ln -s $DOTFILES_ROOT/.gitignore_global $HOME/.gitignore_global
git config --global core.excludesfile $HOME/.gitignore_global

echo "Reloading zsh"
source $HOME/.zshrc

echo "Done!"