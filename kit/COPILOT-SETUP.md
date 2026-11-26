# Setting up the consultancy kit (instructions for Copilot)

You are GitHub Copilot on the user's work machine, working in a folder that is not a git repository. Follow
these steps to connect that folder to the consultancy kit. Run the commands in PowerShell, show the user each
command before you run it, and stop and ask if anything fails or differs from what is described.

## 1. Find the clone

The kit lives in a clone of `https://github.com/dan-tome/consultancy-new.git`.

- If the user named a path, use it. Otherwise check `$HOME\consultancy-new`.
- If it isn't there, ask the user where to put it (default `$HOME\consultancy-new`), then run:
  `git clone https://github.com/dan-tome/consultancy-new.git "<path>"`
- Don't put the clone inside the working folder.

## 2. Install

Run, with the working folder's full path (the folder open in this session):

```powershell
& "<clone>\kit\Install-Copilot.ps1" -Folder "<working folder>"
```

This links the `kit-*` skills and the kit's instruction file into `~/.copilot`, writes a marked
"Consultancy kit" block into `<working folder>\AGENTS.md` (anything else in that file is kept), and turns off
pushing from the clone. Warnings that a folder was skipped mean something with that name already exists in
`~/.copilot`; report them, don't delete anything.

## 3. Check

- `Get-ChildItem "$HOME\.copilot\skills" -Filter 'kit-*'` lists the kit skills.
- `<working folder>\AGENTS.md` contains the block between `consultancy-kit:start` and `consultancy-kit:end`.
- `git -C "<clone>" remote -v` shows `no-push` for push.
- `git -C "<clone>" status --porcelain` prints nothing.
- Read `<clone>\kit\copilot\instructions\consultancy-kit.instructions.md`, which holds the rules for the
  repo. In your report, summarise them for the user in a few lines so they can confirm you've understood.

## 4. Report

Tell the user what was installed and that new skills and instructions load in a new chat session (in VS Code,
a reload may be needed). From then on:

- "update the kit" pulls the clone and re-runs the install.
- "ask the consultant" uses the `kit-ask-consultant` skill.

## Rules while doing this

The full rules are in `kit/copilot/instructions/consultancy-kit.instructions.md`. During setup in particular:

- Never edit, commit to or push from the clone. Never copy anything from the working folder or the machine
  into it.
- Don't change other Copilot settings, skills or instructions.
- Company policy comes first: if it forbids any step, stop and tell the user.
