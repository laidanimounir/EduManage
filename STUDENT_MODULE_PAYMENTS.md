# Student Module & Payments — Changelog and Status

**Last updated:** 2026-08-05  
**Scope:** All UI/UX and data-model work on the Student list, Student Add/Edit dialog, Student Detail dialog, and the unified per-student payment system (registration fee + session charges), across all commits from the 2026-08-04/05 work session.

---

## 1. Overview

This document is the single source of truth for everything built, fixed, or intentionally deferred in the Student module during this round. It covers the redesigned Add/Edit and Detail dialogs, the new unified Pay dialog with registration-fee and session-charge support, the undo/reversal system, multi-select exports, and the registration fee architecture (frozen-amount mechanism with per-student overrides). It also records every significant root-cause bug that was found and fixed during this session, along with what was explicitly deferred.

---

## 2. What was implemented — by feature area

### 2.1 Add/Edit Student dialog

- **Dense no-scroll layout.** The full form fits on screen without scrolling. Arabic first/last name fields are placed side-by-side with a French-name toggle button (`AR`/`FR`) that reveals/hides French name fields beneath them.
- **Phone field with carrier detection.** When the admin types a phone number, the app detects the Algerian carrier (Mobilis, Djezzy, Ooredoo) using prefix matching and displays the real carrier logo to the left of the input. The field is restricted to digits only.
- **School level autocomplete.** The school level field shows a filtered dropdown based on existing levels in the database, with a real-time suggestions list.
- **Gender selector.** Uses icon-based segmented buttons (`MaleIcon` / `FemaleIcon`) instead of a dropdown.
- **Birth date input.** Three segmented fields for day/month/year with auto-advance (moving to the next field after input). Month names use Algerian French-transliterated forms (e.g., "جانفي" for January).
- **Professional icons.** Every input field has a leading Phosphor icon.
- **Success animation.** A scale-up check-circle animation with the success message appears on both **create** and **edit** (`تم إضافة التلميذ بنجاح` / `تم تعديل التلميذ بنجاح`), followed by an 800ms delay before the dialog closes and the table refreshes.
- **Save error handling.** The catch block in `_save()` now shows a visible SnackBar with the actual exception text if the database write fails, instead of silently swallowing the error.

### 2.2 Multi-select, export, and card generation

- **Selection styling.** Selected rows show a thin left-edge accent border instead of a heavy full-row green highlight. This keeps the table readable when many rows are selected.
- **PDF export.** When students are selected, the export button exports only the selected ones. Shows a confirmation notice ("تصدير N طالب مختار"). The PDF export offers a **print-or-save dialog** before writing the file — exactly matching the receipt/statement pattern.
- **Excel export.** Same selection-aware behavior. Shows a confirmation dialog **before** writing the file with the save path pre-displayed, and gives the user a Cancel/Save choice instead of auto-saving to Documents without consent.
- **Generate Cards.** When students are selected, generates printable PDF student cards with photo, name, code, school level, and a scannable barcode.

### 2.3 Search/barcode bar

- **Unified card strip design.** Search field and barcode field share a single rounded-card container. Both fields are compact with reduced height.
- **Barcode toggle.** A pill-shaped barcode field with a green dot (✓) indicator when barcode mode is active, grey dot (○) when inactive. Clicking the toggle button toggles barcode mode on/off and focuses/clears the appropriate field.

### 2.4 Unenrolled student row styling

- Unenrolled students show an increased red tint opacity on their status chip for better visibility.
- Table row separators are strengthened with consistent border lines between rows.

### 2.5 Registration fee system

#### Frozen-amount mechanism

The registration fee for a given student is captured **once** — at the moment the `registration_fee` transaction is created for that student (during student creation in the Add dialog). The amount is read from the current global Settings value (`registration_fee_amount` in SharedPreferences) and written as a hard `amount` on the `registration_fee` transaction row in the database.

**It does NOT change afterward.** If the admin edits the global Settings registration fee from 2300 to 2000, existing students' owed amounts remain at whatever was frozen when their `registration_fee` charge was created. Changing the global value only affects **new** students created after the change.

#### Per-student override

The Student Edit dialog has an optional field: "حقوق التسجيل (اختياري)". If the admin enters a value here, it is stored in the `registrationFeeOverride` column on the `students` table. This override is **informational only** — it does not retroactively change the frozen amount. It is available for future use (e.g., if a replacement `registration_fee` charge is ever created for this student).

#### Settings save button

The global registration fee in Settings **requires an explicit Save button press**. A previous implementation auto-saved on every keystroke via `onChanged`, which was replaced with a proper controller + `Form` validation + "حفظ" `FilledButton`. A SnackBar ("تم حفظ القيمة") confirms a successful save.

#### How remaining/paid status is calculated

Three new database methods were added to `AppDatabase`:

- **`getRegistrationFeeChargeAmount(studentId)`** — returns the frozen `SUM(amount)` of all `registration_fee` type transactions for this student (the amount they owe).
- **`getRegistrationFeeRemaining(studentId)`** — returns the frozen amount minus:
  - `SUM(registration_fee_payment)` amounts (direct payments toward the fee), minus
  - `SUM(reversal)` amounts against those payments (from undo), plus
  - `SUM(payment_allocation)` amounts where a `student_payment` was FIFO-allocated toward a `registration_fee` charge
- **`isRegistrationFeePaid(studentId)`** — returns `true` if `getRegistrationFeeRemaining <= 0`.

The previous implementation used `COUNT(*) >= COUNT(*)` (count-based, not amount-based) and only counted `registration_fee_payment` rows, completely ignoring partial payments, FIFO allocations, and reversals. The new implementation correctly handles partial payments, multi-payment scenarios, and undo/reversal accounting.

### 2.6 Unified Pay dialog

#### Layout

The Pay dialog is opened from the row-level "دفع" button on the student table. It shows:

1. **Registration fee section** — the frozen fee amount ("حقوق التسجيل: 2300 دج") with a status chip ("مدفوع" in green or "غير مدفوع" in red). When partially paid, a "باقي: X دج" line appears below the fee amount in orange. A quick "دفع" `FilledButton` pays the FULL remaining amount in one click.
2. **Session charges section** — lists each unpaid session charge with its type, date, and remaining amount, plus a total.
3. **Payment target selector** — a `SegmentedButton` with two options ("رسوم الحصص" / "حقوق التسجيل"). Only appears when BOTH session charges and registration fee are unpaid. Auto-selects the appropriate target when only one is applicable.
4. **Payment form** — amount input, "دفع الكل" quick-fill button, payment method dropdown (cash/card/bank transfer/mobile payment), optional note field, and a "دفع" submit button.
5. **Recent payments** — payments made within the last 48 hours, each with an "تراجع" (undo) button if still within the undo window and not already reversed.

#### Payment routing

- When target is **"حقوق التسجيل"**: the custom amount is routed through `createRegistrationFeePayment()`, which creates a `registration_fee_payment` transaction. Supports any amount (partial payment).
- When target is **"رسوم الحصص"**: the amount is routed through `createStudentPayment()` with `chargeTypes: ['session_charge', 'correction']` — this ensures the FIFO allocation only distributes the payment toward session charges, never toward the registration fee (avoiding the conflation bug that existed before).
- The **"دفع الكل"** button fills the amount field with `_feeRemaining` (when targeting registration fee) or `_totalUnpaid` (when targeting session charges). The `_totalUnpaid` value is now computed from session-only charges, avoiding the previous double-counting bug where the registration fee was added to both `_totalUnpaid` and the fee amount separately.

### 2.7 Undo/reversal system

- Payments made within the last **48 hours** show an "تراجع" button.
- Clicking "تراجع" shows a confirmation dialog, then calls `createReversal()`.
- `createReversal` creates a new `reversal`-type transaction linked to the original payment via `referenceTransactionId`, and creates an audit log entry.
- After a successful undo, the Pay dialog reloads. The reversed payment is **removed from the recent payments list** (a cross-reference check now queries the `transactions` table for existing `reversal` rows with matching `referenceTransactionId`).

#### Duplicate-reversal bug (found and fixed)

A second undo on the same already-reversed payment was silently accepted, creating unlimited reversals. This was caused by:
1. No deduplication check anywhere in `createReversal` — it would create a new reversal for the same `referenceTransactionId` every time.
2. The Pay dialog's `_load()` method only checked `referenceTransactionId == null` on the payment row itself but never cross-referenced the `transactions` table for existing reversal rows — so the original payment always re-appeared in the recent list after reload.

**Fix:** A dedup check was added at the start of `createReversal` (queries for an existing `reversal` with the same `referenceTransactionId`, throws `StateError('Transaction already reversed')` if found). And `_load()` now loads reversal rows alongside payments and filters out payments whose IDs appear in the `reversedIds` set.

### 2.8 Audit logging

- `createReversal` and related payment operations already create entries in the `audit_logs` table via `AuditLogRepository`.
- `createStudentPayment`, `createRegistrationFeePayment`, and other transaction service methods include audit log creation with user ID, action type, entity type/ID, and details.

### 2.9 Student Detail dialog layout

- **Photo placement.** Larger photo on the left side.
- **Two-column info grid.** Personal information arranged in a two-column layout within a card section.
- **Split financial sections.** Session charges and registration fee each get their own card section (`_SessionChargesBlock` and `_RegistrationFeeBlock` widgets).
- **Receipt button.** Redesigned as an `OutlinedButton.icon` with accent-green border, receipt icon, and Arabic label "وصل" — clickable and clearly visible.
- **Statement button.** Generates a printable PDF account statement.

---

## 3. Known root-cause bugs found and fixed

### 3.1 Stale build making real fixes appear broken

**Symptom:** After committing `b78e6c6` (registration fee frozen-amount fix + payment target selector), the running app showed none of the changes — fee amount still changed dynamically, no SegmentedButton appeared, generic payments still recorded as session charges.

**Root cause:** The app running on the device was built from an earlier commit. A simple `flutter run` reuses the previous build unless explicitly told to rebuild from scratch.

**Fix:** Running `flutter clean; flutter pub get; flutter run` forces a full rebuild. Debug markers (red banner in Pay dialog, red "FROZEN" label in Detail dialog) were temporarily added to visually confirm which build is running.

**Lesson:** Before debugging further when a fix "doesn't work," always verify the running build matches the source code on disk. Use a visual marker or version string as a definitive check.

### 3.2 SQL parameter-binding bug that silently emptied the entire student list

**Symptom:** After a clean rebuild, the student table showed zero rows (`1–0 of 0`). Adding a new student showed no error but the student did not appear in the table. The database file at `C:\Users\Mounir\Documents\edumanage.db` was intact at 262KB — data was NOT actually lost.

**Root cause:** The `getRegistrationFeeRemaining()` SQL query in `app_database.dart` used `?2` positional parameter references in 5 places but passed only **one** variable (`Variable.withString(studentId)`). SQLite threw a parameter-index-out-of-range error on every call. This function was called by `isRegistrationFeePaid()`, which was called by `_fetchPage()` for EVERY student in the list. The `catch (_)` block in `_fetchPage()` silently swallowed the exception — the loading spinner disappeared, but `_rows` remained empty and `_total` remained 0, producing a completely empty table with zero error feedback.

**Fix:** Changed all `?2` references to plain `?` (anonymous positional parameter) and provided 5 identical variables (one per `?`). Also changed `catch (_)` to `catch (e)` with `debugPrint('[FETCHPAGE] ERROR: $e')`.

**Pattern to watch:** **Silently-swallowed `catch (_)` blocks were a recurring root cause across multiple bugs in this session.** The undo handler, the Save button, the Pay dialog's `_pay()` method, the `_payRegistrationFee()` method, and `_fetchPage()` all had `catch (_)` or `catch (e)` without any user-visible error feedback. Exceptions were thrown by the database layer but the user saw "nothing happened" with zero indication of what went wrong. This pattern has been fixed in the Student module files touched during this session, but likely exists elsewhere in the codebase (see §5.1).

### 3.3 Undo/reversal duplicate-ID bug

**Symptom:** After a successful undo, the undo button re-appeared for the same payment. Clicking it again produced no visible change, but console logs showed the SAME reversal ID returned twice.

**Root cause:** Three interacting issues:
1. `createReversal` had no dedup check — it would create a new reversal for the same `referenceTransactionId` on every call without checking if one already existed.
2. The Pay dialog's `_load()` method only filtered `referenceTransactionId == null` on the payment row itself (which is always null for original payments), but never checked whether a reversal row already existed for that payment in the `transactions` table.
3. The `_undoPayment` catch block silently swallowed exceptions — if `createReversal` had thrown an error (e.g., from a dedup check), the user would see no feedback.

**Fix:** Added a dedup query at the top of `createReversal` that checks for an existing `reversal` row with the same `referenceTransactionId` and throws `StateError('Transaction already reversed')` if found. Updated `_load()` to load reversal rows alongside payment rows and build a `reversedIds` set used to filter `_recentPayments`. Updated the catch block to show a visible error SnackBar.

### 3.4 Registration fee dynamic-recalculation bug

**Symptom:** Changing the global Settings registration fee from 2300 to 2000 immediately changed the displayed fee amount for ALL existing students in both the Detail dialog and the Pay dialog.

**Root cause:** Both `_RegistrationFeeBlock._load()` and `_StudentPayDialog._load()` were reading the fee amount live from `SharedPreferences.getInstance().getDouble('registration_fee_amount')` on every load — computing the display value as `student.registrationFeeOverride ?? globalFee`. The actual frozen `registration_fee` charge amount stored in the `transactions` table was completely ignored for display purposes.

**Fix:** Both `_load()` methods now call `db.getRegistrationFeeChargeAmount()` and `db.getRegistrationFeeRemaining()` — which read the actual frozen transaction amounts from the database. The `isRegistrationFeePaid` function was rewritten from a count-based comparison to a proper SUM-based calculation that accounts for partial payments, FIFO allocations, and reversals.

### 3.5 Session-charge/registration-fee conflation bug

**Symptom:** Payments made through the generic amount field at the bottom of the Pay dialog were always recorded as `student_payment` type transactions (labeled "رسوم حصص" in the UI), even when the student had zero session charges. The registration fee section remained "غير مدفوع" regardless of how much was paid through the generic field. This created orphan floating credits (negative balance) with no effect on the registration fee status.

**Root cause:** The generic payment form's "دفع" button called `createStudentPayment()` which:
1. Created a `student_payment` type transaction
2. Used `_fifoAllocate()` with `chargeTypes: ['session_charge', 'registration_fee', 'correction']` — meaning the payment COULD be allocated toward the registration fee charge at the data level
3. But `isRegistrationFeePaid` (at the time) only counted `registration_fee_payment` type rows, completely ignoring `student_payment` allocations

So even though the FIFO allocation correctly distributed the money at the data level, the UI status check never recognized it.

**Fix:** Added a `SegmentedButton` payment target selector ("رسوم الحصص" / "حقوق التسجيل"). When "حقوق التسجيل" is selected, `_pay()` routes through `createRegistrationFeePayment()` instead. When "رسوم الحصص" is selected, `createStudentPayment()` is called with `chargeTypes: ['session_charge', 'correction']` (registration_fee explicitly excluded from FIFO). Rewrote `isRegistrationFeePaid`/`getRegistrationFeeRemaining` to correctly account for all payment paths (direct fee payments + student payment allocations + reversals).

---

## 4. Explicitly deferred — NOT done in this session

### 4.1 Subjects / Groups / Sessions restructuring

**Status: NOT STARTED.** This was the original "Point 12" from the session task list and was intentionally deferred entirely. The current data model still routes Sessions through a "Group" concept (`subject_groups` table) that sits between Subjects and Sessions. The previous round (commits `c58aead` through `b180457`) added a `subjects` table and a `subject_id` foreign key on `subject_groups`, plus a dedicated Subjects management screen — but the conceptual restructuring (what is a Subject vs a Group vs a Session, and how they relate for billing/tuition) has not been designed or implemented.

This is the next major task.

### 4.2 Unified Pay dialog interaction with future session/tuition charges

**Status: NOT REVIEWED.** The current Pay dialog's session-charge payment path calls `createStudentPayment()` which uses FIFO allocation to distribute payments across `session_charge` transaction rows in the `transactions` table. These `session_charge` rows are created during the enrollment/attendance flow and are tied to `enrollments` and `sessions`.

If the Subjects/Groups/Sessions data model is restructured, the shape of session charge transactions may change — for example, if "tuition fees" become per-subject rather than per-session, or if the enrollment flow is redesigned. The Pay dialog's allocation logic (`_fifoAllocate`, `chargeTypes` parameter) will need to be revisited once that restructuring is designed.

### 4.3 Unverified items

- The `_payRegistrationFee` method in the Pay dialog still uses `_load().then((_) { ... })` without `await` — this was flagged but not fully fixed. The race condition is minor (affects only the timing of the success-animation hide after fee payment) but should be addressed.
- The Excel export's "Save" confirmation dialog was restructured but has not been user-tested to confirm it works correctly on all platforms (the path construction uses `getApplicationDocumentsDirectory()` which returns platform-specific paths).
- The debug markers (`BUILD b78e6c6` red banner, `FROZEN` label) added in `0357d05` are still present in the code as temporary diagnostic tools — they should be removed once final confirmation of all fixes is complete.

---

## 5. Outstanding risks / things to watch

### 5.1 Silently-swallowed exceptions pattern

`catch (_)` or `catch (e)` blocks that silently discard the error without any user-visible feedback (SnackBar, dialog, or console log) were found and fixed in the following locations during this session:

| File | Method | Fix |
|------|--------|-----|
| `student_list_screen.dart` | `_undoPayment` | Added `debugPrint` + `SnackBar` error display |
| `student_list_screen.dart` | `_payRegistrationFee` | Added `debugPrint` + `SnackBar` error display |
| `student_list_screen.dart` | `_save()` (Edit dialog) | Added `SnackBar` error display |
| `student_list_screen.dart` | `_fetchPage()` | Changed `catch (_)` to `catch (e)` with `debugPrint` |
| `transaction_service.dart` | `createReversal` | Added dedup check that throws `StateError` instead of silent acceptance |
| `app_database.dart` | `getRegistrationFeeRemaining` | Fixed SQL parameter binding (was throwing silently via catch block) |

**This pattern almost certainly exists elsewhere in the codebase** — other screens, repositories, and services. A recommended next step is an audit pass to grep for `catch (_)` or `catch (e)` blocks without `debugPrint`/`SnackBar`/`throw` to identify all remaining silent-failure points. This was the single most common root cause that prolonged debugging during this session.

### 5.2 Registration fee edge case: no `registration_fee` charge for existing old students

Students created before the registration fee feature was added may not have a `registration_fee` transaction row. In this case, `getRegistrationFeeChargeAmount()` returns `null`, and the Pay/Detail dialogs display `_feeAmount = 0` and `_feePaid = true`. This means these students will show "حقوق التسجيل: 0 دج" with "مدفوع" status. If this is not the desired behavior, a migration or manual fix script would be needed to create `registration_fee` charges for legacy students.

### 5.3 Debug markers still in production code

The red "BUILD b78e6c6" banner in the Pay dialog and the red "FROZEN" label in the Detail dialog's registration fee block (commit `0357d05`) are temporary diagnostic tools. They should be removed in a cleanup pass once all fixes are confirmed working end-to-end.
