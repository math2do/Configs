# Notes on system configuration

<!-- TODO: put this in Note project -->
## Installing WSL in fresh **windows 11**

> Enable the virtualization support in BIOS (Advanced -> OC -> Advanced CPU Configuration -> SVM)

> Enable the `Windows Hypervisor Platform` from (Control Panel -> Programs and Features -> Turn windows features on or off)

Search for `wsl` in windows search box and click on `wsl`. WSL installation will start automatically. Alternatively you can open powershell and enter `wsl --install` followed by below commands.

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

- Check the [link](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh) to install zsh-autosuggestions

- Check the [link](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh) to install zsh-syntax-highlighting

```bash
# clone to ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# add to the following list in ~/.zshrc
plugins=(git, ...other, zsh-autosuggestions, zsh-syntax-highlighting)
# 
```

## Manage dotfiles in WSL
>
> Place your `Configs` project at Home(/home/math2do). Noe treat `~/Configs` as the home directory and **move (cut-paste)** dotfiles from `~/` to `~/Configs`.

```bash
# Install
sudo apt install stow

# execute from ~/Configs which is same as `stow -d=~/Configs -t=~/`
stow .

# remote the symblink for specific file or folder
stow -D <file>  # didn't remove the symblink hence force remove by: rm ~/.bashrc
```
