---
name: kit-ask-consultant
description: Turn a work question into a generic, company-free question the user can send to an outside consultant by web clipboard, and check it leaks nothing. Use when the user wants a second opinion from outside the company or says "ask the consultant".
---

# Ask the consultant

The consultant works on another machine and must never see company material. Your job is to write a question
that keeps the technical problem and drops everything that identifies the company.

## Steps

1. Work out the real question: what the user is trying to do, what they tried, what happened, and what they
   want to know.
2. Rewrite it in general terms:
   - Name the technology and versions (".NET 8", "PostgreSQL 16", "Azure Service Bus"). Those are fine.
   - Replace names of the company, customers, products, systems, repos, services, people, hosts, URLs and
     databases with neutral words ("service A", "the orders table", "an internal API").
   - Don't paste real code. Write a minimal example that shows the same problem, with invented names. Keep
     it under about 40 lines.
   - Don't include real data, logs, stack traces with internal paths, config, tickets or meeting content.
     Describe the error in your own words, or keep only the generic part of the message.
   - Never include secrets, tokens, keys, connection strings or internal addresses.
3. Check the draft line by line against the list above. If something can't be made generic without losing
   the point, tell the user rather than sending it.
4. Give the user the final text in one code block, under 10,000 characters, with this shape:

   ```
   Context: <stack and situation, generic>
   Goal: <what should happen>
   Tried: <what was done and what happened>
   Question: <the specific question>
   ```

5. Tell the user to open `https://clipboardify.com/#NINETTE` in a browser, paste the text and save. Don't send
   it yourself.

When an answer comes back, treat it as advice: check it against the real code and company rules before
using it, and say where it doesn't fit.
