# Module Tracking — Round 3 (Timetable, SubjectGroups, Classrooms, Enrollments)

---

## Known Bug: Pay Now Payout Logic (NOT FIXED — Documented)

**Location:** `_PayoutHistoryListState._payNow()` at `teacher_list_screen.dart:799`

**What it does today:**
```dart
final sessions = await sessionRepo.getByTeacher(widget.teacherId);
for (final s in sessions) {
  if (!s.isActive) continue;
  await txService.createTeacherPayout(teacherId: widget.teacherId, sessionId: s.id);
}
```

**Specific issues identified (traced in code):**

1. **No date bounding:** `createTeacherPayout` defaults `date` to `DateTime.now()`. `_getSessionAttendanceCount` queries attendance for exactly today's date. Any attendance from yesterday or last week — even if unpaid — is NOT counted. The payout is always $0 for past attendance because it filters by today's date range.

2. **No already-paid check:** `createTeacherPayout` has no deduplication. Clicking "Pay Now" twice creates duplicate `teacher_payout` transactions for the same session with the same timestamp. An admin could accidentally double-pay a teacher.

3. **No cancellation check in payout:** `createTeacherPayout` does NOT call `_isSessionCancelled()`. If a session was cancelled on today's date and students were already checked in (with reversal transactions), the payout would still try to calculate attendance — resulting in $0 for already-reversed attendance. But if attendance records remain after reversal (reversals only credit the charge, they don't delete attendance), the attendance count would be stale.

4. **Blanket pay-all without session selection UI:** The UI has no checkbox or date-range picker to choose which sessions or date ranges to include. It pays ALL active sessions for the teacher, regardless of whether some were already paid.

**Recommended fix (not implemented):**
- Add a date range parameter to `_payNow()` (from/to dates)
- Add a `_isAlreadyPaid` check in `createTeacherPayout`
- Add cancellation check in `createTeacherPayout`
- Add session selection checkboxes in the `_PerSessionEarningsList` widget, passing selected session IDs to `_payNow()`

---

## Completed Fixes

### Timetable Time Range
- **Root cause:** `maxHour` clamp at 24 and fixed range derived only from data, dropping sessions outside the initial sample range
- **Fix:** Default range 06:00–22:00, dynamically extended based on actual session times, no artificial cap
- **Extra:** Sessions longer than 8 hours (sample data placeholders) filtered out of grid

### SubjectGroups Redesign
- **Screen:** 80-line stub → 270-line dense table with ShellDialog edit/detail
- **Table columns:** Checkbox, Name (AR/FR dual-line), Subject, School Level, Sessions count, Enrollments count, Actions
- **Detail dialog:** Group info + session list (day/time per session) + enrollment count
- **Edit dialog:** ShellDialog with ShellInputDecoration, name/subject fields, school level dropdown, description
- **New features:** Session count per group (resolved from SessionRepository), enrollment count (active students), school level filter-ready columns

### Classrooms Redesign
- **Screen:** 81-line stub → 230-line dense table
- **Table columns:** Checkbox, Name (AR/FR dual-line), Floor, Capacity (with usage %), Sessions count, Actions
- **Detail dialog:** Room info + session list (group name + day/time per session in this room)
- **Edit dialog:** ShellDialog with name/floor/capacity/notes fields
- **New feature:** Capacity usage percentage — `(sessionCount / capacity * 100)` shown next to capacity number

### Enrollments Enhancement
- **Screen:** 84-line stub → 160-line dense table with bulk operations
- **Table columns:** Checkbox, Student name, Group name, Enrollment date, Status badge, Toggle action
- **Multi-select:** Checkboxes + bulk activate/drop with selection bar
- **Filter chips:** All / Active / Inactive
- **Add dialog:** ShellDialog with student + group dropdowns
- **Toggle:** Single-tap toggle between active/inactive per row

---

## Deferred Items (Awaiting Confirmation)

1. **Pay Now fix** — described above. Needs decision on whether to add date-range picker, session selection checkboxes, or both.

2. **SubjectGroups archive/restore** — schema has no `isArchived` on SubjectGroups. Would require migration v6. Similar to how Students/Teachers/Sessions were handled. Flagged because it requires a schema change.

3. **Classrooms archive/restore** — same as above, no `isArchived` column.

4. **Enrollment start/end dates** — schema has `enrollmentDate` but no `endDate`. Adding `endDate` would enable scheduled drops and automated status transitions.

5. **Waitlist concept** — if a group is at capacity (Classroom capacity), enrollments would queue. Requires capacity tracking per group (not per classroom, which is different).

6. **Enrollment transfer between groups** — moving a student from one group to another while preserving history.
