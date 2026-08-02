import 'package:edumanage/constants/app_constants.dart';
import 'package:edumanage/database/app_database.dart';
import 'package:edumanage/l10n/app_localizations.dart';
import 'package:edumanage/screens/payments/student_history_dialog.dart';
import 'package:edumanage/widgets/shell_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpHistoryDialog(WidgetTester tester, {required double charged, required double paid, required List<Transaction> txs}) async {
    await tester.pumpWidget(MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => ShellDialog(
                  maxWidth: 700,
                  maxHeight: 650,
                  title: 'أحمد بن محمد',
                  body: StudentHistoryContent(charged: charged, paid: paid, txs: txs),
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  List<Transaction> fakeTransactions() {
    final now = DateTime(2026, 1, 15);
    return [
      Transaction(
        id: 'tx1',
        studentId: 's1',
        type: 'session_charge',
        amount: 150,
        transactionDate: now,
        deviceId: 'test-device',
        createdAt: now,
        note: 'Cycle 1 charge',
        cycleNumber: 1,
      ),
      Transaction(
        id: 'tx2',
        studentId: 's1',
        type: 'student_payment',
        amount: 120,
        transactionDate: now,
        deviceId: 'test-device',
        createdAt: now,
        note: 'Cash payment',
      ),
    ];
  }

  testWidgets('history dialog renders summary and transaction rows without unbounded-height exceptions', (tester) async {
    await pumpHistoryDialog(tester, charged: 200, paid: 120, txs: fakeTransactions());

    expect(tester.takeException(), isNull);

    final l10n = AppLocalizations.of(tester.element(find.byType(ShellDialog)));
    expect(find.text(l10n.totalCharged), findsOneWidget);
    expect(find.text(l10n.totalPaid), findsOneWidget);
    expect(find.text(l10n.remaining), findsOneWidget);
    expect(find.text(l10n.paymentHistory), findsOneWidget);

    const currency = AppConstants.currencySymbol;
    expect(find.text('200 $currency'), findsOneWidget);
    expect(find.text('80 $currency'), findsOneWidget);
    expect(find.text('150 $currency'), findsOneWidget);
    expect(find.text('120 $currency'), findsNWidgets(2));

    expect(find.text('Cycle 1 charge'), findsOneWidget);
    expect(find.text('Cash payment'), findsOneWidget);
  });

  testWidgets('history dialog shows empty state when there are no transactions', (tester) async {
    await pumpHistoryDialog(tester, charged: 0, paid: 0, txs: const []);

    expect(tester.takeException(), isNull);

    final l10n = AppLocalizations.of(tester.element(find.byType(ShellDialog)));
    expect(find.text(l10n.noData), findsOneWidget);
  });
}
