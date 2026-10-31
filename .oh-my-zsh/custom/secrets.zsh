# Secrets resolved via pass on first use, not at startup: each `pass show` is a gpg
# round-trip (~250ms). Sourced by oh-my-zsh from $ZSH_CUSTOM. Work secrets are defined
# in the private overlay (~/.config/work/zshrc) as work-secrets().

load-secrets() {
  [[ -n "$_SECRETS_LOADED" ]] && return 0
  _SECRETS_LOADED=1
  command -v pass >/dev/null || return 0
  export GEMINI_API_KEY=$(pass show personal/gemini/api-key 2>/dev/null)
  export GOOGLE_TTS_API_KEY=$(pass show personal/google/tts-key 2>/dev/null)
  (( $+functions[work-secrets] )) && work-secrets
}

# ~/.npmrc reads ${NPM_TOKEN}, so npm and npx need the secrets in their environment.
npm() { load-secrets; command npm "$@"; }
npx() { load-secrets; command npx "$@"; }
