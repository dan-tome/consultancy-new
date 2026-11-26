---
name: kit-pr-description
description: Write a pull request title and description from the branch's diff and commits, so a reviewer knows why the change exists, what it does and how it was tested. Use when asked to write or improve a PR description, unless the repository has its own PR template.
---

# Pull request description

If the repository has a PR template (`.github/pull_request_template.md` or similar), fill that in instead.

## Steps

1. Read the diff against the target branch and the commit messages. Find the linked issue if there is one.
2. Write a title under about 70 characters that says what the change does, in the imperative
   ("Retry failed uploads with backoff").
3. Write the body with these sections, leaving out any that would be empty:

   ```
   ## Why
   The problem or need, in one or two sentences. Link the issue.

   ## What changed
   The main changes, grouped by intent rather than by file.

   ## How it was tested
   What was run or checked, and the result.

   ## Risks and rollout
   Migrations, flags, config, backwards compatibility, how to roll back.

   ## Notes for reviewers
   Where to start, what to look at closely, what is out of scope.
   ```

4. Keep it short. Say only what the diff doesn't already make obvious. Don't claim tests were run unless
   they were.
