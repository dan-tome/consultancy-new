---
name: kit-code-review
description: Review a diff or pull request for correctness, security, performance and maintainability, and report only findings worth acting on. Use when asked to review code, a branch, a PR or "my changes", unless the repository has its own review skill.
---

# Code review

If the repository has its own review guide or skill, use it instead of this one.

## Steps

1. Find out what the change is for: the PR description, linked issue or commit messages. Review against that
   intent, not against how you would have written it.
2. Read the whole diff, then the surrounding code each change touches: callers, tests, config.
3. Check each change against the list below.
4. For every possible finding, confirm it from the code before reporting: name the input or state that
   triggers it and what goes wrong. Drop anything you can't make concrete.
5. Report findings most severe first. For each one give the file and line, the problem, the failure scenario
   and a suggested fix. Mark style points as nits, and keep them few.

## What to check

- **Correctness:** edge cases (empty, null, zero, one, many, very large), off-by-one, wrong conditions,
  error paths, retries, time zones, concurrency and shared state, partial failure.
- **Security:** input validation, injection (SQL, shell, path, template), authn/authz checks on every new
  entry point, secrets in code or logs, unsafe deserialisation, overly broad permissions.
- **Data:** migrations that are reversible and safe on large tables, backwards compatibility of APIs, events
  and stored formats.
- **Performance:** N+1 queries, unbounded loops or result sets, work in hot paths, missing timeouts.
- **Tests:** does a test fail without the change? Are the risky paths covered?
- **Maintainability:** naming, duplication of existing helpers, dead code, comments that say why.

Don't report what a linter or compiler would catch, unless the build isn't run.
