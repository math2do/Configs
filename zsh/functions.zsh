# AI command
# ------------------------------------------------------------------------------
ai() {
  if [ -p /dev/stdin ]; then
    claude -p "$(cat)" "$*" | glow
  else
    claude -p "$*" | glow
  fi
}

