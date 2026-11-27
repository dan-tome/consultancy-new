---
name: kit-build-prep
description: Checklist to run before building one or more repositories, so the build uses current sources and the user knows its exact scope. States the scope, finds steps that need approval, checks every checkout with a tested script, refreshes only what is routine, and asks about the rest. Use before any build, rebuild or "build the stack", and when asked why a build used old sources.
---

# Before a build

Do the steps in order. Say which step you are on. Building comes last, at step 6.

The script is `<clone>\kit\copilot\skills\kit-build-prep\Get-RepoState.ps1`, where `<clone>` is the clone path
from the "Consultancy kit" block in `AGENTS.md`. It fetches, then changes no files.

## Step 1. Write the scope

Write down, from the task and then the repos' own build docs (README, AGENTS.md, build instructions):

- the target repo (path) and the build configuration;
- each dependency repo that gets built from source, with its path;
- dependencies used prebuilt (not rebuilt).

Check: every item has a value. If one is unclear, ask the user that exact question, listing what you do
know. Asking is not stopping: carry on with the steps you can do.

## Step 2. Find the approval gates

Read the repos' own instructions and the user's request for anything that needs approval or is not allowed,
such as refreshing shared dependencies, switching branches or fetching. Write them as a list, or "none
found". Those instructions come before this skill (kit rule 5).

## Step 3. Check every checkout

Run, with every repo from step 1:

```
& "<clone>\kit\copilot\skills\kit-build-prep\Get-RepoState.ps1" -Path "<target repo>", "<dependency repo>"
```

If step 2 found that fetching needs approval, add `-NoFetch` and say so.

Check: one row per repo with a State. If not, stop and tell the user.

## Step 4. Decide per repo

| State | Target repo | Dependency repo |
| --- | --- | --- |
| UP-TO-DATE | Nothing to do. | Nothing to do. |
| BEHIND | Run `git -C "<repo>" pull --ff-only`. This is routine, unless step 2 found a gate or the user asked for a specific older commit; then ask. | Refresh only if the user or the repo's instructions say so. Otherwise ask. |
| AHEAD | Build as is. Mention the local commits. | Same. |
| DIRTY, DIVERGED, DETACHED, NO-UPSTREAM, FETCH-FAILED, NOT-A-REPO | Change nothing. Ask the user. | Same. |

After any pull, run step 3 again. Expected: that repo is now UP-TO-DATE.

## Step 5. Show the plan

Before building, show the user one block:

```
Build plan
Scope: <target, configuration, dependencies built, dependencies prebuilt>
Sources: <the script's table>
Refreshed: <repos pulled, or "none">
Needs your answer: <each question, or "nothing">
```

If anything needs an answer, wait for it. Otherwise go on.

## Step 6. Build

Build exactly the scope from step 5. Keep the Commit column with your results, so every result can be tied to
the sources it came from.

## If something was skipped, or the user asks why

Never just stop. Answer in this shape, then wait for the user's choice:

```
What happened: <the step skipped, e.g. "I built without refreshing the target checkout">
What it affects: <from the script, e.g. "target was 3 commits behind; the build may lack recent changes">
Options:
A. Refresh <repos> and rebuild (<what needs approval, if anything>)
B. Keep this build and label the results with commit <Commit>
C. Something else you choose
```

Run the script first if you haven't, so "What it affects" is observed, not guessed.
