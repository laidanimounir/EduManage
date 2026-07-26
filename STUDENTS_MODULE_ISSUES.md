# Students Module — Issue Tracking

## Status Key
- 🔴 Unconfirmed — Reported, not yet verified against code
- 🟡 Investigating — Code looks correct but behavior doesn't match; potential caching/staleness
- 🟠 Root cause found — Specific code defect identified
- 🟢 Fixed — Code changed, tested, `flutter analyze` passes
- ✅ Verified — Confirmed working via code + logic trace

---

## Regressed Items (previously reported fixed, still broken)

### 1. Dialog backgrounds don't match sidebar/chrome tokens
- **Status:** 🟡 Investigating
- **Code check:** All 4 `Dialog()` calls in student_list_screen.dart use `backgroundColor: ShellTokens.chromeSurface`. All 3 in student_list_screen.dart (detail, edit, archive) plus the group_assignment_dialog.dart all use the correct token. No plain black found.
- **Possible root cause:** Flutter's `Dialog` widget imposes a default cupertino-style or Material barrierColor that may be visually confusing. Or the `Dialog.fullscreen` variant could be being used elsewhere. This may also be an IndexedStack caching issue — the old dialog widgets may be cached from before the token was applied.
- **Action:** Apply `barrierColor: Colors.black54` explicitly on all dialogs. Also ensure `ShapeBorder` isn't contributing. If still unresolved, consider replacing `Dialog` with `showGeneralDialog` to bypass default theming entirely.

### 2. Detail dialog only opens on Name column tap, not full row
- **Status:** 🟡 Investigating
- **Code check:** Lines 612-630 — ALL non-interactive columns (surname, address, level, status, date) are each individually wrapped in `GestureDetector(onTap: () => _openDetail(s))`. The code is correct.
- **Possible root cause:** IndexedStack caching — the old version of the widget with tap only on Name cell may be cached. The `KeyedSubtree` with `_visitCounters` in the shell should force rebuild on tab switch, but if the list screen is the ACTIVE tab when the code was hot-reloaded, the old widget tree may persist.
- **Action:** Verify via cold restart (not hot reload). If still broken, the `_buildTextCell` GestureDetector may need `behavior: HitTestBehavior.opaque` to capture taps on small text widgets.

### 3. Row background tint for unenrolled doesn't appear
- **Status:** 🟡 Investigating
- **Code check:** Line 600 — conditional `!isEnrolled ? const Color(0xFF2B2416).withValues(alpha: 0.4)` exists.
- **Possible root cause:** Same IndexedStack caching as #2. Also possible that `_enrolledIds` is empty (enrollment query fails silently). The `_fetchPage` calls `_enrollRepo.getAll()` at line 83 which should return all enrollments.
- **Action:** Verify via cold restart. Add debug logging for `_enrolledIds.size`. Check if `isEnrolled` is correctly computed per-row.

### 4. Date pickers show non-Maghreb month names
- **Status:** 🟡 Investigating
- **Code check:** Line 1489 — `locale: Localizations.localeOf(context)` is passed to `showDatePicker`. The edit dialog's `_dateField` method includes the locale parameter.
- **Possible root cause:** The `showDatePicker` Material widget uses `Localizations.localeOf(context)` but the Arabic locale in Material (`material_localizations_ar.dart`) ships with Standard Arabic month names, NOT Maghreb. Flutter's built-in `MaterialLocalizationsAr` uses "يوليو" not "جويلية". Our `DateHelper` utility only affects our custom date DISPLAY, not Flutter's built-in `showDatePicker` widget.
- **Real fix:** The `showDatePicker` widget does NOT use our `DateHelper.formatHeaderDate`. We cannot change the picker's month names without patching `MaterialLocalizationsAr` or using a custom date picker package. This is a Flutter framework limitation — the date picker widget uses its own localizations.
- **Resolution:** This cannot be fixed by us without replacing Flutter's `showDatePicker` entirely. Accept this as a framework limitation. Document: all date DISPLAYS use Maghreb names via `DateHelper`; the interactive date PICKER uses Flutter's built-in Standard Arabic names which we cannot override without a custom date picker implementation.

### 5. Selection checkbox column still too wide
- **Status:** 🟠 Root cause found
- **Code check:** Line 649 — `padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10)` — same as all other cells. The previous "fix" changed the checkbox from 16px to 14px but didn't reduce the PADDING. The column width comes from the `Table`'s `columnWidths` constraint at index 0 which is `FlexColumnWidth(2)` — the SAME as the name column. The checkbox column gets as much space as the name column!
- **Fix:** Change column index 0 from `FlexColumnWidth(2)` to `FixedColumnWidth(48)`.
- **Also:** Reduce checkbox cell horizontal padding from 8 to 4.

---

## New / Previously Incomplete

### 6. Student photo does not persist
- **Status:** 🟠 Root cause found
- **Root cause:** `_StudentEditDialogState.initState()` (lines 1252-1267) never initializes `_photo` from `widget.student?.photoPath`. When editing an existing student, `_photo` is always `null`. The `_save()` method correctly saves the photoPath when a new photo is picked, but on edit, the null `_photo` overwrites the existing path with `null`.
- **Fix:** In `initState`, add: `if (s?.photoPath != null) { _photo = File(s!.photoPath!); }`
- **Also:** Add `_photo` display in the detail dialog's header (show thumbnail or initials avatar).

### 7. Registration fee badge + "Mark as Paid" not visible
- **Status:** 🟠 Root cause found
- **Root cause #1 (badge):** `hasFee` is hardcoded `true` in `_buildDataRow` line 590. Should check whether a `registration_fee` transaction actually exists for the student. Currently works by accident: `isFeePaid` returns true when both counts are 0, so no badge shows for no-fee students. But if a student has a fee charge and hasn't paid, the badge DOES show correctly.
- **Root cause #2 (Mark as Paid):** The `TransactionService` is called in `_FinancialSummaryState` but no `registration_fee` charge is ever CREATED for students (only seeded students get no fee). Without a charge, there's nothing to mark as paid.
- **Also:** The `_fetchPage()` iterates ALL students for individual `isRegistrationFeePaid()` calls — this is N+1 queries and slow.
- **Fix:** Properly compute `hasFee` by checking transaction existence. Also add a visible indicator in the detail dialog financial section to show the registration fee amount even when unpaid.

### 8. Settings registration fee amount not persisted
- **Status:** 🟡 Investigating
- **Code check:** `onFieldSubmitted` at line 141 saves to SharedPreferences. The save action EXISTS and works on Enter/submit. There is no visible "Save" button but the TextFormField saves on submit.
- **Possible issue:** User may not realize they need to press Enter to save. The value might appear to not save because they tap away without submitting.
- **Fix:** Add `onChanged` auto-save with 500ms debounce, OR add a small checkmark/save icon button inline. Propose: add an `onChanged` handler that auto-saves on blur with a brief debounce.

### 9. Unenrolled row tint should be red-leaning
- **Status:** 🟠 Root cause found (color choice)
- **Current:** `const Color(0xFF2B2416).withValues(alpha: 0.4)` — dark amber/brown.
- **Target:** Muted red-leaning, using existing semantic tokens.
- **Fix:** Change to `SemanticTokens.error.withValues(alpha: 0.08)` — a very subtle red tint at 8% opacity against the dark background. Stays muted, not alarming, clearly distinct from the amber badge.

---

## Confirmed Working
- Archive filter (Bug 1 from prior batch) — logic fixed, confirmed via code trace.

---

## Caching Risk Assessment
The IndexedStack in MainShell uses `KeyedSubtree(key: ValueKey('screen_${i}_${_visitCounters[i] ?? 0}'))` which should force widget recreation on every sidebar click. However:
- If the user hot-reloads while the students screen IS the active tab, the widget tree may not be fully recreated.
- If the user is testing via the RUNNING app (not a fresh launch after each build), the old widget instance persists.
- **Recommendation for all items above**: Test with `flutter run` (full cold start, NOT hot reload) and then verify. Screenshots/code inspection confirm correctness for items 1-5 but IndexedStack caching may explain the visual discrepancies.

---

## Forward-Looking Shared Components (to extract after fixes)

1. **`ShellDialog`** — shared modal dialog wrapper with `backgroundColor: ShellTokens.chromeSurface`, `barrierColor: Colors.black54`, `shape: RoundedRectangleBorder(10)`, consistent `x` close button.
2. **`DataTable` pattern** — frozen first column + checkbox + zebra striping + pagination. Currently embedded in student_list_screen.dart (700+ lines). Should be extractable for reuse in Teachers, Groups, Sessions screens.
3. **`DateHelper`** — Maghreb month names for displays; doc note that `showDatePicker` uses Flutter's built-in locale which we cannot override.
4. **`AppBadge`** — the small colored badge widget pattern (currently `_buildBadge` in student_list_screen.dart).

Current status of extraction: NOT YET EXTRACTED. To be done after all bugs fixed and verified.
