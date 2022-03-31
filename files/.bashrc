## RTSP .bashrc (rtsp-bash)

## shell optional behavior
shopt -s checkwinsize

## shell history control
shopt -s histappend
unset HISTCONTROL
HISTFILESIZE=100000000
HISTTIMEFORMAT="[%a %Y-%m-%d %H:%M:%S] "
HISTSIZE=2000

## user@host template for prompt and window title
if [ $EUID -eq 0 ]; then
  PS1_UserHost='\h'
else
  PS1_UserHost='\u@\h'
fi

## prompt color - enable a colored prompt, if the terminal has the capability
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  PS1="\[\e[01;93m\]\t\[\e[m\] \[\e[01;32m\]${PS1_UserHost}\[\e[m\]:\[\e[01;96m\]\w\[\e[m\]\\$ "
else
  PS1="${PS1_UserHost}:\w\\$ "
fi

## window title - if this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}${PS1_UserHost}: \w\a\]$PS1"
  # PROMPT_COMMAND='echo -ne \\a'
  ;;
*)
  ;;
esac

## lesspipe - make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/bash lesspipe)"

## gcc - colored GCC warnings and errors
which gcc > /dev/null 2>&1 && export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

## ls - enable color support of ls and also add handy aliases
export LS_OPTIONS='-hFT 0 --time-style=long-iso'
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  export LS_OPTIONS="${LS_OPTIONS} --color=auto"
fi
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias la='ls $LS_OPTIONS -la'

## grep/diff - enable color support
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

## netstat - shorthand aliases
alias n='netstat -tunlp'
alias nt='netstat -tunap'
alias na='netstat -nap'

## ps/df/free - shorthand aliases
alias p='ps axf'
alias pp='ps auxf'
alias d='df -Th'
alias di='df -Thi'
alias f='free -lm'
alias h='history | tail -n 100'

## mount/lsblk - shorthand aliases
alias m='mount | column -t'
which blkid lsblk > /dev/null 2>&1 && alias bls='blkid | sort; echo; lsblk -o NAME,FSTYPE,LABEL,PARTLABEL,SIZE,MOUNTPOINT'

## pico/tailf/vim - add missing aliases
which pico > /dev/null 2>&1 || alias pico='nano'
which tailf > /dev/null 2>&1 || alias tailf='tail -f'
which vim > /dev/null 2>&1 || alias vim='vi'

## git - shorthand aliases
if which git > /dev/null 2>&1; then
  alias gs='git status'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gba='git branch -a'
  alias gl='git log --oneline --graph -n 30 --decorate'
  alias gls='git log --oneline --graph -n 10 --decorate --stat'
  alias gld='git diff HEAD~1'
  alias grv='git remote -v'
fi

## apt - shorthand aliases
if [ $EUID -eq 0 ]; then
  if which apt > /dev/null 2>&1; then
    alias qu='apt update'
    alias qi='apt --no-install-recommends install'
    alias qr='apt remove'
    alias qp='apt purge'
    alias qg='apt upgrade'
    alias qs='apt search'
  elif which aptitude > /dev/null 2>&1; then
    alias qu='aptitude update'
    alias qi='aptitude --without-recommends install'
    alias qr='aptitude remove'
    alias qp='aptitude purge'
    alias qg='aptitude upgrade'
  elif which apt-get > /dev/null 2>&1; then
    alias qu='apt-get update'
    alias qi='apt-get --no-install-recommends install'
    alias qr='apt-get remove'
    alias qp='apt-get purge'
    alias qg='apt-get upgrade'
  fi
fi

## dpkg - shorthand aliases
if which apt-cache > /dev/null 2>&1; then
  alias qc='apt-cache search'
  alias qd='apt-cache depends'
  alias qpl='apt-cache policy'
fi

if which dpkg > /dev/null 2>&1; then
  alias ql='dpkg -l'
  alias qll='dpkg -L'
  alias qls='dpkg -S'
fi
