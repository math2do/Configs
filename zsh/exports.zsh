# It's loaded during login, Onetime stuff like .profile. So put env variables
## Use .zshrc for shell behavior

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
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

# Make neovim the default manpager
export MANPAGER='nvim +Man!'
