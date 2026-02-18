# Agent Team

A collection of reusable Claude Code slash commands that act as specialized agents for building software projects. Designed around a compounding workflow where each unit of work makes future work easier.

## The Workflow Loop

```
/brainstorm → /architect or /plan → /implement → /review → /compound
     ↑                                                         |
     └─────────────── learnings feed back in ──────────────────┘
```

- **Brainstorm** — Explore what to build (skip for clear tasks)
- **Architect** — Design the system (new projects)
- **Plan** — Plan the implementation (features in existing projects)
- **Spec** — Define detailed requirements (complex features)
- **Implement** — Write the code from a plan or spec
- **Review** — Multi-perspective code review
- **Compound** — Document what was learned so future work benefits

Supporting agents: `/scaffold`, `/test`, `/debug`, `/docs`, `/devops`

## Integrated Plugins

The agent team is enhanced by official Anthropic plugins:
- **commit-commands** — Git workflows (commit, push, PR creation)
- **pr-review-toolkit** — Multi-agent PR reviews
- **feature-dev** — Guided feature development with codebase exploration
- **code-simplifier** — Refactoring for clarity
- **security-guidance** — Proactive security warnings
- **explanatory-output-style** — Educational insights
- **linear** — Issue tracking integration
- **github** — GitHub repository integration
- **playwright** — Browser E2E testing
- **typescript-lsp** & **pyright-lsp** — Language intelligence

See PLUGINS.md for installation instructions.

## Git Workflow

Use **git worktrees** for any non-trivial feature or fix so multiple workstreams can run in parallel without branch-switching.

### Branch Prefixes

| Type | Prefix | When |
|------|--------|------|
| New feature | `feat/` | Adding new functionality |
| Bug fix | `fix/` | Fixing broken behavior |
| Refactor | `refactor/` | Restructuring without behavior change |
| Documentation | `docs/` | Docs-only changes |
| Maintenance | `chore/` | Dependencies, config, tooling |

Branch names: `{prefix}/{short-slug}` — e.g., `feat/user-auth`, `fix/login-redirect`

### Worktree Convention

Worktrees live as sibling directories alongside the main project:

```
../project-name-feat-user-auth    ← worktree for feat/user-auth
../project-name-fix-login-redirect ← worktree for fix/login-redirect
project-name/                      ← main checkout
```

**Setup a new worktree:**
```bash
git worktree add ../project-name-{branch-slug} {prefix}/{short-slug}
```

**Open Claude Code in the worktree:**
```bash
claude ../project-name-feat-user-auth
```

**Remove when merged:**
```bash
git worktree remove ../project-name-feat-user-auth
```

### Rules

- Never commit directly to `main` — always work on a branch
- Start a worktree when `/plan` produces a plan, before `/implement`
- `/review` compares against `main` (`git diff main...HEAD`), not just staged changes

## Knowledge Accumulation

Agents search `docs/solutions/` before starting work. After solving non-trivial problems, `/compound` documents the solution. This creates a searchable knowledge base that grows with the project.

## Project Structure

- `commands/` — Slash command markdown files (the agents)
- `install.sh` — Symlinks commands to `~/.claude/commands/` for global access
- Each `.md` file in `commands/` becomes a `/command-name` in Claude Code

## Editing Agents

When modifying agent commands:
- Each agent has: a role description, a phased workflow, and behavioral guidelines
- All agents use `$ARGUMENTS` for input from the user
- Agents are collaborative — they present options and wait for confirmation at key decision points
- Keep workflows to 4-6 phases max
- Every agent should produce a concrete output (files, reports, code), not just advice
- Planning agents save artifacts to `docs/plans/`
- Agents that solve problems should suggest `/compound`

## Installing

Run `./install.sh` to symlink all commands to `~/.claude/commands/`.
