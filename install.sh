#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

rt_script_dir=$(realpath "$(dirname "$0")")
cd "$rt_script_dir" || exit 

reve_installation_target="$HOME/.local/bin/reve"

echo "[1/5] Creating reve installation folder"
mkdir -p "$reve_installation_target"

echo "[2/5] Copying: reve.sh and _reve.sh"
cp reve.sh "$reve_installation_target/reve"
cp _reve.sh "$reve_installation_target/_reve"
chmod +x "$reve_installation_target/reve"
chmod -x "$reve_installation_target/_reve"

echo "[3/5] Adding reve to path"
if grep -q "/bin/bash" /etc/shells; then
    echo "==> bash detected."
    if ! grep -q "$reve_installation_target" ~/.bashrc; then
        echo "export PATH=\"\$PATH:$reve_installation_target\"" >> ~/.bashrc
        echo "Added $reve_installation_target to bash PATH."
    else
        echo "$reve_installation_target is already in bash PATH."
    fi
fi

if grep -q "/bin/zsh" /etc/shells; then
    echo "==> zsh detected."
    if ! grep -q "$reve_installation_target" ~/.zshrc; then
        echo "export PATH=\"\$PATH:$reve_installation_target\"" >> ~/.zshrc
        echo "Added $reve_installation_target to zsh PATH."
    else
        echo "$reve_installation_target is already in zsh PATH."
    fi
fi

if grep -q "/bin/fish" /etc/shells; then
    echo "==> fish detected."
    if ! fish -c "echo $PATH | grep -q $reve_installation_target"; then
        fish -c "fish_add_path $reve_installation_target"
        echo "Added $reve_installation_target to fish PATH."
    else
        echo "$reve_installation_target is already in fish PATH."
    fi
fi

echo "[4/5] Creating chores/mode folder"
mkdir -p "$reve_installation_target/chores/mode"

echo "[5/5] Copying chore: gtk_theme.sh"
cp chores/mode/gtk_theme.sh "$reve_installation_target/chores/mode/gtk_theme.sh"
chmod +x "$reve_installation_target/chores/mode/gtk_theme.sh"

echo "🎉 Base installation completed. You can copy remaining default chores from chores/mode at will or create your own chores following the examples in examples folder."
exit 0
