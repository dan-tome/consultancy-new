---
name: kit-change-plan
description: Plan a risky change (a migration, refactor, dependency upgrade, config or infrastructure change, data fix, or release) as small, reversible steps, each with a check and a way back. Use before making a change that could break production, lose data or be hard to undo, or when asked how to roll something out safely.
---

# Safe change planning

Make big changes as small, checked, reversible steps.

## Steps

1. **Describe the change and why** in two sentences. Name what it touches: code, data, schema, config,
   infrastructure, other teams' systems.
2. **Find what could break.** Callers, consumers, jobs, reports, data shape, performance, permissions,
   anything that depends on the old behaviour. Read the code and config. Label assumptions as unverified
   (see `kit-evidence`).
3. **Split it into steps** that can each be shipped and undone on their own. Common patterns:
   - expand, then migrate, then contract (add the new thing, move users and data, remove the old thing);
   - feature flag or config switch, off by default;
   - write to both old and new, then read from new, then stop writing to old;
   - small batches for data changes, with a dry run first.
4. **For each step, write down:**
   - what to do (exact commands or code change);
   - how to check it worked (a test, query, metric or log line, and the expected result);
   - how to undo it, and whether undoing loses anything;
   - when to stop and undo (the signal that it went wrong).
5. **Before starting:** backups or snapshots for data, who needs to know, when to do it (low traffic, people
   available), and what "done" looks like.
6. **Review the plan** for any step that can't be undone. Make it as late and as small as possible, and get
   the user's explicit agreement for it.

## Output

A numbered plan. Each step lists: Do / Check / Undo / Stop if. Before step 1, list the preconditions. After
the last step, list the clean-up.

## Stop and ask when

- A step can't be undone and there's no backup.
- You don't know who or what depends on the thing being changed.
- The repository or company has a change process (approvals, change tickets, release windows). Follow it.
