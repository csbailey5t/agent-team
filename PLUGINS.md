# Plugins

This document describes the official Anthropic plugins installed to enhance the agent team workflow.

## Why These Plugins?

The agent team provides workflow orchestration and knowledge accumulation. These plugins add:
- **Language intelligence** (LSP) for real-time type checking and code navigation
- **External integrations** (Linear, GitHub) for project management
- **Specialized capabilities** (PR reviews, E2E testing) that complement the agents

## Installed Plugins

### Core Workflow Enhancement

**commit-commands** (`@claude-plugins-official`)
- **What:** Git commit workflows with smart commit message generation
- **Skills:** `/commit-commands:commit`, `/commit-commands:commit-push-pr`, `/commit-commands:clean_gone`
- **When to use:** After `/implement` completes, instead of manually creating commits
- **Integrates with:** `/implement` suggests using this in the "Next Steps" section

**pr-review-toolkit** (`@claude-plugins-official`)
- **What:** Multi-agent PR review system with specialized reviewers
- **Skills:** `/pr-review-toolkit:review-pr`
- **When to use:** For thorough PR reviews with confidence scoring
- **Integrates with:** `/review` mentions this as an alternative for PR-specific reviews

**feature-dev** (`@claude-plugins-official`)
- **What:** Guided feature development with codebase exploration and architecture focus
- **Skills:** `/feature-dev:feature-dev`
- **When to use:** Complex features needing deep codebase understanding
- **Integrates with:** `/plan` and `/architect` mention this for complex scenarios

### Code Quality

**code-simplifier** (`@claude-plugins-official`)
- **What:** Refactors code for clarity, consistency, and maintainability
- **When to use:** After implementation, or as part of the `/review` process
- **Integrates with:** Could be spawned as a sub-agent during `/review`

**security-guidance** (`@claude-plugins-official`)
- **What:** Proactive security warnings via hooks (command injection, XSS, unsafe patterns)
- **When to use:** Automatically active during file edits
- **Integrates with:** Complements the Security Reviewer in `/review`

**explanatory-output-style** (`@claude-plugins-official`)
- **What:** Adds educational insights about implementation choices
- **When to use:** When learning from implementation decisions
- **Integrates with:** Could enhance `/compound` by adding "why" context to solutions

### Project Management

**linear** (`@claude-plugins-official`)
- **What:** Linear issue tracking integration
- **When to use:** Managing the workflow loop as Linear issues
- **Integrates with:** The entire workflow (brainstorm → plan → implement → review → compound)

**github** (`@claude-plugins-official`)
- **What:** GitHub repository integration for repos, PRs, issues
- **When to use:** Working with GitHub-hosted projects
- **Integrates with:** `/review` for PR reviews, general project management

### Testing

**playwright** (`@claude-plugins-official`)
- **What:** Browser automation and end-to-end testing
- **When to use:** E2E tests for web applications
- **Integrates with:** `/test` mentions this for E2E test scenarios

### Language Intelligence

**typescript-lsp** (`@claude-plugins-official`)
- **What:** TypeScript/JavaScript language server for real-time diagnostics
- **Requires:** `typescript-language-server` binary installed
- **When to use:** Automatic when editing TypeScript/JavaScript projects
- **Integrates with:** All agents benefit from immediate type error feedback

**pyright-lsp** (`@claude-plugins-official`)
- **What:** Python language server for type checking and code intelligence
- **Requires:** `pyright-langserver` binary installed
- **When to use:** Automatic when editing Python projects
- **Integrates with:** All agents benefit from immediate type error feedback

## Installation

### Automated Setup

Run the installation script:
```bash
./install-plugins.sh
```

This will install all plugins listed above.

### Manual Installation

Install plugins one by one:
```bash
/plugin install <plugin-name>@claude-plugins-official
```

Example:
```bash
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
```

### Verify Installation

Check installed plugins:
```bash
/plugin
```

Then navigate to the **Installed** tab.

## LSP Setup

Language servers require binaries to be installed on your system.

### TypeScript/JavaScript
```bash
npm install -g typescript-language-server typescript
```

### Python
```bash
pip install pyright
```

### Verify LSP is Working

After installing the language server binaries:
1. Open a file in the target language
2. Make a type error
3. You should see diagnostics appear automatically

## Plugin Scopes

Plugins can be installed at three scopes:

- **User scope** — Available across all your projects (recommended for these plugins)
- **Project scope** — All collaborators on this repo get the plugins
- **Local scope** — Just you, just this repo

The installation script uses **user scope** so plugins are available everywhere.

## Integration with Agent Workflow

The plugins integrate at specific points in the workflow loop:

```
/brainstorm → /architect or /plan → /implement → /review → /compound
                      ↓                   ↓           ↓          ↓
              feature-dev:feature-dev  commit-*  pr-review  explanatory-
                                                  -toolkit   output-style
```

**During planning:**
- `/feature-dev:feature-dev` for complex features

**During implementation:**
- LSP provides real-time feedback
- `security-guidance` warns about security issues

**After implementation:**
- `/commit-commands:commit` for commits
- `/commit-commands:commit-push-pr` for commits + PR

**During review:**
- `/pr-review-toolkit:review-pr` for PR reviews
- `code-simplifier` for refactoring suggestions

**During compound:**
- `explanatory-output-style` adds educational context

**Throughout:**
- `linear` for issue tracking
- `github` for repository operations
- `playwright` for E2E testing

## Updating Plugins

Plugins auto-update by default. To manually update:
```bash
/plugin update <plugin-name>
```

Or update all:
```bash
/plugin update-all
```

## Removing Plugins

If you need to remove a plugin:
```bash
/plugin uninstall <plugin-name>
```

## Further Reading

- [Official plugin marketplace](https://github.com/anthropics/claude-plugins-official)
- [Claude Code plugin documentation](https://code.claude.com/docs/en/plugins)
- [Available plugins catalog](https://claude.com/plugins)
