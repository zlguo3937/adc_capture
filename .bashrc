# ~/.bashrc: executed by bash(1) for non-login shells.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable bash completion in interactive shells
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

export PS1="\[\e]0;zlguo@\h: \w\a\]\[\033[1m\]\[\033[33m\]zlguo\[\033[33m\]@ \[\033[32m\]\w\[\033[33m\] \$(git_branch) \$ \[\033[0m\]"
export PS2="\[\033[1m\]\[\033[30m\]&gt; \[\033[0m\]"

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#github：git@github.com:zlguo3937/adc_capture.git
#git@github.com:zlguo3937/regmap-flow.git
#git@github.com:zlguo3937/ctrl_sys.git
#git@github.com:zlguo3937/efuse-ctrl-smic40ll.git
#git@github.com:zlguo3937/ip-8b-riscv-cpu.git

alias ll='ls -alF'

export LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.sh=01;32:*.csh=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35"

alias ls='ls --color'

cd_ll() {
  \cd $1
  ls
}
alias cd="cd_ll" 
alias g="gvim"
alias gdff="gvimdiff"
alias gitsta="git status"
alias gitcom="git commit -m"
alias gitfet="git fetch | git rebase"

alias zlg='cd /local/zlguo/prj'

JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64
JRE_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.312.b07-2.el8_5.x86_64/jre
export PATH=$PATH:$JAVA_HOME/bin
export PATH=$PATH:$JRE_HOME/bin

#source /home/zlguo/.bashrc_2018
source /home/zlguo/.bashrc_eda
