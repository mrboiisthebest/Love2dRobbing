---
name: end-my-day
description: Wrap up the user's dev day on Rapio. Check what got done against today's GitHub day issue, tick off finished goals, fill in "Proof of work", update the Ideas issue (#1) statuses, and help commit. Use when the user says "end my day", "wrap up", "done for today", or similar.
---

# End My Day

The user is learning Lua/LÖVE by building this game over October 2026, with one GitHub issue per day.
Repo: `mrboiisthebest/Love2dRobbing`. **Do not write or edit any game code.** This skill reviews, records and commits only.

`gh` may not be on PATH. If `gh` fails, use `"C:\Program Files\GitHub CLI\gh.exe"` (PowerShell) or `"/c/Program Files/GitHub CLI/gh.exe"` (Bash).

## 1. Find the day(s) being wrapped up

- Today's day number = today's date minus September 30, 2026. For example, Oct 8 = Day 8.
- Find the `Day <N> - ...` issue (match the title exactly, since "Day 1" also matches "Day 10").
- Also include **earlier day issues that are still OPEN**, since the user may have worked on those today too.

## 2. Gather evidence (read-only)

- `git status --short` and `git diff --stat`: uncommitted work.
- `git log --since=midnight --oneline`: anything already committed today.
- Read the changed files (only the parts that changed) to understand what was actually built.
- Each day issue's goals checklist and comments, including any "🟡 Code improvements" checklist comment.

Match the work to the goals. For each unchecked goal, decide: **done**, **partly done**, or **not touched**. Base this on the code, not guesses.

## 3. Confirm with the user (one AskUserQuestion call)

Ask in a single call:
1. **Which goals are finished?** (multiSelect). Pre-describe your evidence, e.g. "Create Item Class: `Classes/Item.lua` exists with `new()`".
2. **Commit?** Options: "Commit & push as Day N (Recommended)", "Commit only, don't push", "I'll commit myself".
   - The user's convention is commit messages like `Day 7`. If two days were worked on, use e.g. `Day 7 & 8`.
3. **Close finished day issues?** Only ask if every goal on an issue is ticked.

Never tick, commit or close anything the user didn't confirm.

## 4. Apply

In this order:
0. **Screenshot.** Run the capture script in this skill's folder. It launches the game, waits, captures the game window (even if it's covered) and closes the game:
   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File .claude/skills/end-my-day/capture.ps1 -ProjectDir <repo root> -OutFile <repo root>/Proof/day-NN.png
   ```
   - Use two-digit day numbers (`day-08.png`). If several days were wrapped up, name it after the latest one.
   - **Look at the image** (Read it) before using it. If it's blank or wrong, skip it and say so.
   - If the script reports the game **exited early**, that means it crashes on startup. Tell the user clearly; this is the most important finding of the day. Don't commit until they decide what to do.
   - If LÖVE isn't installed at the default path (another device), skip the screenshot and mention it.
1. **Commit** (if chosen). Stage only project files that are part of today's work, plus `Proof/day-NN.png`. Check that `git status` contains no surprises (no save files, no secrets) before committing. Push if chosen.
2. **Tick the confirmed goals** in the issue body (`- [ ]` → `- [x]`). Edit only those checkboxes. Use `gh issue edit <n> --body-file <file>` after saving a backup of the original body to the scratchpad.
3. **Fill in "Proof of work"** under the existing `**Proof of work**` heading in the issue body. Add it below the heading, and don't replace anything the user wrote there. Include:
   - 2–4 bullets on what was built, in plain words
   - the files added/changed
   - the commit link, if committed (`https://github.com/mrboiisthebest/Love2dRobbing/commit/<sha>`)
   - the screenshot, embedded as an image:
     - **If committed and pushed:** pin it to the commit with `![Day N](https://raw.githubusercontent.com/mrboiisthebest/Love2dRobbing/<sha>/Proof/day-NN.png)`.
     - **Otherwise:** link `.../main/Proof/day-NN.png` and tell the user the image shows up once they push.
   - "📸 *Startup screen captured automatically. Paste screenshots of today's actual feature here too.*" The auto screenshot only shows the opening screen, so the user adds shots of deeper screens themselves (Win+Shift+S, then paste into the issue on GitHub).
4. **Close** the confirmed issues (`gh issue close <n>`).
5. **Update the Ideas #1 statuses** the same way `start-my-day` does. Edit the comment starting `# 🧩 Main Game Systems` (id `5944241416`). Change only the ✅ / 🔨 / ⬜ emojis, based on evidence, and back it up first.

## 5. Report

```
## 🌙 Day <N> wrapped up

**Finished:** <ticked goals>
**Still open:** <unfinished goals>: these show up in tomorrow's /start-my-day automatically

**What you learned today:** <2–3 concepts from the actual code, e.g. "inheritance with setmetatable", "table.remove while looping">
**Worth a look tomorrow:** <at most 1–2 real problems spotted in today's diff, named but not fixed. Or "nothing stood out">

**Committed:** <sha + message, or "not committed">
**Ideas #1 updated:** <status changes, or "no changes">
**Tomorrow:** Day <N+1> - <Topic> (<one-line preview>)
```

End with a **Files changed** list: `Proof/day-NN.png`, scratchpad backups, any commit, and GitHub edits (issue bodies ticked, issues closed, Ideas comment).
