# Notes on system configuration

## Installing WSL in fresh **windows 11**

> Enable the virtualization support in BIOS (Advanced -> OC -> Advanced CPU Configuration -> SVM)

> Enable the `Windows Hypervisor Platform` from (Control Panel -> Programs and Features -> Turn windows features on or off)

Seach for `wsl` in windows search box and click on `wsl`. WSL installation will start automatically. Alternatively you can open powershell and enter `wsl --install` followed by below commands.

```powershell
# List all available distros
wsl --list --online

# Install a distro
wsl --install -d <Distribution Name>
```

## Install zsh terminal in WSL/ubuntu

### Install `zsh` shell
Execute following commands and relaunch the terminal
```bash
# Install by apt
sudo apt install zsh

# check version
zsh --version

# Make zsh the default shell
chsh -s $(which zsh)
```

Verify using
```bash
# Output: /usr/bin/zsh or similar
echo $SHELL
``` 

Creates files like:  `.zshenv`, `.zprofile`, `.zshrc`, `.zlogin`

> Put environment variables in `.zprofile`. Put aliases, prompts, functions in `.zshrc`

### Install `oh my zsh`
Checkout [official site](https://ohmyz.sh/)

```bash
# Install via curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### Install oh-my-zsh plugins
1. 