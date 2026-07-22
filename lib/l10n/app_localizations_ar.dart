// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'EduManage';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get confirm => 'تأكيد';

  @override
  String get close => 'إغلاق';

  @override
  String get back => 'رجوع';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get operationSuccessful => 'تمت العملية بنجاح';

  @override
  String get confirmDelete => 'هل أنت متأكد من الحذف؟';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get login => 'تسجيل الدخول';
  @override
  String get username => 'اسم المستخدم';
  @override
  String get password => 'كلمة المرور';
  @override
  String get invalidCredentials => 'اسم المستخدم أو كلمة المرور غير صحيحة';
  @override
  String get users => 'المستخدمين';
  @override
  String get role => 'الدور';
  @override
  String get firstName => 'الاسم';
  @override
  String get lastName => 'اللقب';
  @override
  String get active => 'نشط';
  @override
  String get inactive => 'غير نشط';
  @override
  String get admin => 'مدير';
  @override
  String get teacher => 'أستاذ';
  @override
  String get addUser => 'إضافة مستخدم';
  @override
  String get editUser => 'تعديل مستخدم';
  @override
  String get settings => 'الإعدادات';
  @override
  String get language => 'اللغة';
  @override
  String get arabic => 'العربية';
  @override
  String get francais => 'الفرنسية';
  @override
  String get sessionTimeout => 'مدة الجلسة';
  @override
  String get about => 'حول';
  @override
  String get version => 'الإصدار';
  @override
  String get minutes => 'دقائق';
  @override
  String get dashboard => 'لوحة القيادة';
  @override
  String get totalStudents => 'مجموع الطلاب';
  @override
  String get totalTeachers => 'مجموع الأساتذة';
  @override
  String get todaySessions => 'حصص اليوم';
  @override
  String get todayAttendance => 'حضور اليوم';
  @override
  String get monthlyRevenue => 'الإيرادات الشهرية';
  @override
  String get outstandingDebts => 'الديون المستحقة';
  @override
  String get quickActions => 'إجراءات سريعة';
  @override
  String get scanBarcode => 'مسح الباركود';
  @override
  String get checkIn => 'تسجيل الحضور';
  @override
  String get checkInSuccess => 'تم تسجيل الحضور بنجاح';
  @override
  String get checkInFailed => 'فشل تسجيل الحضور';
  @override
  String get studentNotFound => 'الطالب غير موجود';
  @override
  String get noActiveSession => 'لا توجد حصة نشطة';
  @override
  String get multipleSessionsFound => 'تم العثور على عدة حصص';
  @override
  String get selectSession => 'اختر الحصة';
  @override
  String get alreadyCheckedIn => 'تم تسجيل الحضور مسبقا';
  @override
  String get searchStudent => 'بحث عن طالب';
  @override
  String get teacherCheckin => 'تسجيل حضور الأستاذ';
  @override
  String get scanTeacherBarcode => 'مسح باركود الأستاذ';
  @override
  String get teacherNotFound => 'الأستاذ غير موجود';
  @override
  String get teacherCheckinSuccess => 'تم تسجيل حضور الأستاذ بنجاح';
  @override
  String get teacherAlreadyCheckedIn => 'الأستاذ سجل حضوره اليوم';
  @override
  String get noActiveSessionForTeacher => 'لا توجد حصة نشطة لهذا الأستاذ';
  @override
  String get name => 'الاسم';
  @override
  String get floor => 'الطابق';
  @override
  String get capacity => 'السعة';
  @override
  String get note => 'ملاحظة';
  @override
  String get status => 'الحالة';
  @override
  String get all => 'الكل';
  @override
  String get classrooms => 'القاعات';
  @override
  String get enrollStudent => 'تسجيل طالب';
  @override
  String get students => 'الطلاب';
  @override
  String get groups => 'المجموعات';
  @override
  String get customPrice => 'سعر مخصص';
  @override
  String get discount => 'تخفيض';
  @override
  String get enrollments => 'التسجيلات';
  @override
  String get noEnrollments => 'لا توجد تسجيلات';
  @override
  String get dropEnrollment => 'إسقاط التسجيل';
  @override
  String get subject => 'المادة';
  @override
  String get schoolLevel => 'المستوى الدراسي';
  @override
  String get description => 'الوصف';
  @override
  String get amountMustBePositive => 'يجب أن يكون المبلغ موجبا';
  @override
  String get saveSuccess => 'تم الحفظ بنجاح';
  @override
  String get financialStatus => 'الحالة المالية';
  @override
  String get income => 'المداخيل';
  @override
  String get payments => 'المدفوعات';
  @override
  String get expenses => 'المصاريف';
  @override
  String get teacherPayouts => 'مستحقات الأساتذة';
  @override
  String get amount => 'المبلغ';
  @override
  String get category => 'الفئة';
  @override
  String get rent => 'كراء';
  @override
  String get salary => 'أجرة';
  @override
  String get materials => 'مواد';
  @override
  String get utilities => 'مرافق';
  @override
  String get other => 'أخرى';
  @override
  String get expense => 'مصروف';
  @override
  String get paymentHistory => 'سجل المدفوعات';
  @override
  String get teachers => 'الأساتذة';
  @override
  String get code => 'الرمز';
  @override
  String get phone => 'الهاتف';
  @override
  String get address => 'العنوان';
  @override
  String get email => 'البريد الإلكتروني';
  @override
  String get idCard => 'بطاقة الهوية';
  @override
  String get salaryType => 'نوع الأجر';
  @override
  String get percentage => 'نسبة مئوية';
  @override
  String get fixed => 'ثابت';
  @override
  String get teacherShare => 'نسبة الأستاذ %';
  @override
  String get teacherFixedAmount => 'أجر ثابت للأستاذ';
  @override
  String get employmentStartDate => 'تاريخ بدء العمل';
  @override
  String get sessionCancellation => 'إلغاء الحصص';
  @override
  String get selectDate => 'اختر التاريخ';
  @override
  String get reason => 'السبب';
  @override
  String get cancellationCreated => 'تم الإلغاء بنجاح';
  @override
  String get reactivate => 'إعادة التفعيل';
  @override
  String get upcomingCancellations => 'الإلغاءات القادمة';
  @override
  String get noActiveSessions => 'لا توجد حصص نشطة';
  @override
  String get cancelConfirmation => 'هل أنت متأكد من إلغاء هذه الحصة؟';
  @override
  String get session => 'الحصة';
  @override
  String get cancelledOn => 'تم الإلغاء بتاريخ';
  @override
  String get checkedIn => 'تم تسجيل الحضور';
  @override
  String get missing => 'غائب';
  @override
  String get expected => 'متوقع';
  @override
  String get noAttendanceToday => 'لا توجد سجلات حضور اليوم';
  @override
  String get attendanceTime => 'الوقت';
  @override
  String get presentCount => 'حاضر';
  @override
  String get absentCount => 'غائب';
  @override
  String get auditLog => 'سجل التدقيق';
  @override
  String get filterByDate => 'تصفية حسب التاريخ';
  @override
  String get filterByUser => 'تصفية حسب المستخدم';
  @override
  String get allUsers => 'كل المستخدمين';
  @override
  String get startDate => 'تاريخ البداية';
  @override
  String get endDate => 'تاريخ النهاية';
  @override
  String get action => 'الإجراء';
  @override
  String get entity => 'الكيان';
  @override
  String get timestamp => 'الطابع الزمني';
  @override
  String get details => 'التفاصيل';
  @override
  String get previous => 'السابق';
  @override
  String get next => 'التالي';
  @override
  String get user => 'المستخدم';
  @override
  String get noAuditEntries => 'لا توجد سجلات تدقيق';
  @override
  String get profitReport => 'تقرير الأرباح';
  @override
  String get netProfit => 'صافي الربح';
  @override
  String get sessionCharges => 'رسوم الحصص';
  @override
  String get studentPayments => 'مدفوعات الطلاب';
  @override
  String get selectMonth => 'اختر الشهر';
  @override
  String get selectYear => 'اختر السنة';
  @override
  String get month => 'الشهر';
  @override
  String get year => 'السنة';
  @override
  String get noStudentsFound => 'لم يتم العثور على طلاب';
  @override
  String get studentCard => 'بطاقة الطالب';
  @override
  String get studentCards => 'بطاقات الطلاب';
  @override
  String get selectStudent => 'اختيار الطالب';
  @override
  String get generateCard => 'إنشاء بطاقة';
  @override
  String get reissueCard => 'إعادة إصدار البطاقة';
  @override
  String get confirmReissue => 'تأكيد إعادة الإصدار';
  @override
  String get reissueConfirmMessage => 'سيؤدي هذا إلى إلغاء البطاقة الحالية وإنشاء بطاقة جديدة. هل تريد المتابعة؟';
  @override
  String get cardNotFound => 'لا توجد بطاقة نشطة';
  @override
  String get cardRevoked => 'تم إلغاء البطاقة';
  @override
  String get cardActive => 'البطاقة نشطة';
  @override
  String get studentCode => 'رمز الطالب';
  @override
  String get qrCode => 'رمز QR';
  @override
  String get print => 'طباعة';
  @override
  String get cardPreview => 'معاينة البطاقة';
  @override
  String get issuedDate => 'تاريخ الإصدار';
  @override
  String get secureToken => 'رمز الأمان';
  @override
  String get barcode => 'رمز شريطي';
  @override
  String get student => 'الطالب';
  @override
  String get debt => 'الدين';
  @override
  String get total => 'المجموع';
  @override
  String get outstandingDebtsList => 'الديون المستحقة';
}
