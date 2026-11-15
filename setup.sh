#!/bin/bash


DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sudo apt update

# Color scheme (only for wsl)
echo "------------Setup color scheme--------------"
if grep -qi microsoft /proc/version; then
    sudo apt install jq -y
    LAD=$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')
    S="$(wslpath "$LAD")/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    cp "$S" "$S.bak"
    sed 's#^\s*//.*$##' "$S" | jq '.profiles.defaults.colorScheme = "One Half Dark"' > /tmp/wt.json && mv /tmp/wt.json "$S"
fi
echo "--------------------------------------------"


# Oh-my-posh
echo "----------Setup oh-my-posh theme------------"
sudo apt install unzip bsdextrautils -y
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin
mkdir -p ~/.config/oh-my-posh
curl -fsSL -o ~/.config/oh-my-posh/theme.omp.json https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/json.omp.json

sed -i '/oh-my-posh.*init bash/d' ~/.bashrc
if ! grep -q "pentest_prompt.sh" ~/.bashrc; then
	cat >> ~/.bashrc <<- 'EOF'
	export LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:ex=01;32:'
	export PATH=$PATH:$HOME/.local/bin
	[[ -f ~/.config/bash/pentest_prompt.sh ]] && source ~/.config/bash/pentest_prompt.sh
	EOF
fi
echo "--------------------------------------------"


# Config
echo "------------Setup config file---------------"
mkdir -p ~/.config
cp -r "$DIR/ghostty/." ~/.config/ghostty/
cp -r "$DIR/nvim/." ~/.config/nvim/
cp -r "$DIR/bash/." ~/.config/bash/

mkdir -p ~/.backup
sudo cp "$DIR/Text_editor_config/nanorc" /etc/nanorc
sudo cp "$DIR/Text_editor_config/vimrc.local" /etc/vim/vimrc.local
echo "--------------------------------------------"



# Next action
echo "You need to open new terminal or run 'exec bash' to update new theme"
