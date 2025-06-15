## Update system
```bash
sudo apt update && sudo apt install -y curl
```

## Install with curl / wget

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/riorz/dotfiles/main/bootstrap.sh)"
# or with wget
bash -c "$(wget -qO- https://raw.githubusercontent.com/riorz/dotfiles/main/bootstrap.sh)"
```

## Clone repo manually

```bash
git clone https://github.com/riorz/dotfiles ~
bash ~/dotfiles/bootstrap.sh
```

