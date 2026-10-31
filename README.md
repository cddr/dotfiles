# dotfiles

Shell, Emacs, git, Homebrew and macOS setup for my Macs. Public on purpose, so a
fresh laptop can clone it with no credentials; nothing private lives here.

```sh
git clone https://github.com/cddr/dotfiles ~/my-repos/dotfiles
cd ~/my-repos/dotfiles && ./install.sh     # ./install.sh --links-only to just relink
```

`install.sh` is idempotent. It runs `brew bundle`, clones oh-my-zsh, symlinks the
config into `$HOME`, installs and loads the LaunchAgents (Emacs daemon, a client
frame at login, Caps Lock to Command), sets key-repeat defaults and points git at
the secret-scanning hooks in `.githooks/`.

## Layout

| Path | What |
|---|---|
| `.zshrc` `.zshenv` | zsh (oh-my-zsh, mise, atuin) |
| `.gitconfig` | git; work identity and signing come from the overlay, this repo's own commits use `.config/git/personal` |
| `.emacs.d/` | Emacs, run as a daemon; packages via straight.el |
| `.config/` | mise, gh, git ignore, btop |
| `LaunchAgents/` | `com.andrew.*` agents, symlinked into `~/Library/LaunchAgents` |
| `Brewfile` | formulae, casks and taps |
| `backup.sh` | encrypted bundle of personal keys, `pass/personal` and atuin (to Proton Drive) |

## Private overlay

Work config, secret lookups and the work key backup live in a separate private
repo that installs `~/.config/work/`. The base config loads `~/.config/work/{zshrc,gitconfig,emacs/work.el}`
if they exist and works without them. Never commit credentials, hostnames or
account IDs here; the pre-commit and pre-push hooks run `gitleaks`.

## New laptop

1. `xcode-select --install`, then install Homebrew (https://brew.sh).
2. Clone this repo and run `./install.sh`.
3. `gh auth login` (HTTPS, browser works with no keys yet).
4. Clone your private overlay repo and follow its `MIGRATION.md` for key restore,
   SSO logins and verification.
