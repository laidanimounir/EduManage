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

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkIn;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @teachers.
  ///
  /// In en, this message translates to:
  /// **'Teachers'**
  String get teachers;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @groups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// No description provided for @classrooms.
  ///
  /// In en, this message translates to:
  /// **'Classrooms'**
  String get classrooms;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit Log'**
  String get auditLog;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @birthPlace.
  ///
  /// In en, this message translates to:
  /// **'Birth Place'**
  String get birthPlace;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @graduated.
  ///
  /// In en, this message translates to:
  /// **'Graduated'**
  String get graduated;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @subject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// No description provided for @schoolLevel.
  ///
  /// In en, this message translates to:
  /// **'School Level'**
  String get schoolLevel;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @capacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get capacity;

  /// No description provided for @dayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get dayOfWeek;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @monthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'Monthly Price'**
  String get monthlyPrice;

  /// No description provided for @sessionsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Sessions per Month'**
  String get sessionsPerMonth;

  /// No description provided for @teacherShare.
  ///
  /// In en, this message translates to:
  /// **'Teacher Share'**
  String get teacherShare;

  /// No description provided for @teacherFixedAmount.
  ///
  /// In en, this message translates to:
  /// **'Teacher Fixed Amount'**
  String get teacherFixedAmount;

  /// No description provided for @salaryType.
  ///
  /// In en, this message translates to:
  /// **'Salary Type'**
  String get salaryType;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @fixed.
  ///
  /// In en, this message translates to:
  /// **'Fixed'**
  String get fixed;

  /// No description provided for @enrollments.
  ///
  /// In en, this message translates to:
  /// **'Enrollments'**
  String get enrollments;

  /// No description provided for @enrollmentDate.
  ///
  /// In en, this message translates to:
  /// **'Enrollment Date'**
  String get enrollmentDate;

  /// No description provided for @customPrice.
  ///
  /// In en, this message translates to:
  /// **'Custom Price'**
  String get customPrice;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @debt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debt;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @sessionCharge.
  ///
  /// In en, this message translates to:
  /// **'Session Charge'**
  String get sessionCharge;

  /// No description provided for @studentPayment.
  ///
  /// In en, this message translates to:
  /// **'Student Payment'**
  String get studentPayment;

  /// No description provided for @teacherPayout.
  ///
  /// In en, this message translates to:
  /// **'Teacher Payout'**
  String get teacherPayout;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @correction.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get correction;

  /// No description provided for @reversal.
  ///
  /// In en, this message translates to:
  /// **'Reversal'**
  String get reversal;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @materials.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get materials;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilities;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @checkInTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in Time'**
  String get checkInTime;

  /// No description provided for @checkInMethod.
  ///
  /// In en, this message translates to:
  /// **'Check-in Method'**
  String get checkInMethod;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @todayAttendance.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Attendance'**
  String get todayAttendance;

  /// No description provided for @todaySessions.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sessions'**
  String get todaySessions;

  /// No description provided for @missingStudents.
  ///
  /// In en, this message translates to:
  /// **'Missing Students'**
  String get missingStudents;

  /// No description provided for @printCard.
  ///
  /// In en, this message translates to:
  /// **'Print Card'**
  String get printCard;

  /// No description provided for @reissueCard.
  ///
  /// In en, this message translates to:
  /// **'Reissue Card'**
  String get reissueCard;

  /// No description provided for @cardPreview.
  ///
  /// In en, this message translates to:
  /// **'Card Preview'**
  String get cardPreview;

  /// No description provided for @barcodeContent.
  ///
  /// In en, this message translates to:
  /// **'Barcode Content'**
  String get barcodeContent;

  /// No description provided for @secureToken.
  ///
  /// In en, this message translates to:
  /// **'Secure Token'**
  String get secureToken;

  /// No description provided for @issuedDate.
  ///
  /// In en, this message translates to:
  /// **'Issued Date'**
  String get issuedDate;

  /// No description provided for @revoked.
  ///
  /// In en, this message translates to:
  /// **'Revoked'**
  String get revoked;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @accountant.
  ///
  /// In en, this message translates to:
  /// **'Accountant'**
  String get accountant;

  /// No description provided for @secretary.
  ///
  /// In en, this message translates to:
  /// **'Secretary'**
  String get secretary;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @isActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get isActive;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @francais.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get francais;

  /// No description provided for @sessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout'**
  String get sessionTimeout;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @totalTeachers.
  ///
  /// In en, this message translates to:
  /// **'Total Teachers'**
  String get totalTeachers;

  /// No description provided for @monthlyRevenue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Revenue'**
  String get monthlyRevenue;

  /// No description provided for @outstandingDebts.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Debts'**
  String get outstandingDebts;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @revenueBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Revenue Breakdown'**
  String get revenueBreakdown;

  /// No description provided for @expenseBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Expense Breakdown'**
  String get expenseBreakdown;

  /// No description provided for @topDebtors.
  ///
  /// In en, this message translates to:
  /// **'Top Debtors'**
  String get topDebtors;

  /// No description provided for @attendanceRate.
  ///
  /// In en, this message translates to:
  /// **'Attendance Rate'**
  String get attendanceRate;

  /// No description provided for @teacherHours.
  ///
  /// In en, this message translates to:
  /// **'Teacher Hours'**
  String get teacherHours;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode...'**
  String get scanBarcode;

  /// No description provided for @studentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Student not found'**
  String get studentNotFound;

  /// No description provided for @noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active session right now'**
  String get noActiveSession;

  /// No description provided for @alreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Already checked in'**
  String get alreadyCheckedIn;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check-in successful'**
  String get checkInSuccess;

  /// No description provided for @selectSession.
  ///
  /// In en, this message translates to:
  /// **'Select session'**
  String get selectSession;

  /// No description provided for @multipleSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'Multiple sessions found at this time'**
  String get multipleSessionsFound;

  /// No description provided for @manualCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Manual check-in'**
  String get manualCheckIn;

  /// No description provided for @searchStudent.
  ///
  /// In en, this message translates to:
  /// **'Search student...'**
  String get searchStudent;

  /// No description provided for @cancelSession.
  ///
  /// In en, this message translates to:
  /// **'Cancel session'**
  String get cancelSession;

  /// No description provided for @cancelDate.
  ///
  /// In en, this message translates to:
  /// **'Cancellation date'**
  String get cancelDate;

  /// No description provided for @cancelReason.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason'**
  String get cancelReason;

  /// No description provided for @sessionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Session cancelled'**
  String get sessionCancelled;

  /// No description provided for @cancelledDate.
  ///
  /// In en, this message translates to:
  /// **'Cancelled date'**
  String get cancelledDate;

  /// No description provided for @reactivate.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivate;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @paymentReceipt.
  ///
  /// In en, this message translates to:
  /// **'Payment Receipt'**
  String get paymentReceipt;

  /// No description provided for @paidTo.
  ///
  /// In en, this message translates to:
  /// **'Paid to'**
  String get paidTo;

  /// No description provided for @paymentFor.
  ///
  /// In en, this message translates to:
  /// **'Payment for'**
  String get paymentFor;

  /// No description provided for @receiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt Number'**
  String get receiptNumber;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @idleTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session expired due to inactivity'**
  String get idleTimeout;

  /// No description provided for @perSessionPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per session'**
  String get perSessionPrice;

  /// No description provided for @enrolledStudents.
  ///
  /// In en, this message translates to:
  /// **'Enrolled Students'**
  String get enrolledStudents;

  /// No description provided for @teacherPayouts.
  ///
  /// In en, this message translates to:
  /// **'Teacher Payouts'**
  String get teacherPayouts;

  /// No description provided for @totalOwed.
  ///
  /// In en, this message translates to:
  /// **'Total Owed'**
  String get totalOwed;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @runningBalance.
  ///
  /// In en, this message translates to:
  /// **'Running Balance'**
  String get runningBalance;

  /// No description provided for @previousBalance.
  ///
  /// In en, this message translates to:
  /// **'Previous Balance'**
  String get previousBalance;

  /// No description provided for @newBalance.
  ///
  /// In en, this message translates to:
  /// **'New Balance'**
  String get newBalance;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saveSuccess;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get invalidCredentials;

  /// No description provided for @sessionHeld.
  ///
  /// In en, this message translates to:
  /// **'Session confirmed'**
  String get sessionHeld;

  /// No description provided for @noActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get noActiveSessions;

  /// No description provided for @checkInFailed.
  ///
  /// In en, this message translates to:
  /// **'Check-in failed'**
  String get checkInFailed;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this session?'**
  String get confirmCancellation;

  /// No description provided for @cardReissued.
  ///
  /// In en, this message translates to:
  /// **'Card reissued'**
  String get cardReissued;

  /// No description provided for @tokenRotated.
  ///
  /// In en, this message translates to:
  /// **'Security token rotated'**
  String get tokenRotated;

  /// No description provided for @noEnrollments.
  ///
  /// In en, this message translates to:
  /// **'No enrollments'**
  String get noEnrollments;

  /// No description provided for @enrollStudent.
  ///
  /// In en, this message translates to:
  /// **'Enroll Student'**
  String get enrollStudent;

  /// No description provided for @dropEnrollment.
  ///
  /// In en, this message translates to:
  /// **'Drop Enrollment'**
  String get dropEnrollment;

  /// No description provided for @confirmDrop.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to drop this enrollment?'**
  String get confirmDrop;

  /// No description provided for @customAmount.
  ///
  /// In en, this message translates to:
  /// **'Custom Amount'**
  String get customAmount;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base Price'**
  String get basePrice;

  /// No description provided for @amountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Amount must be positive'**
  String get amountMustBePositive;

  /// No description provided for @duplicateCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Already checked in for this session'**
  String get duplicateCheckIn;

  /// No description provided for @sessionDateCancelled.
  ///
  /// In en, this message translates to:
  /// **'This date is cancelled for this session'**
  String get sessionDateCancelled;

  /// No description provided for @noStudentsEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No students enrolled in this session'**
  String get noStudentsEnrolled;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get personalInfo;

  /// No description provided for @financialStatus.
  ///
  /// In en, this message translates to:
  /// **'Financial Status'**
  String get financialStatus;

  /// No description provided for @parentApp.
  ///
  /// In en, this message translates to:
  /// **'Parent App'**
  String get parentApp;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQr;

  /// No description provided for @studentCard.
  ///
  /// In en, this message translates to:
  /// **'Student Card'**
  String get studentCard;

  /// No description provided for @idCard.
  ///
  /// In en, this message translates to:
  /// **'ID Card'**
  String get idCard;

  /// No description provided for @employmentStartDate.
  ///
  /// In en, this message translates to:
  /// **'Employment Start Date'**
  String get employmentStartDate;

  /// No description provided for @employmentEndDate.
  ///
  /// In en, this message translates to:
  /// **'Employment End Date'**
  String get employmentEndDate;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @filterByUser.
  ///
  /// In en, this message translates to:
  /// **'Filter by User'**
  String get filterByUser;

  /// No description provided for @allUsers.
  ///
  /// In en, this message translates to:
  /// **'All Users'**
  String get allUsers;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @absentCount.
  ///
  /// In en, this message translates to:
  /// **'Absent Count'**
  String get absentCount;

  /// No description provided for @cancellationCreated.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Created'**
  String get cancellationCreated;

  /// No description provided for @cancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled on'**
  String get cancelledOn;

  /// No description provided for @cardActive.
  ///
  /// In en, this message translates to:
  /// **'Card Active'**
  String get cardActive;

  /// No description provided for @cardNotFound.
  ///
  /// In en, this message translates to:
  /// **'Card Not Found'**
  String get cardNotFound;

  /// No description provided for @cardRevoked.
  ///
  /// In en, this message translates to:
  /// **'Card Revoked'**
  String get cardRevoked;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @confirmReissue.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reissue'**
  String get confirmReissue;

  /// No description provided for @entity.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entity;

  /// No description provided for @generateCard.
  ///
  /// In en, this message translates to:
  /// **'Generate Card'**
  String get generateCard;

  /// No description provided for @missing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get missing;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @noActiveSessionForTeacher.
  ///
  /// In en, this message translates to:
  /// **'No Active Session for Teacher'**
  String get noActiveSessionForTeacher;

  /// No description provided for @noAttendanceToday.
  ///
  /// In en, this message translates to:
  /// **'No Attendance Today'**
  String get noAttendanceToday;

  /// No description provided for @noAuditEntries.
  ///
  /// In en, this message translates to:
  /// **'No Audit Entries'**
  String get noAuditEntries;

  /// No description provided for @noStudentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Students Found'**
  String get noStudentsFound;

  /// No description provided for @outstandingDebtsList.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Debts'**
  String get outstandingDebtsList;

  /// No description provided for @presentCount.
  ///
  /// In en, this message translates to:
  /// **'Present Count'**
  String get presentCount;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @profitReport.
  ///
  /// In en, this message translates to:
  /// **'Profit Report'**
  String get profitReport;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @reissueConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will revoke the current card and generate a new token. Continue?'**
  String get reissueConfirmMessage;

  /// No description provided for @scanTeacherBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan teacher barcode...'**
  String get scanTeacherBarcode;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @sessionCancellation.
  ///
  /// In en, this message translates to:
  /// **'Session Cancellation'**
  String get sessionCancellation;

  /// No description provided for @sessionCharges.
  ///
  /// In en, this message translates to:
  /// **'Session Charges'**
  String get sessionCharges;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @studentCode.
  ///
  /// In en, this message translates to:
  /// **'Student Code'**
  String get studentCode;

  /// No description provided for @studentPayments.
  ///
  /// In en, this message translates to:
  /// **'Student Payments'**
  String get studentPayments;

  /// No description provided for @teacherAlreadyCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Teacher Already Checked In'**
  String get teacherAlreadyCheckedIn;

  /// No description provided for @teacherCheckin.
  ///
  /// In en, this message translates to:
  /// **'Teacher Check-in'**
  String get teacherCheckin;

  /// No description provided for @teacherCheckinSuccess.
  ///
  /// In en, this message translates to:
  /// **'Teacher Check-in Successful'**
  String get teacherCheckinSuccess;

  /// No description provided for @teacherNotFound.
  ///
  /// In en, this message translates to:
  /// **'Teacher Not Found'**
  String get teacherNotFound;

  /// No description provided for @upcomingCancellations.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Cancellations'**
  String get upcomingCancellations;

  /// No description provided for @totalCharged.
  ///
  /// In en, this message translates to:
  /// **'Total Charged'**
  String get totalCharged;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;
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
