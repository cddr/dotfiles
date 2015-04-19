[ -n "$PS1" ] && source ~/.bash_profile;

export RUBY_BUILD_CACHE_PATH=~/.rbenv/ruby-cache

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
