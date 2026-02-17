# Agent Team

Reusable Claude Code slash commands for building software projects. Built around a compounding workflow where each unit of work makes future work easier.

## The Core Idea

Traditional development accumulates technical debt. This system inverts that: solved problems become searchable knowledge, and the project gets smarter with every bug fix.

## The Workflow Loop

```
/brainstorm → /architect or /plan → /implement → /review → /compound
     ↑                                                         |
     └─────────────── learnings feed back in ──────────────────┘
```

### Core Loop

1. **`/brainstorm`** — Explore *what* to build through one-question-at-a-time dialogue. Presents 2-3 approaches with tradeoffs.
2. **`/architect`** — Design the system. Tech stack evaluation, component breakdown, data model, API surface. Saves to `docs/plans/`.
3. **`/plan`** — Detailed implementation planning. Searches past learnings, produces ordered task checklists. Saves to `docs/plans/`.
4. **`/implement`** — Write the code. Reads plan files, updates checkboxes, follows patterns. Suggests `/review` after.
5. **`/review`** — Multi-perspective code review. Spawns parallel sub-agents for correctness, security, simplicity, performance, testing.
6. **`/compound`** — **The money step.** Document what was learned. Saves solutions to `docs/solutions/[category]/` with structured metadata.

### Supporting Agents

- **`/spec`** — Turn a feature idea into a detailed technical specification
- **`/scaffold`** — Generate project boilerplate with working configs
- **`/test`** — Write comprehensive tests for existing code
- **`/debug`** — Systematic debugging with hypothesis testing
- **`/docs`** — Generate README, API docs, guides
- **`/devops`** — CI/CD, Docker, deployment configs

## Knowledge Accumulation

The compounding loop is real, not metaphorical:

- Every `/plan`, `/architect`, `/debug`, and `/implement` searches `docs/solutions/` before starting
- Every problem solved via `/compound` feeds back as searchable knowledge
- The system literally gets smarter with every bug fix

## Installation

### 1. Install the Agents

```bash
git clone https://github.com/csbailey5t/agent-team.git
cd agent-team
./install.sh
```

This symlinks all commands to `~/.claude/commands/` so they're globally available.

### 2. Install the Plugins (Optional but Recommended)

The agents are enhanced by official Anthropic plugins that add language intelligence, external integrations, and specialized capabilities.

**Quick install:**
```bash
./install-plugins.sh
```

**Or install manually:**
```bash
/plugin install pr-review-toolkit@claude-plugins-official
/plugin install commit-commands@claude-plugins-official
/plugin install linear@claude-plugins-official
# ... see PLUGINS.md for the full list
```

See [PLUGINS.md](PLUGINS.md) for detailed plugin documentation.

### 3. Set Up Language Servers (Optional)

For real-time type checking and code intelligence:

```bash
# TypeScript/JavaScript
npm install -g typescript-language-server typescript

# Python
pip install pyright
```

## Quick Start

### Starting a New Project

```bash
/brainstorm a CLI tool for managing dotfiles
# ... explore options ...

/architect
# ... choose tech stack, design system ...

/scaffold
# ... generate project structure ...

/plan the sync command
# ... detailed implementation plan ...

/implement docs/plans/2026-02-16-sync-command-plan.md
# ... write the code ...

/review
# ... multi-perspective review ...

/compound
# ... document any non-obvious solutions ...
```

### Working on an Existing Project

```bash
/plan user authentication with OAuth
# ... detailed plan saved to docs/plans/ ...

/implement docs/plans/2026-02-16-oauth-auth-plan.md
# ... code written, tests added ...

/review
# ... thorough review with parallel sub-agents ...

/compound
# ... capture learnings about OAuth integration ...
```

### Debugging

```bash
/debug "TypeError: Cannot read property 'id' of undefined when logging in"
# ... searches past solutions first ...
# ... systematic investigation ...
# ... fix applied, test added ...
# ... suggests /compound to document the solution ...
```

## Project Structure After First Use

```
your-project/
├── CLAUDE.md                    # Project conventions (created by /architect or /scaffold)
├── ARCHITECTURE.md              # System design (created by /architect)
├── docs/
│   ├── brainstorms/             # Exploration sessions (/brainstorm)
│   ├── plans/                   # Implementation plans (/plan, /architect)
│   └── solutions/               # Searchable learnings (/compound)
│       ├── build-errors/
│       ├── test-failures/
│       ├── runtime-errors/
│       ├── performance/
│       ├── database/
│       ├── security/
│       ├── ui-bugs/
│       ├── integration/
│       ├── logic-errors/
│       ├── configuration/
│       └── patterns/
└── [your code]
```

## How It Differs from Other Workflows

**vs. Compound Engineering Plugin:**
- Simpler (12 agents vs. 29 agents + 22 commands + 19 skills)
- Tech-agnostic (not Rails-specific)
- Lower ceremony (use any agent independently)
- Same core insight: knowledge should compound

**vs. Ad-hoc Claude Code usage:**
- Knowledge persists across sessions (`docs/solutions/`)
- Workflow is explicit and repeatable
- Each step has clear outputs and next steps
- Quality bar is higher (multi-perspective reviews)

**vs. Traditional development:**
- Past work informs future work (not just in your head)
- Reviews are thorough by default (5 parallel perspectives)
- Planning is a first-class artifact, not a comment block

## Advanced Usage

### Custom Plan Templates

Save your own plan templates to `docs/plans/templates/` and reference them:

```bash
/plan docs/plans/templates/api-endpoint-template.md
```

### Integration with Linear

Track the workflow loop as Linear issues:

```bash
# Create issue from brainstorm session
# Plan → mark issue as "In Progress"
# Implement → update with progress
# Review → mark as "In Review"
# Compound → close with learnings link
```

### Automated Commits

Use the commit-commands plugin after implementation:

```bash
/implement docs/plans/2026-02-16-feature-plan.md
# ... code written ...

/commit-commands:commit-push-pr
# ... commit created, pushed, PR opened ...
```

## Editing Agents

All agent source files are in `commands/`. Edit them to customize behavior:

```bash
cd agent-team
vim commands/review.md
# ... make changes ...
# Changes take effect immediately (symlinked to ~/.claude/commands/)
```

See [CLAUDE.md](CLAUDE.md) for agent design principles.

## Philosophy

From Every's Compound Engineering methodology:

> "Each unit of engineering work should make subsequent units of work easier — not harder."

This agent team makes that real through:
1. **Searchable knowledge base** (`docs/solutions/`)
2. **Planning as primary artifact** (`docs/plans/`)
3. **Multi-perspective quality** (parallel review agents)
4. **Explicit workflow** (brainstorm → plan → implement → review → compound)

## Credits

- Inspired by [Every, Inc.'s Compound Engineering](https://github.com/EveryInc/compound-engineering-plugin)
- Built for [Claude Code](https://code.claude.com)
- Designed for product development workflows

## License

MIT
