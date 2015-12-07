# Sourcing so sourcing
source /usr/bin/virtualenvwrapper.sh
source $HOME/.git-flow-completion.zsh

export GOROOT=$HOME/go
export GOARCH=amd64
export GOOS=linux
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$HOME/bin
export GPG_TTY=$(tty)

#Set LS_COLORS
if [[ -f ~/.dir_colors ]]; then
        eval `dircolors -b ~/.dir_colors`
else
        eval `dircolors -b /etc/DIR_COLORS`
fi

# History settings
HISTFILE=~/.histfile
HISTSIZE=3000
SAVEHIST=3000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt NO_HIST_BEEP
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
# Use the same history file for all sessions
setopt SHARE_HISTORY
# Let the user edit the command line after history expansion (e.g. !ls) instead of immediately running it
setopt hist_verify

setopt extended_glob
setopt noequals
setopt nobeep
setopt CORRECT
setopt autocd
setopt nohup
setopt HASH_CMDS

# Don't fail on unsuccessful globbing
unsetopt NOMATCH

bindkey -e 

# The following lines were added by compinstall
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

bindkey "^[[2~" yank
bindkey "^[[3~" delete-char
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[A"  up-line-or-history
bindkey "^[[B"  down-line-or-history
bindkey "^[[H"  beginning-of-line
bindkey "^[[F"  end-of-line
bindkey "^[e"   expand-cmd-path
bindkey "^[[1~" beginning-of-line                      # Pos1
bindkey "^[[4~" end-of-line
bindkey " "     magic-space
bindkey "^[u"   undo
bindkey "^[r"   redo

bindkey "^R"	history-incremental-search-backward

alias ls='ls -h --color=auto --group-directories-first'
alias flash='mount /mnt/flash'
alias df='df -m'
alias lsl='ls -hl --color=auto --group-directories-first'

alias mv='nocorrect mv -i'
alias cp='nocorrect cp -Ri'
alias rm='nocorrect rm -rI'
alias rmf='nocorrect rm -f'
alias rmrf='nocorrect rm -fR'
alias mkdir='nocorrect mkdir'

# Convenient ones
alias tmux="tmux -u2"
alias wget="wget --continue --content-disposition"
alias vim="nvim"
alias grep="grep --colour"
alias sift="sift --binary-skip --exclude-dirs=".git" -n"
alias pt="GOGC=off pt"

function zle-line-init () {
    if (( ${+terminfo[smkx]} )); then
        echoti smkx
    fi
}
function zle-line-finish () {
    if (( ${+terminfo[rmkx]} )); then
        echoti rmkx
    fi
}
zle -N zle-line-init
zle -N zle-line-finish

## Shell functions
# Watch YouTube video with Mplayer
youmplayer () { mplayer `youtube-dl -g $1` }

# Coloured and lessed diff
udiff() {
        difflength=`diff -u $1 $2 | wc -l`
        cmd="diff -u $1 $2 | pygmentize-3.1 -g"
        if [[ LINES -lt difflength ]] then
            cmd="${cmd} | less"
        fi
        eval $cmd
}

# Open package homepage
urlix () {
    for url in `eix -e --pure-packages $1 --format '<homepage>'`; do
        $BROWSER "$url" > /dev/null;
    done
}

# Open package's ebuild in editor
ebldopen () {
     $EDITOR `equery which $1`
}

# Open package changelog
ebldlog () {
     $EDITOR $(dirname `equery which $1`)/ChangeLog
}

compdef "_gentoo_packages available" urlix ebldopen ebldlog

# Auto-completion from `cmd --help`
compdef _gnu_generic feh

# Complete pumount like umount
compdef _mount pumount

# Set LCD brightness (root access required, obviously)
bright () {
  BRIGHTFILE="/sys/devices/virtual/backlight/acpi_video0/brightness"
  if [[ -n $1 ]] then
    echo $1 > $BRIGHTFILE;
    return 0;
  fi
  local list
  list=("1" "5")
  bright=`cat $BRIGHTFILE`
  if [[ $bright != $list[1] ]] then
    echo $list[1] > $BRIGHTFILE
  else
    echo $list[2] > $BRIGHTFILE
  fi
}

# Imguring
imgur() {
    curl -s -F image=@$1 -F "key=486690f872c678126a2c09a9e196ce1b" http://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
          }

imgur() {
    curl -s -F "image=@$1" -F "key=486690f872c678126a2c09a9e196ce1b" http://imgur.com/api/upload.xml | grep -E -o "<original_image>(.)*</original_image>" | grep -E -o "http://i.imgur.com/[^<]*"
}

# prompt
autoload -U promptinit
promptinit

# gentoovcs prompt theme
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:git:*' formats '[±:%b]'
zstyle ':vcs_info:hg:*' formats '[☿:%b]'
setopt PROMPT_SUBST

prompt_gentoovcs_help () {
  cat <<'EOF'
Standard Gentoo prompt theme with VCS info. Like original, it's color-scheme-able:

  prompt gentoovcs [<promptcolour> [<usercolour> [<rootcolour> [<vcsinfocolour>]]]]

EOF

}

prompt_gentoovcs_setup () {
  prompt_gentoo_prompt=${1:-'blue'}
  prompt_gentoo_user=${2:-'green'}
  prompt_gentoo_root=${3:-'red'}
  prompt_gentoo_vcs=${4:-'white'}

  if [ "$USER" = 'root' ]
  then
    base_prompt="%B%F{$prompt_gentoo_root}%m%k "
  else
    base_prompt="%B%F{$prompt_gentoo_user}%n@%m%k "
  fi
  post_prompt="%b%f%k"

  path_prompt="%B%F{$prompt_gentoo_prompt}%1~"
  PS1="$base_prompt"'%B%F{$prompt_gentoo_vcs}${vcs_info_msg_0_:+${vcs_info_msg_0_} }'"$path_prompt %# $post_prompt"
  PS2="$base_prompt$path_prompt %_> $post_prompt"
  PS3="$base_prompt$path_prompt ?# $post_prompt"

  add-zsh-hook precmd vcs_info
}

if [[ $TERM == "screen" ]] then
  prompt clint
else
  prompt_gentoovcs_setup "$@"
fi

# Zmv!
autoload -U zmv
# Zcalc!
autoload -U zcalc

# Cache completion
zstyle ':completion::complete:*' use-cache 1

# List completions
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Kill processes with completion
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes' sort false
zstyle ':completion:*:processes-names' command 'ps xho command'
zstyle '*' hosts $hosts

# Force rehashing
_force_rehash() {
(( CURRENT == 1 )) && rehash
return 1
}

# Load forced rehash
zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete

