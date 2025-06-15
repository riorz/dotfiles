#!/bin/bash

echo "🔧 更新系統..."
sudo apt update && sudo apt upgrade -y

echo "⚙️ 安裝必要工具..."
PACKAGES="zsh git vim curl wget unzip fzf zoxide pipx jq golang-go stow"
for pkg in $PACKAGES; do
  dpkg -l | grep -q $pkg || sudo apt install -y $pkg
done

echo "📌 設定 pipx 環境變數..."
pipx ensurepath

echo "⚙️ 安裝 Rust（使用 Rustup）..."
if ! command -v rustc &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

echo "⚙️ 設定 Zsh 為預設 Shell..."
chsh -s $(which zsh)

echo "🎨 安裝 Nerd Font..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -O FiraCodeNerdFont.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
unzip -o FiraCodeNerdFont.zip
fc-cache -fv

echo "⚡ 安裝 zsh-autosuggestions..."
if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
fi

echo "🔍 安裝 zsh-syntax-highlighting..."
if [ ! -d ~/.zsh/zsh-syntax-highlighting ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
fi

echo "📂 安裝 k..."
if [ ! -d ~/k ]; then
  git clone https://github.com/supercrabtree/k.git ~/k
fi

echo "安裝 powerline..."
if [ ! -d ~/powerlevel10k ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
fi

echo "📁 下載 dotfiles 並應用設定..."
if [ ! -d ~/dotfiles ]; then
  git clone https://github.com/YOUR_GITHUB/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles
for dir in */; do stow "${dir%/}"; done

echo "📁 自動執行 stow..."
cd ~/dotfiles
for dir in */; do
  stow -v "${dir%/}"
done

echo "✨ 完成！請重新啟動終端機以套用設定 🎯"
