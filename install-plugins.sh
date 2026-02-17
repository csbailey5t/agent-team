#!/bin/bash
set -euo pipefail

echo "Installing agent-team recommended plugins..."
echo ""

# Array of plugins to install
plugins=(
  "pr-review-toolkit"
  "commit-commands"
  "feature-dev"
  "code-simplifier"
  "security-guidance"
  "explanatory-output-style"
  "linear"
  "github"
  "playwright"
  "typescript-lsp"
  "pyright-lsp"
)

installed=0
failed=0
already_installed=0

echo "This script will install ${#plugins[@]} plugins from @claude-plugins-official"
echo ""
echo "NOTE: This script assumes you're running it from within Claude Code."
echo "If you're not, please run the individual /plugin install commands instead."
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Installation cancelled."
  exit 0
fi

echo ""
echo "Installing plugins..."
echo ""

for plugin in "${plugins[@]}"; do
  echo "Installing $plugin..."

  # Check if already installed by trying to read the plugin directory
  # This is a heuristic - actual check would require parsing plugin config
  if claude plugin list 2>/dev/null | grep -q "$plugin"; then
    echo "  ✓ Already installed"
    ((already_installed++))
  else
    # Install the plugin
    if claude plugin install "$plugin@claude-plugins-official" 2>/dev/null; then
      echo "  ✓ Installed"
      ((installed++))
    else
      echo "  ✗ Failed to install"
      ((failed++))
    fi
  fi
  echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Installation summary:"
echo "  Installed:          $installed"
echo "  Already installed:  $already_installed"
echo "  Failed:             $failed"
echo ""

if [ $failed -eq 0 ]; then
  echo "✓ All plugins ready!"
else
  echo "⚠ Some plugins failed to install. Try installing them manually:"
  echo "  /plugin install <plugin-name>@claude-plugins-official"
fi

echo ""
echo "IMPORTANT: You may need to restart Claude Code for plugins to take effect."
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (if needed)"
echo "  2. Install language server binaries for LSP plugins:"
echo "     - TypeScript: npm install -g typescript-language-server typescript"
echo "     - Python:     pip install pyright"
echo "  3. Run /plugin to verify installation"
echo ""
echo "See PLUGINS.md for detailed plugin documentation."
