#!/usr/bin/zsh
source $HOME/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions \
  && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting \
  && git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting \
  && git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete \
  && omz plugin enable  zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete debian pip python \
  && omz theme set duellj


sudo corepack enable

sudo chown -R 1000:1000 /workspace \
  && pnpm install-completion zsh