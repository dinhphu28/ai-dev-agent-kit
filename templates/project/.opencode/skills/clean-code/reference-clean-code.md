# Clean Code — Reference for an AI Coding Agent

Distilled from Robert C. Martin, *Clean Code: A Handbook of Agile Software Craftsmanship* (2008).

**How to use this reference.** Skim the H2 sections while writing or reviewing code and apply the named principles as concrete checks. Each item is traceable to the book — a chapter concept (e.g., "Command-Query Separation", "the Stepdown Rule") or a Chapter 17 smell/heuristic code (e.g., `G5`, `N1`, `F3`). When you flag something in a review, cite the code or principle by name so the feedback is verifiable, not vague. The tables at the end are the fast lookup; the prose sections above them give the reasoning. Do not invent codes or rules that are not listed here.

---

## Meaningful Names (Ch. 2)

- **Use intention-revealing names.** The name should answer why it exists, what it does, and how it is used. If a name needs a comment, it does not reveal its intent.
- **Avoid disinformation.** Don't use `accountList` unless it's actually a `List`; avoid names that vary in small ways (`XYZControllerForEfficientHandlingOfStrings` vs `...HandlingOfStrings`); avoid characters that look alike (`l`, `1`, `O`, `0`).
- **Make meaningful distinctions.** No number-series names (`a1`, `a2`) and no noise words (`ProductInfo`/`ProductData`, `theMessage`/`message`, `Variable`, `table`). Distinctions must convey different meaning to the reader.
- **Use pronounceable names.** `genymdhms` → `generationTimestamp`. If you can't pronounce it, you can't discuss it.
- **Use searchable names.** Single letters and raw numeric literals are hard to grep. Prefer named constants; single-letter names are only acceptable as local loop variables in tiny scopes.
- **Avoid encodings.** No Hungarian notation, no type/scope prefixes, no member prefixes (`m_`). Modern tooling makes them noise.
- **Avoid mental mapping.** Don't force the reader to translate `r` into "the lowercased URL without the host". Clarity is king.
- **Class names are nouns** or noun phrases (`Customer`, `WikiPage`, `AddressParser`) — not verbs.
- **Method names are verbs** or verb phrases (`postPayment`, `deletePage`, `save`). Use JavaBean-style `get`/`set`/`is`. When constructors are overloaded, prefer static factory methods with names describing arguments (`Complex.FromRealNumber(23.0)`).
- **Don't be cute.** No jokes/slang names (`HolyHandGrenade`); say what you mean.
- **Pick one word per concept.** One of `fetch`/`retrieve`/`get` per abstraction; one of `controller`/`manager`/`driver`. A consistent lexicon is a huge help to readers.
- **Don't pun.** Don't reuse the same word for two different ideas (e.g., `add` meaning both concatenation and insertion).
- **Use solution-domain names** (algorithm names, pattern names, CS terms like `JobQueue`, `AccountVisitor`) — readers are programmers.
- **Use problem-domain names** when there's no programmer-ese; a domain expert can then help interpret.
- **Add meaningful context.** A bare `state` is unclear; `addrState` or an `Address` class gives it context. Don't add gratuitous context (`GSD` prefix on every class in "Gas Station Deluxe").

---

## Functions (Ch. 3)

- **Small.** Functions should be small, then smaller than that. Blocks inside `if`/`else`/`while` should be one line — usually a function call. This keeps nesting shallow.
- **Do one thing.** "Functions should do one thing. They should do it well. They should do it only." A function does one thing if its statements are all one level of abstraction below the function's name. If you can extract another function with a name that isn't just a restatement, it was doing more than one thing.
- **One level of abstraction per function**, and **the Stepdown Rule**: code should read top-down as a narrative — every function is followed by those at the next level of abstraction, like paragraphs of "To do X, we do A, then B."
- **Switch statements** are unavoidable but bury them low, once, behind a factory that returns polymorphic objects, so the `switch` isn't repeated.
- **Use descriptive names.** A long descriptive name beats a short enigmatic one; be consistent in the phrasing (`includeSetupAndTeardownPages`, `includeSetupPages`, `includeSuiteSetupPage`).
- **Function arguments:** fewer is better — niladic (0) > monadic (1) > dyadic (2) > triadic (3, avoid) > polyadic (needs strong justification). More arguments = harder to understand and to test.
- **Common monadic forms:** ask a question about the arg (`boolean fileExists("MyFile")`), transform and return it (`InputStream fileOpen("MyFile")`), or an event with no return. Avoid other monadic shapes.
- **No flag arguments.** Passing a boolean proclaims the function does more than one thing. Split it into two functions.
- **Argument objects.** When a function needs 2–3 args that belong together, wrap them (`Circle(Point center, double radius)`).
- **Verbs and keywords.** `write(name)` reads well; `writeField(name)` tells us `name` is a field. `assertExpectedEqualsActual(expected, actual)` encodes argument order into the name.
- **Have no side effects.** A function that promises one thing but secretly does another (e.g., `checkPassword` that also initializes the session) is a lie and creates temporal coupling. If coupling is required, make it explicit in the name.
- **Output arguments** should be avoided; prefer `report.appendFooter()` over `appendFooter(report)`. In OO, the receiver is the natural output.
- **Command-Query Separation.** A function should either do something (command) or answer something (query), not both. `if (set("username", "unclebob"))` is confusing — split into `attributeExists(...)` and `setAttribute(...)`.
- **Prefer exceptions to returning error codes.** Error codes force the caller to handle the error immediately and breed nested `if` blocks. Exceptions separate the happy path from error handling.
- **Extract try/catch blocks.** Error handling is one thing; a function that has a `try` should have `try` as its first word and nothing after the `catch`/`finally` block.
- **DRY — Don't Repeat Yourself.** Duplication is arguably the root of all evil in software; every principle here fights it.
- **Structured programming.** Dijkstra's single-entry/single-exit is helpful mainly in large functions. In small functions, multiple `return`, `break`, `continue` can be fine; avoid `goto`.

---

## Comments (Ch. 4)

> "Comments do not make up for bad code." When tempted to comment, first try to express yourself in code.

### Good comments
- **Legal comments** — copyright/license headers required by convention.
- **Informative comments** — e.g., what a returned value or regex means (though often better as a function/variable name).
- **Explanation of intent** — the reasoning behind a decision, not just the mechanics.
- **Clarification** — translating an obscure argument/return value you can't change (e.g., library code) into readable form.
- **Warning of consequences** — "Don't run unless you have time to kill", non-thread-safe notes.
- **TODO comments** — legitimate notes on work to be done later; scan and clean them periodically.
- **Amplification** — stressing the importance of something that looks inconsequential.
- **Public API docs (Javadocs)** — good docs for a published API; but keep them honest.

### Bad comments
- **Mumbling** — a hurried comment that only makes sense to the author.
- **Redundant comments** — say no more than the code (`// the day of the month` above `int dayOfMonth`).
- **Misleading comments** — subtly inaccurate; worse than none.
- **Mandated comments** — a rule that every function/variable have a Javadoc produces clutter and lies.
- **Journal comments** — change logs at the top of files; version control replaces these.
- **Noise comments** — restate the obvious (`/** Default constructor. */`).
- **Position markers** — banners (`// Actions //////////`); use sparingly if at all.
- **Closing-brace comments** — `} // while`; shrink the function instead.
- **Attributions/bylines** — `/* Added by Rick */`; version control tracks authorship.
- **Commented-out code** — delete it; VCS remembers it. (See `C5`.)
- **Don't use a comment when a function or variable will do.**
- **Nonlocal information** — a comment describing something far from it (e.g., a system-wide default beside a local var).
- **Too much information** — historical/RFC detail nobody needs here.
- **Inobvious connection** — a comment whose relationship to the code it explains is unclear.

---

## Formatting (Ch. 5)

- **The newspaper metaphor.** A source file reads like a news article: name says what it's about, the top gives high-level concepts and algorithms, detail increases downward.
- **Vertical openness between concepts.** Blank lines separate groups of related lines (a "thought").
- **Vertical density.** Lines that are tightly related should be close together — no needless comments/blanks splitting them.
- **Vertical distance.** Concepts that are closely related should be vertically close; avoid forcing readers to hop between files/classes.
  - **Variable declarations** near their use; locals at the top of the function they're used in.
  - **Instance variables** at the top of the class (per Java convention).
  - **Dependent functions** — caller above callee where possible, so the code reads top-down.
- **Conceptual affinity.** Related functions (e.g., overloads, or a family like `assertTrue`/`assertFalse`) belong near each other.
- **Horizontal formatting.** Keep lines short (Martin cites ~120 cols max). Use horizontal whitespace to associate/dissociate (`b*b - 4*a*c`). Don't align declarations artificially. Indent to show scope; don't collapse short scopes onto one line.
- **Team rules.** A team agrees on one formatting style and every file looks like one person wrote it. Consistency > personal preference. (See `G24`.)

---

## Objects and Data Structures (Ch. 6)

- **Data abstraction.** Hide implementation behind abstractions; expose behavior, not internals. Don't blindly add getters/setters for every private variable — that just exposes the implementation.
- **Data/object anti-symmetry.**
  - *Objects* expose behavior and hide data. Adding new object types is easy; adding new operations is hard.
  - *Data structures* expose data and have no meaningful behavior. Adding new operations is easy; adding new data types is hard.
  - Procedural code (data structures + functions) and OO code have complementary strengths. Choose deliberately; don't build hybrids that are half object, half data structure.
- **The Law of Demeter.** A method should only talk to: its own object, its parameters, objects it creates, and its direct component objects — not objects returned by those. **Avoid train wrecks:**

```java
final String outputDir = ctxt.getOptions().getScratchDir().getAbsolutePath();
```

  This chains through multiple returned objects. Whether it violates Demeter depends on whether these are objects (violation) or data structures (fine). Prefer telling an object to do the work rather than digging for the pieces.
- **Hybrids.** Structures that are half data, half object have the worst of both worlds — avoid.
- **DTOs (Data Transfer Objects).** Classes with public variables and no functions — good for communicating with DBs, parsing messages, etc. "Bean" forms add private vars with getters/setters.
- **Active Record.** A special DTO with navigational methods like `save`/`find`. Don't put business logic in it — that turns it into a hybrid. Keep business rules in separate objects.

---

## Error Handling (Ch. 7)

- **Use exceptions rather than return codes.** Return codes clutter the caller and are easily forgotten.
- **Write your try-catch-finally statement first.** Start with the scope where things can throw; it defines a transaction whose state stays consistent no matter what the `try` does. Use TDD to force each exception.
- **Use unchecked exceptions.** Checked exceptions violate the Open/Closed Principle (a `throws` change cascades up every caller) and are not worth the cost for most applications.
- **Provide context with exceptions.** Each exception should carry enough information (the operation and failure type) to locate the source; create informative messages and pass them along.
- **Define exception classes in terms of a caller's needs.** Wrap third-party APIs and classify exceptions by how the caller will catch/handle them. Often one exception class per area of code is enough. Wrapping also minimizes dependence on a specific library.
- **Define the normal flow — the Special Case pattern.** Instead of forcing callers to handle exceptional cases, create an object (or configure it) that handles the special case for them, so the client code deals with normal flow only.

```java
// instead of catching a "no meals" exception:
MealExpenses expenses = expenseReportDAO.getMeals(employee.getID());
m_total += expenses.getTotal();   // getMeals returns a PerDiemMealExpenses when none exist
```

- **Don't return null.** Returning `null` invites `NullPointerException`s and litters callers with checks. Return an empty collection, throw, or use the Special Case pattern instead.
- **Don't pass null.** Passing `null` into methods is worse than returning it. Forbid it by policy so you don't need to guard against it everywhere.

---

## Boundaries (Ch. 8)

- **Using third-party code.** There's tension between providers (who want broad APIs) and users (who want focused ones). A boundary interface like `Map` can leak too much capability (e.g., `clear()`); don't pass boundary interfaces (like a bare `Map`) around the system.
- **Encapsulate boundaries.** Wrap third-party types so their API doesn't spread. Keep the wrapped type inside the class; expose only what you need.

```java
public class Sensors {
    private Map sensors = new HashMap();
    public Sensor getById(String id) { return (Sensor) sensors.get(id); }
    // the Map lives here, never leaks out
}
```

- **Exploring and learning boundaries — learning tests.** Rather than experimenting inside production code, write **learning tests**: small tests that call the third-party API the way you intend to use it, to learn and confirm its behavior.
- **Learning tests are better than free.** They cost nothing extra (you had to learn the API anyway) and, when the third party ships a new version, re-running them tells you instantly whether behavior changed.
- **Using code that does not yet exist.** Define the interface *you wish you had* at the boundary, code against it, and adapt to the real API later (Adapter pattern) — keeps the seam clean and testable.
- **Clean boundaries.** Boundaries are where change happens. Good design accommodates change without large investment. Depend on something you control rather than on something you don't; wrap, or use an Adapter, so a boundary change touches one place.

---

## Unit Tests (Ch. 9)

### The Three Laws of TDD
1. You may not write production code until you have written a failing unit test.
2. You may not write more of a unit test than is sufficient to fail (not compiling counts as failing).
3. You may not write more production code than is sufficient to pass the currently failing test.

### Keeping tests clean
- **Tests are as important as production code**, and must be kept clean. Dirty tests are worse than no tests: they rot, become a liability, and eventually get abandoned — taking your ability to change code with them.
- **Tests enable change.** Tests keep production code flexible, maintainable, and reusable. With a test suite you can improve the architecture without fear; without one, every change is risky.
- **What makes a clean test?** Readability — clarity, simplicity, density of expression. Use the **BUILD-OPERATE-CHECK** pattern: build the test data, operate on it, check the results.
- **A dual standard.** Test code has different engineering standards from production code: it must be simple, succinct, and expressive, but need not be as efficient (e.g., resource-constrained). A test-specific "domain language" of helper functions/utilities makes tests easy to write and read.
- **One assert per test** is a good guideline; more strongly, **a single concept per test.** Don't test multiple unrelated concepts in one test function.

### F.I.R.S.T
- **Fast** — tests must run quickly, or you won't run them often.
- **Independent** — tests should not depend on each other; each sets up its own state and can run in any order.
- **Repeatable** — must run in any environment (prod, QA, laptop with no network).
- **Self-Validating** — a boolean pass/fail; no manual log-reading to judge the result.
- **Timely** — written just before the production code that makes them pass (per TDD). Writing them after makes production code hard to test.

---

## Classes (Ch. 10)

- **Class organization.** Standard Java order: public static constants, private static variables, private instance variables, then public functions, with each private helper right after the public function that uses it (stepdown / newspaper).
- **Encapsulation.** Keep variables and helpers private; loosen only when a test in the same package needs access, and only as a last resort.
- **Classes should be small** — measured in **responsibilities**, not lines. A class name should describe its responsibility; if you can't name it concisely (or the name has "Processor"/"Manager"/"Super"), it likely has too many responsibilities. You should be able to describe it in ~25 words without "if", "and", "or", "but".
- **The Single Responsibility Principle (SRP).** A class (or module) should have one, and only one, reason to change. Many small, single-purpose classes beat a few large multipurpose ones. The goal is organization so a reader knows where to look.
- **Cohesion.** Classes should have few instance variables, and each method should manipulate one or more of them; the more variables a method touches, the more cohesive. When cohesion drops (some methods use only some variables), **split the class** — that's a signal a smaller class is trying to emerge. Breaking large functions into smaller ones often causes classes to proliferate, which is good.
- **Organizing for change.** Structure code so new features are added by *extending* the system, not *modifying* existing code (Open/Closed Principle). Isolate each concrete behavior in its own class so a change touches one place.
- **Isolating from change (DIP).** Depend on abstractions (interfaces), not concrete details. The **Dependency Inversion Principle** keeps classes depending on abstractions, which makes them testable (you can substitute test doubles) and insulates them from changes in concrete implementations.

```java
public interface StockExchange { Money currentPrice(String symbol); }
public class Portfolio {
    private StockExchange exchange;               // depends on the abstraction
    public Portfolio(StockExchange e) { exchange = e; }  // inject a real or fake
}
```

---

## Smells and Heuristics — Catalog (Ch. 17)

Compact lookup of the actual codes. Cite the code when flagging an issue in a review.

### Comments

| Code | Name | Meaning |
|---|---|---|
| C1 | Inappropriate Information | Info better held elsewhere (VCS, issue tracker) doesn't belong in a comment. |
| C2 | Obsolete Comment | A comment that has grown old, irrelevant, or incorrect. |
| C3 | Redundant Comment | Describes something that already describes itself. |
| C4 | Poorly Written Comment | Worth writing means worth writing well: brief, correct, no rambling. |
| C5 | Commented-Out Code | Delete it; source control remembers it. |

### Environment

| Code | Name | Meaning |
|---|---|---|
| E1 | Build Requires More Than One Step | Building should be a single trivial command (checkout + one build). |
| E2 | Tests Require More Than One Step | Run all tests with one command/button. |

### Functions

| Code | Name | Meaning |
|---|---|---|
| F1 | Too Many Arguments | Prefer zero; more than three is very questionable. |
| F2 | Output Arguments | Arguments used as outputs are counterintuitive; change the object's state instead. |
| F3 | Flag Arguments | Boolean args announce a function does more than one thing; eliminate. |
| F4 | Dead Function | Methods never called should be deleted. |

### Java

| Code | Name | Meaning |
|---|---|---|
| J1 | Avoid Long Import Lists by Using Wildcards | Import the whole package with a wildcard rather than a long list of specific imports. |
| J2 | Don't Inherit Constants | Don't put constants in an interface/base class and inherit them to avoid qualification; use a static import instead. |
| J3 | Constants versus Enums | Prefer enums over `public static final int` constants; enums are a proper type with methods and fields. |

### General

| Code | Name | Meaning |
|---|---|---|
| G1 | Multiple Languages in One Source File | Minimize the number of languages per file. |
| G2 | Obvious Behavior Is Unimplemented | Follow the Principle of Least Surprise; implement what a name implies. |
| G3 | Incorrect Behavior at the Boundaries | Don't rely on intuition; write tests for every boundary/edge case. |
| G4 | Overridden Safeties | Don't turn off compiler warnings, failing tests, or safety checks. |
| G5 | Duplication | Every duplication is a missed abstraction (DRY); unify it. |
| G6 | Code at Wrong Level of Abstraction | Keep higher-level concepts in base classes, lower-level details in derivatives; don't mix. |
| G7 | Base Classes Depending on Their Derivatives | Base classes should know nothing about their subclasses. |
| G8 | Too Much Information | Keep interfaces small and tight; hide data, limit exposed methods. |
| G9 | Dead Code | Code that never executes; find and delete it. |
| G10 | Vertical Separation | Define variables and functions close to where they're used. |
| G11 | Inconsistency | Do similar things the same way; follow the Principle of Least Surprise. |
| G12 | Clutter | Remove dead code, empty constructors, unused variables, meaningless comments. |
| G13 | Artificial Coupling | Don't couple things that have no real dependency (e.g., misplaced constants/enums). |
| G14 | Feature Envy | A method that wants the data of another class; move the behavior to that class. |
| G15 | Selector Arguments | Avoid boolean/enum selector args that pick behavior; prefer many functions. |
| G16 | Obscured Intent | Don't write code so terse or dense that intent is lost. |
| G17 | Misplaced Responsibility | Put code where a reader would naturally expect it. |
| G18 | Inappropriate Static | Prefer non-static; static functions can't be overridden polymorphically. |
| G19 | Use Explanatory Variables | Break calculations into intermediate variables with meaningful names. |
| G20 | Function Names Should Say What They Do | If you must read the impl to know what it does, rename it. |
| G21 | Understand the Algorithm | Actually understand the code; don't hack until tests pass. |
| G22 | Make Logical Dependencies Physical | A module depending on another should ask it explicitly, not assume. |
| G23 | Prefer Polymorphism to If/Else or Switch/Case | Consider polymorphism before selection; one switch to create, not many to dispatch. |
| G24 | Follow Standard Conventions | Team-agreed conventions, applied by everyone, consistently. |
| G25 | Replace Magic Numbers with Named Constants | Name raw literals (numbers, strings) that carry meaning. |
| G26 | Be Precise | Make decisions precisely: nulls, concurrency, rounding, locks — don't be lazy. |
| G27 | Structure over Convention | Enforce design decisions with structure (abstract methods) over convention. |
| G28 | Encapsulate Conditionals | Extract complex boolean logic into a well-named function. |
| G29 | Avoid Negative Conditionals | Positives are easier to read than negatives; invert where possible. |
| G30 | Functions Should Do One Thing | Split functions that do several things into smaller single-purpose ones. |
| G31 | Hidden Temporal Couplings | Make required call order explicit via arguments/return values. |
| G32 | Don't Be Arbitrary | Structure should communicate intent; a convention followed everywhere is defensible. |
| G33 | Encapsulate Boundary Conditions | Put `+1`/`-1` edge logic in one place (a named variable/function). |
| G34 | Functions Should Descend Only One Level of Abstraction | Statements should be one level below the function's name. |
| G35 | Keep Configurable Data at High Levels | High-level constants/config are easy to find and change; pass them down. |
| G36 | Avoid Transitive Navigation | Don't `a.getB().getC()`; talk to direct collaborators only (Law of Demeter). |

### Names

| Code | Name | Meaning |
|---|---|---|
| N1 | Choose Descriptive Names | Names carry ~90% of readability; choose them carefully and keep them current. |
| N2 | Choose Names at the Appropriate Level of Abstraction | Name for the concept, not the implementation detail. |
| N3 | Use Standard Nomenclature Where Possible | Reuse pattern/convention names (e.g., `Decorator`, `toString`) that readers know. |
| N4 | Unambiguous Names | Pick a name that leaves no doubt about what it does. |
| N5 | Use Long Names for Long Scopes | Short names for short scopes; longer, more descriptive names for wide scopes. |
| N6 | Avoid Encodings | No type/scope encodings, Hungarian, or member prefixes. |
| N7 | Names Should Describe Side-Effects | Name the full effect (`createOrReturnOos`), not a partial one (`getOos`). |

### Tests

| Code | Name | Meaning |
|---|---|---|
| T1 | Insufficient Tests | Test everything that could plausibly break. |
| T2 | Use a Coverage Tool | Use tooling to reveal gaps in test coverage. |
| T3 | Don't Skip Trivial Tests | They're easy to write and their documentary value exceeds their cost. |
| T4 | An Ignored Test Is a Question about an Ambiguity | Express uncertainty about requirements with an ignored/commented test. |
| T5 | Test Boundary Conditions | Boundaries are where bugs hide; test them explicitly. |
| T6 | Exhaustively Test Near Bugs | Bugs cluster; when you find one, test thoroughly around it. |
| T7 | Patterns of Failure Are Revealing | The shape of which tests fail points to the diagnosis. |
| T8 | Test Coverage Patterns Can Be Revealing | Looking at what passing tests do/don't cover reveals why failing ones fail. |
| T9 | Tests Should Be Fast | A slow test is a test that won't get run. |
