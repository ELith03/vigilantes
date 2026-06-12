# 5. Smallest reversible change

**Statement:** Prefer incremental, undoable moves over big-bang rewrites.

**Why:** Reversible changes lower the cost of being wrong. The cost of an unrevertable mistake is asymmetric.

**Anti-pattern:** "Let me rewrite the whole module while I'm in there." (Scope creep, irreversibly.)

**Used by:** brainstorming (Phase 6 approaches), writing-plans (steps ordered by reversibility), code-review, git worktrees.

**Source basis:** Kent Beck, "Tidy First?", and the broader incremental-design school. Operationalized via the using-git-worktrees skill.
