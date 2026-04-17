# Aliases
alias c="clear"
alias cdp="cd ~/Projects/"
alias cdc="cd ~/Configs"
alias cdn="cd ~/Notes"
alias clip="xclip -selection clipboard"
alias d='docker'
alias docker-compose='docker compose'
alias k='kubectl'
alias h='helm'
alias hf='helmfile'
alias t='terraform'
alias cl='clear'
alias lg='lazygit'
alias n='nvim'
alias bat='batcat'
# AI command
# ------------------------------------------------------------------------------
ai() {
  if [ -p /dev/stdin ]; then
    sgpt "$(cat)" "$*"
  else
    sgpt "$*"
  fi
}

# eza (better ls)
# ------------------------------------------------------------------------------
if type eza &>/dev/null; then
  alias lt2="eza -lTg --level=2 --icons=always"
  alias lt3="eza -lTg --level=3 --icons=always"
  alias lt4="eza -lTg --level=4 --icons=always"
  alias lt="eza -lTg --icons=always"
  alias lta2="eza -lTag --level=2 --icons=always"
  alias lta3="eza -lTag --level=3 --icons=always"
  alias lta4="eza -lTag --level=4 --icons=always"
  alias lta="eza -lTag --icons=always"
fi
