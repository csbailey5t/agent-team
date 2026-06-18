#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink every *.md in $1 (source dir) into $2 (dest dir), backing up any
# pre-existing regular files. Echoes a per-directory summary.
install_dir() {
  local src="$1" dst="$2" label="$3"
  [ -d "$src" ] || return 0

  mkdir -p "$dst"
  local installed=0 updated=0 skipped=0 pruned=0

  for file in "$src"/*.md; do
    [ -e "$file" ] || continue
    local filename target current_target
    filename="$(basename "$file")"
    target="$dst/$filename"

    if [ -L "$target" ]; then
      current_target="$(readlink "$target")"
      if [ "$current_target" = "$file" ]; then
        ((skipped++)); continue
      fi
      ln -sf "$file" "$target"; ((updated++))
    elif [ -f "$target" ]; then
      echo "  Backing up existing $filename → ${filename}.bak"
      mv "$target" "${target}.bak"
      ln -s "$file" "$target"; ((updated++))
    else
      ln -s "$file" "$target"; ((installed++))
    fi
  done

  # Prune symlinks pointing into $src whose target no longer exists (e.g. a
  # command removed from the repo) so the install always mirrors the source.
  for link in "$dst"/*.md; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$src"/*) [ -e "$link" ] || { rm "$link"; ((pruned++)); echo "  Pruned orphaned $(basename "$link")"; } ;;
    esac
  done

  echo "  $label — installed: $installed, updated: $updated, already current: $skipped, pruned: $pruned"
}

echo "Installing agent-team..."
install_dir "$SCRIPT_DIR/commands" "$HOME/.claude/commands" "Commands (slash commands)"
install_dir "$SCRIPT_DIR/agents"   "$HOME/.claude/agents"   "Agents (subagents)"

# Hook scripts: symlink + make executable. Registration in settings.json is a
# separate one-time step (see README) so install.sh never edits your settings.
if [ -d "$SCRIPT_DIR/hooks" ]; then
  mkdir -p "$HOME/.claude/hooks"
  for hook in "$SCRIPT_DIR/hooks"/*.sh; do
    [ -e "$hook" ] || continue
    chmod +x "$hook"
    ln -sf "$hook" "$HOME/.claude/hooks/$(basename "$hook")"
  done
  echo "  Hooks — symlinked to ~/.claude/hooks/ (chmod +x)"
fi

echo ""
echo "Slash commands:"
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
  [ -e "$cmd_file" ] || continue
  echo "  /$(basename "$cmd_file" .md)"
done

if [ -d "$SCRIPT_DIR/agents" ]; then
  echo ""
  echo "Subagents (invoked by other agents, via @name, or auto-delegated):"
  for agent_file in "$SCRIPT_DIR/agents"/*.md; do
    [ -e "$agent_file" ] || continue
    echo "  @$(basename "$agent_file" .md)"
  done
fi

echo ""
echo "Use these in any Claude Code session."
