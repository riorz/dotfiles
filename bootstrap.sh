#!/bin/bash
set -e
set -o pipefail

# Helpers

install_apt_if_missing() {
  local pkg=$1

  if dpkg -s "$pkg" >/dev/null 2>&1; then
    echo "✅ 已安裝 $pkg"
  else
    echo "📦 安裝 $pkg..."
    sudo apt install -y "$pkg"
  fi
}

clone_or_update() {
  local repo_url=$1
  local target_dir=$2
  local checkout_ref=$3  # 可選參數，可是 commit / tag / branch
  
  # 展開 ~
  target_dir="${target_dir/#\~/$HOME}"

  if [ -d "$target_dir/.git" ]; then
    echo "📁 已存在 $target_dir"
    read -p "🔄 是否更新該 repo？(y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      echo "🚀 拉取更新中..."
      git -C "$target_dir" pull --ff-only || echo "⚠️ 更新失敗，請檢查本地變更"
    else
      echo "⏭️ 跳過更新"
    fi
  else
    echo "📥 Cloning $repo_url 到 $target_dir..."
    git clone --depth=1 "$repo_url" "$target_dir"
  fi

  # 如指定版本（tag / commit / branch），就切換過去
  if [ -n "$checkout_ref" ]; then
    echo "🔁 切換到版本 $checkout_ref"
    git -C "$target_dir" fetch --depth=1 origin "$checkout_ref"
    git -C "$target_dir" checkout "$checkout_ref" || echo "⚠️ 切換版本失敗，請檢查名稱是否正確"
  fi
}


# Update and install packages.
echo "🔧 更新系統..."
sudo apt update && sudo apt upgrade -y

echo "⚙️ 安裝必要工具..."
PACKAGES=(
	zsh git vim curl wget unzip fontconfig fzf zoxide pipx jq golang-go stow
)
for pkg in "${PACKAGES[@]}"; do
  install_apt_if_missing "$pkg"
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

REPOS=(
	"https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions"
	"https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting"
	"https://github.com/supercrabtree/k.git ~/k"
	"https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k"
	"https://github.com/riorz/dotfiles.git ~/dotfiles"	
)

for entry in "${REPOS[@]}"; do
  # 用 set -- 把字串分成位置參數
  set -- $entry
  repo_url=$1
  target_dir=$2
  checkout_ref=$3

  clone_or_update "$repo_url" "$target_dir" "$checkout_ref"
done

echo "📁 自動執行 stow..."
cd ~/dotfiles
for dir in */; do
  stow -v "${dir%/}"
done

echo "✨ 完成！請重新啟動終端機以套用設定 🎯"
