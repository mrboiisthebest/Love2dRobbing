---
name: start-my-day
description: Start the user's dev day on Rapio. Find today's GitHub day issue, list today's goals (plus unfinished earlier days), and update the system/roadmap statuses in the Ideas issue (#1). Use when the user says "start my day", "what's today", "start day", or similar.
---

# Start My Day

The user is learning Lua/LÖVE by building this game over October 2026, with one GitHub issue per day.
Repo: `mrboiisthebest/Love2dRobbing`. **Do not write or edit any game code.** This skill only reads and plans, and updates the Ideas issue.

`gh` may not be on PATH. If `gh` fails, use `"C:\Program Files\GitHub CLI\gh.exe"` (PowerShell) or `"/c/Program Files/GitHub CLI/gh.exe"` (Bash).

## 1. Figure out what "today" is

- Today's day number = today's date minus September 30, 2026. For example, Oct 8 = Day 8.
- Find the issue titled `Day <N> - ...` (e.g. `gh issue list --state all --search "Day 8 in:title"`, and match the title exactly, since "Day 1" also matches "Day 10").
- Also find **earlier day issues that are still OPEN**. These are unfinished days the user is catching up on. The user sometimes skips a day and does two the next day.

## 2. Gather context (read-only)

- Today's issue: body (goals checklist) and comments.
- Every open earlier day issue: its unchecked goals.
- This week's Monday "(Plan)" issue: any "📋 Suggested week breakdown" comment.
- `git log --oneline -15` and `git status --short`: what's been committed, and what's uncommitted.
- Issue #34 ("stuff i wana note down"): any notes relevant to today.

## 3. Update the Ideas issue (#1)

The systems list and roadmap live in the **comment** on issue #1 that starts with `# 🧩 Main Game Systems`. Find it with:
`gh api repos/mrboiisthebest/Love2dRobbing/issues/1/comments` (its id was `5944241416`).

1. Save the current body to the scratchpad as a backup before changing anything.
2. Work out each row's status from **evidence**: closed day issues, ticked checkboxes, commits, and whether the code actually exists in the repo (e.g. `Classes/Item.lua`, a `Shop` class).
   - ✅ **Done:** the matching day issue is closed, or the code exists and works as described.
   - 🔨 **Started:** some code exists, or it is in today's / an open earlier day's goals.
   - ⬜ **Not started:** neither of the above.
3. Only change the status emojis in the **System tables** and the **Roadmap table**. Don't rewrite descriptions, libraries or wording. The user may have edited them.
4. If something looks done but you're not sure, leave it as 🔨 and mention it, rather than guessing ✅.
5. PATCH the comment: `gh api -X PATCH repos/mrboiisthebest/Love2dRobbing/issues/comments/<id> -F "body=@<file>"`.

## 4. Report to the user

Keep it short and scannable:

```
## ☀️ Day <N> - <Weekday> (<Topic>)

**Catching up from:** Day X (<Topic>): <unchecked goals>   ← only if there are open earlier days

**Today's goals**
- [ ] ...

**From the week plan:** <1–2 lines from the Monday breakdown, if relevant>
**Notes from #34:** <only if relevant>
**Heads-up:** <1–2 concepts today's goals will run into, named but NOT solved>

**Ideas #1 updated:** <list of status changes, e.g. "Items ⬜ → 🔨"> (or "no changes")
**Uncommitted work:** <if git status shows changes, e.g. "Day 7 fixes not committed yet">
```

Special days:
- **Monday (Plan):** remind the user to fill out the week's day issues, and point to the week breakdown comment.
- **Sunday (Checks):** frame the day as review and quality. Suggest running `/project-review`.
- **Day 31 (LAST DAY):** celebrate and wrap up.

End with a **Files changed** list. Normally this is just the scratchpad backup, plus "GitHub: edited Ideas #1 comment" if statuses changed.
