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
