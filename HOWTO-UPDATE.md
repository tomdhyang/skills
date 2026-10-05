# How this repo is used (my notes)

Fork of [mattpocock/skills](https://github.com/mattpocock/skills). Lives at `~/.agents/skills-repo/` on every machine.

- `origin`   = github.com/tomdhyang/skills (mine, push here)
- `upstream` = github.com/mattpocock/skills (Matt, pull only)
- `skills/mine/` = my own skills. Upstream never touches it.
- `scripts/link.sh` = symlinks engineering + productivity + mine into `~/.claude/skills` and `~/.agents/skills`.
  `in-progress/`, `misc/`, `deprecated/` stay unlinked.

## Pull Matt's updates

```bash
cd ~/.agents/skills-repo
git fetch upstream
git merge upstream/main        # conflicts only where I edited a file he also edited
./scripts/link.sh              # picks up added / removed skills
git push
```

Read `CHANGELOG.md` after merging to see what changed.

## New machine

```bash
git clone https://github.com/tomdhyang/skills.git ~/.agents/skills-repo
cd ~/.agents/skills-repo
git remote add upstream https://github.com/mattpocock/skills.git
./scripts/link.sh
```

## Rules I set for myself

- Prefer not to edit Matt's skill files. Standing behaviour goes in `~/.claude/CLAUDE.md`; it survives every merge with zero conflicts. (This is also Matt's own advice in `docs/engineering/ask-matt.md`.)
- Don't delete a skill I dislike. Leave the folder; a skill is "uninstalled" by not being in a linked bucket.
- Add a new skill of my own: folder under `skills/mine/<name>/SKILL.md`, run `link.sh`, commit, push.
