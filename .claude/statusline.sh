#!/usr/bin/env bash
# Claude Code status line, in the style of the robbyrussell prompt:
#   <dir> git:(<branch>) ✗  <model> <context used>% $<session cost>
# The ✗ appears when the working tree has changes. Claude Code pipes a JSON
# document to stdin on every update.
input=$(cat)
read -r model used cost dir < <(
  jq -r '[(.model.display_name // "?" | gsub(" "; "_")),
          ((.context_window.used_percentage // 0) | floor),
          (.cost.total_cost_usd // 0),
          (.workspace.current_dir // .cwd // "" | gsub(" "; "\u0001"))] | @tsv' <<<"$input"
)
dir="${dir//$'\001'/ }"

cyan=$'\e[36m'; blue=$'\e[1;34m'; red=$'\e[31m'; yellow=$'\e[33m'; reset=$'\e[0m'

name="${dir##*/}"; [[ "$dir" == "$HOME" ]] && name="~"; [[ -z "$name" ]] && name="/"
out="${cyan}${name}${reset}"

if [[ -n "$dir" ]] && branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null \
                               || GIT_OPTIONAL_LOCKS=0 git -C "$dir" rev-parse --short HEAD 2>/dev/null); then
  out+=" ${blue}git:(${red}${branch}${blue})${reset}"
  [[ -n "$(GIT_OPTIONAL_LOCKS=0 git -C "$dir" status --porcelain 2>/dev/null | head -1)" ]] && out+=" ${yellow}✗${reset}"
fi

printf '%s  %s %s%% $%.2f\n' "$out" "${model//_/ }" "$used" "$cost"
