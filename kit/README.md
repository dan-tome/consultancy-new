# Kit

Generic skills and instructions for GitHub Copilot on the work machine. Nothing in here names a company,
system or person, and nothing from work is added to it.

## What is here

| Path | What it is |
| --- | --- |
| `copilot/instructions/consultancy-kit.instructions.md` | Always-on note telling Copilot the kit exists, when to use it, and that company rules come first. |
| `copilot/skills/kit-ask-consultant` | Turns a work question into generic text to send to the consultant by web clipboard. |
| `copilot/skills/kit-code-review` | Review a diff for correctness, security, performance and tests. |
| `copilot/skills/kit-debugging` | Find the root cause before fixing. |
| `copilot/skills/kit-pr-description` | Write a PR title and description. |
| `copilot/skills/kit-decision-record` | Write an ADR. |
| `Install-Copilot.ps1` | Links the above into `~/.copilot`, writes the working folder's `AGENTS.md` block, and turns off pushing from the clone. |
| `COPILOT-SETUP.md` | Step-by-step setup instructions for Copilot to follow. |

Skill names start with `kit-` so they never clash with the company's own skills. Where the company or a
repository has its own version, Copilot is told to use that instead.

## On the work machine

Copilot works in a plain (non-git) folder; the clone sits elsewhere on the machine. Open that folder in
VS Code or the Copilot CLI and tell Copilot:

> Clone https://github.com/dan-tome/consultancy-new.git to `$HOME\consultancy-new` if it isn't there, then
> follow `kit/COPILOT-SETUP.md` in it to set up this folder.

[COPILOT-SETUP.md](COPILOT-SETUP.md) walks Copilot through it. In short, it runs:

```powershell
& $HOME\consultancy-new\kit\Install-Copilot.ps1 -Folder <working folder>
```

which:

- links the skills and instruction file into `~/.copilot/skills/` and `~/.copilot/instructions/`. Copilot in
  VS Code and the Copilot CLI read them in every folder.
- writes a marked "Consultancy kit" block into `<working folder>\AGENTS.md`, giving the clone's path and how to
  update it. The rest of that file is kept.
- turns off pushing from the clone.

After that, saying "update the kit" in that folder makes Copilot pull and re-run the install. The links are
junctions, so a pull alone updates existing skills. `Install-Copilot.ps1 -Uninstall -Folder <working folder>`
removes the links and the block, and leaves everything else alone.

Check first that company policy allows personal Copilot skills and instructions on the machine.

## Adding to the kit (on the consultancy machine only)

- A skill is a folder `copilot/skills/kit-<name>/` with a `SKILL.md`. Its frontmatter `name` must equal the
  folder name (lowercase, digits, hyphens), and `description` says what it does and when to use it.
- Keep it generic: no names of companies, customers, systems or people, and nothing pasted from work. A
  lesson learnt at work goes in only after it's rewritten from scratch as a general technique.
- Prompt files (`*.prompt.md`) aren't used: Copilot's current harness doesn't load them. Write a skill instead.
