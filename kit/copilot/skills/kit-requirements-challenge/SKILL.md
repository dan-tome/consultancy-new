---
name: kit-requirements-challenge
description: Question a request, ticket or spec before building it, to surface gaps, contradictions, hidden assumptions and the real goal, and produce a short list of questions and proposed answers. Use when a requirement is vague, seems wrong, could be read in more than one way, or before starting work bigger than a small fix.
---

# Requirements challenge

Make sure the right thing gets built before building it.

## Steps

1. **Restate it.** In two or three sentences, say what is being asked and for whom. If you can't, that is
   the first question.
2. **Find the real goal.** Ask "what problem does this solve, and how will we know it worked?" Note whether
   the request is a solution in disguise, and whether a simpler change would reach the same goal.
3. **Probe for gaps.** Go through these and note anything missing or unclear:
   - who uses it and with what permissions;
   - inputs, outputs and formats; what happens with invalid, missing or duplicate input;
   - edge cases: empty, very large, concurrent, partial failure, retries, time zones;
   - non-functional needs: speed, scale, availability, security, privacy, audit, accessibility;
   - what must not change: existing behaviour, APIs, data, other teams;
   - how it will be tested and accepted.
4. **Look for conflicts.** Requirements that contradict each other or the existing code. Check the code
   rather than assuming (see `kit-evidence`).
5. **Propose answers.** For each question, suggest the most likely answer or a sensible default, so the user
   can confirm instead of starting from scratch.
6. **Size the risk.** Say which open questions would change the design if answered differently. Those must
   be answered before building. The rest can be decided along the way.

## Output

```
Understanding: <restated request and goal>
Must answer before building
1. <question> - proposed: <answer>
Can decide later
1. <question> - proposed default: <answer>
Simpler alternative (if any): <option>
```

## Stop when

- The goal is unclear, or a must-answer question has no plausible default. Ask the user, don't build.
- Answering would need information you don't have access to. Say who would likely know.
