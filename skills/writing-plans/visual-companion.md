# writing-plans v2 — Worked Example

> A long-form walkthrough of writing-plans v2 applied to a real feature: the "password reset" feature from the Brainstorming v2 worked example. Shows the planner's flow: risk-class → design intake → principles audit → structure selection → step authoring → self-review → user review → handoff.

The Brainstorming v2 spec already exists at `docs/vigilantes/specs/2026-06-13-password-reset.md`. This document shows how the planner turns that spec into a plan.

---

## Phase 0 — Risk-class confirmation

The Brainstorming v2 spec declared the feature as **medium risk** in its scope-risk profile. The planner confirms: "medium" matches the heuristic (auth surface, but contained to 2 modules — `src/auth/` and `src/mail/`). The user agrees.

Plan depth: ~4-10 steps. Medium-risk plan structure.

## Phase 1 — Design intake

Design is at `docs/vigilantes/specs/2026-06-13-password-reset.md` — a full spec with 6 components (DB schema, API, email template, UI, rate limit, tests). Sufficient for a plan. No upgrade needed.

## Phase 2 — Principles audit

Pick 4 of the 10 Principles Library principles:

- **#1 Look before you leap** — every step that touches a new file cites a path:line in the design.
- **#5 Smallest reversible change** — order steps so reversible changes (table create, code) come before non-reversible (token storage).
- **#8 Test the boundaries, not the path** — every behavior step has a paired test step; the security tests (expired token, reused token) are explicit.
- **#9 Optimize for the next reader** — the plan is written for an implementer who has zero context.

These appear at the top of the plan file in the "Principles in play" section.

## Phase 3 — Research dispatch

No research needed. The codebase is well-understood from the Brainstorming v2 Phase 1 read (`src/auth/login.ts`, `src/mail/send.ts`, etc.). Skip the subagent.

## Phase 4 — Plan structure selection

Medium-risk plan structure selected. 5 sections: Task, Files to create / modify, Step-by-step, Verification, Done when. No risk register or rollback plan (medium-risk doesn't require them by default).

## Phase 5 — Step authoring

8 step bodies. Each has Action, File path, Code, Verification. Behavior steps (5-7) add Test pairing. Non-reversible steps (Step 1, the table migration) add Rollback.

### Step 1: Create the `password_reset_tokens` table

**File:** `prisma/schema.prisma:24`
**Code:**
```prisma
model PasswordResetToken {
  id        String   @id @default(cuid())
  userId    String
  tokenHash String   @unique
  expiresAt DateTime
  usedAt    DateTime?
  createdAt DateTime @default(now())
  user      User     @relation(fields: [userId], references: [id])
  @@index([userId])
}
```
**Verification:** Run `npx prisma migrate dev --name add_password_reset_tokens` and confirm migration succeeds. Then `psql -c '\d password_reset_tokens'` shows the new table.
**Rollback:** Run `npx prisma migrate resolve --rolled-back <migration-name>`. Then `npx prisma migrate dev` to remove the table. (Reversible because we control the migration tool.)

### Step 2: Write the test for the `requestPasswordReset` function

**File:** `src/auth/password-reset.test.ts:1`
**Code:**
```ts
import { requestPasswordReset } from './password-reset';

describe('requestPasswordReset', () => {
  it('returns success even for non-existent emails', async () => {
    const result = await requestPasswordReset('nobody@example.com');
    expect(result.success).toBe(true);
  });

  it('creates a token for valid users', async () => {
    const user = await testHelpers.createUser({ email: 'real@example.com' });
    const result = await requestPasswordReset('real@example.com');
    expect(result.success).toBe(true);
    const tokens = await db.passwordResetToken.findMany({ where: { userId: user.id } });
    expect(tokens).toHaveLength(1);
  });
});
```
**Verification:** Run `npm test -- password-reset` and confirm RED (function doesn't exist yet).
**Test pairing:** This test step precedes Step 3 (the implementation). TDD-first.

### Step 3: Implement `requestPasswordReset`

**File:** `src/auth/password-reset.ts:1`
**Code:**
```ts
import { randomBytes, createHash } from 'crypto';
import { db } from './db';
import { sendPasswordResetEmail } from '../mail/send';

export async function requestPasswordReset(email: string): Promise<{ success: boolean }> {
  const user = await db.user.findUnique({ where: { email } });
  if (!user) return { success: true }; // Silent: don't reveal whether email exists

  const token = randomBytes(32).toString('hex');
  const tokenHash = createHash('sha256').update(token).digest('hex');

  await db.passwordResetToken.create({
    data: { userId: user.id, tokenHash, expiresAt: new Date(Date.now() + 15 * 60 * 1000) },
  });

  await sendPasswordResetEmail(user.email, token);
  return { success: true };
}
```
**Verification:** Run `npm test -- password-reset` and confirm GREEN (Step 2's tests now pass).

### Step 4: Implement rate limiting on `requestPasswordReset`

**File:** `src/auth/password-reset.ts:42`
**Code:**
```ts
import { rateLimit } from './rate-limit';

export async function requestPasswordReset(email: string): Promise<{ success: boolean }> {
  await rateLimit({ key: `reset:${email}`, max: 3, window: 60 * 60 * 1000 }); // 3 per hour per email
  // ... rest as in Step 3
}
```
**Verification:** Run `npm test -- password-reset -- --grep "rate limit"` and confirm new test passes.

### Step 5: Write the test for `confirmPasswordReset`

**File:** `src/auth/password-reset.test.ts:48`
**Code:**
```ts
describe('confirmPasswordReset', () => {
  it('rejects expired tokens', async () => { /* ... */ });
  it('rejects reused tokens', async () => { /* ... */ });
  it('updates the password on valid use', async () => { /* ... */ });
});
```
**Verification:** Run `npm test -- password-reset` and confirm new tests are RED.

### Step 6: Implement `confirmPasswordReset`

**File:** `src/auth/password-reset.ts:60`
**Code:**
```ts
export async function confirmPasswordReset(token: string, newPassword: string): Promise<{ success: boolean }> {
  const tokenHash = createHash('sha256').update(token).digest('hex');
  const record = await db.passwordResetToken.findUnique({ where: { tokenHash } });
  if (!record || record.usedAt || record.expiresAt < new Date()) {
    return { success: false };
  }
  await db.user.update({ where: { id: record.userId }, data: { passwordHash: await bcrypt.hash(newPassword, 12) } });
  await db.passwordResetToken.update({ where: { id: record.id }, data: { usedAt: new Date() } });
  return { success: true };
}
```
**Verification:** Run `npm test -- password-reset` and confirm Step 5's tests are GREEN.

### Step 7: Wire up the `/forgot` and `/reset` routes

**File:** `src/routes/auth.ts:24`
**Code:**
```ts
router.post('/forgot', async (req, res) => { await requestPasswordReset(req.body.email); res.json({ success: true }); });
router.post('/reset', async (req, res) => { /* calls confirmPasswordReset */ });
```
**Verification:** Run `npm test` and confirm full suite still green.

### Step 8: Add audit log entry on successful reset

**File:** `src/audit/log.ts:18`
**Code:**
```ts
await db.auditLog.create({ data: { event: 'password_reset', userId: user.id, ip: req.ip } });
```
**Verification:** Run `npm test` and confirm new audit log test passes.

---

## Phase 6 — Self-review

Run the 10-item checklist:

1. **Every step has code.** ✓ All 8 steps have complete code blocks.
2. **Every step is bite-sized.** ✓ Each step is one observable change.
3. **Every step has a verification line.** ✓ All 8 have `Verification:` lines.
4. **Every non-reversible step has a rollback line.** ✓ Step 1 (table create) has rollback. Others are reversible.
5. **Every behavior change has a paired test step.** ✓ Steps 2→3, 5→6 are TDD pairs.
6. **Steps are ordered by reversibility.** ✓ Reversible (table, code) first; non-reversible would be last.
7. **Principles cited at the top.** ✓ 4 cited in "Principles in play."
8. **Failure modes for risky steps are named.** ✓ Step 6 calls out expired/reused tokens; Step 4 calls out rate limit.
9. **Exact file paths throughout.** ✓ All paths are absolute or rooted.
10. **No step depends on a prior step's undocumented state.** ✓ Each step names what it expects.

All 10 pass. Self-review: PASS.

## Phase 7 — User review gate

Plan presented to the user. User reads, replies: "Approve. Step 8 wasn't in the original brainstorming spec — was that intentional?"

The planner replies: "Good catch. Step 8 (audit log) was a user-requested addition in the Brainstorming v2 Phase 10 review. Want me to update the spec, or is the plan fine as-is?"

User: "Plan is fine. Spec update can wait."

Approval received. Move to handoff.

## Phase 8 — Handoff

Save the plan to `docs/vigilantes/plans/2026-06-12-password-reset.md`. Return the path to the user.

```
Plan saved to: docs/vigilantes/plans/2026-06-12-password-reset.md
```

The planner's job ends here. Implementation is a separate session. If the user wants to execute the plan now, they open a new session and invoke `subagent-driven-development` (or `executing-plans`) with the plan file as input.

---

## Reference: when to use which plan structure

| Risk class | Length | Use for |
|---|---|---|
| Low | 1-3 steps, ~20-50 lines | Cosmetic changes, internal refactors with full test coverage, well-understood extensions. |
| Medium | 4-10 steps, ~100-200 lines | New features touching 1-2 modules, behavior changes with test requirements, performance improvements. |
| High | 10-15 steps, ~200-500 lines | Schema migrations, auth/permission changes, public API changes, multi-module refactors, production data changes. Adds risk register + rollback plan + step ordering rationale. |

When in doubt, classify as medium. Better to over-engineer the plan than under-engineer it.
