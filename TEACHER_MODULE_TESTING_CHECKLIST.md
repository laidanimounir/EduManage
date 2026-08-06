# Teacher Module Testing Checklist

Cold-start checklist for the Teacher module after Round 17 improvements.
Delete the database (`edumanage.db`) or start fresh, then `flutter run`.
If testing on an existing DB, run the app once to apply schema migration v19, then close and reopen to continue.

---

## TEACHER FINANCIAL ACCURACY

- [ ] **301. Unified payout balance formula — all three functions agree**
  - Create a teacher, check them in (via the teacher check-in screen or live attendance board) so a `teacher_payout` transaction is created. Note the teacher's "رصيد" (Balance) in their detail dialog — should equal the payout amount. Now undo that payout via the payment dialog's "تراجع" button on the recent payments section (48h window). Reopen the detail dialog. Verify the Balance is 0 (not a negative number): Total Earned = 0, Total Paid = 0, Balance = 0. The "إجمالي المستحقات" and "المجموع المدفوع" values in the detail dialog should be equal after every payout reversal.

- [ ] **302. Sort works per column header**
  - In the teacher list table, tap each column header: "الاسم" (Name), "الرمز" (Code), "الراتب" (Salary), "المواد" (Subjects), "الدفع" (Payout Status). Verify each tap sorts by that column, not by first name. Tap the same header twice to toggle ascending/descending.

- [ ] **303. Error shown on edit-save failure**
  - Open the teacher edit dialog. Force a save failure (e.g., clear the required Arabic first-name field and try to save). Verify a red error SnackBar appears with the actual exception text (e.g. "خطأ في الحفظ: …"), not just a silent spinner stopping.

- [ ] **304. Failed session name in full-payment error message**
  - In the teacher payment dialog ("الدفع — [teacher name]"), ensure at least one unpaid session-date exists. In full-payment mode ("دفع كامل المبلغ"), note: if any session fails during payment (e.g., the session gets cancelled between the dialog opening and paying), the error SnackBar now names the failed session's group name and date instead of just showing a generic skipped count.

- [ ] **305. Duplicate payout blocked for same teacher/session/date**
  - Pay a teacher for a specific session-date. Open the payment dialog again for the same teacher. Verify that the already-paid session-date no longer appears in the unpaid list (remaining amount is 0). If you try to force a duplicate payout through another code path, the service layer now throws a StateError ("Payout already recorded for this session on this date").

- [ ] **306. Rate-snapshot freeze for partially-paid sessions**
  - Create a teacher with percentage-based salary (e.g. 50%). Assign them to a session with monthly price 2000 DA and 8 sessions/month. Check in the teacher for 5 students → open the payment dialog: the full owed amount per session-date should be (2000/8) × 0.50 × 5 = 625 DA. Pay half of it (partial payment of 312 DA). Now change the teacher's percentage to 70% (edit dialog → save). Open the payment dialog again: verify the already-partially-paid session-date still shows the remaining owed amount based on the **original** 50% rate (313 DA remaining), NOT recalculated at 70%. Now create a new never-paid attendance record (check in again) — this fresh entry should reflect the new 70% rate. This confirms `frozen_rate` from the stored `rate_snapshot` is being used for partially-paid entries.

---

## TEACHER PAYMENT DIALOG

- [ ] **307. Payment method dropdown visible and all options selectable**
  - Open the teacher payment dialog. Below the grand total, verify a "طريقة الدفع" dropdown with four options: "نقدي" (cash), "شيك" (card), "تحويل" (bank_transfer), and "دفع جوال" (mobile_payment). Select each one; verify the selection persists.

- [ ] **308. Note field wired through and visible**
  - Below the payment method dropdown, the "دفع جزئي" toggle appears. Above the pay button, a "ملاحظة" text field is shown. Type a note (e.g. "دفعة شهر جويلية"). Pay. Verify the note is stored on the transaction (visible in the payout note/audit trail).

- [ ] **309. Recent payments section shows last 48h payouts**
  - After making a payment, reopen the same teacher's payment dialog. Below the "دفع كامل المبلغ" / "تأكيد الدفع الجزئي" button, a new section titled "المدفوعات الأخيرة" lists recent payouts with their amount and date-time, each with a red "تراجع" (Undo) button.

- [ ] **310. Undo a payout — confirmation dialog appears**
  - Tap "تراجع" on a recent payout. A confirmation dialog titled "تأكيد التراجع" appears with the payout amount and confirm/cancel buttons ("تأكيد" / "إلغاء"). Confirm → the payout is reversed, the recent payments list updates, and the unpaid balances recalculate.

- [ ] **311. Dedup — undoing the same payout twice fails gracefully**
  - After undoing a payout once, the "تراجع" button should no longer appear for that payout (it disappears from the list after reversal). Attempting to undo a payout that already has a reversal shows an error ("Transaction already reversed") — this is the existing `createReversal` dedup guard.

- [ ] **312. Payment method and note survive on reopened payout details**
  - Pay a teacher with method "تحويل" and note "اختبار". Open the teacher detail dialog → Payout History section. Verify the payout transaction is listed. (Note: method and note are stored on the transaction row; verify they appear correctly in any payout-export or audit-log view available in the app.)

---

## TEACHER PHONES

- [ ] **313. Existing teacher phone migrated to multi-phone field**
  - On an existing database, check the console output during migration: you should see a line like `[DB] TeacherPhones migration: found N teachers with non-empty phone column` followed by `[DB] TeacherPhones migration: inserted N rows into teacher_phones`. Open a teacher that had a phone number before the migration → edit dialog → verify the phone number appears pre-filled in the first phone field.

- [ ] **314. Add multiple phone numbers**
  - In the teacher edit dialog, below the phone field, tap the "إضافة رقم آخر" button. A second phone row appears with its own number field, description field (hint: "وصف"), and an X button to remove it. Add 3 numbers. Tap the X on one → verify it is removed.

- [ ] **315. Carrier logo detection**
  - Type a phone starting with `07` → a Djezzy logo should appear. Starting with `06` → Mobilis logo. Starting with `05` → Ooredoo logo. Numbers limited to 10 digits when a carrier is detected. Type a landline number (starts with e.g. `02`) → no carrier logo but the field still accepts digits.

- [ ] **316. Label field works**
  - In one phone row, type a label in the description field (e.g. "الأب"). Save the teacher, reopen the edit dialog. Verify the phone number and its label are both preserved.

- [ ] **317. Multiple numbers persist after save**
  - Add 3 phone numbers to a teacher, save, close the edit dialog, reopen it. Verify all 3 numbers with their labels are still present.

---

## TEACHER ADD/EDIT DIALOG

- [ ] **318. Dialog scrolls when content exceeds screen height**
  - Open the teacher edit dialog (full form with photo, phone section, salary, subject assignments, dates, overdue threshold). On a standard laptop screen (1366×768 or lower), verify the dialog either fits without overflow or scrolls smoothly (Flexible + SingleChildScrollView layout). The dialog should never be cut off with unreachable fields.

- [ ] **319. AR/FR name toggle — hidden by default**
  - Open the create-teacher dialog. Verify French name fields are **not** shown. Below the Arabic first name, a "إظهار الأسماء بالفرنسية" toggle row is visible (grey translate icon). Tap it → the label changes to "إخفاء الأسماء بالفرنسية" (blue accent) and two French name fields appear: "First Name FR" and "Last Name FR". Tap again → fields hide.

- [ ] **320. AR/FR name toggle — auto-reveals for existing teacher with French names**
  - Edit a teacher that already has French first or last name filled. When the edit dialog opens, the French name fields should be **visible** and the toggle should read "إخفاء الأسماء بالفرنسية".

- [ ] **321. Gender SegmentedButton (not dropdown)**
  - In the teacher edit dialog, the gender field is now a SegmentedButton (two-pill toggle with male/female icons), not a dropdown. Tap "ذكر" (male) or "أنثى" (female) — the selected segment highlights in blue accent.

- [ ] **322. Employment start date — segmented DD/MM/YYYY entry**
  - The employment start date is now three small text fields (DD / MM / YYYY) with a calendar icon next to them. Type a two-digit day → focus auto-advances to month. Type a two-digit month → focus auto-advances to year. Type a four-digit year. Verify the parsed date is valid. Alternatively, tap the calendar icon → date picker opens, pick a date → verify the three fields update.

- [ ] **323. Employment end date — hidden by default**
  - Below the start date, the end date field is **not** visible. A grey "إضافة تاريخ نهاية العمل" toggle is shown. Tap it → the end date field appears (a date-picker field, same style as the original date field). The toggle disappears once the field is revealed.

- [ ] **324. Success animation on create and edit**
  - Create a new teacher and save → verify a green checkCircle icon scales up with a 400ms animation, accompanied by the text "تم إضافة المعلم بنجاح". The dialog stays open for ~800ms then closes automatically. Edit an existing teacher and save → same animation but with text "تم تعديل المعلم بنجاح".

---

## TEACHER LIST SCREEN

- [ ] **325. Search debounce**
  - In the teacher list, type a fast sequence of characters in the search field. Verify the table does **not** refresh on every single keystroke. After you stop typing for ~300ms, a single query fires and the list updates.

- [ ] **326. Barcode field — focus and filter**
  - In the teacher list toolbar, a pill-shaped barcode field with "Barcode" hint is visible next to the search field. When the screen opens, it auto-focuses. Type a teacher code → press Enter → the list filters to that teacher (or shows empty if not found). The barcode field clears after submission.

- [ ] **327. Barcode field — pause/resume**
  - Tap the small circle toggle next to the barcode field → the field dims (paused state). Tap again → field re-activates and regains focus. Opening any dialog (detail, edit, payment, teaching info) automatically pauses the barcode field; closing the dialog resumes it.

- [ ] **328. PDF export — print-or-save choice**
  - In the teacher list toolbar, tap the PDF export icon. Verify a dialog appears titled "تصدير PDF" with the text "اختر طريقة التصدير" and two buttons: "حفظ" (Save — saves to app documents directory and shows a SnackBar with the file path) and "طباعة" (Print — opens the system print dialog). This replaces the old behavior of printing directly without a choice.

- [ ] **329. Excel export — confirm-before-save dialog**
  - In the teacher list toolbar, tap the Excel export icon. Verify a confirmation dialog appears titled "تصدير Excel" showing the destination file path and "حفظ" / "إلغاء" buttons. Tapping "إلغاء" cancels the export. Tapping "حفظ" writes the file and shows a SnackBar with the saved path.

---

## TEACHER DETAIL DIALOG

- [ ] **330. Direct payment button in detail dialog**
  - Open a teacher's detail dialog. In the actions row at the bottom (before the archive button), verify a new **"الدفعات"** button appears (OutlinedButton.icon with currencyCircleDollar icon, blue accent border). Tap it → the detail dialog closes and the payment dialog ("الدفع — [teacher name]") opens.

- [ ] **331. Table-row payment icon still works**
  - From the teacher list table, tap the currency payout icon (green) on a row. Verify the payment dialog opens directly, same as before. Both entry points (table row icon + detail dialog button) remain functional side by side.

---

## REGRESSION CHECKS

- [ ] **332. Teacher archiving still works with proper warnings**
  - Archive a teacher from the list (archive icon). Verify the confirmation dialog warns if the teacher has unpaid attendance ("حصة غير مدفوعة المستحقات لهذا الأستاذ"). Confirm → teacher is archived. Restore → verify the teacher reappears in the active list.

- [ ] **333. Subject group assignment persists**
  - Edit a teacher, assign several subject groups via the FilterChip multi-select. Save, reopen. Verify all assigned groups are still checked.

- [ ] **334. "Teaching now" live indicator**
  - During a session's active time window (day + time), verify a green "الآن" chip and green-tinted row background appear for the teacher in the list's "الدفع" (Payout Status) column.

- [ ] **335. Overdue badge**
  - Set a teacher's "حد التأخير" to 1 day. Make sure no payout has been made for 1+ days. Verify an orange "متأخر" chip appears in the Payout Status column.

- [ ] **336. Salary change history**
  - Edit a teacher's salary rate (e.g. change from "نسبة مئوية" 50% to "مبلغ ثابت" 1000). Save. Open the detail dialog → scroll to "سجل تغيير الراتب" section. Verify the change is logged with date, old value, and new value.

- [ ] **337. Payout History and Financial Summary still render**
  - Open a teacher's detail dialog. Verify "الحالة المالية" shows earned/paid/balance/attendance count. Verify "سجل المدفوعات" lists recent payouts with a "الدفع" button. Both sections render correctly alongside the new "الدفعات" action button.
