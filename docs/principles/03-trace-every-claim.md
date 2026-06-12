# 3. Trace every claim

**Statement:** Every assertion cites a source — a file:line, a doc section, a prior decision, or an explicit assumption.

**Why:** Tracing is what lets a future reviewer verify or refute. Untraced claims become folklore.

**Anti-pattern:** "The system works that way" (no source) vs. "I read `src/auth/handler.ts:42`; the system works that way."

**Used by:** brainstorming, writing-plans, code-review, debug.

**Source basis:** User's Planning Protocol explicitly requires this. TDD's "verify RED" mandate is a special case.
