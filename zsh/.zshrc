# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
export FZF_CTRL_R_OPTS="--height 40% --preview \"echo {}\" --preview-window up:3:hidden:wrap"
export FZF_DEFAULT_COMMAND="history | tac | awk '{print $2}'"

# zoxide
eval "$(zoxide init zsh)"

# Created by `pipx` on 2025-06-14 02:05:04
export PATH="$PATH:/home/rio/.local/bin"

# 啟用 autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# 啟用 syntax highlighting（⚠️ 必須放在最後）
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $HOME/.cargo/env >> ~/.zshrc
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /home/rio/k/k.sh
alias python=python3
