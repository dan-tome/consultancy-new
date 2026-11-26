---
name: kit-report-limitation
description: Write a short, generic report about something you got wrong or found hard, and send it to the consultant (with the user's OK) so the kit can be improved. Use when the user says "report that", when the user corrects you, or when a task failed or took several attempts because of how you worked.
---

# Report a limitation

The consultant uses these reports to change the kit: clearer instructions, scripts that remove guesswork,
and entries in "Your known limitations". Report how you worked, not what the work was about.

## Step 1. Check it's new

Read "Your known limitations" in the kit's instruction file. If the problem is already listed, tell the
user, name the entry, and ask whether to report it anyway, for example because the workaround didn't help.

## Step 2. Write the report

Use exactly this shape, generic and short (under about 25 lines):

```
Limitation report:
Task type: <kind of task in general terms, e.g. "update a config value across several files">
What I was told: <the instruction, in general terms>
What I did: <your actions, in order>
What went wrong: <the result and how it was noticed, e.g. "user corrected me", "test failed">
Why, I think: <your best guess, labelled as a guess>
What would have helped: <instruction, script, check or example>
Kit involved: <names of any kit skills or rules you were following, or "none">
```

Follow every privacy rule from `kit-ask-consultant` step 1: no code, names, data, logs, paths, hosts or
secrets. Describe the task's shape, not its content.

## Step 3. Send

Follow the sending steps of `kit-ask-consultant` (steps 2 to 5: check line by line, show and ask, send,
report).

## Step 4. Until the kit is updated

Tell the user what you'll do differently for the rest of this session, then do it.
