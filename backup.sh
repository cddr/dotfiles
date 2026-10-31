#!/usr/bin/env bash
# Encrypted bundle of PERSONAL keys and secrets: the personal GPG key, the SSH key,
# the personal `pass` subtree and atuin's key/history. Work items have their own
# script in the private overlay. The bundle is passphrase-encrypted (AES256).
#
#   ./backup.sh list                   show what would be included
#   ./backup.sh backup <out-dir>       write <out-dir>/personal-keys-YYYY-MM-DD.tar.gpg
#   ./backup.sh restore <file>         decrypt and unpack into $HOME (never overwrites)
#
# Put the output somewhere you control, e.g. the Proton Drive sync folder. Practise
# a restore into a scratch HOME now and then: HOME=$(mktemp -d) ./backup.sh restore <file>
# BUNDLE_PASSPHRASE_FILE=<path> supplies the bundle passphrase non-interactively (tests).
set -euo pipefail
umask 077

NAME=personal
GPG_EMAIL="achambers.home@gmail.com"                     # selects the GPG key to export
HOME_FILES=(.ssh/id_ed25519 .ssh/id_ed25519.pub          # paths under $HOME
            .password-store/personal
            .local/share/atuin/key .local/share/atuin/history.db .config/atuin)

fpr() { gpg --list-secret-keys --with-colons "$GPG_EMAIL" 2>/dev/null | awk -F: '/^fpr/{print $10; exit}'; }
present() { local p; for p in "${HOME_FILES[@]}"; do [[ -e "$HOME/$p" ]] && echo "$p"; done; }
gpg_bundle() {
  local args=(--symmetric --cipher-algo AES256)
  [[ -n "${BUNDLE_PASSPHRASE_FILE:-}" ]] && args+=(--batch --yes --pinentry-mode loopback --passphrase-file "$BUNDLE_PASSPHRASE_FILE")
  gpg "${args[@]}" "$@"
}
gpg_unbundle() {
  local args=(--decrypt)
  [[ -n "${BUNDLE_PASSPHRASE_FILE:-}" ]] && args+=(--batch --pinentry-mode loopback --passphrase-file "$BUNDLE_PASSPHRASE_FILE")
  gpg "${args[@]}" "$@"
}

case "${1:-}" in
  list)
    f=$(fpr); echo "gpg key for $GPG_EMAIL: ${f:-NOT FOUND}"
    present | while read -r p; do printf '%s (%s)\n' "$p" "$(du -sh "$HOME/$p" | cut -f1)"; done ;;
  backup)
    out="${2:?usage: backup.sh backup <out-dir>}"; f=$(fpr)
    [[ -n "$f" ]] || { echo "no secret key for $GPG_EMAIL" >&2; exit 1; }
    mkdir -p "$out"; stage=$(mktemp -d); trap 'rm -rf "$stage"' EXIT
    gpg --armor --export-secret-keys "$f" > "$stage/gpg-secret.asc"
    gpg --armor --export "$f" > "$stage/gpg-public.asc"
    echo "$f" > "$stage/fingerprint"
    mkdir "$stage/home"
    present | while read -r p; do mkdir -p "$stage/home/$(dirname "$p")"; cp -R "$HOME/$p" "$stage/home/$p"; done
    file="$out/$NAME-keys-$(date +%F).tar.gpg"
    tar -C "$stage" -cf - . | gpg_bundle --output "$file"
    chmod 600 "$file"; echo "wrote $file" ;;
  restore)
    file="${2:?usage: backup.sh restore <file>}"
    stage=$(mktemp -d); trap 'rm -rf "$stage"' EXIT
    gpg_unbundle "$file" | tar -xf - -C "$stage"
    gpg --import "$stage/gpg-secret.asc" "$stage/gpg-public.asc" 2>&1 | grep -E "imported|unchanged|secret" || true
    echo "$(cat "$stage/fingerprint"):6:" | gpg --import-ownertrust 2>/dev/null   # mark your own key ultimately trusted
    (cd "$stage/home" && find . -type f | while read -r p; do
       [[ -e "$HOME/$p" ]] || { mkdir -p "$(dirname "$HOME/$p")"; cp -p "$p" "$HOME/$p"; }   # never overwrite
     done)
    chmod 700 "$HOME/.ssh" 2>/dev/null || true
    echo "restored into $HOME (existing files were kept)" ;;
  *) sed -n '2,12p' "$0"; exit 1 ;;
esac
