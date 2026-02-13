#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMMANDS_SRC="$SCRIPT_DIR/commands"
COMMANDS_DST="$HOME/.claude/commands"

echo "Installing agent-team commands..."

# Create target directory if it doesn't exist
mkdir -p "$COMMANDS_DST"

# Track what we do
installed=0
updated=0
skipped=0

for cmd_file in "$COMMANDS_SRC"/*.md; do
  filename="$(basename "$cmd_file")"
  target="$COMMANDS_DST/$filename"

  if [ -L "$target" ]; then
    # Already a symlink — check if it points to us
    current_target="$(readlink "$target")"
    if [ "$current_target" = "$cmd_file" ]; then
      ((skipped++))
      continue
    fi
    # Points elsewhere — update it
    ln -sf "$cmd_file" "$target"
    ((updated++))
  elif [ -f "$target" ]; then
    # Regular file exists — back it up, then symlink
    echo "  Backing up existing $filename → ${filename}.bak"
    mv "$target" "${target}.bak"
    ln -s "$cmd_file" "$target"
    ((updated++))
  else
    # New install
    ln -s "$cmd_file" "$target"
    ((installed++))
  fi
done

echo ""
echo "Done! Installed: $installed, Updated: $updated, Already current: $skipped"
echo ""
echo "Available commands:"
for cmd_file in "$COMMANDS_SRC"/*.md; do
  filename="$(basename "$cmd_file" .md)"
  echo "  /$filename"
done
echo ""
echo "Use these in any Claude Code session."
