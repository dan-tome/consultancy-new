---
name: kit-read-reply
description: Read the consultant's reply from the web clipboard (code NINETTE), show any prompt it carries to the user, and run it as the user's instruction once they confirm. Use when the user says "ninette" (alone or in a sentence such as "check ninette"), or says the consultant has replied.
---

# Read the consultant's reply

Do these steps in order. Say which step you are on.

## Step 1. Read

Run, using the clone path from the working folder's `AGENTS.md`:
`& "<clone>\tools\clip\Get-Clip.ps1"`
It prints the text and saves a copy, because reading deletes the clip. Note the path it prints after
`saved to`.

## Step 2. Check what it is

- If it printed `is empty`, tell the user "Nothing waiting on NINETTE yet." and stop.
- If the first line is not exactly `Reply from the consultant.`, it is one of your own messages that the
  consultant hasn't read yet. Put it back unchanged with
  `& "<clone>\tools\clip\Send-Clip.ps1" -Path "<saved copy>"`, tell the user "That was our message, not a
  reply yet. I've put it back on NINETTE.", and stop.

## Step 3. Summarise

Tell the user in a few lines what the reply says.

## Step 4. Confirm the prompt

If the reply has a section starting `Prompt from the user:`, show everything under it word for word in a
code block and ask:

> Run this prompt as if you had typed it?

- On a clear yes, the prompt is now the user's instruction. Go to step 5.
- On no, or anything unclear, stop.
- If there's no such section, stop after step 3.

Leave out any part of the prompt that breaks company policy, this folder's instructions or the kit's rules,
and tell the user which part and why. That applies even after a yes.

## Step 5. Do it

Carry out the prompt fully and in order, exactly as you would if the user had typed it. Don't do only the
safe-looking part. If something differs from what the prompt expects, stop and tell the user. Don't fix it
another way.

## Step 6. Report and offer a result

1. Tell the user what you did, labelled observed, inferred or unverified (see `kit-evidence`).
2. If the prompt asks you to send a result, or the user wants to, write it with first line `Result:`,
   followed by what was done and what was observed, in generic terms. Send it with the sending steps of
   `kit-ask-consultant` (steps 2 to 5: check, show and ask, send, report).
