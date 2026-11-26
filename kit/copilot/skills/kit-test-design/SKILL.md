---
name: kit-test-design
description: Decide what to test for a change or feature, based on where failure is most likely and most costly, and produce a short, prioritised list of test cases. Use when asked what to test, to write tests for new or changed code, or whether test coverage is enough.
---

# Risk-based test design

Spend tests where failure is likely and expensive. Don't aim for coverage numbers.

## Steps

1. **Scope.** List what changed or is being built: the entry points, the data it touches, and the callers.
   Read the code. Don't guess from names.
2. **Find the risks.** For each part, note what could go wrong and rate two things:
   - likelihood (high / medium / low): new or complex logic, edge cases, concurrency, external calls,
     parsing, dates and time zones, money and rounding, permissions;
   - impact (high / medium / low): data loss or corruption, security, money, many users, hard to notice or
     undo.
3. **Pick cases**, highest risk first. Per risk choose the cheapest test that would catch it:
   - unit test for logic and edge cases (empty, one, many, boundary values, invalid input, nulls);
   - integration test for contracts with databases, queues, APIs and config;
   - end-to-end test only for a few critical user journeys;
   - a negative test for every permission or validation rule.
4. **Check existing tests.** Mark which risks are already covered, and by which test. Don't duplicate them.
5. **Write the tests** if asked, following the repository's test framework, naming and folder layout. Each
   test checks one behaviour, and its name says which.

## Output

A table, highest risk first:

| Risk | Likelihood | Impact | Test (type, what it checks) | Covered already? |

Then name the risks you chose not to test and why.

## Stop and ask when

- You can't tell what the code is supposed to do. Use `kit-requirements-challenge` first.
- A risk can only be tested against a real external system or real data you mustn't use.
- The repository has its own test strategy that says otherwise. Follow it.
