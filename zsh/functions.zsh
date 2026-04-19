# AI command
# ------------------------------------------------------------------------------
ai() {
  if [ -p /dev/stdin ]; then
    claude -p "$(cat)" "$*"
  else
    claude -p "$*"
  fi
}

