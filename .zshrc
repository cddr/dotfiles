export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git macos emacs)

source $ZSH/oh-my-zsh.sh

# term
export TERM=xterm-256color

# history
export HISTFILE="$HOME/.zsh_history_from_other_machine"
export SAVEHIST=1000

# path
export PATH=/opt/homebrew/bin:$HOME/bin:$PATH
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.duckdb/cli/latest:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

[[ -d "$HOME/Applications/quarto/bin" ]] && export PATH="$HOME/Applications/quarto/bin:$PATH"

# nix
[[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]] && \
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# mise
eval "$(mise activate zsh)"

# editor — override in .zshrc.secrets if emacs path differs on this machine
export EDITOR=/opt/homebrew/bin/emacsclient

# gpg (gpg-agent starts on demand the first time pass is used)
export GPG_TTY=$(tty)

# atuin
eval "$(atuin init zsh)"

# Google Cloud SDK
GCLOUD_SDK=/opt/homebrew/share/google-cloud-sdk  # from the gcloud-cli cask
[[ -d "$GCLOUD_SDK" ]] && source "$GCLOUD_SDK/path.zsh.inc" && source "$GCLOUD_SDK/completion.zsh.inc"

# keybindings
bindkey -e
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Secrets: load-secrets / npm / npx live in .oh-my-zsh/custom/secrets.zsh (sourced above).

# Private overlay: work config and secrets (separate private repo, optional)
[[ -f "$HOME/.config/work/zshrc" ]] && source "$HOME/.config/work/zshrc"

# Machine-specific overrides (not tracked — e.g. EDITOR path, per-machine flags)
[[ -f "$HOME/.zshrc.secrets" ]] && source "$HOME/.zshrc.secrets"
