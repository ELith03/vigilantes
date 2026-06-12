# Vigilantes Principles Library

The shared senior-dev principles the Vigilantes methodology cites by name. See `docs/principles/<NN>-<slug>.md` for full detail on each.

| # | Principle | One-liner |
|---|-----------|-----------|
| 1 | Look before you leap | Research the codebase and data model before acting. |
| 2 | Distinguish signal from assumption | Name what's verified vs what's guessed. |
| 3 | Trace every claim | Every assertion cites a source. |
| 4 | Question the question | Probe the real problem, not the stated one. |
| 5 | Smallest reversible change | Prefer incremental, undoable moves. |
| 6 | Make the implicit explicit | Surface tradeoffs, constraints, assumptions. |
| 7 | Push back when warranted | Challenge respectfully with evidence. |
| 8 | Test the boundaries, not the path | Probe edge cases + failure modes. |
| 9 | Optimize for the next reader | Clarity over cleverness. |
| 10 | Decide at the latest responsible moment | Delay commitment while keeping options open. |

## How to cite

- Top of a SKILL.md: include a "Principles cited in this skill" section listing the names + 1-sentence summary.
- Inline in skill text: *"We extend `requestPasswordReset`, following *Smallest reversible change*."*
- The full library is not auto-loaded; skills cite principles on demand.

## Adding a principle

v1 holds the cap at 10. Future additions require a justification: "what does this add that the existing 10 don't cover?" The cap is reviewed annually (post-v1).
