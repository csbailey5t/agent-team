#!/bin/bash
# agent-team SessionStart hook.
#
# Surfaces the workflow ONLY in projects that already use it — so it stays out
# of the way in unrelated repos (opt-in by presence, not by force). Detection:
# the project has a dev-docs/ artifacts dir or a .claude/rules/ dir.
#
# SessionStart hooks add their stdout to Claude's context, so anything echoed
# here becomes a gentle, project-scoped reminder at the start of the session.
set -euo pipefail

root="${CLAUDE_PROJECT_DIR:-$PWD}"

# Only act in agent-team projects.
if [ ! -d "$root/dev-docs" ] && [ ! -d "$root/.claude/rules" ]; then
  exit 0
fi

# Count captured learnings so the reminder is concrete, not generic.
solutions_count=0
if [ -d "$root/dev-docs/solutions" ]; then
  solutions_count=$(find "$root/dev-docs/solutions" -name '*.md' -type f 2>/dev/null | wc -l | tr -d ' ')
fi

cat <<EOF
[agent-team] This project uses the agent-team workflow.
- Loop: /brainstorm → /architect or /plan → /implement → /review → /compound
- Before non-trivial work, search dev-docs/solutions/ for past learnings (${solutions_count} captured so far).
- After solving something non-obvious, run /compound — capture a Tier 1 solution doc, and promote recurring, preventable lessons to .claude/rules/ so they auto-load next time.
- Path-scoped rules in .claude/rules/ already apply automatically when you edit matching files.
EOF
