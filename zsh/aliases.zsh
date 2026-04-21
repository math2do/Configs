# Aliases
alias c="clear"
alias cls="clear"
alias cdp="cd ~/Projects/"
alias cdg="cd ~/Projects/go/src/"
alias cda="cd ~/Projects/ansible-linux-mint/"
alias cdj="cd ~/Projects/java/"
alias cdc="cd ~/Configs"
alias cdn="cd ~/Notes"
alias clip="xclip -selection clipboard"
alias d='docker'
alias docker-compose='docker compose'
alias k='kubectl'
alias h='helm'
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kd="kubectl describe"
alias hf='helmfile'
alias t='terraform'
alias cl='clear'
alias lg='lazygit'
alias n='nvim'
alias bat='batcat'
alias fd="fdfind"
alias pbcopy="xclip -selection clipboard"
alias pbpaste="xclip -selection clipboard -o"
alias e="exit"
alias vim="nvim"

# Suffix Aliases
alias -s md="bat"
alias -s mov="xdg-open"
alias -s png="xdg-open"
alias -s mp4="xdg-open"
alias -s jpg="xdg-open"
alias -s jpeg="xdg-open"
# TODO: Add more file types
alias -s go="$EDITOR"
alias -s js="$EDITOR"
alias -s ts="$EDITOR"
alias -s yaml="bat -l yaml"
alias -s json="jless"

alias path='echo $PATH | tr ":" "\n" | sort -u'

# ssh into mini pc aliases
alias lenovo="ssh lenovo"
alias hp="ssh hp"
