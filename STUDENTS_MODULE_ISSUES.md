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
- All 4 `Dialog()` calls use `backgroundColor: ShellTokens.chromeSurface`.

## Item 2 — Full-row tap
- **Status:** ✅ Verified
- Every non-interactive column wrapped in `GestureDetector(behavior: HitTestBehavior.opaque)`.

## Item 3 — Unenrolled row tint
- **Status:** 🟢 Fixed
- Changed from amber to `SemanticTokens.error.withValues(alpha: 0.08)` — muted red.

## Item 4 — Date picker Maghreb names
- **Status:** ✅ Verified (framework limitation)
- `showDatePicker` uses Flutter's `MaterialLocalizationsAr` (Standard Arabic). Cannot override without custom date picker.

## Item 5 — Checkbox column width
- **Status:** 🟢 Fixed
- Changed from `FlexColumnWidth(2)` to `FixedColumnWidth(44)`. Padding reduced to 4.

## Item 6 — Photo persistence
- **Status:** 🟢 Fixed
- `_photo` now initialized from `student.photoPath` on edit.

## Item 7 — Registration fee badge + Mark as Paid
- **Status:** 🟢 Fixed
- `createRegistrationFee()` called on new student save. "Mark as Paid" button present in detail dialog.

## Item 8 — Settings save
- **Status:** 🟢 Fixed
- `onChanged` replaces `onFieldSubmitted` for auto-save.

## Item 9 — Unenrolled tint color
- **Status:** 🟢 Fixed
- Now `SemanticTokens.error.withValues(alpha: 0.08)` — muted red.

---

## Item 10 — Vertical scroll with fixed header
- **Status:** 🟢 Fixed
- **Root cause:** `Table` widget rendered all rows in one non-scrollable container.
- **Fix:** Split into fixed header `Table` and scrollable body `Table` inside `Expanded(SingleChildScrollView)`. Both share `_columnWidths()` for column alignment.

## Item 11 — Replace Status column with Date of Birth
- **Status:** 🟢 Fixed
- **Fix:** Removed status column (redundant with filter chips). Replaced with `s.birthDate` using existing `_formatDate()`. Column widths adjusted from 8 to 7 columns. Removed `_buildStatusCell` from data row.

## Item 12 — Photo shown in Detail Dialog
- **Status:** 🟢 Fixed
- **Root cause:** Detail dialog always used initials-based `CircleAvatar`, never read `student.photoPath`.
- **Fix:** `_buildAvatar()` method added to `_StudentDetailDialog` — shows `ClipOval(Image.file())` when photoPath exists, falls back to initials `CircleAvatar` with `errorBuilder` for corrupted files.

## Item 13 — Auto-switch OS keyboard input language
- **Status:** Deferred — OS-level limitation
- **Feasibility:** Technically possible on Windows via `ActivateKeyboardLayout()` in the `win32` package, but NOT recommended because:
  1. Thread-local scope is fragile — can leak to other apps on Alt+Tab
  2. No major desktop app does this (Word, Chrome, VS Code — none auto-switch)
  3. Windows-only solution, no macOS/Linux equivalent
  4. Surprising UX — forcibly changing OS-level keyboard layout from inside an app
- **Alternative:** Small visual hint labels (`⌨ AR` / `⌨ FR`) next to each input field. This is purely visual, zero platform dependencies, respects user control.
- **Implementation status:** Not implemented. Deferred for future consideration.

---

## IndexedStack Caching Note
Items 1-3 may appear broken under hot reload. Test with `flutter run` (cold start). The `KeyedSubtree` visit-counter mechanism in `MainShell` forces widget recreation on tab switch but hot reload bypasses this.

## Shared Components Plan
To extract before next module (Subjects/Groups/Payments):
1. `ShellDialog` — chromeSurface bg, 10px radius, barrierColor, x close button
2. `DataTable` — frozen column, checkbox, zebra stripes, pagination
3. `DateHelper` — Maghreb month names (display only; `showDatePicker` cannot use them)
4. `AppBadge` — amber badge widget pattern
