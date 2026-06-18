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

Supporting agents: `/scaffold`, `/test`, `/debug`, `/docs`, `/devops`, `/a11y`

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

Learnings compound only if future work actually retrieves them, so `/compound` captures them in **three tiers by durability**:

1. **Tier 1 — `dev-docs/solutions/`** — a full, searchable case file for every learning. Agents grep it before starting work. Best for the long tail of specific issues.
2. **Tier 2 — `.claude/rules/`** — a short guardrail with a `paths:` glob, for recurring/preventable mistakes tied to a kind of file. These load **automatically** when matching files are edited, so retrieval doesn't depend on anyone remembering to search.
3. **Tier 3 — `CLAUDE.md`** — a one-line rule for universal, project-wide constraints.

Default is Tier 1. Promotion to always-on context (Tier 2/3) must earn its place: `/compound` runs a baseline subagent that has to *actually make the mistake* without the rule before the rule is kept (test-driven documentation). This keeps always-loaded context lean.

## Project Structure

- `commands/` — Slash command markdown files (the agents), each with YAML frontmatter. Each `.md` becomes a `/command-name` in Claude Code.
- `agents/` — Subagent definitions (isolated-context workers, e.g. `a11y-auditor`). Each `.md` becomes an `@agent-name`, launchable via the Task tool or auto-delegated.
- `install.sh` — Symlinks `commands/` → `~/.claude/commands/` and `agents/` → `~/.claude/agents/` for global access
- `dev-docs/` — visible, committed workflow artifacts (per-project): `solutions/` (Tier 1 knowledge base), `plans/`, `brainstorms/`, `specs/`. Kept out of `docs/` so it never collides with a project's published docs site.
- `.claude/rules/` — Tier 2 auto-loading guardrails (per-project, promoted by `/compound`). **Commit these** — gitignore only `.claude/settings.local.json`, never all of `.claude/`, or rules won't travel with the repo.

## Editing Agents

There are two kinds of agent in this repo, split by **context management**, not capability:
- **Slash commands** (`commands/*.md`) run *inline* in the main conversation. Use them for interactive workflows with approval gates and back-and-forth (`/brainstorm`, `/plan`, `/implement`, `/debug`, `/test`) and for orchestrators that coordinate workers (`/review`).
- **Subagents** (`agents/*.md`) run in an *isolated context* and return only a summary. Use them for verbose, read-heavy work whose endpoint is a report and that needs no mid-run user input (`a11y-auditor`). A thin slash command can delegate to a subagent via the Task tool (see `/a11y`); interactive commands can offload just their heavy exploration to a read-only `Explore` subagent (see `/debug`, `/test`). Subagent frontmatter uses `name` + `description` (required) and `tools`/`disallowedTools` instead of `allowed-tools` (e.g. `a11y-auditor` sets `disallowedTools: Write, Edit` to stay read-only).

When modifying agent commands:
- **Every agent starts with YAML frontmatter** (see any file in `commands/`):
  - `description` — written as *what it does + when to use it* (a trigger, not a summary). This is what lets Claude Code surface and auto-select the agent, not just respond to a typed slash command. Keep it one or two sentences.
  - `argument-hint` — the shape of `$ARGUMENTS`, shown during autocomplete.
  - `allowed-tools` — restrict tools where it adds safety (e.g. `/review` has no `Write`/`Edit` — it reviews, it never mutates; `/a11y` is a thin delegator restricted to just `Task`). **Omit** this field for agents that need the full toolset or MCP/Playwright tools (`/implement`, `/test`).
  - `model` — set `opus` for design/planning altitude (`/architect`, `/plan`, `/spec`), `haiku` for templated capture (`/compound`, `/docs`, `/scaffold`). **Omit** it elsewhere so the agent inherits the session model — don't override unless there's a clear reason.
- Each agent has: a role description, a phased workflow, and behavioral guidelines
- All agents use `$ARGUMENTS` for input from the user
- Agents are collaborative — they present options and wait for confirmation at key decision points
- Keep workflows to 4-6 phases max
- Every agent should produce a concrete output (files, reports, code), not just advice
- Planning agents save artifacts to `dev-docs/plans/`
- Agents that solve problems should suggest `/compound`

## Installing

Run `./install.sh` to symlink all commands to `~/.claude/commands/`.
