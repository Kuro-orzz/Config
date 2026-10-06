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
cp ghostty/ ~/.config/ghostty/
cp nvim/ ~/.config/nvim