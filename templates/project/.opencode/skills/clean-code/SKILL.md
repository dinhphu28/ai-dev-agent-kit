---
name: clean-code
description: Use when writing or reviewing code and craftsmanship matters — naming, function or class design, code smells, refactoring, or duplication; when shaping system design, architecture boundaries, dependency direction, or applying SOLID; when frameworks or details leak into business rules; or when professional discipline is at stake — estimates, commitments, saying no, TDD, or working under pressure. Keywords: Clean Code, Clean Architecture, SOLID, code smell, refactor, TDD, boundaries, dependency rule.
---

# Clean Code

This skill distills three Robert C. Martin books into one discipline across three layers: **code** (Clean Code — naming, functions, classes, and the smell catalog), **system** (Clean Architecture — SOLID, component principles, the Dependency Rule, and boundaries), and **conduct** (The Clean Coder — commitment, estimation, TDD discipline, and behavior under pressure). Apply the code and system layers while producing a diff; apply all three when reviewing one or finishing a task. Every finding here is traceable to a named principle, smell code, or rule — never vague advice.

## When to use

- **While writing/implementing** — read *Principles at a glance* and open the relevant reference for the concern in front of you (a function, a module boundary, an estimate). Write to the principle, don't retrofit it.
- **While reviewing/finishing** — run the *Review checklist* against the diff or design, then emit the *Output format* verdict.

The three reference files are loaded **on demand** to save context — open only the one you need:

- `reference-clean-code.md` — code-level craftsmanship + full smell catalog (N, F, G, C, E, T codes).
- `reference-clean-architecture.md` — SOLID, component principles, the Dependency Rule, boundaries.
- `reference-clean-coder.md` — professional conduct, commitment, TDD discipline, estimation, pressure.

## Principles at a glance

### Code (Clean Code)

- **Meaningful names** — intention-revealing, pronounceable, searchable; no disinformation, no encodings (N6).
- **Functions do one thing** — small, one level of abstraction, descriptive names; few arguments (ideally 0–2), no flag args (F3), no side effects.
- **Command Query Separation** — a function either does something or answers something, never both.
- **DRY** — eliminate duplication; it is the root of most evil in software (G5).
- **Comments compensate for failures in code** — prefer expressing intent in code over a comment; delete commented-out code (C5).
- **Boy Scout Rule** — leave the code cleaner than you found it.
- **Errors over return codes** — throw exceptions, don't return error codes; don't return or pass `null`.
- Full catalog → `reference-clean-code.md`

### Architecture (Clean Architecture)

- **SRP** — a module has one reason to change / responds to one actor.
- **OCP** — open for extension, closed for modification; isolate changes behind abstractions.
- **LSP** — subtypes must be substitutable for their base types.
- **ISP** — depend on no interface you don't use; keep interfaces client-specific.
- **DIP** — depend on abstractions, not concretions; source code dependencies point toward policy.
- **The Dependency Rule** — source dependencies point inward; inner circles (entities, use cases) know nothing of outer circles (UI, DB, frameworks).
- **Component principles** — cohesion (REP, CCP, CRP) and coupling (**acyclic dependencies — no cycles**, SDP: depend in the direction of stability, SAP: stable = abstract).
- **Boundaries** — keep business rules independent of frameworks, DB, and delivery mechanism; details are plugins to policy.
- Full catalog → `reference-clean-architecture.md`

### Conduct (The Clean Coder)

- **An estimate is not a commitment** — estimate as a probability distribution (PERT: optimistic/nominal/pessimistic), commit only to what you control.
- **Say no** — professionals say no to unrealistic asks; "trying" implies reserved energy and is a form of lying.
- **TDD discipline** — the three laws; keep tests **F.I.R.S.T** (Fast, Independent, Repeatable, Self-validating, Timely).
- **Practice and craftsmanship** — the code you produce is your responsibility; test coverage and quality are non-negotiable.
- **Pressure** — stay calm, don't abandon your disciplines when squeezed; the way out of a mess is the disciplines, not shortcuts.
- Full catalog → `reference-clean-coder.md`

## Review checklist

### Code-level

- [ ] Names reveal intent; no noise words, no encodings (N6), searchable (N1–N4).
- [ ] Each function does **one thing** at **one level of abstraction**; ≤ ~3 args (F1 Too Many Arguments); no flag arguments (F3 Flag Arguments); no hidden side effects (G).
- [ ] No duplication — same logic appears once (**G5 Duplication**).
- [ ] Prefer polymorphism over switch/if-else chains on type (**G23**).
- [ ] Follow the **Law of Demeter** — no train wrecks `a.getB().getC().doX()` (G36).
- [ ] Dead code, commented-out code (**C5**), and dead comments removed; comments explain *why*, not *what*.
- [ ] Errors handled via exceptions; no returned/passed `null`; no swallowed exceptions.
- [ ] Code reads top-down; related things vertically close; conceptual affinity respected.

### Architecture

- [ ] Each class/module has **one reason to change / one actor** (**SRP**).
- [ ] New behavior added by extension, not by modifying tested code (**OCP**).
- [ ] Subtypes honor their base contract (**LSP**); no fat interfaces forced on clients (**ISP**).
- [ ] Dependencies point toward abstractions and inward toward policy (**DIP**, **Dependency Rule**).
- [ ] No cyclic dependencies between components (**Acyclic Dependencies Principle**).
- [ ] Business rules are free of framework, DB, and UI types — details sit behind boundaries.

### Professional discipline

- [ ] Tests are **F.I.R.S.T** and were written with the code (Timely), not bolted on; coverage is real, not skipped.
- [ ] No test disabled/deleted just to make the build green.
- [ ] Any estimate is a range, not a promise; commitments cover only what the author controls.
- [ ] Scope, risks, and blockers surfaced honestly — no "trying," no silent overcommitment.

## Output format

```markdown
## Clean Code Review

**Verdict:** PASS | NEEDS_WORK | BLOCKED

### Critical Issues
- [<PRINCIPLE/SMELL>] <file:line> — <what is wrong and why it violates the rule>
  <!-- e.g. [G5 Duplication] src/pay.ts:40 — tax calc repeated in 3 handlers -->
  <!-- e.g. [DIP] core/order.ts:12 — domain imports the Postgres client directly -->

### Suggested Changes
- <concrete refactor tied to a principle; smallest change that satisfies it>

### Professional/Process Notes
- <estimation/commitment/TDD/pressure observations, e.g. "PR disables 2 tests to pass CI (Clean Coder: don't go green by cheating)">
```

`PASS` = ships as-is. `NEEDS_WORK` = fixable issues, none blocking. `BLOCKED` = a red flag below is present.

## Red flags — stop and reconsider

- A function does **more than one thing**, or mixes levels of abstraction.
- A **cyclic dependency** between components/modules.
- **Framework, DB, or UI types leaking** into entities or use cases (violates the Dependency Rule).
- Committing to a **date you can't control**, or answering "I'll try" instead of yes/no.
- **Disabling or deleting a test to go green** instead of fixing the code.
- Widespread **duplication (G5)** or a growing `switch` on type where polymorphism belongs (G23).

## Sources

- *Clean Code: A Handbook of Agile Software Craftsmanship* — Robert C. Martin → `reference-clean-code.md`
- *Clean Architecture: A Craftsman's Guide to Software Structure and Design* — Robert C. Martin → `reference-clean-architecture.md`
- *The Clean Coder: A Code of Conduct for Professional Programmers* — Robert C. Martin → `reference-clean-coder.md`
