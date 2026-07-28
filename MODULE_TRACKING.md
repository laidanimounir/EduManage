# Module Tracking — Full Project

---

## MANUAL TESTING CHECKLIST

Use `flutter run` (cold start) for all tests — hot reload bypasses `IndexedStack`/`KeyedSubtree` rebuilds.

---

### STUDENTS

- [ ] **1. List — dense table visual check**
  - Open sidebar → Students. Verify: dark theme, zebra stripes (alternating transparent/chromeBase rows), 7 columns (checkbox, name AR/FR, surname, school level, birth date, registration date, actions), fixed header doesn't scroll with body.
- [ ] **2. Frozen name column**
  - Scroll horizontally. Verify the name column stays visible while other columns scroll off-screen.
- [ ] **3. Checkbox column + multi-select**
  - Click the checkbox icon in the header → all rows selected. Click a single row's checkbox. Verify: selection bar appears with count, "Clear Selection" and "Select All" buttons. Click the header checkbox again → all deselected.
- [ ] **4. Sortable headers**
  - Click "Name" header → rows sorted ascending (arrow up). Click again → descending (arrow down).
- [ ] **5. Pagination**
  - Verify "Showing 1–X of Y" footer with prev/next PhosphorIcon buttons. Click next → page 2. Click prev → page 1.
- [ ] **6. Filter chips**
  - Click "Active" → only active students shown. Click "Inactive" → only inactive. Click "Graduated" → only graduated. Click "Archived" → only archived. Click "All" → everything except archived.
- [ ] **7. Search**
  - Type a student name or code in the search field. Verify results filter live. Clear button appears; click it → filters reset.
- [ ] **8. Registration fee unpaid badge**
  - Find a student without a paid registration fee. Verify amber "Fee Unpaid" badge next to their name in the name cell.
- [ ] **9. Unenrolled row tint**
  - Find a student with no active enrollments. Verify their row has a muted red tint background (SemanticTokens.error at 8% alpha).
- [ ] **10. Export toolbar buttons**
  - Click the PDF export icon → verify it's present (stub, may show "coming soon"). Click Excel icon → same.
- [ ] **11. Barcode auto-focus field**
  - In the student list, verify there's a barcode input field. Type a valid student code (e.g., STU-001) and press Enter → student detail dialog opens. Type an invalid code → nothing happens (or message shown).
- [ ] **12. Student detail dialog**
  - Click any row → modal ShellDialog opens with: photo avatar (initials or photo), student name + code, X close button. Scroll down: Personal Info section (names, phone, address, gender, birth date, birth place, school level), Financial Status section (total charged, total paid, balance, registration fee status + "Mark as Paid" button), Enrollments section (enrolled groups with resolved names and active/inactive dots).
- [ ] **13. Photo in detail dialog**
  - For a student with a photo uploaded via edit: verify photo appears as circular avatar in the detail header. For a student without: verify initials-based CircleAvatar.
- [ ] **14. Registration fee — Mark as Paid**
  - In student detail, if registration fee is unpaid, "Mark as Paid" button is visible. Click it → verify fee status changes to "Fee Paid" immediately. Reopen dialog → still shows paid.
- [ ] **15. Registration fee — auto-created on new student**
  - Create a new student via edit dialog. Open their detail → verify Financial Status shows a registration_fee charge (default 2000 DA from Settings).
- [ ] **16. Student edit dialog — create new**
  - Click "+" button → ShellDialog opens. Verify: code field auto-generates (STU-XXX), photo picker area (72x88 rounded container with camera icon), grid form layout (name AR/FR, surname AR/FR, phone, address, gender, birth date, birth place), school level dropdown with "+ Add New" option. Fill fields and click Create → new student appears in list.
- [ ] **17. School level — dynamic creation**
  - In add/edit dialog, open school level dropdown → scroll to bottom → "+ Add New 'name'" option. Click it → type a level name → confirm. New level appears in the dropdown and is selected.
- [ ] **18. Photo upload in edit**
  - In edit dialog, click the photo picker area → select an image. Verify the photo preview appears in the container. Save → reopen detail → photo appears.
- [ ] **19. Student edit dialog — edit existing**
  - Click pencil icon on a row → edit dialog opens pre-filled with student's data including existing photo.
- [ ] **20. Archive student**
  - Click archive icon on a row → confirmation dialog appears. Verify warning shows if student has transactions/enrollments. Confirm → row disappears from active view. Switch to "Archived" filter → student appears.
- [ ] **21. Restore student**
  - Switch to "Archived" filter → click restore icon → confirmation dialog → row disappears from archived view. Switch to "All" → student reappears as active.
- [ ] **22. Group assignment**
  - Click the group assignment button on a student row (3-dot/people icon if present). Verify a multi-select dialog opens showing all subject groups. Select one or more → confirm → student is enrolled. Open student detail → new enrollments appear.
- [ ] **23. Student balances screen**
  - Open sidebar → Outstanding Debts. Verify list shows students with non-zero balances, sorted by amount.
- [ ] **24. Settings — registration fee**
  - Open sidebar → Settings. Verify "Registration Fee" field exists. Change the value → it auto-saves (SharedPreferences). Create a new student → verify their registration fee matches the new value.

---

### TEACHERS

- [ ] **25. List — dense table visual check**
  - Open sidebar → Teachers. Verify: dark theme, zebra stripes, 7 columns (checkbox, name, code, salary, subjects, payout status, actions).
- [ ] **26. Filter chips**
  - Click "Active" → only teachers without employment end date. Click "Ended" → only teachers with an end date (muted amber tint). Click "Archived" → only archived. Click "All" → everything except archived.
- [ ] **27. Live "teaching now" indicator**
  - Schedule a session that overlaps the current time for teacher Samir. Navigate to Teachers → verify Samir's row has a green tint background + green "Live" badge in the payout status column. Wait until the session time passes → revisit → badge should disappear.
- [ ] **28. Overdue badge**
  - Edit a teacher → set "Overdue Threshold" to 1 day. No payouts exist yet → amber "Overdue" badge appears. Clear the threshold → badge disappears.
- [ ] **29. Teacher detail dialog**
  - Click any row → ShellDialog with: photo, name + code, personal info rows (names, phone, email, ID card, gender, salary type, employment dates, overdue threshold), Subjects section (assigned groups with session day/time beneath each), Financial Status (total earned, total paid, balance, attendance count).
- [ ] **30. Per-session earnings**
  - In teacher detail, scroll to "Per-Session Earnings" section. Verify each session shows: group name, day/time, rate (percentage or fixed DA), attendance count, amount paid, amount deducted.
- [ ] **31. Pay Now — always visible**
  - In teacher detail, scroll to "Payout History" section. Verify "Pay Now" FilledButton is always present, regardless of whether payouts exist. If no payouts, "No payout history" text + Pay Now button both visible.
- [ ] **32. Pay Now — creates payout**
  - Click "Pay Now" → confirmation dialog → confirm. Verify payout history section updates with a new transaction showing amount and date. Financial summary updates (total paid increases, balance decreases).
- [ ] **33. Payout history**
  - Verify last 10 payout transactions show date + amount in the Payout History section.
- [ ] **34. Salary change history**
  - Edit a teacher → change salary type or rate → save. Reopen detail → "Salary Change History" section shows the change with old→new values and timestamp.
- [ ] **35. Teacher edit dialog**
  - Click pencil icon → ShellDialog with: photo picker, code (read-only on edit), name fields AR/FR, gender, phone, email, ID card, address, salary type toggle (percentage/fixed), subject multi-select filter chips, employment date pickers, overdue threshold field.
- [ ] **36. Subject assignment — multi-select chips**
  - In edit dialog, scroll to Subject Assignment section. Verify FilterChips for all subject groups. Select/deselect multiple → save → reopen detail → subjects section reflects changes.
- [ ] **37. Archive teacher**
  - Click archive icon → confirmation with "has transactions/sessions" warning if applicable. Confirm → row disappears. Switch to Archived filter → teacher appears.
- [ ] **38. Restore teacher**
  - Switch to Archived filter → restore icon → confirm → teacher reappears in active list.

---

### SESSIONS

- [ ] **39. List — dense table**
  - Open sidebar → Sessions. Verify: dark theme, zebra stripes, 8 columns (checkbox, day+time, group, teacher, classroom, monthly price, status, actions).
- [ ] **40. Filter chips**
  - Click "Active" → only isActive=true sessions. Click "Inactive" → only isActive=false. Click "Archived" → only archived. Click "All" → all non-archived.
- [ ] **41. Day-of-week filter chips**
  - Click "Mon" chip → only Monday sessions. Click "Tue" → only Tuesday. Click "All" → all days.
- [ ] **42. Live indicator**
  - During a session's scheduled time, verify that session's row has a green tint + "Live" badge in the status column. After the session time passes, revisit → badge gone.
- [ ] **43. Session detail dialog**
  - Click any row → ShellDialog with: day/time, teacher name, classroom name, monthly price, sessions/month, Enrolled Students section (student names with codes), Attendance History section (per-date records with student names, cancellation/closure badges if applicable).
- [ ] **44. Session edit dialog — create new**
  - Click "+" → ShellDialog (600px). Verify: rich dropdowns (subject group shows subject+level, teacher shows default rate, classroom shows capacity), day-of-week as ChoiceChip strip (not dropdown), time-picker buttons showing formatted hours, monthly price + sessions/month fields, teacher rate section (radio: "Use default (X%)" vs "Override rate" with conditional input field).
- [ ] **45. Conflict detection — teacher overlap**
  - Create session with Samir, Monday, 09:00-11:00. Create another with Samir, Monday, 10:00-12:00 → red conflict warning box appears. Try saving → blocked with error SnackBar.
- [ ] **46. Conflict detection — classroom overlap**
  - Same as above but with same classroom → red conflict. Try saving → blocked.
- [ ] **47. Conflict detection — same-group warning**
  - Create two sessions with same group, same day+time, different teachers → amber warning (parallel sections valid). Saving is allowed.
- [ ] **48. Rate override**
  - In session edit, select "Override rate" → enter a different percentage. Save → teacher detail "Per-Session Earnings" shows the overridden percentage for this session.
- [ ] **49. Rate snapshot — historical accuracy**
  - Create a payout for a session. Edit the session to change its rate override. Check the transaction's `rateSnapshot` field (database) → old payout still shows the original rate, not the new one.
- [ ] **50. Cancel session occurrence**
  - Click the X (cancel) button on a session row → date picker dialog. Select today's date, enter a reason → confirm. Verify: SnackBar shows "Session [name] on [date] was cancelled — a replacement session should be scheduled."
- [ ] **51. Cancellation auto-reversal — student refund**
  - Before canceling: check a student into that session (Check-in screen). Then cancel the session for that date. Open the student's detail → Financial Status → verify a "session_cancellation_reversal" credit appears, refunding the session charge.
- [ ] **52. Cancellation auto-reversal — teacher deduction**
  - Same flow but after a payout was already made for that teacher. Verify the teacher's payout history or per-session earnings shows a deduction.
- [ ] **53. Cancellation — no attendance → no reversal**
  - Cancel a session for a future date (no attendance exists). Verify no reversal transactions are created (SnackBar shows "0 reversals").
- [ ] **54. Archive session**
  - Click archive icon → confirmation → row disappears from active view. Switch to Archived filter → session appears.
- [ ] **55. Restore session**
  - Archived filter → restore icon → confirm → session reappears.

---

### WEEKLY TIMETABLE

- [ ] **56. Grid layout**
  - Open sidebar → Timetable. Verify: days as rows (Mon–Sun), time slots as columns (from ~06:00 to ~22:00 based on session data), sessions rendered as colored cards with left-border color matching their subject group.
- [ ] **57. Color-coded by group**
  - Verify different subject groups have different left-border colors on their cards.
- [ ] **58. Session card content**
  - Each card shows: group name (bold, colored), teacher name (small), classroom name (smaller, disabled color).
- [ ] **59. Conflict highlighting**
  - Create two sessions at the same day+time in the same group → verify the cell has a red border + red tint background.
- [ ] **60. Dynamically-created session appears**
  - Create a new session from the Sessions list. Navigate to Timetable → verify the new session card appears in the correct day×time cell. Create a session at an unusual time (e.g., 19:00-20:00) → verify the grid extends to include it.
- [ ] **61. Export buttons**
  - Verify PDF and Excel export icons are present on the toolbar (stubs, may not generate output).

---

### SUBJECT GROUPS

- [ ] **62. List — dense table**
  - Open sidebar → Groups. Verify: dark theme, zebra stripes, 8 columns (checkbox, name AR/FR, subject, school level, capacity, sessions count, enrollments count, actions).
- [ ] **63. Filter chips**
  - "All" / "Active" / "Archived" — verify each shows correct subset.
- [ ] **64. Capacity column + "Full" badge**
  - Set a group's capacity to a number lower than current enrollments → "Full" badge (red) appears in the enrollments column. Increase capacity above enrollment count → shows numeric count instead.
- [ ] **65. Group detail dialog**
  - Click a row → ShellDialog shows: name, subject, school level, capacity. Below: Sessions section (day/time per session for this group), Enrollments section (student names with X button to drop), Waitlist section.
- [ ] **66. Drop enrollment from detail**
  - In group detail, click the X button next to an enrolled student → enrollment status changes to inactive. The enrollment count decreases.
- [ ] **67. Waitlist section**
  - If students are on the waitlist: verify Waitlist section shows their names, request dates, and "Move to active" button.
- [ ] **68. Move from waitlist to active (spot free)**
  - Drop an enrollment from a full group (frees a spot). In Waitlist section, click "Move to active" on a waiting student → student moves from waitlist to active enrollment. Waitlist list updates.
- [ ] **69. Move from waitlist to active (spot not free)**
  - For a full group with no spots free, click "Move to active" → "Group is full" dialog appears with "Increase Capacity" option.
- [ ] **70. Group edit dialog**
  - Click pencil → ShellDialog with: name AR/FR, subject AR/FR, school level dropdown, capacity field (empty = unlimited), description field.
- [ ] **71. Archive group**
  - Click archive icon → confirm (warning if active sessions/enrollments). Group moves to Archived filter.
- [ ] **72. Restore group**
  - Archived filter → restore icon → confirm → group reappears.
- [ ] **73. Archived groups hidden from dropdowns**
  - Archive a group. Go to Sessions → create new session → group dropdown: archived group is not listed. Go to Enrollments → add enrollment → same.
- [ ] **74. Archived groups hidden from teacher subject assignment**
  - Archive a group. Edit a teacher → Subject Assignment chips: archived group does not appear.

---

### CLASSROOMS

- [ ] **75. List — dense table**
  - Open sidebar → Classrooms. Verify: dark theme, zebra stripes, 6 columns (checkbox, name AR/FR, floor, capacity with usage %, sessions count, actions).
- [ ] **76. Filter chips**
  - "All" / "Active" / "Archived" — verify each shows correct subset.
- [ ] **77. Capacity usage percentage**
  - Verify capacity column shows e.g. "30 66%" where 30 is capacity and 66% is (sessions using this room / capacity * 100).
- [ ] **78. Classroom detail dialog**
  - Click a row → ShellDialog shows: name, floor, capacity, notes. Below: Sessions section listing which sessions use this room (group name + day/time).
- [ ] **79. Classroom edit dialog**
  - Click pencil → ShellDialog with: name AR/FR, floor, capacity, notes.
- [ ] **80. Archive classroom**
  - Click archive icon → confirm (warning if active sessions). Classroom moves to Archived filter.
- [ ] **81. Restore classroom**
  - Archived filter → restore → classroom reappears.
- [ ] **82. Archived classrooms hidden from session dropdowns**
  - Archive a classroom. Create new session → classroom dropdown: archived room not listed.

---

### ENROLLMENTS

- [ ] **83. List — dense table**
  - Open sidebar → Enrollments. Verify: dark theme, zebra stripes, 6 columns (checkbox, student name, group name, enrollment date, status badge, actions).
- [ ] **84. Filter chips**
  - "All" / "Active" / "Inactive" — verify each shows correct subset.
- [ ] **85. Multi-select + bulk operations**
  - Select multiple rows via checkboxes → selection bar appears with "Active" and "Drop Enrollment" bulk buttons. Click "Drop Enrollment" → all selected become inactive. Click "Active" → all selected become active.
- [ ] **86. Single-row toggle**
  - Click the checkmark/X icon on a row → toggles between active and inactive immediately.
- [ ] **87. Add enrollment — direct**
  - Click "Enroll Student" button → ShellDialog with student dropdown + group dropdown (archived groups excluded) + "Enroll Student" button + "Add to Waitlist" button. Select student + group, click "Enroll Student" → enrollment created.
- [ ] **88. Add enrollment — capacity blocked**
  - Fill a group to its capacity. Try enrolling another student in that group → dialog appears: "Group is full (N/N)" with: Cancel / Increase Capacity / Add to Waitlist. Choose "Increase Capacity" → enter new number → enrollment proceeds. Try again → choose "Add to Waitlist" → student added to waitlist.
- [ ] **89. Add enrollment — direct to waitlist**
  - In add enrollment dialog, click "Add to Waitlist" directly (without triggering capacity check) → student goes to waitlist immediately.
- [ ] **90. Transfer enrollment**
  - Click the ⇄ (transfer) button on an active enrollment row → "Transfer Student" dialog. Shows source group name + destination group dropdown (excluding same group and archived groups). Pick destination → "Transfer" button. Enrollment moves.
- [ ] **91. Transfer to full group**
  - Fill destination group to capacity. Try transferring a student there → "Destination group is full" dialog with: Cancel / Increase Capacity / Cancel Transfer. Choose "Increase Capacity" → enter new number → transfer proceeds. Choose "Cancel Transfer" → nothing changes.
- [ ] **92. Transfer preserves history**
  - After transfer: open the student's detail dialog → "Enrollment History" section shows the old group with "Transferred" status. Active section shows the new group.
- [ ] **93. Student detail — enrollment history**
  - Open any student detail → Enrollments section: active enrollments at top (with group names and session times), "Enrollment History" below showing past/inactive/transferred enrollments with group name + status label.

---

### SCHOOL CLOSURES (via Cancellation Screen or Sessions)

- [ ] **94. Check-in blocked on closure date**
  - Delete DB, restart to get sample data. But for test: create a school closure for today's date. Try to check in a student → session should be treated as cancelled (no active session / check-in blocked).

---

### CROSS-MODULE CHECKS

- [ ] **95. Sidebar navigation**
  - Click each sidebar item (Dashboard, Check-in, Students, Teachers, Sessions, Timetable, Groups, Classrooms, Enrollments, Payments, Outstanding Debts, Reports, Cards, Audit Log, Users, Settings) → each loads without crash. Timetable appears between Sessions and Groups.
- [ ] **96. Dark theme consistency**
  - Navigate all screens. Verify: all use ShellTokens (chromeSurface/chromeBase backgrounds), PhosphorIcons (no Material Icons.add, etc.), ShellDialog, ShellInputDecoration patterns.
- [ ] **97. RTL text rendering**
  - Switch app language to Arabic (Settings). Verify all Arabic text renders correctly, no layout breaks, column headers in Arabic.
- [ ] **98. Cold start with sample data**
  - Delete edumanage.db and restart app. Verify sample data seeds: 3 students, 2 teachers, 2 groups, 7 sessions, 3 classrooms, 3 school levels.

---

## KNOWN OPEN ISSUES

### Pay Now Payout Logic (NOT FIXED)

**Location:** `_PayoutHistoryListState._payNow()` in `teacher_list_screen.dart:799`

**What it does today:**
```dart
final sessions = await sessionRepo.getByTeacher(widget.teacherId);
for (final s in sessions) {
  if (!s.isActive) continue;
  await txService.createTeacherPayout(teacherId: widget.teacherId, sessionId: s.id);
}
```

**Specific bugs (traced in code):**

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

## Deferred Items

1. ~~Pay Now fix~~ — FIXED in Round 5.

2. ~~SubjectGroups archive/restore~~ — COMPLETED in Round 4.

3. ~~Classrooms archive/restore~~ — COMPLETED in Round 4.

4. **Enrollment end dates** — still deferred.

5. ~~Waitlist concept~~ — COMPLETED in Round 4.

6. ~~Enrollment transfer~~ — COMPLETED in Round 4.

7. ~~Family accounts~~ — COMPLETED in Round 6.

8. ~~Billing cycles~~ — COMPLETED in Round 6 (basic cycle tracking). School-closure vs cancellation distinction for cycle counting remains deferred.

9. ~~Refunds and credit notes~~ — COMPLETED in Round 6.

10. ~~KPI dashboard~~ — COMPLETED in Round 6.

11. ~~Bulk payment recording~~ — COMPLETED in Round 6.

12. **Student/Teacher PDF statements** — deferred.

13. **PDF receipt with QR code** — deferred.

14. ~~Unbilled-but-active indicator~~ — COMPLETED in Round 6.

---

## Round 4 — Group Archiving, Classroom Archiving, Capacity+Waitlist, Transfer (2026-07-27)

### Schema v6
- `isArchived` on `subject_groups` + `classrooms`; `capacity` on `subject_groups`
- `isTransferred` on `enrollments`; new `enrollment_waitlist` table

### Group Archiving — Done
- Archive/restore with confirmation dialog + active-session/enrollment warning
- Archived filter chip; archived groups hidden from dropdowns

### Classroom Archiving — Done  
- Same pattern as groups

### Capacity + Waitlist — Done
- Capacity field (null = unlimited); enrollment blocked when full
- User offered: increase capacity OR add to waitlist
- Waitlist shown in group detail with "Move to active" per student
- Manual promotion only; rechecks capacity before allowing

### Enrollment Transfer — Done
- `transferEnrollment()` marks original as `transferred_out`, creates new active row
- Capacity-aware transfer: full destination → same capacity/waitlist choice
- Transfer button per enrollment row; destination group picker dialog

### Enrollment History — Done
- Student detail: active enrollments (top) + history section (past/transferred)
- Group name + status shown for each past enrollment

### Consistency — Done
- Student `_EnrollmentList` filters to `status=='active' && !isTransferred`
- Enrollment add-dialog excludes archived groups
- Transfer excludes source group + archived groups

---

## Round 5 � Payments & Debts Overhaul (2026-07-28)

### Schema Changes
- **v7:** Added `paymentMethod` (text) and `priceSnapshot` (text) columns to `transactions`
- **v8:** Added `payment_allocations` table (id, paymentTransactionId, chargeTransactionId, amount)
- **v9:** Added `closed_periods` table (id, year, month, closedAt, closedByUserId)

### Payments Screen � Complete Rebuild
- Dense table with all 10 transaction types (session_charge, student_payment, registration_fee, registration_fee_payment, teacher_payout, expense, correction, reversal, discount, session_cancellation_reversal)
- Student/teacher name resolution via SQL JOIN
- Color-coded type badges (blue=charges, green=payments, purple=teacher payouts, orange=expenses, red=corrections/reversals)
- Filter chips per type, date range picker (from/to), debounced search
- Sortable headers (date, amount, type), ShellPaginationBar
- Checkbox multi-select with selection bar
- PDF/Excel export stubs (matching app pattern)
- Transaction detail ShellDialog (all fields, rateSnapshot, priceSnapshot, reference transaction, audit info)
- Record Payment ShellDialog (student selector, amount, payment method dropdown, note, FIFO auto-allocation toggle with charge checkboxes)
- Record Expense ShellDialog (amount, category dropdown, note)
- Void/Reverse Transaction ShellDialog (mandatory reason field, creates linked reversal)
- Per-student financial history dialog (charges/paid/balance summary + full transaction list)
- Month-end Close Period dialog (year/month selector, pre-close summary showing revenue/expenses/outstanding/net)
- Balance Transfer dialog (from/to student, amount, mandatory reason, audit logged)
- Period guard: all createStudentPayment/createExpense/createTeacherPayout calls check isPeriodClosed() and throw StateError if period is closed

### Outstanding Debts Screen � Complete Rebuild
- Dense table with school level, total charged, total paid, remaining columns
- DB-level pagination (scales to 500+ students)
- DB-level sorting (name, debt, code)
- Filter chips: All / Has Debt / Settled / Credit Balance
- Filter dropdowns: School Level, Subject Group
- Debounced search field
- Click-through to student balance detail ShellDialog (charged/paid/balance cards, Record Payment button, View History button)
- Debt aging: per-row color tinting based on configurable bucket thresholds, with "Xd" aging label
- Excel export (functional, writes to documents directory)

### Debt Aging Settings
- Configurable 3-tier aging buckets in Settings screen (stored in SharedPreferences)
- Default: 30 days (green?amber), 60 days (amber), 90 days (red)
- Outstanding Debts list queries oldest unpaid charge date per student and tints rows accordingly

### Pay Now Bug � FIXED
- Added deduplication check in createTeacherPayout (prevents double-payout for same session/date)
- Added cancellation check in createTeacherPayout (throws StateError if session is cancelled)
- Replaced AlertDialog with ShellDialog showing session list with checkboxes, attendance counts, per-session amounts, and date picker
- Shows pre-payment calculated total before confirming
- Error handling: per-session try/catch with success/skip counts in result SnackBar

### Partial Payment Allocation
- FIFO auto-allocation: payment applied to oldest unpaid charges first by default
- Manual allocation toggle: shows unpaid charge checkboxes with remaining amounts, running total
- payment_allocations table tracks per-charge paid vs remaining
- getUnpaidCharges() returns charges with remaining balance for allocation UI

### Correction & Reversal Mandatory Reasons
- createCorrection: note parameter changed from String? to required String with empty-check guard
- createReversal: note parameter changed from String? to required String with empty-check guard
- VoidTransactionDialog enforces reason field before saving

### Archive Warning for Pending Balance
- Student archive confirmation dialog now checks getStudentBalance() and shows red warning with outstanding amount

### Historical Price Snapshot for Student Charges
- createSessionCharge now snapshots price:amount, monthly:rate, perMonth:sessionsCount into priceSnapshot column

### Teacher Payout Accuracy
- Pay Now session selection allows choosing which sessions to pay (not blanket all-active)
- Pre-payment summary shows attendance count per session and calculated amount before confirming

### Balance Transfer
- Transfer dialog: select from/to student, enter amount, mandatory reason
- Creates payment transaction on destination student with transfer metadata
- Full audit trail via audit_log entries

### Period Close Guard
- isPeriodClosed() check in createStudentPayment, createExpense, createTeacherPayout, createBalanceTransfer
- Prevents retroactive edits to closed periods
- Close Period dialog shows revenue/expenses/outstanding/net summary before committing

---

## PAYMENTS (REBUILT)
- [ ] **99. Payments � dense table visual**
  - Open sidebar ? Payments. Verify: dark theme, zebra stripes, 8 columns (checkbox, date, type badge, student/teacher name, amount, method, notes, actions).
- [ ] **100. Payments � type filter chips**
  - Click each filter chip (All, Payments, Charges, Registration Fee, Teacher Payouts, Expenses, Corrections, Reversals) ? only matching transactions shown. Click active chip again ? returns to All.
- [ ] **101. Payments � date range filter**
  - Click "From" date button ? pick a date ? only transactions after that date. Click X to clear. Same for "To".
- [ ] **102. Payments � search**
  - Type a student name or teacher name in the search field ? results filter live. Clear button resets.
- [ ] **103. Payments � sortable headers**
  - Click "Date" header ? sorted ascending. Click again ? descending. Same for Amount.
- [ ] **104. Payments � pagination**
  - Verify "Showing 1�X of Y" footer with prev/next buttons. Navigate pages.
- [ ] **105. Payments � checkbox multi-select**
  - Click checkbox column header ? all rows selected, selection bar appears. Clear selection.
- [ ] **106. Payments � transaction detail dialog**
  - Click any row ? ShellDialog shows: Transaction ID, date, type, amount, student/teacher name, session group if applicable, payment method, note, rate/price snapshot, reference transaction, audit timestamps.
- [ ] **107. Payments � record payment dialog**
  - Click "+" button ? ShellDialog. Search for a student ? select. Enter amount, choose payment method (Cash/Card/Bank Transfer/Mobile), add note. Save ? new payment appears in list.
- [ ] **108. Payments � manual payment allocation**
  - In record payment dialog: toggle "Manual Allocation" ? unpaid charges appear with checkboxes. Check one ? allocated total updates. Unchecked ? FIFO applies automatically.
- [ ] **109. Payments � record expense dialog**
  - Open from Payments screen. Enter amount, choose category (Rent/Salary/Materials/Utilities/Other), add note. Save ? expense appears in list.
- [ ] **110. Payments � void/reverse transaction**
  - Click counter-clockwise arrow on a non-reversal row ? ShellDialog. Enter mandatory reason ? confirm. New reversal transaction created and linked to original.
- [ ] **111. Payments � per-student history**
  - Click receipt icon ? search for a student ? ShellDialog shows: charged/paid/balance cards, full transaction history with date/type/note/amount.
- [ ] **112. Payments � correction badge**
  - Find a correction transaction. Verify it has a distinct red badge visually different from charges/payments.

## OUTSTANDING DEBTS (REBUILT)
- [ ] **113. Debts � dense table**
  - Open sidebar ? Outstanding Debts. Verify: dark theme, zebra stripes, 6 columns (name, school level, total charged, total paid, remaining, code). Balance column colored red (positive) or green (zero/negative).
- [ ] **114. Debts � filter chips**
  - Click "Debt" ? only positive-balance students. Click "Settled" ? only zero balance. Click "Credit" ? only negative balance. Click "All" ? everyone.
- [ ] **115. Debts � level/group filter**
  - Select a school level from dropdown ? list filters. Select a group ? list filters. Select "All" ? resets.
- [ ] **116. Debts � search**
  - Type a student name/code ? results filter. Clear ? resets.
- [ ] **117. Debts � sortable headers**
  - Click "Remaining" header ? sorted by balance. Click "Name" ? sorted by name. Arrow indicators show direction.
- [ ] **118. Debts � pagination**
  - Verify footer pagination works with prev/next. Large datasets should page correctly.
- [ ] **119. Debts � student detail dialog**
  - Click any row ? ShellDialog shows: student name/code, charged/paid/balance cards. "Record Payment" button opens quick-pay dialog. "View History" opens full transaction history.
- [ ] **120. Debts � debt aging visual**
  - If any student has unpaid charges older than aging bucket thresholds, verify their row has a colored tint (amber/orange/red) and shows "Xd" aging label.
- [ ] **121. Debts � Excel export**
  - Click Excel icon ? verify file written to documents directory with student data.

## TEACHER PAYOUTS (FIXED)
- [ ] **122. Pay Now � session selection**
  - Open a teacher's detail ? click "Pay Now". Verify: ShellDialog shows date picker, session list with checkboxes, attendance counts, per-session amounts, and calculated total.
- [ ] **123. Pay Now � deduplication**
  - Pay Now for a session, try to Pay Now again for same date ? should skip with "skipped" count in SnackBar.
- [ ] **124. Pay Now � cancellation check**
  - Cancel a session for today, try to Pay Now ? should skip that session gracefully.

## SETTINGS � DEBT AGING
- [ ] **125. Debt aging buckets**
  - Open sidebar ? Settings. Verify "Debt Aging Buckets" section with 3 number fields (Green/Amber/Red days). Change a value ? it persists after re-opening Settings.

## MONTH-END CLOSING
- [ ] **126. Close Period dialog**
  - From Payments toolbar, click archive/close period icon. Select year/month ? click search ? verify summary shows Revenue, Expenses, Outstanding Debt, Net.
- [ ] **127. Close Period guard**
  - Close a period. Try to record a payment for that month ? should fail with "Cannot modify transactions in a closed period" error.

## BALANCE TRANSFER
- [ ] **128. Balance Transfer dialog**
  - From Payments toolbar, click ? icon. Select From/To students, enter amount and reason ? save. Verify new payment appears in destination student's history.

## ARCHIVE WARNING
- [ ] **129. Archive warning for balance**
  - Give a student an outstanding balance. Try to archive them ? verify red warning shows balance amount.


---

## Round 6 � Critical Bug Fix, Billing Cycles, Families, Refunds, KPIs & Bulk Payments (2026-07-28)

### Phase 0 � Crash Fix (Payments Record Payment Flow)
- **Root cause:** Multiple unhandled async exceptions in `_pick()`, `_loadCharges()`, and `_StudentSearchDialog.onChanged`. The `_loadCharges()` method was called without `await` or `catchError`, and the `onSubmitted`/`onChanged` callbacks in search dialogs had no try/catch around database operations. When any DB query failed, the unhandled future exception crashed Flutter with a red error screen.
- **Fix:** Added try/catch in `_pick()` (wrapping `_loadCharges()` with await), in `_StudentSearchDialog.onChanged`, and in `_BalanceTransferDialog._pick()`. Made `_loadCharges()` resilient (sets `_charges = []` on error). Changed allocation lookups in `_save()` from `firstWhere` to `where` + `isEmpty` check to prevent StateError on stale `_selectedCharges`. Added `ctx.mounted` guards before all Navigator.pop/ScaffoldMessenger calls inside nested dialogs.

### Phase 1 � Billing Cycles (Schema v10)
- Added `cycle_number` (int, nullable) column to `transactions`
- `createSessionCharge`: auto-computes cycle number = floor(prior charges / sessionsPerMonth) + 1
- `_countSessionCharges()` counts prior charges for the same enrollment
- Cycle number displayed in unpaid charge allocation UI (checkboxes) and student history dialog
- **TODO comment left** in `createSessionCharge`: school closures vs single-session cancellations need clearer distinction for cycle counting � deferred

### Phase 2 � Family Accounts (Schema v11)
- New tables: `families` (name, discountPercent, discountFixed) and `family_members` (familyId, studentId)
- New Families management screen at `lib/screens/families/family_screen.dart`
- Create/edit via ShellDialog: family name, discount type (% or fixed DA), student multi-select
- Families entry added to sidebar (after Enrollments, before Payments)
- Family discount auto-applied in `createSessionCharge`: checks family membership, applies % or fixed discount after enrollment-level discounts
- Family info shown in StudentDetailDialog as colored banner (family name + discount)
- Full manual linking only � no auto-detection

### Phase 3 � Refunds & Credit Notes
- New `_RefundCreditDialog` in Payments screen (toolbar icon: arrow counter-clockwise)
- **Credit Note mode:** creates `discount` transaction (reduces balance, no cash leaves)
- **Cash Refund mode:** creates `correction` transaction via `TransactionService.createRefund()` (adds to balance, money leaves)
- Mandatory reason field for both modes
- Audit trail entries via `audit_log` (action: `refund_issued`)
- **Auto-credit application:** `createSessionCharge` now checks `getStudentBalance()` before charging. If balance < 0 (credit), the credit is automatically applied to reduce the new charge amount

### Phase 4 � Enhanced KPI Dashboard
- Rebuilt dashboard with free date-range filter (from/to date buttons)
- KPI cards: Total Students, Total Teachers, Today's Sessions, Today's Attendance, Revenue, Expenses, Net Balance, Outstanding Debt, Collection Rate
- Collection Rate = (Revenue - Outstanding) / Revenue � 100%
- All KPIs driven by `getPeriodSummary()` database method
- RefreshIndicator pull-to-refresh

### Phase 5 � Bulk Payment Recording
- "Bulk Pay" button in Outstanding Debts toolbar
- `_BulkPaymentDialog` ShellDialog: enter amount per student, optional reason notice, checkbox multi-select from all owing students
- Per-student success/failure tracking with summary SnackBar ("X/Y students paid (Z failed)")
- Each payment created individually (not batched in one DB transaction) � if some fail, others still succeed

### Phase 6 � Reports (PDF Statements) � deferred
- Not implemented in this round. Requires dedicated PDF generation with full transaction history per student/teacher.

### Phase 7 � Monthly Receipt with QR Code � deferred
- Not implemented. The payment_method infrastructure (schema column + UI) is complete. QR generation library not added.

### Phase 8 � Unbilled-but-Active Indicator
- Added `countUnbilledActiveStudents()` database query: counts students with active enrollments but zero session_charge transactions
- "Unbilled (N)" filter chip in Outstanding Debts showing count
- Filter logic added to `getStudentBalancesPage` query: filters to students with active enrollments and no session_charges

---

## BILLING CYCLES
- [ ] **130. Cycle number on charges**
  - Create a student, enroll them, check them into a session. Open Payments ? search for their history. Verify "Cycle 1" appears on session_charge rows.
- [ ] **131. Cycle in allocation UI**
  - Record a payment for a student with multiple session charges. Toggle "Manual Allocation" ? verify unpaid charges show "Cycle N:" prefix.
- [ ] **132. Cycles per enrollment**
  - Enroll a student in two groups. Check them into sessions for both groups. Verify each group tracks cycles independently.

## FAMILIES
- [ ] **133. Families list**
  - Open sidebar ? Families. Verify empty or existing families in card list.
- [ ] **134. Create family**
  - Click "+" ? ShellDialog. Enter name, set discount (e.g. 10%), select students from checklist. Save ? family appears in list.
- [ ] **135. Family discount on charges**
  - Create a session charge for a family member. Verify the charge amount is reduced by the family discount percentage.
- [ ] **136. Family info in student detail**
  - Open a student who belongs to a family. Verify a colored banner shows family name and discount.
- [ ] **137. Edit/delete family**
  - Click pencil icon ? edit dialog pre-filled. Change discount ? save. Click X icon ? delete confirmation ? family removed.

## REFUNDS & CREDIT NOTES
- [ ] **138. Refund/Credit dialog**
  - From Payments toolbar, click counter-clockwise arrow icon. Verify ShellDialog with student selector, mode radio (Credit Note / Cash Refund), amount, and reason fields.
- [ ] **139. Credit note**
  - Select a student, choose "Credit Note", enter amount and reason ? save. Verify student balance decreases (or credit increases).
- [ ] **140. Cash refund**
  - Select a student, choose "Cash Refund", enter amount and reason ? save. Verify student balance increases.
- [ ] **141. Auto-credit application**
  - Give a student a credit balance (>0 in paid column, negative balance). Create a new session charge ? verify the credit is automatically applied, reducing the new charge.

## KPI DASHBOARD
- [ ] **142. Dashboard KPIs**
  - Open sidebar ? Dashboard. Verify 9 KPI cards: Students, Teachers, Sessions, Attendance, Revenue, Expenses, Net, Outstanding, Collection Rate.
- [ ] **143. Date range filter**
  - Click "From" date ? pick a date ? KPIs update dynamically. Click "To" date ? KPIs update. Clear dates ? resets.

## BULK PAYMENTS
- [ ] **144. Bulk Pay button**
  - Open sidebar ? Outstanding Debts. Verify "Bulk Pay" button in toolbar.
- [ ] **145. Bulk Pay dialog**
  - Click "Bulk Pay" ? ShellDialog with amount field, reason field, and student checklist (showing only students with debt). Select a few students, enter amount, save ? verify each selected student gets a payment.

## UNBILLED FILTER
- [ ] **146. Unbilled filter chip**
  - In Outstanding Debts, click "Unbilled (N)" filter ? verify only students with active enrollments and no session_charges appear. Return to "All" ? all students return.

## CRASH FIX REGRESSION TESTS
- [ ] **147. Record Payment � student search**
  - Open Payments ? click "+" ? click "Select Student" ? type a student name ? verify results appear without crash.
- [ ] **148. Record Payment � allocation load**
  - Select a student ? verify unpaid charges load without crash (or show "No data" if none).
- [ ] **149. Record Payment � FIFO save**
  - Enter amount, leave allocation as auto (FIFO), save ? verify payment created and balance updated.
- [ ] **150. Record Payment � manual allocation**
  - Toggle manual allocation, select charges, save ? verify allocated amounts are tracked.
