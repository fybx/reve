#!/usr/bin/env bash

# reve                              desktop environment framework
# Yigid BALABAN <fyb@fybx.dev>                               2024

rt_script_dir=$(realpath "$(dirname $0)")
cd "$rt_script_dir" 

reve_installation_target="$HOME/.local/reve"

echo "Creating reve installation folder"
mkdir -p "$reve_installation_target"

echo "Copying: reve.sh"
cp reve.sh "$reve_installation_target/reve"
chmod +x "$reve_installation_target/reve"

echo "Creating chores/mode folder"
mkdir -p "$reve_installation_target/chores/mode"

echo "Copying chore: gtk_theme.sh"
cp chores/mode/gtk_theme.sh "$reve_installation_target/chores/mode/gtk_theme.sh"
chmod +x "$reve_installation_target/chores/mode/gtk_theme.sh"

echo "Base installation completed. You can copy remaining default chores from chores/mode at will or create your own chores following the examples in examples folder.
exit 0
