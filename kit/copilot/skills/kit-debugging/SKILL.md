---
name: kit-debugging
description: Find the root cause of a bug, failing test or unexpected behaviour before changing code, by reproducing, narrowing and testing one hypothesis at a time. Use when something is broken and the cause isn't already obvious.
---

# Debugging

Don't propose a fix until you can explain the cause.

## Steps

1. **State the symptom precisely.** What was expected, what happened, where, since when. Collect the exact
   error and the steps that trigger it.
2. **Reproduce it.** Find the smallest, fastest way to trigger it: a failing test is best. If you can't
   reproduce it, gather more evidence (logs, inputs, environment differences) before guessing.
3. **Look for what changed.** Recent commits, dependency updates, config, data or environment. `git log`,
   `git bisect` and a diff between a working and a broken setup often find it fastest.
4. **Narrow it down.** Follow the data from input to the wrong output. Add logging or breakpoints at the
   boundaries and halve the search space each time.
5. **One hypothesis at a time.** Say what you think is wrong and what result would prove it, then check.
   Change one thing per experiment. Undo experiments that didn't help.
6. **Fix the cause, not the symptom.** Write or keep a test that fails before the fix and passes after.
   Check whether the same mistake exists elsewhere.
7. **Verify.** Run the reproduction, the related tests and the wider suite. Report what you ran and what
   passed.

If three attempts fail, stop and summarise what is known, what was ruled out and what you'd try next.
