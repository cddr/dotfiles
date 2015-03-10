# Andy's Dev Environment

## Installation

You can clone the repository wherever you want. (I like to keep it in
`~/Projects/dotfiles`. The rsync-dotfiles script will synchronize the
dotfiles directory into $HOME (minus a few administrive files like
README.md etc).

```bash
# clone and sync the repo
git clone https://github.com/cddr/dotfiles.git ~/.dotfiles && \
  ~/.dotfiles/bin/rsync-dotfiles

# setup osx the way I like it
./.osx

# install your toolbox
./toolbox.sh
```

## After updating

```bash
rsync-dotfiles
```

Note that if you have any long-running processes (e.g. Emacs, Chrome etc), they will need
to be re-started to pick up the new environment unless the applications themselves watch
the files that they are interested in to listen for changes


### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files,
before any feature testing. This is intended to be used to setup the PATH
variable according to local requirements.

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="Andy Chambers"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="[my email]"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

You could also use `~/.extra` to override settings, functions and
aliases from my dotfiles repository. It’s probably better to [fork
this repository](https://github.com/cddr/dotfiles/fork) instead,
though.

### Sensible OS X defaults

When setting up a new Mac, you may want to set some sensible OS X defaults:

```bash
./.osx
```

### Install Developer Toolbox

When setting up a new Mac, you may want to install some common developer
tools (e.g. a range of browsers, 1password, xcode command line tools etc)

```Bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
./brew.sh
```

## Feedback

Suggestions/improvements
[welcome](https://github.com/cddr/dotfiles/issues)!

## Thanks to…

* @mathias from whose repository this was forked
* @ptb and [his _OS X Lion Setup_ repository](https://github.com/ptb/Mac-OS-X-Lion-Setup)
* [Ben Alman](http://benalman.com/) and his [dotfiles repository](https://github.com/cowboy/dotfiles)
* [Chris Gerke](http://www.randomsquared.com/) and his [tutorial on creating an OS X SOE master image](http://chris-gerke.blogspot.com/2012/04/mac-osx-soe-master-image-day-7.html) + [_Insta_ repository](https://github.com/cgerke/Insta)
* [Cătălin Mariș](https://github.com/alrra) and his [dotfiles repository](https://github.com/alrra/dotfiles)
* [Gianni Chiappetta](http://gf3.ca/) for sharing his [amazing collection of dotfiles](https://github.com/gf3/dotfiles)
* [Jan Moesen](http://jan.moesen.nu/) and his [ancient `.bash_profile`](https://gist.github.com/1156154) + [shiny _tilde_ repository](https://github.com/janmoesen/tilde)
* [Lauri ‘Lri’ Ranta](http://lri.me/) for sharing [loads of hidden preferences](http://osxnotes.net/defaults.html)
* [Matijs Brinkhuis](http://hotfusion.nl/) and his [dotfiles repository](https://github.com/matijs/dotfiles)
* [Nicolas Gallagher](http://nicolasgallagher.com/) and his [dotfiles repository](https://github.com/necolas/dotfiles)
* [Sindre Sorhus](http://sindresorhus.com/)
* [Tom Ryder](http://blog.sanctum.geek.nz/) and his [dotfiles repository](https://github.com/tejr/dotfiles)
* [Kevin Suttle](http://kevinsuttle.com/) and his [dotfiles repository](https://github.com/kevinSuttle/dotfiles) and [OSXDefaults project](https://github.com/kevinSuttle/OSXDefaults), which aims to provide better documentation for [`~/.osx`](https://mths.be/osx)
* [Haralan Dobrev](http://hkdobrev.com/)
* anyone who [contributed a patch](https://github.com/mathiasbynens/dotfiles/contributors) or [made a helpful suggestion](https://github.com/mathiasbynens/dotfiles/issues)
