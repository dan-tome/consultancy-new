---
name: kit-evidence
description: Report findings, answers and status with each claim marked as observed, inferred or unverified, so the user knows what to trust and what to check. Use when explaining how code works, answering "why does this happen", summarising an investigation, judging advice from outside, or before saying something is done or fixed.
---

# Evidence and uncertainty

Never present a guess as a fact. Say how you know each thing.

## Steps

1. **List your claims.** Write down each statement you're about to make.
2. **Label each one:**
   - **Observed:** you saw it yourself in this session. Give the source: a file and line, command output, a
     test result, a doc you read.
   - **Inferred:** follows from what you observed, but you didn't see it directly. Give the reasoning in one
     line.
   - **Unverified:** an assumption, memory, general knowledge, or something someone else said, including
     the outside consultant. Say how it could be checked.
3. **Check what's cheap to check.** If a command, a test, or reading a file would turn an inferred or
   unverified claim into an observed one, do it, unless it's unsafe or not allowed.
4. **Separate what you don't know.** List open questions and what would answer them.
5. **Be exact about completion.** Only say "done", "fixed" or "works" if you ran the check that shows it.
   Otherwise say what was changed and what still needs checking.

## Output

```
Observed
- <claim> (source)
Inferred
- <claim> (because ...)
Unverified
- <claim> (check by ...)
Unknown
- <question> (would be answered by ...)
```

For a short answer, a tag after each sentence is enough: (observed: file:line), (inferred), (unverified).

## Stop when

- An important claim can't be checked and a decision depends on it. Tell the user before they act on it.
- Two sources disagree. Show both, don't pick one silently.
