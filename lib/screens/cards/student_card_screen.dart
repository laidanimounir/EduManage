import 'dart:typed_data';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../database/app_database.dart';
import '../../l10n/app_localizations.dart';
import '../../repositories/student_repository.dart';
import '../../repositories/student_card_repository.dart';
import '../../widgets/barcode_widget.dart';
import '../../widgets/qr_code_widget.dart';
import '../../utils/uuid_helper.dart';

class StudentCardScreen extends StatefulWidget {
  final AppDatabase database;

  const StudentCardScreen({super.key, required this.database});

  @override
  State<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends State<StudentCardScreen> {
  late final StudentRepository _studentRepo;
  late final StudentCardRepository _cardRepo;

  List<Student> _students = [];
  List<Student> _filtered = [];
  Student? _selectedStudent;
  StudentCard? _studentCard;
  String _searchQuery = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _studentRepo = StudentRepository(widget.database);
    _cardRepo = StudentCardRepository(widget.database);
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final students = await _studentRepo.getAll();
    setState(() {
      _students = students;
      _loading = false;
    });
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filtered = _students;
    } else {
      final q = _searchQuery.toLowerCase();
      _filtered = _students.where((s) {
        return s.firstNameAr.toLowerCase().contains(q) ||
            s.lastNameAr.toLowerCase().contains(q) ||
            (s.firstNameFr?.toLowerCase().contains(q) ?? false) ||
            (s.lastNameFr?.toLowerCase().contains(q) ?? false) ||
            s.code.toLowerCase().contains(q) ||
            (s.phone?.toLowerCase().contains(q) ?? false);
      }).toList();
    }
    setState(() {});
  }

  Future<void> _selectStudent(Student student) async {
    setState(() {
      _selectedStudent = student;
      _studentCard = null;
    });
    final card = await _cardRepo.getActiveCard(student.id);
    setState(() {
      _studentCard = card;
    });
  }

  Future<void> _generateCard() async {
    if (_selectedStudent == null) return;

    final existingCard = await _cardRepo.getActiveCard(_selectedStudent!.id);
    if (existingCard != null) {
      setState(() => _studentCard = existingCard);
      return;
    }

    final secureToken = UuidHelper.generate();
    final barcodeContent = _selectedStudent!.code;

    await _cardRepo.create(StudentCardsCompanion(
      studentId: Value(_selectedStudent!.id),
      secureToken: Value(secureToken),
      barcodeContent: Value(barcodeContent),
    ));

    final card = await _cardRepo.getActiveCard(_selectedStudent!.id);
    setState(() => _studentCard = card);

    if (mounted) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.operationSuccessful)),
      );
    }
  }

  Future<void> _reissueCard() async {
    final l10n = AppLocalizations.of(context);
    if (_selectedStudent == null || _studentCard == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.confirmReissue),
        content: Text(l10n.reissueConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.confirm)),
        ],
      ),
    );

    if (confirmed != true) return;

    if (_studentCard != null) {
      await _cardRepo.revoke(_studentCard!.id);
    }

    final secureToken = UuidHelper.generate();
    final barcodeContent = _selectedStudent!.code;

    await _cardRepo.create(StudentCardsCompanion(
      studentId: Value(_selectedStudent!.id),
      secureToken: Value(secureToken),
      barcodeContent: Value(barcodeContent),
    ));

    final newCard = await _cardRepo.getActiveCard(_selectedStudent!.id);
    setState(() => _studentCard = newCard);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.operationSuccessful)),
      );
    }
  }

  Future<void> _printCard() async {
    if (_selectedStudent == null) return;

    await Printing.layoutPdf(
      onLayout: (_) => _buildCardPdf(),
      name: 'student_card_${_selectedStudent!.code}',
    );
  }

  Future<Uint8List> _buildCardPdf() async {
    final pdf = pw.Document();
    final student = _selectedStudent!;
    final cardToken = _studentCard?.secureToken ?? '';

    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(85 * PdfPageFormat.mm, 54 * PdfPageFormat.mm),
        build: (ctx) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'EduManage',
                  style: const pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  '${student.firstNameAr} ${student.lastNameAr}',
                  style: const pw.TextStyle(fontSize: 7),
                ),
                pw.Text(
                  student.code,
                  style: const pw.TextStyle(fontSize: 6),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  'Code: ${student.code}',
                  style: const pw.TextStyle(fontSize: 5),
                ),
                if (cardToken.isNotEmpty)
                  pw.Text(
                    'Token: $cardToken',
                    style: const pw.TextStyle(fontSize: 4),
                  ),
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: l10n.searchStudent,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() => _searchQuery = '');
                                _applyFilter();
                              },
                            )
                          : null,
                    ),
                    onChanged: (v) {
                      setState(() => _searchQuery = v);
                      _applyFilter();
                    },
                  ),
                ),
                _selectedStudent == null
                    ? Expanded(child: _buildStudentList(l10n))
                    : Expanded(child: _buildCardPreview(l10n)),
              ],
            ),
    );
  }

  Widget _buildStudentList(AppLocalizations l10n) {
    if (_filtered.isEmpty) {
      return Center(child: Text(l10n.noStudentsFound));
    }

    return ListView.builder(
      itemCount: _filtered.length,
      itemBuilder: (ctx, i) {
        final s = _filtered[i];
        return ListTile(
          leading: CircleAvatar(child: Text(s.firstNameAr.isNotEmpty ? s.firstNameAr[0] : '?')),
          title: Text('${s.firstNameAr} ${s.lastNameAr}'),
          subtitle: Text('${l10n.code}: ${s.code}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _selectStudent(s),
        );
      },
    );
  }

  Widget _buildCardPreview(AppLocalizations l10n) {
    final student = _selectedStudent!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => setState(() {
                _selectedStudent = null;
                _studentCard = null;
              }),
            ),
            Expanded(
              child: Text(
                '${student.firstNameAr} ${student.lastNameAr}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'EduManage',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${student.firstNameAr} ${student.lastNameAr}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (student.firstNameFr != null && student.firstNameFr!.isNotEmpty)
                  Text(
                    '${student.firstNameFr} ${student.lastNameFr ?? ''}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                const SizedBox(height: 2),
                Text(
                  '${l10n.studentCode}: ${student.code}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BarcodeWidget(
                    data: student.code,
                    height: 50,
                    width: 220,
                  ),
                ),
                const SizedBox(height: 8),
                if (_studentCard != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: QrCodeWidget(
                      data: 'EDU:${student.code}:${_studentCard!.secureToken}',
                      size: 120,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'No QR generated',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_studentCard == null)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _generateCard,
              icon: const Icon(Icons.credit_card),
              label: Text(l10n.generateCard),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          )
        else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _printCard,
              icon: const Icon(Icons.print),
              label: Text(l10n.print),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _reissueCard,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.reissueCard),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                foregroundColor: Colors.orange.shade700,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        _buildCardInfoCard(l10n),
      ],
    );
  }

  Widget _buildCardInfoCard(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.details, style: Theme.of(context).textTheme.titleSmall),
            const Divider(),
            _infoRow(l10n.student, '${_selectedStudent!.firstNameAr} ${_selectedStudent!.lastNameAr}'),
            _infoRow(l10n.code, _selectedStudent!.code),
            if (_studentCard != null) ...[
              _infoRow(l10n.issuedDate, '${_studentCard!.issuedDate.year}/${_studentCard!.issuedDate.month}/${_studentCard!.issuedDate.day}'),
              _infoRow(l10n.status, _studentCard!.isActive ? l10n.cardActive : l10n.cardRevoked),
            ] else
              _infoRow(l10n.status, l10n.cardNotFound),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
