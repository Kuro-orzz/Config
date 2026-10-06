#!/bin/bash

sudo apt update

# Color scheme
sudo apt install jq

LAD=$(cmd.exe /c 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')
S="$(wslpath "$LAD")/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
cp "$S" "$S.bak"
sed 's#^\s*//.*$##' "$S" | jq '.profiles.defaults.colorScheme = "One Half Dark"' > /tmp/wt.json && mv /tmp/wt.json "$S"

# Oh-my-posh
sudo apt install unzip

curl -s https://ohmyposh.dev/install.sh | bash -s
cat >> ~/.bashrc << 'EOF'
echo export LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:ex=01;32:'
export PATH="$HOME/.local/bin:$PATH"
eval "$(oh-my-posh --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/json.omp.json' init bash)"
EOF
bash ~/.bashrc

# Config
mkdir -p ~/.config
cp -r ghostty/ ~/.config/ghostty/
cp -r nvim/ ~/.config/nvim