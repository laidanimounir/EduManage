# EduManage — System Understanding & Environment Report

> Written by Claude after reviewing the full project specification.
> This document proves understanding before any implementation code is written.

---

## 1. The Core Problem We're Solving

### 1.1 What the old system ("Sable School") got wrong

The old desktop app suffers from a fundamental architectural flaw: **financial balances are stored as mutable fields that get updated in place**. There are two separate, unsynchronized tables — one for "income" (المداخيل) and one for "collections" (التحصيل) — that should represent the same real-world money movements but drift apart over time. The old UI even has a "difference" (الفرق) column, which is a band-aid trying to surface the desync rather than fixing root cause.

The result: teachers and students show incorrect balances and debts that don't match what was actually paid in cash. This happens frequently enough that the client is certain it's a software bug, not human error.

### 1.2 The fix: append-only ledger

**This is the single most important architectural decision in EduManage.** Every money movement — student charges for attending sessions, student payments, teacher payouts, discounts, corrections, expenses — is recorded as an **immutable row in a unified `transactions` table**. Nothing is ever edited or deleted in place. Corrections are new transactions of type `correction` or `reversal` that reference the original transaction.

Balances and debts are NEVER stored directly on student or teacher records. They are always **computed on demand** from `SUM(amount)` across relevant transactions. This means:
- It's mathematically impossible for a balance to be "wrong" — it's always the sum of recorded facts.
- Every number on a screen can be drilled down into the list of transactions that produced it.
- There is no "difference" column — because there's only one source of truth.

This also fixes a likely secondary bug in the old system: **teacher payments based on scheduled sessions rather than sessions that actually happened**. See Scenario 5 below.

---

## 2. Entity Model (Conceptual)

### 2.1 Core Entities

**Students** — A child enrolled at the center. Has identity info (name, phone, address, gender, birth date/place, registration date, status) and a unique `code` used in the barcode. A student can be enrolled in multiple subjects simultaneously (new capability — the old system only allowed one).

**Teachers** — A staff member who teaches. Has identity info, employment dates, and a code. Teachers check in to confirm sessions happened, which drives their payout calculation.

**Subjects / Groups** (المجموعات) — A subject offering tied to a school level. Examples: "French 3rd Primary", "Quran Sunday Group 10yo". This is the entity students enroll into. A "group" is essentially a subject+level combination — a specific class offering.

**Classrooms** — Physical rooms where sessions take place. Simple list.

**Sessions** (الحصص) — A scheduled recurring class occurrence: which subject/group, which teacher, which classroom, day of week, time range, pricing (price per session, monthly price, sessions per month), teacher share percentage, teacher cut, admin cut.

**Enrollments** — The many-to-many join between students and subjects/groups. Each enrollment can have its own custom price or discount, overriding the session's default pricing for that specific student. A student's total balance is the sum across all their active enrollments.

**Transactions** (the ledger) — The heart of the system. UUID primary key. Fields: amount, type (enum: `session_charge`, `student_payment`, `teacher_payout`, `expense`, `discount`, `correction`, `reversal`), date, associated entity (student_id or teacher_id), created_by (user_id), device_id, note, optional reference to related session or enrollment. **Append-only. Never updated. Never deleted.** Corrections are new rows.

**Attendance** — A record that a specific student or teacher was present at a specific session occurrence on a specific date. Not just "present today" — explicitly tied to the session instance. Each student attendance record auto-generates a `session_charge` transaction.

**Users** — Staff accounts with roles (admin, accountant, secretary, teacher) and permissions. These are the people operating the staff-facing app.

**Audit Log** — Immutable record of who did what and when. Especially important for manual overrides (e.g., staff manually checking in a student who forgot their card).

### 2.2 Key Relationships

```
Student ──< Enrollment >── Subject/Group
Student ──< Attendance >── Session
Student ──< Transaction (as payer)
Teacher ──< Attendance >── Session
Teacher ──< Transaction (as payee)
Subject/Group ──< Session >── Classroom
Session >── Teacher
User ──< AuditLog
User ──< Transaction (as creator)
```

---

## 3. Attendance Scenarios (All 6)

This is the operational foundation. The barcode scanner at the front desk is the primary input device.

### Scenario 1 — Normal check-in
Student walks in, scans their barcode card. The barcode encodes the student's `code` (not their UUID — the code is a human-readable identifier). System looks up the student, finds their active enrollments, checks which sessions are currently active (current time falls within session time range on current day of week), and logs attendance tied to that specific session occurrence. Straightforward, fully automatic.

### Scenario 2 — Ambiguous sessions (edge case)
If the current time matches multiple sessions for the same student (maybe they're enrolled in two subjects scheduled at overlapping times, or a schedule was misconfigured), the system cannot determine which session to record. It prompts the staff member to pick the correct session from a shortlist. This is expected to be rare but must be handled gracefully.

### Scenario 3 — Forgotten card (manual check-in)
Student shows up without their card. Staff opens a quick-search screen, searches by name/last name/phone, finds the student, and manually selects the session to check them into. This action is recorded in the **audit log** as a staff-initiated manual entry (not a barcode scan). This preserves accountability — we know a human made the call, not the scanner.

### Scenario 4 — Attended but hasn't paid (THE KEY FIX)
This is where the old system's bug manifested most. In the old system, deciding whether to charge a student for attending seemed to involve a manual step, which was error-prone.

In EduManage: **every time a student checks in (by any method), a `session_charge` transaction is automatically created in the ledger.** This is a deterministic, non-negotiable side effect of the attendance event. It happens regardless of the student's current balance. The student's debt increases by the session price (or their custom enrollment price) at the exact moment they scan in.

When the student later pays, a `student_payment` transaction (negative amount relative to the charge, or positive depending on sign convention) offsets the debt. The gap between charges and payments is always precisely tracked because both are driven by actual events — the check-in and the payment — not by staff remembering to record them.

The center wants students in class even if behind on payment. This design supports that: students can accumulate debt, the system tracks it accurately, and staff can see who owes what at any time.

### Scenario 5 — Teacher check-in
Teachers scan their own card at the start of their session. This confirms the session actually took place. The attendance record for the teacher marks the session as "held."

**Critical business rule: teacher payouts are calculated ONLY from sessions confirmed as held via teacher check-in.** If a teacher doesn't scan in, the session was either cancelled or the teacher was absent — no payout is generated. This prevents the old-system problem of paying teachers for sessions that didn't happen.

When a teacher checks in, a `teacher_payout` transaction (or a scheduled accrual) is generated based on the session's teacher share/teacher cut.

### Scenario 6 — Cancelled session / teacher absence
If a session is explicitly marked as cancelled (e.g., holiday, teacher sick leave), no attendance is taken, no `session_charge` is generated for students, and no `teacher_payout` is generated for the teacher. Simple: no attendance event, no money movement.

---

## 4. Multi-Subject Enrollment

The old system limited each student to one group/subject. EduManage supports many-to-many: a student can be in French 3rd Primary AND English 3rd Primary AND Quran Sunday.

Each enrollment:
- Is its own row linking student to subject/group.
- Can have a custom price (if the student gets a special rate) or a custom discount.
- Tracks its own portion of the student's debt — by filtering the ledger transactions by enrollment or subject.

The student's total balance is the sum across all enrollments. This separation allows the center to see which subject a student is behind on payment for, rather than just a lump sum.

---

## 5. Student Card Design (Barcode + QR)

Each student gets a printed card with two machine-readable codes:

**Barcode (1D):** Encodes the student's `code` — a simple, human-readable identifier. Read by the existing front-desk barcode scanner (which only reads 1D barcodes, not QR). This is the primary check-in method.

**QR code (2D):** Encodes a **random, unguessable, per-student secure token** — NOT the student's sequential ID or code. This token:
- Is generated when the student is first registered (cryptographically random UUID or similar).
- Can be rotated (regenerated) if the card is lost or reissued.
- Revoking the old token invalidates any previously-printed cards.
- Is what a parent's phone scans to link their child to their parent account.

This separation is important: the barcode is for check-in (operational, low-security), the QR is for parent access (privacy-sensitive, needs a secure unguessable token).

---

## 6. Parent Mobile App (Future Phase, Designed Now)

A separate Flutter mobile app for parents. Key features:
- **Child linking**: Parent scans the child's QR code (containing the secure token) once to permanently link the child to their account. One parent account can link multiple children (siblings).
- **Live attendance**: Push notification when their child checks in or out.
- **Schedule & teachers**: View enrolled subjects, who teaches each, and the weekly schedule.
- **Financial transparency**: View balance/debt with full transaction history — every charge and payment visible, exactly as recorded in the ledger.
- **Payment receipts**: Download payment history as PDF.
- **Absence alerts**: Notification if the child misses a scheduled session (no check-in during the session window).

This app requires internet connectivity (unlike the staff app), so it will necessitate a cloud backend in a later phase. The architecture is designed so the ledger and entity model don't change when that backend is added — the QR token, UUID primary keys, and transaction model all work the same whether the database is local SQLite or cloud PostgreSQL.

---

## 7. Architecture Strategy: Local-First, Then Cloud

### 7.1 The phased approach

**Phase 1 (now):** Single-device Flutter desktop app, SQLite via `drift`, fully offline. All features operational without internet. Run on the center's front-desk computer.

**Phase 2 (later):** Add cloud backend (Supabase or Node.js+PostgreSQL) when the parent app's connectivity requirement makes it necessary. Then add multi-device sync for staff.

**Phase 3 (even later):** Web dashboard for the owner.

### 7.2 Design decisions that make Phase 2 a pure addition

These are not optional — they must be baked in from day one:

1. **UUID primary keys on every table.** No auto-increment integers. When multiple devices eventually sync to a cloud database, UUIDs prevent collision. If we used integers, merging two devices' data would require remapping IDs everywhere — a massive error-prone rewrite.

2. **Every row has sync-ready columns from day one:** `created_at`, `updated_at`, `device_id`, and optionally a `synced` flag (boolean, defaults to false locally). These columns exist now, cost nothing, and mean the sync layer later just reads/writes these fields rather than requiring schema changes.

3. **Append-only ledger from day one.** The transactions table never allows UPDATE or DELETE. This invariant holds whether the database is local SQLite (enforced by application code/repository layer) or cloud PostgreSQL (enforced by RLS policies). No phase transition changes how money is tracked.

4. **Repository pattern.** All data access goes through repository interfaces. Today, implementations read/write SQLite via drift. Later, we can add network-backed implementations that read/write a remote API. The UI and business logic never touch the database directly — they call repository methods. This makes the storage swap a matter of dependency injection, not rewriting every screen.

### 7.3 Why drift (not raw SQLite)

`drift` (formerly moor) provides:
- Type-safe, compile-checked SQL queries in Dart.
- Automatic migration support (versioned schema changes).
- Stream-based reactive queries (the UI rebuilds when data changes).
- Native SQLite on all Flutter platforms via `sqlite3_flutter_libs`.

These matter because the ledger design relies on complex SUM/GROUP BY queries for balance computation — type safety on those queries prevents runtime errors.

---

## 8. Features from the Old App to Preserve

The client likes these and wants them in the new system:
- CRUD for students, teachers, groups, classrooms
- Session scheduling (subject, teacher, room, day, time, pricing, teacher share %)
- Payment collection screen with history log
- Per-student and per-teacher status views (balance, debt, attendance, absences)
- Printable student card with barcode (now also QR)
- Profit/earnings report — **but this must be fully automatic, derived from the ledger, NOT the old manual checkbox-based calculator**

---

## 9. Environment Readiness Report

### 9.1 Installed and Working

| Tool | Version | Status |
|------|---------|--------|
| Flutter SDK | 3.44.0 (stable) | ✓ |
| Dart SDK | 3.12.0 (stable) | ✓ |
| Visual Studio | Community 2026 Insiders (12.0.2009) | ✓ (Windows builds) |
| Android SDK | 36.0.0 | ✓ |
| Chrome | Available | ✓ (web dev) |
| Git | Working (repo exists) | ✓ |
| Connected devices | 3 (1 not authorized) | ✓ |

Full `flutter doctor` output: **No issues found.** All checks pass.

### 9.2 Package Resolution Test

Created a minimal `pubspec.yaml` with `drift: ^2.27.0`, `sqlite3_flutter_libs: ^0.5.0`, `drift_dev: ^2.27.0`, `build_runner: ^2.4.0`. All resolved successfully:

| Package | Resolved Version |
|---------|-----------------|
| drift | 2.34.2 |
| drift_dev | 2.34.4 |
| sqlite3_flutter_libs | 0.5.42 |
| sqlite3 | 3.5.0 |
| build_runner | 2.15.1 |

### 9.3 SQLite Availability

SQLite CLI (`sqlite3`) is not installed as a standalone tool on this machine, but **this is not an issue.** The `sqlite3_flutter_libs` package bundles SQLite natively for all Flutter platforms including Windows — the app does not depend on a system-installed SQLite. Drift accesses SQLite through this bundled native library.

### 9.4 Missing / Noteworthy

| Item | Status | Notes |
|------|--------|-------|
| Flutter project scaffold | Not yet created | Per instructions — no scaffolding until go-ahead |
| `pubspec.yaml` | Not in repo | Will be created in the actual Flutter project |
| SQLite CLI | Not installed | Not needed; drift bundles its own |
| Code generation tools | Resolvable but not installed globally | `build_runner` + `drift_dev` will be dev dependencies |

### 9.5 Recommended Additional Tools

| Tool | Purpose | Priority |
|------|---------|----------|
| **sqlitebrowser (DB Browser for SQLite)** | Visual inspection of SQLite database during development/debugging | High |
| **GitHub Desktop or GitKraken** | If CLI-only git is insufficient for the developer | Low |
| **Postman / Bruno** | For testing APIs when cloud phase begins | Later |
| **dart_code_metrics** (linting) | Enforce code quality beyond default analyzer | Medium |

---

## 10. Questions, Ambiguities, and Concerns

These should be resolved before schema design and coding begin.

### 10.1 Session Pricing Ambiguity

A session has both `price per session`, `monthly price`, and `sessions per month`. How do these relate?
- **Option A:** Monthly price is the total, sessions per month is the count, per-session price = monthly / count (derived).
- **Option B:** Monthly price and per-session price are alternatives — the center chooses which pricing model applies per session.
- **Option C:** Per-session is the base unit; monthly price is just informational for parents.

**Recommended:** Clarify with the client. My assumption is Option A (monthly price defines the total, per-session is derived), but this affects the charge calculation in Scenario 4.

### 10.2 Teacher Compensation Ambiguity

A session has `teacher share %`, `teacher cut`, and `admin cut`. Are these three separate numbers or is `teacher cut = session price * teacher share %`? If both `teacher cut` (explicit amount) and `teacher share %` exist, which takes precedence?

**Recommended:** Pick one model. I suggest: `teacher_share_percentage` (e.g., 70%) and derive `teacher_cut = session_price * teacher_share_percentage / 100`. The `admin_cut` is the remainder. If some teachers have flat-fee arrangements, that's a different field/type.

### 10.3 Barcode Scanner Interface

The spec says the existing scanner reads barcodes (1D). What's the hardware interface?
- **Keyboard wedge (most common):** Scanner acts as a USB keyboard and types the barcode content followed by Enter. This is simplest — we just listen for input in a focused text field.
- **Serial/COM port:** Requires direct port communication.
- **Proprietary SDK:** Could be anything.

**Recommended:** Confirm the scanner model and interface. If it's a keyboard wedge, the check-in screen is essentially a text field that auto-submits on Enter.

### 10.4 Barcode Content Format

What exactly is in the barcode? Options:
- Just the student `code` (e.g., "STU-00123")
- A structured string (e.g., "EDU|STU-00123|")
- Something else entirely

The existing cards from "Sable School" have barcodes already — we need to know what they encode so the new system can read them (backward compatibility) or at least understand the format.

### 10.5 Session Occurrence Instantiation

How do session "occurrences" get created? A session is a recurring schedule (e.g., "every Monday 10:00-12:00"). When does the actual "occurrence for Monday July 21, 2026" get created?
- **Option A:** Generated in advance (e.g., all occurrences for the next month are created at the start of the month).
- **Option B:** Created on-the-fly when the first attendance event happens for that date+session.
- **Option C:** Not stored at all — attendance just references `(session_id, date)`.

**Recommended:** Option C for simplicity in the local-only phase, but this limits the ability to pre-mark cancellations. Option A is better if we need to mark specific dates as cancelled in advance. This affects the database schema significantly.

### 10.6 Sign Convention for Transaction Amounts

What sign convention do amounts use?
- **Positive = debit (student owes more):** `session_charge = +500`, `student_payment = -500`, `teacher_payout = +1000`.
- **All positive, type determines direction:** `session_charge = 500` (student debt increases), `student_payment = 500` (student debt decreases), `teacher_payout = 1000` (what teacher is owed).

**Recommended:** All positive, type determines direction. This prevents sign errors and makes `SUM(CASE WHEN type = ...)` queries explicit.

### 10.7 Student "Status" Field

What status values are needed? Common ones:
- `active` (currently enrolled)
- `inactive` (taking a break)
- `graduated` (completed the level)
- `dropped_out`
- `suspended`

**Recommended:** Start with `active`, `inactive`, `graduated`. Add more as needed.

### 10.8 Expense Transaction Scope

Are `expense` transactions meant for:
- **Only education-related expenses:** buying books, materials, exam fees.
- **Full business accounting:** rent, electricity, salaries (separate from teacher payouts), maintenance, cleaning supplies.

If it's the latter, the ledger becomes a general business ledger. This has implications for reporting and categorization.

### 10.9 Teacher Salary Type

The existing README mentions "salary type: fixed or per-session." The new spec focuses on "teacher share %" per session. Are both models needed (some teachers on fixed monthly salary regardless of sessions, others on per-session commission)?

### 10.10 "Device ID" Format

For the single-device phase, what should `device_id` be?
- A hardcoded string (e.g., "front_desk_pc")?
- A generated installation UUID?
- The machine's hostname?

**Recommended:** Generated installation UUID, stored in app preferences. This costs nothing and is ready for multi-device sync later.

### 10.11 Existing README.md Content

The existing README.md describes a different architecture (Supabase-first, cloud-first, 4 apps, different schema). This new specification is essentially a reboot with a different technical approach. Should I:
- Replace the README with the new vision?
- Keep both and note the pivot?
- Remove it and start fresh?

### 10.12 Data Migration from Old System

Will there be a need to import existing students, teachers, and historical data from "Sable School"? This would require understanding the old system's database format and writing a migration script. If historical financial data is unreliable (which it seems to be), we might import entity data (students, teachers) but start the ledger fresh.

### 10.13 Language / Localization

The project is for an Arabic-speaking client (the old app name is in French "Sable School" but the user is in Algeria). Should the UI be:
- Arabic only?
- French only?
- Bilingual (Arabic + French)?
- Multi-language with localization infrastructure?

This affects string handling, RTL layout requirements, and date/number formatting from day one.

---

## 11. Summary

The EduManage project is well-defined at a conceptual level. The core innovation is the **append-only ledger** — a unified, immutable transaction table that eliminates the accounting desync that plagued the old system. The six attendance scenarios cover all operational edge cases, and the architecture is designed so that moving from local-only to cloud-synced is a pure addition, not a rewrite.

The development environment is ready: Flutter 3.44.0, Dart 3.12.0, Visual Studio for Windows builds, and all required packages (drift, sqlite3_flutter_libs, build_runner) resolve correctly. No blocking issues found.

The 13 questions above need answers before schema design begins, but none of them should fundamentally change the architecture — they're clarifications on business rules and operational details.
