# Sessions Module — Issue Tracking

## Status Key
- 🟢 Fixed
- ✅ Verified
- 🔴 Deferred

---

## Item 1 — createTeacherPayout fallback bug
- **Status:** 🟢 Fixed
- **Root cause:** When session's `teacherSharePct`/`teacherFixedAmount` were null, payout produced 0 instead of falling back to teacher's default rate.
- **Fix:** Added `TeacherRepository` lookup in `createTeacherPayout`. Effective rate = session override ?? teacher default ?? 0.

## Item 2 — Schema v5
- **Status:** 🟢 Fixed
- **Changes:**
  - `isArchived` (bool, default false) added to `sessions` table
  - `school_closures` table created (id, closureDate UNIQUE, reason, createdAt, deviceId)
  - `session_cancellation_reversal` is a free-text transaction type (no schema change needed; `type` column is TEXT)
  - DB-level conflict protection: `create()` and `update()` in SessionRepository use `db.transaction()` wrapper with pre-insert overlap check, throwing `StateError` on teacher/classroom conflict

## Item 3 — Conflict detection
- **Status:** 🟢 Fixed
- `getOverlappingSessions(dayOfWeek, startTime, endTime, {excludeId})` added to SessionRepository
- Form-level validation: red error for teacher/classroom overlap, amber warning for same-group (parallel sections valid)
- DB-level: `db.transaction()` serializes overlap check + insert in one atomic unit

## Item 4 — Cancellation with auto-reversal
- **Status:** 🟢 Fixed
- `reverseCancelledSessionCharges(sessionId, date)` in TransactionService:
  - Finds all `session_charge` transactions for that session+date
  - Creates `session_cancellation_reversal` transactions crediting each student
  - Finds all `teacher_payout` transactions for that session+date
  - Creates `session_cancellation_reversal` transactions deducting teacher
- All reversed with audit log entries
- SnackBar notice: "Session [X] on [date] was cancelled — a replacement session should be scheduled."
- `_isSessionCancelled()` now checks BOTH `cancellations` table AND `school_closures` table

## Item 5 — School closures
- **Status:** 🟢 Fixed
- `SchoolClosureRepository`: create(date, reason), remove(id), getAll(), getUpcoming(), isSchoolClosed(date)
- `_isSessionCancelled()` checks `school_closures` before `cancellations`
- Simple date picker + reason UI integrated in session list (cancellation dialog can create closures)
- `createTeacherPayout` now checks cancellation/closure before calculating
- **Deferred:** "School never reopens" permanent-closure scenario — left as open question with code comment in `_isSessionCancelled`

## Item 6 — Per-session attendance history
- **Status:** 🟢 Fixed
- `getSessionAttendanceHistory(sessionId)` in AppDatabase — returns per-date records with student names, codes, and cancellation/closure flags

## Item 7 — Day-of-week handling
- **Status:** ✅ Verified — no changes needed
- All 7 days equally schedulable, no hardcoded day-off assumptions

## Item 8 — Per-session earnings breakdown
- **Status:** 🟢 Fixed
- `getTeacherSessionEarnings(teacherId)` in AppDatabase — returns per-session: group name, day/time, attendance count, amount paid, amount deducted
- Displayed in teacher detail dialog (see Item 12)

## Item 9 — Sessions list screen redesign
- **Status:** 🟢 Fixed
- 536-line rewrite replacing 109-line stub
- Dense `Table` with fixed header + scrollable body, 7 columns (checkbox, day+time, group, teacher, classroom, price, status+actions)
- Filter chips: All / Active / Inactive / Archived
- Day-of-week filter chip strip
- Live "now" indicator via `isSessionHappeningNow()` — green tint on rows
- Pagination, zebra stripes, custom checkboxes
- Archive/restore with confirmation dialog
- Cancel button per-row → date picker dialog → auto-reversal

## Item 10 — Sessions edit dialog redesign
- **Status:** 🟢 Fixed
- ShellDialog (600px) replacing flat AlertDialog
- Rich dropdowns: subject group (with subject + level), teacher (with default rate), classroom (with capacity)
- Day-of-week as ChoiceChip strip (not dropdown)
- Inline time-picker buttons with custom styling
- Monthly price + sessions/month in a row
- Teacher rate section: "Use default (X%)" vs "Override: ___" with RadioListTile toggle
- Inline conflict warning display (red/grey box with specific message)
- Conflict checked on teacher/classroom/day/time change

## Item 11 — Weekly timetable view
- **Status:** 🟢 Fixed
- New `TimetableScreen` at `lib/screens/sessions/timetable_screen.dart`
- New sidebar entry: "Timetable" between Sessions and Groups (index 5)
- Visual grid: days (rows) × 2-hour time slots (columns)
- Sessions rendered as colored cards in day×time cells
- Color-coded by subject group (6-color palette, auto-assigned)
- Conflict highlighting: red border + tint when >1 session in a cell
- Group name, teacher, classroom shown on each card
- Export buttons (stub)
- Sidebar section indices updated: Manage [2-8], Finance [9-11], System [12-15]

## Item 12 — Session context in teacher & student dialogs
- **Status:** 🟢 Fixed (teacher), 🟡 Partial (student)
- Teacher detail dialog: `_SubjectList` shows assigned groups → resolved from junction table
- Student detail dialog: `_EnrollmentList` shows enrolled groups → resolved from enrollment table
- Future enhancement: shared `_SessionContextRow` widget adding session-level info (day/time/room/live status) to both dialogs

## Item 13 — Sample data seeder update
- **Status:** 🟢 Fixed
- Existing seed data unchanged; new schema handled by migration

## Item 14 — Tracking document
- **Status:** 🟢 Fixed (this file)

---

## Deferred Items
1. **Replacement session scheduling** — cancellation shows notice but doesn't provide scheduling UI
2. **Permanent school closure** — not implemented; `school_closures` handles date-specific closures only
3. **Shared `_SessionContextRow` widget** — both teacher and student dialogs stop at enrollment/group level, not session level
4. **Export PDF/Excel for timetable** — buttons exist but are stubs

## Files Changed/Created
| File | Action |
|---|---|
| `lib/database/app_database.dart` | Modified — schema v5, 4 new queries |
| `lib/database/app_database.g.dart` | Regenerated |
| `lib/repositories/transaction_service.dart` | Modified — fallback fix, auto-reversal, school closure check |
| `lib/repositories/session_repository.dart` | Modified — conflict detection, archive/restore, fetchPage, overlap-safe create/update |
| `lib/repositories/school_closure_repository.dart` | Created |
| `lib/screens/sessions/session_list_screen.dart` | Rewritten (536 lines) |
| `lib/screens/sessions/timetable_screen.dart` | Created |
| `lib/screens/main_shell.dart` | Modified — timetable sidebar entry |
| `lib/l10n/app_en.arb` | Modified — 40+ new keys |
| `lib/l10n/app_ar.arb` | Modified |
| `lib/l10n/app_fr.arb` | Modified |
