# 8. Test the boundaries, not the path

**Statement:** Probe edge cases, failure modes, and adversarial inputs — not just the happy path.

**Why:** Happy-path correctness is the cheapest property to achieve. Robustness is the property that matters in production.

**Anti-pattern:** A test suite that exercises `add(2, 3)` and stops.

**Used by:** brainstorming (Phase 7 failure-mode pass), TDD (iron law extension), writing-plans, debug.

**Source basis:** TDD's iron law is the test-time version; the brainstorming extension is design-time. The category list in brainstorming's Phase 7 (10 categories) is the operational checklist.
