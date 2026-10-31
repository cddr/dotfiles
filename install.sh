#!/usr/bin/env bash
set -euo pipefail

# Usage: ./install.sh [--links-only]   (skip brew/oh-my-zsh bootstrap)
LINKS_ONLY=0; [[ "${1:-}" == "--links-only" ]] && LINKS_ONLY=1

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bootstrap() {
  # Packages: formulae and casks (mise, atuin, gcloud, emacs, ...)
  if command -v brew >/dev/null; then
    brew bundle --file="$DOTFILES/Brewfile"
  else
    echo "brew not found; install Homebrew first: https://brew.sh" >&2
    exit 1
  fi
  # oh-my-zsh isn't a Homebrew formula; clone it (never overwrites ~/.zshrc)
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  fi
}

link() {
  link_to "$DOTFILES/$1" "$HOME/$1"
}

link_to() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst.bak"
    echo "backed up: $dst -> $dst.bak"
  fi
  ln -sfn "$src" "$dst"
  echo "linked:    $dst"
}

# Link each LaunchAgent plist into ~/Library and load it if it isn't already
# (never restart a running agent: that would kill the Emacs daemon).
install_launch_agents() {
  local plist label
  for plist in "$DOTFILES"/LaunchAgents/*.plist; do
    link_to "$plist" "$HOME/Library/LaunchAgents/$(basename "$plist")"
    label="$(basename "$plist" .plist)"
    if ! launchctl print "gui/$(id -u)/$label" >/dev/null 2>&1; then
      launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/$(basename "$plist")"
    fi
  done
}

# macOS preferences. These persist across reboots (unlike the hidutil Caps Lock
# remap, which has its own LaunchAgent) but only apply after logging out and in.
macos_defaults() {
  # Fastest key repeat and shortest delay before repeat starts
  # (the System Settings slider extremes).
  defaults write NSGlobalDomain KeyRepeat -int 2
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
}

# Claude Code owns ~/.claude/settings.json (it writes model, theme, ...), so it can't
# be symlinked. Merge in only the status line, leaving everything else alone.
claude_settings() {
  local f="$HOME/.claude/settings.json" tmp
  mkdir -p "$HOME/.claude"
  [[ -s "$f" ]] || echo '{}' > "$f"
  tmp="$(mktemp)"
  jq '.statusLine = {type: "command", command: "~/.claude/statusline.sh"}' "$f" > "$tmp" && mv "$tmp" "$f"
  echo "settings:  $f (statusLine)"
}

(( LINKS_ONLY )) || bootstrap

link .zshrc
link .emacs.d
link .zshenv
link .gitconfig
# Link each skill individually: ~/.claude/skills also holds app-managed content
# (synced/), which must not end up inside this repo.
for skill in "$DOTFILES"/.claude/skills/*/; do
  [[ -d "$skill" ]] || continue   # no skills in this repo: the glob stays literal
  link ".claude/skills/$(basename "$skill")"
done
link .config/mise/config.toml
link .config/git/ignore
link .config/git/personal
link .config/gh/config.yml
link .config/btop/btop.conf
link .claude/statusline.sh
link .oh-my-zsh/custom/secrets.zsh
claude_settings

install_launch_agents
macos_defaults

# Secret-scanning hooks (needs gitleaks, installed via the Brewfile)
git -C "$DOTFILES" config core.hooksPath .githooks

cat <<'MSG'

Done. Still by hand: key restore, SSO logins, app sign-ins (see MIGRATION.md in the private overlay).
Private overlay (work config and secrets), if you have it: run its install.sh.
MSG
