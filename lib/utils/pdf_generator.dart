import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../database/app_database.dart';
import '../repositories/transaction_repository.dart';

class PdfGenerator {
  static const _currency = 'DA';

  static String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static Future<String> generateStudentReceipt({
    required AppDatabase database,
    required String studentId,
    required String receiptNumber,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    final pdf = pw.Document();
    final student = await (database.select(database.students)
      ..where((t) => t.id.equals(studentId))).getSingleOrNull();
    if (student == null) throw ArgumentError('Student not found');

    final txns = await TransactionRepository(database).getByStudent(studentId);
    final charges = txns.where((t) =>
        t.type == 'session_charge' || t.type == 'registration_fee' || t.type == 'correction').toList();
    final discounts = txns.where((t) => t.type == 'discount').toList();
    final payments = txns.where((t) =>
        t.type == 'student_payment' || t.type == 'registration_fee_payment' || t.type == 'reversal').toList();

    final totalCharged = charges.fold<double>(0, (s, t) => s + t.amount);
    final totalDiscounts = discounts.fold<double>(0, (s, t) => s + t.amount);
    final totalPaid = payments.fold<double>(0, (s, t) => s + t.amount);
    final balance = totalCharged - totalDiscounts - totalPaid;
    final balColor = balance > 0 ? PdfColors.red : PdfColors.green;

    final chargeRows = <List<String>>[];
    for (final c in charges) {
      final discountNote = discounts
          .where((d) => d.referenceTransactionId == c.id)
          .map((d) => 'Discount: ${d.amount.toStringAsFixed(0)} ${_currency}')
          .join(', ');
      chargeRows.add([
        _formatDate(c.transactionDate),
        c.type == 'session_charge' ? 'Session' : c.type == 'registration_fee' ? 'Reg Fee' : 'Correction',
        '${c.amount.toStringAsFixed(0)} ${_currency}',
        discountNote.isNotEmpty ? discountNote : '—',
        c.note ?? '',
      ]);
    }

    final paymentRows = payments.map((p) => [
      _formatDate(p.transactionDate),
      p.type == 'student_payment' ? 'Payment' : p.type == 'reversal' ? 'Reversal' : 'Reg Fee Pay',
      '${p.amount.toStringAsFixed(0)} ${_currency}',
      p.note ?? '',
    ]).toList();

    final balanceColor = balance > 0 ? PdfColors.red : PdfColors.green;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        pw.Header(text: 'Bon de Paiement', level: 1),
        pw.SizedBox(height: 8),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Student: ${student.firstNameAr} ${student.lastNameAr}',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('Code: ${student.code}', style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text('Receipt #: $receiptNumber', style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${_formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 10)),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('EduManage', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text('Total: ${balance.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ]),
        ]),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Header(text: 'Charges & Discounts', level: 2),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headers: ['Date', 'Type', 'Amount', 'Discount Applied', 'Note'],
          data: chargeRows,
        ),
        pw.SizedBox(height: 12),
        pw.Divider(),
        pw.Header(text: 'Payments', level: 2),
        if (paymentRows.isEmpty)
          pw.Text('No payments recorded', style: const pw.TextStyle(fontSize: 9))
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 8),
            headers: ['Date', 'Type', 'Amount', 'Note'],
            data: paymentRows,
          ),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Summary', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Total Charged:', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('${totalCharged.toStringAsFixed(0)} ${_currency}', style: const pw.TextStyle(fontSize: 9)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Total Discounts:', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('${totalDiscounts.toStringAsFixed(0)} ${_currency}',
              style: pw.TextStyle(fontSize: 9)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Total Paid:', style: const pw.TextStyle(fontSize: 9)),
          pw.Text('${totalPaid.toStringAsFixed(0)} ${_currency}', style: pw.TextStyle(fontSize: 9)),
        ]),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Balance:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('${balance.toStringAsFixed(0)} ${_currency}',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text(
          'QR: edumanage://receipt/$receiptNumber/$studentId',
          style: const pw.TextStyle(fontSize: 7),
        ),
        pw.Text(
          'This is an electronically generated document.',
          style: const pw.TextStyle(fontSize: 7),
        ),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'receipt_${student.code}_$receiptNumber.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> generateStudentStatement({
    required AppDatabase database,
    required String studentId,
  }) async {
    final pdf = pw.Document();
    final student = await (database.select(database.students)
      ..where((t) => t.id.equals(studentId))).getSingleOrNull();
    if (student == null) throw ArgumentError('Student not found');

    final txns = await TransactionRepository(database).getByStudent(studentId);
    final totalCharged = txns
        .where((t) => t.type == 'session_charge' || t.type == 'registration_fee' || t.type == 'correction')
        .fold<double>(0, (s, t) => s + t.amount);
    final totalDiscounts = txns.where((t) => t.type == 'discount').fold<double>(0, (s, t) => s + t.amount);
    final totalPaid = txns
        .where((t) => t.type == 'student_payment' || t.type == 'registration_fee_payment' || t.type == 'reversal')
        .fold<double>(0, (s, t) => s + t.amount);
    final balance = totalCharged - totalDiscounts - totalPaid;

    final rows = txns.map((t) => [
      _formatDate(t.transactionDate),
      t.type,
      t.cycleNumber?.toString() ?? '',
      '${t.amount.toStringAsFixed(0)} ${_currency}',
      t.note ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        pw.Header(text: 'Financial Statement', level: 1),
        pw.Text('Student: ${student.firstNameAr} ${student.lastNameAr} (${student.code})',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text('Generated: ${_formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 12),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
          pw.Column(children: [
            pw.Text('Charged', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${totalCharged.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Text('Discounts', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${totalDiscounts.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Text('Paid', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${totalPaid.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Text('Balance', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${balance.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
        ]),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headers: ['Date', 'Type', 'Cycle', 'Amount', 'Note'],
          data: rows,
        ),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'statement_${student.code}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> generatePaymentReceipt({
    required AppDatabase database,
    required String transactionId,
    String? receiptNumber,
  }) async {
    final pdf = pw.Document();
    final txRepo = TransactionRepository(database);
    final tx = await txRepo.getById(transactionId);
    if (tx == null) throw ArgumentError('Transaction not found');
    if (tx.type != 'student_payment' && tx.type != 'registration_fee_payment') {
      throw ArgumentError('Not a payment transaction');
    }

    if (tx.studentId == null) throw ArgumentError('Transaction has no student');

    final student = await (database.select(database.students)
      ..where((t) => t.id.equals(tx.studentId!))).getSingleOrNull();
    if (student == null) throw ArgumentError('Student not found');

    final receiptNo = receiptNumber ?? 'REC-${tx.id.hashCode.abs().toString().substring(0, 6)}';

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        pw.Header(text: 'Bon de Paiement', level: 1),
        pw.SizedBox(height: 8),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('Student: ${student.firstNameAr} ${student.lastNameAr}',
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
            pw.Text('Code: ${student.code}', style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 4),
            pw.Text('Receipt #: $receiptNo', style: const pw.TextStyle(fontSize: 10)),
            pw.Text('Date: ${_formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 10)),
          ]),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('EduManage', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Text('${tx.amount.toStringAsFixed(0)} $_currency',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ]),
        ]),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Header(text: 'Payment Details', level: 2),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headers: ['Date', 'Type', 'Amount', 'Method', 'Note'],
          data: [[
            _formatDate(tx.transactionDate),
            tx.type == 'student_payment' ? 'Payment' : 'Reg Fee Pay',
            '${tx.amount.toStringAsFixed(0)} $_currency',
            tx.paymentMethod ?? '—',
            tx.note ?? '',
          ]],
        ),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text('Amount Received:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          pw.Text('${tx.amount.toStringAsFixed(0)} $_currency',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
        ]),
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 8),
        pw.Text(
          'QR: edumanage://receipt/$receiptNo/${student.id}',
          style: const pw.TextStyle(fontSize: 7),
        ),
        pw.Text(
          'This is an electronically generated document.',
          style: const pw.TextStyle(fontSize: 7),
        ),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'receipt_${student.code}_$receiptNo.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }

  static Future<String> generateTeacherStatement({
    required AppDatabase database,
    required String teacherId,
  }) async {
    final pdf = pw.Document();
    final teacher = await (database.select(database.teachers)
      ..where((t) => t.id.equals(teacherId))).getSingleOrNull();
    if (teacher == null) throw ArgumentError('Teacher not found');

    final earnings = await database.getTeacherSessionEarnings(teacherId);
    final payouts = await database.getTeacherPayoutHistory(teacherId);
    final totalEarned = earnings.fold<double>(0, (s, e) {
      final paid = e['paid'] as double;
      final deducted = e['deducted'] as double;
      return s + paid - deducted;
    });
    final totalPaidOut = payouts.fold<double>(0, (s, t) => s + t.amount);
    final balance = totalEarned - totalPaidOut;
    final teachBalColor = balance > 0 ? PdfColors.green : PdfColors.red;

    final sessionRows = earnings.map((e) => [
      e['group_name'] as String,
      '${e['attendance_count']} students',
      '${(e['paid'] as num).toStringAsFixed(0)} ${_currency}',
    ]).toList();

    final payoutRows = payouts.map((p) => [
      _formatDate(p.transactionDate),
      '${p.amount.toStringAsFixed(0)} ${_currency}',
      p.note ?? '',
    ]).toList();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      build: (pw.Context context) => [
        pw.Header(text: 'Teacher Statement', level: 1),
        pw.Text('Teacher: ${teacher.firstNameAr} ${teacher.lastNameAr} (${teacher.code})',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text('Generated: ${_formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 9)),
        pw.SizedBox(height: 12),
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly, children: [
          pw.Column(children: [
            pw.Text('Earned', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${totalEarned.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Text('Paid Out', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${totalPaidOut.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
          pw.Column(children: [
            pw.Text('Balance', style: const pw.TextStyle(fontSize: 9)),
            pw.Text('${balance.toStringAsFixed(0)} ${_currency}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ]),
        ]),
        pw.SizedBox(height: 16),
        pw.Divider(),
        pw.Header(text: 'Session Earnings', level: 2),
        pw.TableHelper.fromTextArray(
          headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headers: ['Group', 'Attendance', 'Amount'],
          data: sessionRows,
        ),
        pw.SizedBox(height: 12),
        pw.Divider(),
        pw.Header(text: 'Payout History', level: 2),
        if (payoutRows.isEmpty)
          pw.Text('No payouts recorded', style: const pw.TextStyle(fontSize: 9))
        else
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            cellStyle: const pw.TextStyle(fontSize: 8),
            headers: ['Date', 'Amount', 'Note'],
            data: payoutRows,
          ),
      ],
    ));

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'statement_${teacher.code}.pdf';
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}
