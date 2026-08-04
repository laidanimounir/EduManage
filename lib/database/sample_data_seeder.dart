import '../repositories/student_repository.dart';
import '../repositories/teacher_repository.dart';
import '../repositories/subject_group_repository.dart';
import '../repositories/session_repository.dart';
import '../repositories/enrollment_repository.dart';
import '../repositories/classroom_repository.dart';
import '../repositories/school_level_repository.dart';
import '../repositories/teacher_subject_group_repository.dart';
import '../repositories/attendance_repository.dart';
import '../utils/uuid_helper.dart';
import '../utils/device_id.dart';
import '../database/app_database.dart';
import 'package:drift/drift.dart';

class SampleDataSeeder {
  static Future<void> seed(AppDatabase db) async {
    final studentRepo = StudentRepository(db);
    final existingStudents = await studentRepo.getAll();

    if (existingStudents.isEmpty) {
      await _seedCoreData(db, studentRepo);
    }

    await _seedAttendance(db);
  }

  static Future<void> _seedCoreData(AppDatabase db, StudentRepository studentRepo) async {
    final roomRepo = ClassroomRepository(db);
    final rooms = await roomRepo.getAll();
    final classroomId = rooms.isNotEmpty ? rooms.first.id : '';

    final schoolLevelRepo = SchoolLevelRepository(db);
    final existingLevels = await schoolLevelRepo.getAll();
    if (existingLevels.isEmpty) {
      await schoolLevelRepo.create('Primaire');
      await schoolLevelRepo.create('Collège');
      await schoolLevelRepo.create('Lycée');
    }

    final s1Id = await studentRepo.create(StudentsCompanion(
      code: const Value('STU-001'),
      firstNameAr: const Value('أحمد'),
      lastNameAr: const Value('بن محمد'),
      firstNameFr: const Value('Ahmed'),
      lastNameFr: const Value('Ben Mohamed'),
      phone: const Value('0555123456'),
      gender: const Value('male'),
      status: const Value('active'),
    ));

    final s2Id = await studentRepo.create(StudentsCompanion(
      code: const Value('STU-002'),
      firstNameAr: const Value('فاطمة'),
      lastNameAr: const Value('علي'),
      firstNameFr: const Value('Fatima'),
      lastNameFr: const Value('Ali'),
      phone: const Value('0555789012'),
      gender: const Value('female'),
      status: const Value('active'),
    ));

    final s3Id = await studentRepo.create(StudentsCompanion(
      code: const Value('STU-003'),
      firstNameAr: const Value('كريم'),
      lastNameAr: const Value('سعيد'),
      firstNameFr: const Value('Karim'),
      lastNameFr: const Value('Said'),
      phone: const Value('0555345678'),
      gender: const Value('male'),
      status: const Value('active'),
    ));

    final teacherRepo = TeacherRepository(db);
    final t1Id = await teacherRepo.create(TeachersCompanion(
      code: const Value('TCH-001'),
      firstNameAr: const Value('سمير'),
      lastNameAr: const Value('عمار'),
      firstNameFr: const Value('Samir'),
      lastNameFr: const Value('Amar'),
      phone: const Value('0666123456'),
      salaryType: const Value('percentage'),
      teacherSharePct: const Value(70),
    ));

    final t2Id = await teacherRepo.create(TeachersCompanion(
      code: const Value('TCH-002'),
      firstNameAr: const Value('ليلى'),
      lastNameAr: const Value('حميد'),
      firstNameFr: const Value('Leila'),
      lastNameFr: const Value('Hamid'),
      phone: const Value('0666789012'),
      salaryType: const Value('fixed'),
      teacherFixedAmount: const Value(30000),
    ));

    final groupRepo = SubjectGroupRepository(db);
    final g1Id = await groupRepo.create(SubjectGroupsCompanion(
      nameAr: const Value('فرنسية ابتدائي'),
      nameFr: const Value('Français Primaire'),
      subjectAr: const Value('اللغة الفرنسية'),
      subjectFr: const Value('Langue française'),
      schoolLevel: const Value('primary'),
    ));

    final g2Id = await groupRepo.create(SubjectGroupsCompanion(
      nameAr: const Value('إنجليزية متوسط'),
      nameFr: const Value('Anglais Moyen'),
      subjectAr: const Value('اللغة الإنجليزية'),
      subjectFr: const Value('Langue anglaise'),
      schoolLevel: const Value('middle'),
    ));

    final junctionRepo = TeacherSubjectGroupRepository(db);
    await junctionRepo.assign(t1Id, g1Id);
    await junctionRepo.assign(t2Id, g2Id);

    final sessionRepo = SessionRepository(db);
    final startTime = DateTime(2026, 1, 1, 0, 0);
    final endTime = DateTime(2026, 1, 1, 23, 59);

    for (int day = 1; day <= 7; day++) {
      await sessionRepo.create(SessionsCompanion(
        subjectGroupId: Value(g1Id),
        teacherId: Value(t1Id),
        classroomId: Value(classroomId),
        dayOfWeek: Value(day),
        startTime: Value(startTime),
        endTime: Value(endTime),
        monthlyPrice: const Value(5000),
        sessionsPerMonth: const Value(8),
        teacherSharePct: const Value(70),
      ));
    }

    for (int day = 1; day <= 7; day++) {
      await sessionRepo.create(SessionsCompanion(
        subjectGroupId: Value(g2Id),
        teacherId: Value(t2Id),
        classroomId: Value(classroomId),
        dayOfWeek: Value(day),
        startTime: Value(startTime),
        endTime: Value(endTime),
        monthlyPrice: const Value(4000),
        sessionsPerMonth: const Value(8),
        teacherFixedAmount: const Value(30000),
      ));
    }

    final enrollingRepo = EnrollmentRepository(db);
    await enrollingRepo.create(EnrollmentsCompanion(
      studentId: Value(s1Id),
      subjectGroupId: Value(g1Id),
      status: const Value('active'),
    ));

    await enrollingRepo.create(EnrollmentsCompanion(
      studentId: Value(s2Id),
      subjectGroupId: Value(g1Id),
      status: const Value('active'),
    ));

    await enrollingRepo.create(EnrollmentsCompanion(
      studentId: Value(s1Id),
      subjectGroupId: Value(g2Id),
      status: const Value('active'),
    ));

    await enrollingRepo.create(EnrollmentsCompanion(
      studentId: Value(s3Id),
      subjectGroupId: Value(g2Id),
      status: const Value('active'),
    ));
  }

  static Future<void> _seedAttendance(AppDatabase db) async {
    final existing = await db.customSelect(
      'SELECT COUNT(*) AS cnt FROM attendance WHERE student_id IS NOT NULL AND status = \'present\'',
    ).getSingle();
    if (existing.read<int>('cnt') > 0) return;

    final teachers = await TeacherRepository(db).getAll();
    final sessionRepo = SessionRepository(db);
    final enrollingRepo = EnrollmentRepository(db);
    final deviceId = await DeviceId.get();

    for (final teacher in teachers.where((t) => !t.isArchived)) {
      final sessions = await sessionRepo.getByTeacher(teacher.id);
      if (sessions.isEmpty) continue;

      for (final sess in sessions.take(3)) {
        final enrollments = await enrollingRepo.getBySubjectGroup(sess.subjectGroupId);
        final active = enrollments.where((e) => e.status == 'active' && !e.isTransferred).take(2).toList();

        for (int dateOffset = 1; dateOffset <= 3; dateOffset++) {
          final attDate = DateTime(2026, 8, dateOffset);
          for (final enrollment in active) {
            await db.into(db.attendance).insert(AttendanceCompanion(
              id: Value(UuidHelper.generate()),
              studentId: Value(enrollment.studentId),
              personType: const Value('student'),
              sessionId: Value(sess.id),
              attendanceDate: Value(attDate),
              checkInTime: Value(attDate),
              status: const Value('present'),
              deviceId: Value(deviceId),
            ));
          }
        }
      }
    }
  }
}
