# AI command
# ------------------------------------------------------------------------------
ai() {
  if [ -p /dev/stdin ]; then
    claude -p "$(cat)" "$*" | glow
  else
    claude -p "$*" | glow
  fi
}

# C++23 compile
# ------------------------------------------------------------------------------
com() {
  if [ $# -eq 0 ]; then
    echo "Usage: com <source.cpp>"
    return 1
  fi

  local source="$1"
  local output="${source%.*}"

  g++ "$source" -std=c++23 -O2 -o "$output" -Wall -Wextra -DLOCAL
}
