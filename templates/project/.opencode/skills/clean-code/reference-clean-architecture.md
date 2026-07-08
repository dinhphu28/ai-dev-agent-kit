# Clean Architecture — Reference

**Source:** Robert C. Martin, *Clean Architecture: A Craftsman's Guide to Software Structure and Design* (Prentice Hall, 2017).

**How to use this reference:** This is a traceable distillation of *Clean Architecture* for an AI coding agent designing or reviewing systems. Every rule below names its source principle, so you can cite it in a review comment ("violates DIP", "creates a dependency cycle — ADP", "database detail leaking into a use case"). Skim the tables for the SOLID and component principles; read a section in full when you need the rationale. When applying it: check the **Dependency Rule** first (it subsumes most violations), then SOLID at the class level and the component principles at the module/package level. Prefer citing the exact principle over vague "clean code" advice.

---

## 1. What Is Architecture

**Goal:** *The goal of software architecture is to minimize the human resources required to build and maintain the required system.* Good architecture is measured by the effort needed to meet the needs of the customer; if that effort is low and stays low over the life of the system, the design is good.

**Keep options open.** The primary job of an architect is to leave *as many options open as possible, for as long as possible*. Options are the details not yet decided (DB, web framework, delivery mechanism). Architecture is the art of *deferring decisions* and keeping the system *soft* — able to change to fit new requirements.

### Behavior vs Structure — the two values

Every software system provides two different values to stakeholders:

| Value | Question it answers | Nature |
|---|---|---|
| **Behavior** | Does the system do what stakeholders need *now*? | Urgent, visible, always demanded |
| **Structure** (architecture) | Can it *keep* meeting changing needs *cheaply*? | Important, often invisible, easily sacrificed |

The word "soft" in "software" exists because software was meant to be *easy to change*. Architecture serves the second value: the ease with which behavior can be changed.

### The Eisenhower matrix (important vs urgent)

Martin invokes Eisenhower's matrix: **important** vs **urgent**.

- Behavior is **urgent** but not always **important**.
- Architecture is **important** but seldom **urgent**.

The trap: urgent-but-unimportant behavior work continually crowds out important-but-not-urgent architecture work. Managers and developers who let the urgent dominate end up with a rigid system. *If architecture comes last, the system becomes ever more costly to change.* The mantra: **a good architecture makes the system easy to change**, so fighting for structure is fighting for long-term velocity.

---

## 2. Programming Paradigms as Constraints

Each paradigm *removes* a capability. Paradigms tell us what **not** to do — they impose discipline.

| Paradigm | Discipline imposed (what it *removes*) | Architectural payoff |
|---|---|---|
| **Structured** | Removes undisciplined **direct transfer of control** (`goto`) | Functions become decomposable, provable, testable units |
| **Object-Oriented** | Removes undisciplined **indirect transfer of control** (function pointers) → safe polymorphism | Dependency inversion → **plugin architecture** |
| **Functional** | Removes **assignment** / mutable state → immutability | No race conditions, no concurrent-update or deadlock problems in immutable regions |

- **Structured programming** (Dijkstra): disciplined direct transfer of control. Enables functional decomposition and reasoning about correctness. This is why we test — tests show the presence of bugs, structured decomposition lets us falsify a program piece by piece.
- **Object-oriented programming**: disciplined *indirect* transfer of control. The real power of OO is **polymorphism**: it lets high-level modules call low-level modules through an abstraction *without a source-code dependency on them*. This is how you **invert dependencies across a boundary** and build a **plugin architecture**, where business rules are protected from volatile details.
- **Functional programming**: disciplined **assignment**. Variables do not change. Immutability is the root of architectural strategies like **event sourcing** and segregating mutable from immutable components. All problems of concurrency (races, deadlocks, concurrent update) stem from mutable variables.

**Takeaway:** the three paradigms together give you the tools of architecture — structured programming is the basis of the algorithms in functions, OO is the basis of crossing architectural boundaries, and functional is the basis of data management/concurrency.

---

## 3. SOLID Principles (class / module level)

SOLID tells us how to arrange functions and data structures into classes, and how those classes should be interconnected. Goal: mid-level structures that **tolerate change**, are **easy to understand**, and are the basis of **reusable components**.

| Code | Name | Precise statement |
|---|---|---|
| **SRP** | Single Responsibility | A module should have **one, and only one, reason to change** — it should be responsible to **one, and only one, actor**. |
| **OCP** | Open-Closed | Software entities should be **open for extension but closed for modification**. |
| **LSP** | Liskov Substitution | **Subtypes must be substitutable** for their base types. |
| **ISP** | Interface Segregation | **Don't depend on things you don't use.** |
| **DIP** | Dependency Inversion | **Depend on abstractions, not concretions**; source-code dependencies point toward abstractions. |

### SRP — Single Responsibility Principle

A module should have one, and only one, **reason to change**. Reframed: a module should be responsible to **one, and only one, actor** (a group of users/stakeholders who want the system changed the same way).

- Symptom of violation: one class serves multiple actors, so a change for actor A accidentally breaks behavior for actor B (**accidental duplication** / unexpected coupling), or two teams collide when **merging** the same file.
- Classic example: an `Employee` class with `calculatePay()` (CFO's actor), `reportHours()` (COO's actor), and `save()` (DBA's actor). Split by actor.
- Fix: separate the code that different actors depend on. The **Facade** pattern is one way to keep a single access point while splitting responsibilities.

### OCP — Open-Closed Principle

You should be able to **extend** a system's behavior **without modifying** existing code. Achieved by **partitioning the system into components arranged in a dependency hierarchy** that protects **higher-level policy** from changes in **lower-level detail**.

- The goal is to make the system easy to extend without incurring a high impact of change. You do this by separating things that change for different reasons (SRP), then organizing dependencies (DIP) so the arrows point *toward* the high-level policy.
- High-level components must be **protected** from changes in low-level components. If component A must be protected from changes in component B, then B should depend on A (not vice versa).

### LSP — Liskov Substitution Principle

Subtypes must be substitutable for their base types without altering correctness. A well-known violation is the **Square/Rectangle** problem (a `Square` that extends `Rectangle` breaks when width and height are set independently).

- Architectural relevance: LSP applies to **interfaces and implementations**, not just inheritance. When a substitution rule is violated, callers must add **special-case logic** (`if (type == X)`) to handle the non-substitutable subtype — this pollutes the system with fragile conditionals.
- Example: the "REST" example where one taxi dispatcher uses a different URI convention, forcing a special case in the aggregator.

### ISP — Interface Segregation Principle

Don't force a client to depend on methods (or modules) it doesn't use. Depending on something that carries **more than you need** creates unexpected coupling: when the unused part changes, you are forced to recompile/redeploy even though your used part is unchanged.

- Generalized lesson: **depending on things you don't use is harmful** — this scales up to components and even to depending on a heavyweight framework for a feature you don't use.

### DIP — Dependency Inversion Principle

The most flexible systems are those in which **source-code dependencies refer only to abstractions, not to concretions.**

- Practical coding rules from the book:
  - **Don't refer to volatile concrete classes** — refer to abstract interfaces instead.
  - **Don't derive from volatile concrete classes.**
  - **Don't override concrete functions** (override forces you to inherit their dependencies; make them abstract and provide implementations).
  - **Never mention the name of anything concrete and volatile.**
- Stable things (e.g. `String`) may be depended on directly; you invert dependencies on **volatile** concretions.
- **Abstract Factories** manage the undesirable dependency on object *creation*: the abstract factory interface lives with the high-level policy, and the concrete factory lives on the detail side of the boundary. This is how the source-code dependency is inverted relative to the flow of control — control flows *out* to the detail, but the source dependency points *in* to the abstraction.

```text
             flow of control  ───────────────►
   [ High-level policy ] ---> ( Service interface )  <--- [ Low-level detail ]
             source-code dependency points inward (toward abstraction)
```

The curved line where the source dependency opposes the control flow is the **architectural boundary**.

---

## 4. Component Cohesion — Which Classes Belong in a Component

A **component** is the smallest unit of deployment (a jar, DLL, gem, etc.). Three principles govern which classes go into which component.

| Code | Name | Rule | Analogy |
|---|---|---|---|
| **REP** | Reuse/Release Equivalence Principle | The granule of **reuse** is the granule of **release**. Classes/modules in a component must be releasable *together* (versioned, tracked, documented). | — |
| **CCP** | Common Closure Principle | Gather into one component the classes that **change for the same reasons and at the same times**; separate those that change at different times/reasons. | **SRP for components** |
| **CRP** | Common Reuse Principle | **Don't force users of a component to depend on things they don't need.** Classes that are reused together belong together; classes not reused together should be separated. | **ISP for components** |

- **REP:** People reuse software in *releases*; a component must be a coherent, separately-releasable, version-tracked unit. Group classes that form a meaningful, releasable whole.
- **CCP:** Minimize the number of components that must change (and be re-released, re-validated, re-deployed) in response to a requirement change. If two classes are so tightly bound that they always change together, they belong in the same component.
- **CRP:** When you depend on a component, you depend on *everything* inside it. Don't drag along classes you don't use — the CRP tells you what to **keep out** of a component. It is the ISP generalized: don't depend on things you don't need.

### The tension triangle (REP / CCP / CRP)

These three principles **fight** each other:

- REP and CCP are **inclusive** (make components larger).
- CRP is **exclusive** (makes components smaller).

```text
            REP  (reusable, releasable together)
           /   \
          /     \   [ too many components change ]  <- neglect CCP
         /       \
       CRP ------- CCP
   (only what     (changes together
    you need)      stay together)
   ^ neglect            ^ neglect
   REP/CCP →            CRP → too many
   hard to reuse        needless releases forced on users
```

A good architect finds a position in the triangle that meets the *current* concerns of the project — and expects that position to **shift over time**. Early projects lean toward CCP (developability); mature, widely-reused components lean toward REP/CRP.

---

## 5. Component Coupling — Relationships Between Components

| Code | Name | Rule | Metric |
|---|---|---|---|
| **ADP** | Acyclic Dependencies Principle | Allow **no cycles** in the component dependency graph. | The graph must be a DAG. |
| **SDP** | Stable Dependencies Principle | **Depend in the direction of stability.** | Instability **I = fan-out / (fan-in + fan-out)**, 0..1 |
| **SAP** | Stable Abstractions Principle | A component's **abstractness** should increase with its **stability**. | Abstractness **A = Na / Nc** |

### ADP — Acyclic Dependencies Principle

The component dependency graph must have **no cycles** — it must be a Directed Acyclic Graph (DAG). Cycles create the "morning-after syndrome" where a change anywhere ripples everywhere, and no component can be independently built, tested, or released.

**Breaking a cycle** (two techniques):
1. **Apply DIP** — invert one dependency by introducing an interface, so the arrow reverses and the cycle opens.
2. **Create a new component** that both cyclic components depend on; move the shared classes into it.

The component structure is **not** designed top-down first — it *evolves* as the system grows and changes, and must be actively kept acyclic.

### SDP — Stable Dependencies Principle

Depend in the direction of **stability**. A component should depend only on components that are **more stable** than itself.

- **Stability** = difficulty of change. A component is stable if **many** other components depend on it (lots of reasons *not* to change) and it depends on **few** things (few reasons *to* change).
- **Instability metric:** `I = fan-out / (fan-in + fan-out)`, where fan-out = outgoing (efferent) dependencies, fan-in = incoming (afferent) dependencies. `I = 0` is maximally **stable**; `I = 1` is maximally **unstable**.
- Rule: the `I` metric of a component should be **larger than** the `I` of the components it **depends on** — i.e., I decreases in the direction of dependency.
- Not everything should be stable; if everything were maximally stable the system couldn't change. Put **volatile, high-change policy in unstable (high-I) components** and depend downward toward stable ones.

### SAP — Stable Abstractions Principle

A component's **abstractness** should be proportional to its **stability**.

- Rationale: stable components (I≈0) are hard to change, so to keep them *extensible* they must be **abstract** (interfaces/abstract classes you extend without modifying — this is OCP + DIP at component scale). Unstable components (I≈1) should hold concrete detail.
- **Abstractness metric:** `A = Na / Nc`, where Na = number of abstract classes/interfaces in the component, Nc = total number of classes. `A = 0` = fully concrete, `A = 1` = fully abstract.

### The Main Sequence, Zone of Pain, Zone of Uselessness

Plot components on an **A (y-axis) vs I (x-axis)** unit square.

```text
A (abstractness)
 1 |* . . . . . . . . [Zone of Uselessness]
   | * .              (abstract but nobody
   |   *  \  Main       depends on it — I=1,A=1)
   |     * \ Sequence
   |       *\  A + I = 1
   |         *
   |          *
   |            *
 0 |[Zone of Pain]* * *|
   | (rigid, concrete,  I=1
   |  heavily depended-on)
   +--------------------
   0   I (instability)  1
```

- **Zone of Pain** (bottom-left, I≈0, A≈0): highly stable **and** concrete — rigid, cannot be extended (not abstract) and cannot be changed (heavily depended-on). Non-volatile things (e.g. a String utility, a stable schema) can live here safely; **volatile** things here are very painful.
- **Zone of Uselessness** (top-right, I≈1, A≈1): maximally abstract but **nothing depends on it** — dead, useless abstractions.
- **Main Sequence:** the line **A + I = 1** from (I=1, A=0) to (I=0, A=1). Components should sit **on or near** this line.
- **Distance metric:** `D = |A + I − 1|`. `D = 0` means the component is exactly on the Main Sequence (ideal); `D = 1` is worst. Use `D` (mean and variance across releases) as a quality/refactoring signal — components far from the Main Sequence, or trending away from it over releases, are candidates for redesign.

---

## 6. The Dependency Rule

> **Source-code dependencies must point only *inward*, toward higher-level policy.**

This is the central rule of Clean Architecture. Nothing in an inner circle can know anything at all about something in an outer circle. Names declared in an outer circle (classes, functions, variables, data formats) must **not** be mentioned by inner-circle code.

### The concentric circles (inner → outer)

```text
   ┌────────────────────────────────────────────┐
   │   Frameworks & Drivers (DB, Web, UI, ...)   │  outermost — details
   │   ┌──────────────────────────────────────┐  │
   │   │   Interface Adapters                  │  │  controllers, presenters, gateways
   │   │   ┌────────────────────────────────┐  │  │
   │   │   │  Use Cases (App Business Rules) │  │  │  application-specific
   │   │   │   ┌──────────────────────────┐  │  │  │
   │   │   │   │ Entities (Enterprise      │  │  │  │  enterprise-wide, most stable
   │   │   │   │ Business Rules)           │  │  │  │
   │   │   │   └──────────────────────────┘  │  │  │
   │   │   └────────────────────────────────┘  │  │
   │   └──────────────────────────────────────┘  │
   └────────────────────────────────────────────┘
         dependencies point INWARD only ►
```

| Circle | Contents | Depends on |
|---|---|---|
| **Entities** | Enterprise Business Rules — critical business objects/rules that exist regardless of any application | nothing (innermost) |
| **Use Cases** | Application Business Rules — application-specific orchestration of entities | Entities |
| **Interface Adapters** | Controllers, Presenters, Gateways — convert data between use-case form and external form | Use Cases + Entities |
| **Frameworks & Drivers** | DB, web framework, UI, devices — the details | inward only |

### Crossing a boundary against the flow of control

When the flow of control needs to go *outward* (e.g., a use case needs to call the database) but the Dependency Rule forbids an inward-defined thing from depending on an outer thing, use **DIP**: the inner circle defines an **interface** (a port), and the outer circle **implements** it. Control flows outward; the source-code dependency points inward.

```text
Control flow:   UseCase ───────────────► DatabaseGateway (impl in outer circle)
Source dep:     UseCase ──► «interface» ◄──────────────── DatabaseGateway
                            (declared inner)              (declared outer)
```

This is the **same trick** as DIP §3 and the boundary-crossing of §7. Whenever a source dependency would point outward, invert it with a polymorphic interface owned by the inner circle.

---

## 7. Entities, Use Cases, and the Request/Response Models

- **Entities** embody **Enterprise Business Rules** — the business rules and Critical Business Data that would exist even if there were no automation. Pure, no dependency on frameworks, DB, or UI. Most general, most stable, least likely to change when something external changes.
- **Use Cases** embody **Application Business Rules** — application-specific business rules that describe *how* the automated system is used (the flow that produces the business value). A use case orchestrates entities. It depends on entities, **not** the other way around.
- **Request and Response Models:** a use case has an **input data structure** (request model) and **output data structure** (response model). These are **simple data structures with no dependencies** on HTTP, HTML, the DB, or any framework.
  - **Do not** pass entities or DB rows through the boundary as the request/response model, and **do not** let the request/response model reference anything in an outer circle. If it does, framework/UI/DB concerns leak across the boundary and violate the Dependency Rule.

---

## 8. Boundaries

### Boundary anatomy

Boundaries separate software elements that should be kept apart so they can vary independently. A boundary crossing is a function on one side calling a function on the other and passing some data. The trick is to manage the crossing so that **source-code dependencies point in one direction** (inward), regardless of runtime call direction — via a **polymorphic interface** (a **Boundary** interface). The **plugin** structure is the physical form: low-level details plug into high-level policy across the boundary.

### Drawing lines

Draw boundaries **between things that matter and things that don't**. The database doesn't matter to the business rules; the web doesn't matter; the frameworks don't matter. Draw the line so business rules are on one side and volatile details on the other. Boundaries are drawn **where there is an axis of change** (a place where different things change at different rates or for different reasons — the SRP applied spatially).

### Partial boundaries

Full boundaries are expensive (two-way polymorphic interfaces, input/output data structures, separate components). Sometimes you build a **partial boundary** — do the design work but stop short — anticipating a full boundary later:

1. **Skip the last step** — build the reciprocal interfaces and input/output structures but keep everything in **one component** (don't split into separately-compiled/deployed components). You've done the design work; splitting later is cheap.
2. **One-dimensional boundary** — use a single interface (a Strategy) pointing one way, without the full two-way boundary. Cheaper but degrades more easily (developers can sneak a back-channel dependency in).
3. **Facade** — even simpler: a `Facade` class lists the services and delegates to them. The client depends on the facade, but the facade depends on all the services — so there is still a **transitive source dependency** on them, and no dependency inversion. Cheapest, weakest.

Choosing where to invest in full vs partial boundaries is a **cost/benefit** judgment, revisited as the system evolves.

### The Humble Object pattern

**Humble Object** splits behaviors into two modules: one **hard to test** (kept as thin/humble as possible) and one **easy to test** (holds the logic that was moved out of the hard-to-test part).

- **Presenter / View:** the **View** is the humble object — dumb, hard-to-test GUI code with no logic. The **Presenter** is testable: it takes application data and formats it into a **View Model** (a data structure with strings, flags, states already computed) so the View only moves data onto the screen.
- **Database Gateways:** interfaces with methods for each create/read/update/delete operation the use cases need. Use cases call the gateway interfaces (easy to test); the concrete gateway implementations (SQL, humble) live in the DB layer. This keeps SQL out of the use cases.
- Humble Object appears at **every architectural boundary** and is a primary tool for **testability**.

---

## 9. Policy vs Detail — Keep Details at Arm's Length

Business rules are **policy**; everything else is **detail** that the policy should not depend on.

- **The database is a detail.** The DB is a *utility to access data*; the *data* matters, the database (the schema, the vendor, SQL, tables) is a detail. Don't let the DB structure or ORM leak into use cases or entities. (Devil's advocacy: relational tables and SQL are convenient, but they are still a detail — keep them behind a gateway.)
- **The web is a detail.** The web is an I/O device / delivery mechanism. The GUI is a detail; the business rules should not know they're being delivered over HTTP. The "web vs rich client vs API" question is a detail decision to **defer**.
- **Frameworks are details — don't marry the framework.** A framework author solves *their* problems, not necessarily yours, and asks for a deep, one-directional commitment (you depend on it, it never depends on you). Keep the framework at arm's length: use it, but **do not let it into your inner circles**. Don't derive your business objects from framework base classes; wrap the framework behind interfaces you own so you can replace it. The relationship with a framework is asymmetric and hard to reverse — enter it warily.

General rule: **decide details as late as possible** (keeping options open, §1). The longer you defer a detail decision, the more information you have when you make it, and the easier it is to change.

---

## 10. Screaming Architecture

The top-level structure of a system — the directory layout and top-level packages — should **scream the *use cases* / intent of the system**, not the framework.

- A blueprint of a house screams "house". A software architecture should scream "Health Care System" or "Accounting System" — not "Rails", "Spring", or "ASP.NET".
- If the first thing you see is the framework's folder structure (`controllers/`, `models/`, `views/`), the architecture is screaming the framework, not the domain. Frameworks are a detail the architecture should keep at a distance.
- A screaming architecture is also **testable without the framework**: because the use cases don't depend on the delivery mechanism, you can test the business rules without the web server, DB, or UI running.

---

## 11. The Main Component, Plugin Architecture, and the Convergence

### The Main component

`Main` is the **lowest-level, most detailed** component — the ultimate **detail**, the initial entry point. It:
- creates the factories, strategies, and other global facilities,
- **wires** the concrete implementations to the abstractions (dependency injection),
- then hands control to the high-level policy.

`Main` is the "dirtiest" component and depends on everything inward. Think of `Main` as a **plugin** to the application that sets up initial conditions and configuration. Because it's a plugin, you can have different `Main`s for different configurations (dev/test/prod, or one per country/deployment).

### Plugin architecture

Arranging the source-code dependencies (via OCP/DIP) so that details **plug into** business rules gives a **plugin architecture**: the UI is a plugin, the DB is a plugin, each framework is a plugin. Plugins can be swapped or developed independently, and a failure isolated to a plugin cannot corrupt the core policy.

### The convergence (Clean = Hexagonal = Onion = DCI = BCE)

Several architectures share the same goal — **separate policy from detail via dependency inversion at boundaries** — and are essentially the same idea:

- **Hexagonal Architecture** (Ports and Adapters, Alistair Cockburn)
- **Onion Architecture** (Jeffrey Palermo)
- **DCI** (Data, Context, Interaction)
- **BCE** (Boundary–Control–Entity, Ivar Jacobson)

Clean Architecture is the integration of these. All produce systems that are **independent of frameworks, testable, independent of the UI, independent of the database, and independent of any external agency** — the business rules don't know anything about the outside world.

---

## 12. Services, Tests, and Boundaries

### The "fallacy of services" — services aren't automatically architecture

Splitting a system into **services** (microservices, SOA) does **not** by itself give you a good architecture. Two fallacies:

1. **Decoupling fallacy** — services running in separate processes/machines *appear* decoupled, but they can be **strongly coupled by the data they share** and by cross-service behaviors. A new feature that cuts across services forces coordinated changes in all of them — no better than a monolith.
2. **Independent development/deployment fallacy** — services don't guarantee independent development or deployment; cross-cutting concerns still couple teams.

Service boundaries are **not** a substitute for architectural boundaries. The real architectural boundaries are defined by the **Dependency Rule and the SOLID/component principles** — and they can live *inside* a service (a service should itself be designed with components that respect the Dependency Rule, so that new cross-cutting features are handled by adding components rather than modifying every service). Services are a **deployment/scaling** option, not the architecture itself.

### Tests as a system component

Tests are part of the system and participate in the architecture. They are the **outermost circle** — nothing depends on the tests, and the tests depend inward on everything they exercise. Tests follow the Dependency Rule: they are **details**.

- **Fragile Tests Problem:** if tests are coupled to volatile parts of the system (the GUI, the exact API shape, the DB schema), a small change to those volatile parts breaks **many** tests, making the suite brittle and discouraging change. This is a **design smell** in the tests: tests are too tightly coupled to volatile things.
- Rule: **don't depend on volatile things.** Design the system with a **testing API** — a superstructure that decouples the tests from the volatile structure of the application — so tests exercise business rules without going through the fragile UI/DB details.
- **Humble Object for tests:** apply §8's Humble Object so the logic under test is separated from the hard-to-test boundary (e.g., test the Presenter, not the View; test the use case through a gateway interface, not against a live DB). Testable design *is* good design — testability and the Dependency Rule reinforce each other.

---

## Quick Review Checklist

- [ ] Do all source-code dependencies point **inward** toward higher-level policy? (**Dependency Rule**)
- [ ] Does any entity/use case mention a framework, DB, HTTP, or UI type? (leak → Dependency Rule / DIP)
- [ ] Does each class/module have exactly one **actor**/reason to change? (**SRP**)
- [ ] Can behavior be extended without modifying existing high-level code? (**OCP**)
- [ ] Any special-case `if (type == ...)` betraying a broken substitution? (**LSP**)
- [ ] Any client depending on interface methods / a component it doesn't use? (**ISP / CRP**)
- [ ] Are volatile concretions hidden behind abstractions, with creation behind an abstract factory? (**DIP**)
- [ ] Is the component dependency graph a **DAG** (no cycles)? (**ADP**)
- [ ] Do dependencies point toward **more stable** components (lower I)? (**SDP**)
- [ ] Are stable components **abstract** and unstable ones **concrete**? Near the Main Sequence (low D)? (**SAP**)
- [ ] Is hard-to-test code kept **humble** and separated from testable logic? (**Humble Object**)
- [ ] Do the top-level packages **scream the domain**, not the framework? (**Screaming Architecture**)
- [ ] Are tests decoupled from volatile UI/DB details via a testing API? (**Fragile Tests**)
