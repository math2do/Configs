# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

#setting up golang environment variables
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/Projects/go
export GOBIN=$GOPATH/bin
export PATH=$GOPATH/bin:$PATH

# node binary downloaded 'node-v14.17.3-linux-x64.tar.xz' from https://nodejs.org/dist/v14.17.3/
# extract using sudo tar -xJvf node-v14.17.3-linux-x64.tar.xz -C /usr/local/lib/nodejs
# export PATH=/usr/local/lib/nodejs/node-v18.12.1-linux-x64/bin:$PATH
export PATH=/usr/local/lib/nodejs/node-v18.18.0-linux-x64/bin:$PATH
# export PATH=/usr/local/lib/nodejs/node-v14.17.3-linux-x64/bin:$PATH

#cpp custom lib
export CPP_LIB=$HOME/Projects/cpp/
export CPLUS_INCLUDE_PATH=$CPLUS_INCLUDE_PATH:$CPP_LIB

#add java home to path
export JAVA_HOME=$HOME/Java-JDK
export PATH=$JAVA_HOME/bin:$PATH

#add maven
export PATH=$HOME/Maven/bin:$PATH

#add Intellij-Idea to path
export PATH=$HOME/Intellij-IDEA/bin:$PATH
#add Goland path
export PATH=$HOME/Goland/bin:$PATH

#liquibase path
export PATH=$PATH:$HOME/Liquibase

# pip install ... drops scripts into ~/.local/bin and this is not on the default Debian/Ubuntu $PATH.
# so add this to path
export PATH=$HOME/.local/bin:$PATH

# Add custom bash scripts to env
export PATH=$HOME/Configs/bin:$PATH
