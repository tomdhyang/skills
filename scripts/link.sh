#!/usr/bin/env bash
set -euo pipefail

# Link the skills I actually use into the directories each agent reads:
#   ~/.claude/skills  (Claude Code)
#   ~/.agents/skills  (Codex and other Agent Skills harnesses)
#
# Buckets linked: engineering + productivity (Matt's promoted sets) + mine (my own).
# in-progress/, misc/, deprecated/ stay in the repo but are not linked.
#
# Safe to re-run any time: stale links into this repo (or dangling links) are
# removed first, so a skill Matt deletes disappears here after the next run.
# Real directories (not symlinks) in a destination are never touched.
#
# Run after: a fresh clone on a new machine, or `git merge upstream/main`.

REPO="$(cd "$(dirname "$0")/.." && pwd)"
BUCKETS=(engineering productivity mine)
DESTS=("$HOME/.claude/skills" "$HOME/.agents/skills")

srcs=()
for bucket in "${BUCKETS[@]}"; do
  for skill_md in "$REPO/skills/$bucket"/*/SKILL.md; do
    [ -f "$skill_md" ] || continue
    srcs+=("$(dirname "$skill_md")")
  done
done

for DEST in "${DESTS[@]}"; do
  mkdir -p "$DEST"

  # Drop stale symlinks: anything pointing into this repo, or pointing nowhere.
  for entry in "$DEST"/*; do
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      /*) abs="$target" ;;
      *)  abs="$(cd "$DEST" && cd "$(dirname "$target")" 2>/dev/null && pwd)/$(basename "$target")" || abs="" ;;
    esac
    if [ ! -e "$entry" ] || [[ "$abs" == "$REPO"/* ]]; then
      rm "$entry"
    fi
  done

  linked=0
  for src in "${srcs[@]}"; do
    name="$(basename "$src")"
    target="$DEST/$name"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skip   $name  (real directory already at $target; move it away if you want the repo version)" >&2
      continue
    fi
    ln -sfn "$src" "$target"
    linked=$((linked + 1))
  done
  echo "$DEST: linked $linked skills"
done
