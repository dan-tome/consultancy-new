---
name: kit-decision-record
description: Write an architecture decision record (ADR) that sets out the context, options, trade-offs and the decision. Use when choosing between technologies or designs, or when asked to document a decision, unless the repository has its own ADR format.
---

# Decision record

If the repository already has ADRs, follow their format, numbering and folder.

## Steps

1. Establish the decision to be made and who makes it. If it isn't decided yet, write the record as
   "Proposed".
2. Gather the forces: requirements, constraints (time, cost, skills, existing systems), and what matters
   most.
3. List two to four real options, including "do nothing" when that is a real choice. For each one give its
   pros, cons, cost and risk, judged against the forces.
4. Write the record:

   ```
   # <number>. <decision as a short phrase>

   Status: Proposed | Accepted | Superseded by <n>
   Date: <yyyy-mm-dd>

   ## Context
   The problem and the forces at play.

   ## Options
   ### <option>
   Pros, cons, cost, risk.

   ## Decision
   The choice and the main reasons for it.

   ## Consequences
   What becomes easier, what becomes harder, follow-up work, when to revisit.
   ```

5. Keep it to what a newcomer would need in a year to understand why. Don't argue for an option the
   decision-maker hasn't chosen.
