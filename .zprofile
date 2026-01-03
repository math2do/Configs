# It's loaded during login, Onetime stuff like .profile. So put env variables
## Use .zshrc for shell behaviour

# setting up golang environment variables
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Projects/go
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$PATH

# cpp custom lib
export CPP_LIB=$HOME/Projects/cpp/
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$CPP_LIB

# add sync-dotfiles binary to path
export PATH=$HOME/Configs/bin:$PATH

# Add neovim binary to path
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"


# Added by Toolbox App
export PATH="$PATH:/home/math2do/.local/share/JetBrains/Toolbox/scripts"

# Created by `pipx` on 2026-01-03 15:02:59
export PATH="$PATH:/home/math2do/.local/bin"
