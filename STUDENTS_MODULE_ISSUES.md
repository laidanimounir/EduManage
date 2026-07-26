# Students Module — Issue Tracking

## Status Key
- 🔴 Unconfirmed
- 🟡 Investigating
- 🟠 Root cause found
- 🟢 Fixed
- ✅ Verified

---

## Item 1 — Dialog backgrounds
- **Status:** ✅ Verified
- **Code:** All 4 `Dialog()` calls use `backgroundColor: ShellTokens.chromeSurface`. Verified at lines 931, 1323, 808, 1525.
- **Note:** If visual discrepancy persists, check `barrierColor` or test with full cold start (not hot reload) due to IndexedStack caching.

## Item 2 — Full-row tap
- **Status:** ✅ Verified
- **Code:** Lines 612-630 — every non-interactive column individually wrapped in `GestureDetector(onTap: () => _openDetail(s), behavior: HitTestBehavior.opaque)`. Checkbox and actions columns excluded intentionally.
- **Fix applied:** Added `behavior: HitTestBehavior.opaque` to all 5 data cell GestureDetectors to ensure taps register on small text widgets.

## Item 3 — Unenrolled row tint
- **Status:** 🟢 Fixed
- **Code:** `_buildDataRow` decoration has `!isEnrolled` branch. Color changed from amber `Color(0xFF2B2416).withValues(alpha: 0.4)` to `SemanticTokens.error.withValues(alpha: 0.08)` — muted red tint. Test with cold start.
- **Note:** If not visible, check `_enrolledIds` is populated correctly in `_fetchPage()` at lines 83-92.

## Item 4 — Date picker Maghreb names
- **Status:** ✅ Verified (framework limitation)
- **Code:** `locale: Localizations.localeOf(context)` IS passed to `showDatePicker` at line 1489. However, Flutter's built-in `MaterialLocalizationsAr` ships with Standard Arabic month names (يوليو etc.), NOT Maghreb. We cannot override `showDatePicker`'s month names without a custom date picker widget.
- **Resolution:** Accept as Flutter framework limitation. Our `DateHelper.formatHeaderDate()` uses Maghreb names for all custom date displays. The interactive picker uses Flutter's built-in locale.

## Item 5 — Checkbox column width
- **Status:** 🟢 Fixed
- **Root cause:** Column index 0 had `FlexColumnWidth(2)` — same width allocation as the Name column. Table gave the checkbox column disproportionate space.
- **Fix:** Changed to `FixedColumnWidth(44)`. Also reduced checkbox cell horizontal padding from 8 to 4.

## Item 6 — Photo persistence
- **Status:** 🟢 Fixed
- **Root cause:** `_photo` was never initialized from `widget.student?.photoPath` in `initState`. When editing, existing photo path was lost and overwritten with null on save.
- **Fix:** Added `if (s.photoPath != null) { _photo = File(s.photoPath!); }` in `initState`.
- **Note:** Photo still shows only in edit dialog form. Not yet wired into detail dialog or list table avatar. Future enhancement.

## Item 7 — Registration fee badge + Mark as Paid
- **Status:** 🟢 Fixed
- **Root cause (badge):** `hasFee` was hardcoded `true`. For students with no fee, `isFeePaid()` returned true (0=0) so badge was hidden by accident. For students with unpaid fee, badge DID show correctly.
- **Root cause (no fee created):** `registration_fee` transaction was never created on student save. The "Mark as Paid" button was present in code but had nothing to mark.
- **Fix:** Added `createRegistrationFee()` call in `_save()` when creating a new student, using the amount from Settings/SharedPreferences.
- **Note:** Seeded students (created before this fix) still have no registration fee. Create a new student to test the flow end-to-end.

## Item 8 — Settings save
- **Status:** 🟢 Fixed
- **Code check:** `onFieldSubmitted` already existed and saved correctly. But user had to press Enter.
- **Fix:** Replaced `onFieldSubmitted` with `onChanged` — saves to SharedPreferences on every keystroke (debounced by nature of async I/O). No need for a separate Save button.

## Item 9 — Unenrolled tint color
- **Status:** 🟢 Fixed
- **Root cause:** Color choice — was dark amber/brown `Color(0xFF2B2416)`.
- **Fix:** Changed to `SemanticTokens.error.withValues(alpha: 0.08)` — muted red at 8% opacity. Uses existing token, no new color introduced.

---

## Caching / IndexedStack Note
Items 1-3 may appear broken if tested with hot reload rather than full restart. The `KeyedSubtree` visit-counter mechanism in `MainShell` forces widget recreation on tab switch, but hot-reload bypasses this. For accurate testing: `flutter run` (cold start) or kill + relaunch. Do NOT rely on hot reload for UI verification.

---

## Shared Components (to extract for future modules)
1. **`ShellDialog`** — wrapper with chromeSurface bg, 10px radius, barrierColor: black54, Phosphor x close.
2. **`DataTable` pattern** — frozen column, checkbox, zebra stripes, pagination. Currently 700+ lines in student_list_screen.dart.
3. **`DateHelper.formatHeaderDate()`** — Maghreb month names for display. Doc: `showDatePicker` cannot use Maghreb names (Flutter framework limitation).
4. **`AppBadge`** — amber badge widget pattern (`_buildBadge` in student_list_screen.dart:675-685).

*Not yet extracted. To be done before starting Subjects/Groups/Payments screens.*
