import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'EduManage'**
  String get appName;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully'**
  String get operationSuccessful;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete?'**
  String get confirmDelete;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  String get login;
  String get username;
  String get password;
  String get invalidCredentials;
  String get users;
  String get role;
  String get firstName;
  String get lastName;
  String get active;
  String get inactive;
  String get admin;
  String get teacher;
  String get addUser;
  String get editUser;
  String get settings;
  String get language;
  String get arabic;
  String get francais;
  String get sessionTimeout;
  String get about;
  String get version;
  String get minutes;
  String get dashboard;
  String get totalStudents;
  String get totalTeachers;
  String get todaySessions;
  String get todayAttendance;
  String get monthlyRevenue;
  String get outstandingDebts;
  String get quickActions;
  String get scanBarcode;
  String get checkIn;
  String get checkInSuccess;
  String get checkInFailed;
  String get studentNotFound;
  String get noActiveSession;
  String get multipleSessionsFound;
  String get selectSession;
  String get alreadyCheckedIn;
  String get searchStudent;
  String get teacherCheckin;
  String get scanTeacherBarcode;
  String get teacherNotFound;
  String get teacherCheckinSuccess;
  String get teacherAlreadyCheckedIn;
  String get noActiveSessionForTeacher;
  String get name;
  String get floor;
  String get capacity;
  String get note;
  String get status;
  String get all;
  String get classrooms;
  String get enrollStudent;
  String get students;
  String get groups;
  String get customPrice;
  String get discount;
  String get enrollments;
  String get noEnrollments;
  String get dropEnrollment;
  String get subject;
  String get schoolLevel;
  String get description;
  String get amountMustBePositive;
  String get saveSuccess;
  String get financialStatus;
  String get income;
  String get payments;
  String get expenses;
  String get teacherPayouts;
  String get amount;
  String get category;
  String get rent;
  String get salary;
  String get materials;
  String get utilities;
  String get other;
  String get expense;
  String get paymentHistory;
  String get teachers;
  String get code;
  String get phone;
  String get address;
  String get email;
  String get idCard;
  String get salaryType;
  String get percentage;
  String get fixed;
  String get teacherShare;
  String get teacherFixedAmount;
  String get employmentStartDate;
  String get sessionCancellation;
  String get selectDate;
  String get reason;
  String get cancellationCreated;
  String get reactivate;
  String get upcomingCancellations;
  String get noActiveSessions;
  String get cancelConfirmation;
  String get session;
  String get cancelledOn;
  String get checkedIn;
  String get missing;
  String get expected;
  String get noAttendanceToday;
  String get attendanceTime;
  String get presentCount;
  String get absentCount;
  String get auditLog;
  String get filterByDate;
  String get filterByUser;
  String get allUsers;
  String get startDate;
  String get endDate;
  String get action;
  String get entity;
  String get timestamp;
  String get details;
  String get previous;
  String get next;
  String get user;
  String get noAuditEntries;
  String get profitReport;
  String get netProfit;
  String get sessionCharges;
  String get studentPayments;
  String get selectMonth;
  String get selectYear;
  String get month;
  String get year;
  String get noStudentsFound;
  String get studentCard;
  String get studentCards;
  String get selectStudent;
  String get generateCard;
  String get reissueCard;
  String get confirmReissue;
  String get reissueConfirmMessage;
  String get cardNotFound;
  String get cardRevoked;
  String get cardActive;
  String get studentCode;
  String get qrCode;
  String get print;
  String get cardPreview;
  String get issuedDate;
  String get secureToken;
  String get barcode;
  String get student;
  String get debt;
  String get total;
  String get outstandingDebtsList;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
