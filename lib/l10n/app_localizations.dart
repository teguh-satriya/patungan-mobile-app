import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('en'),
    Locale('id')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Patungan'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Track your finances together'**
  String get tagline;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordMin.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get passwordMin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get noAccount;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful! Please login.'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navTransactions;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navTypes.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get navTypes;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}!'**
  String welcomeBack(String name);

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @projectedEndBalance.
  ///
  /// In en, this message translates to:
  /// **'Projected End Balance'**
  String get projectedEndBalance;

  /// No description provided for @carriedOver.
  ///
  /// In en, this message translates to:
  /// **'Carried Over'**
  String get carriedOver;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTitle;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month — {month} {year}'**
  String thisMonth(String month, int year);

  /// No description provided for @yearAllMonths.
  ///
  /// In en, this message translates to:
  /// **'Year {year} — All Months'**
  String yearAllMonths(int year);

  /// No description provided for @startingBalance.
  ///
  /// In en, this message translates to:
  /// **'Starting Balance'**
  String get startingBalance;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @carryOverButton.
  ///
  /// In en, this message translates to:
  /// **'Carry Over to Next Month'**
  String get carryOverButton;

  /// No description provided for @carryOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Carry Over'**
  String get carryOverTitle;

  /// No description provided for @carryOverContent.
  ///
  /// In en, this message translates to:
  /// **'Carry over the ending balance of {month} {year} to next month?'**
  String carryOverContent(String month, int year);

  /// No description provided for @carriedOverSuccess.
  ///
  /// In en, this message translates to:
  /// **'Carried over successfully'**
  String get carriedOverSuccess;

  /// No description provided for @budgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetTitle;

  /// No description provided for @overviewHeader.
  ///
  /// In en, this message translates to:
  /// **'Overview – {month}/{year}'**
  String overviewHeader(String month, int year);

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by Category'**
  String get spendingByCategory;

  /// No description provided for @transactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactionsTitle;

  /// No description provided for @newTransaction.
  ///
  /// In en, this message translates to:
  /// **'New Transaction'**
  String get newTransaction;

  /// No description provided for @editTransaction.
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get editTransaction;

  /// No description provided for @deleteTransaction.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get deleteTransaction;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

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

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Please select a transaction type'**
  String get selectType;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @typesTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Types'**
  String get typesTitle;

  /// No description provided for @newType.
  ///
  /// In en, this message translates to:
  /// **'New Type'**
  String get newType;

  /// No description provided for @editType.
  ///
  /// In en, this message translates to:
  /// **'Edit Type'**
  String get editType;

  /// No description provided for @deleteType.
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction Type'**
  String get deleteType;

  /// No description provided for @deleteTypeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String deleteTypeConfirm(String name);

  /// No description provided for @thisType.
  ///
  /// In en, this message translates to:
  /// **'this type'**
  String get thisType;

  /// No description provided for @noTypesYet.
  ///
  /// In en, this message translates to:
  /// **'No transaction types yet'**
  String get noTypesYet;

  /// No description provided for @typeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Transaction type deleted'**
  String get typeDeleted;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @tabCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow'**
  String get tabCashFlow;

  /// No description provided for @tabComparison.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get tabComparison;

  /// No description provided for @tabTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get tabTrend;

  /// No description provided for @tabCarryover.
  ///
  /// In en, this message translates to:
  /// **'Carryover'**
  String get tabCarryover;

  /// No description provided for @cashFlowSummary.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow Summary'**
  String get cashFlowSummary;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening Balance'**
  String get openingBalance;

  /// No description provided for @netCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Net Cash Flow'**
  String get netCashFlow;

  /// No description provided for @closingBalance.
  ///
  /// In en, this message translates to:
  /// **'Closing Balance'**
  String get closingBalance;

  /// No description provided for @incomeBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Income Breakdown'**
  String get incomeBreakdown;

  /// No description provided for @incomeVsExpenseChart.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpenseChart;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

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

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @selectDateRangePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select a date range and tap Show'**
  String get selectDateRangePrompt;

  /// No description provided for @overallComparison.
  ///
  /// In en, this message translates to:
  /// **'Overall Comparison'**
  String get overallComparison;

  /// No description provided for @netAmount.
  ///
  /// In en, this message translates to:
  /// **'Net Amount'**
  String get netAmount;

  /// No description provided for @monthlyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Monthly Breakdown'**
  String get monthlyBreakdown;

  /// No description provided for @incomeVsExpensePerMonth.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense per Month'**
  String get incomeVsExpensePerMonth;

  /// No description provided for @trendAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Trend Analysis ({months} months)'**
  String trendAnalysis(int months);

  /// No description provided for @avgIncome.
  ///
  /// In en, this message translates to:
  /// **'Avg Income'**
  String get avgIncome;

  /// No description provided for @avgExpense.
  ///
  /// In en, this message translates to:
  /// **'Avg Expense'**
  String get avgExpense;

  /// No description provided for @avgNet.
  ///
  /// In en, this message translates to:
  /// **'Avg Net'**
  String get avgNet;

  /// No description provided for @trendDirection.
  ///
  /// In en, this message translates to:
  /// **'Trend Direction'**
  String get trendDirection;

  /// No description provided for @balanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Balance History'**
  String get balanceHistory;

  /// No description provided for @monthlyTrends.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trends'**
  String get monthlyTrends;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get nature;

  /// No description provided for @iconOptional.
  ///
  /// In en, this message translates to:
  /// **'Icon (optional)'**
  String get iconOptional;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @carryoverSummary.
  ///
  /// In en, this message translates to:
  /// **'Carryover Summary'**
  String get carryoverSummary;

  /// No description provided for @totalCarriedOver.
  ///
  /// In en, this message translates to:
  /// **'Total Carried Over'**
  String get totalCarriedOver;

  /// No description provided for @avgCarryover.
  ///
  /// In en, this message translates to:
  /// **'Average Carryover'**
  String get avgCarryover;

  /// No description provided for @monthlyDetail.
  ///
  /// In en, this message translates to:
  /// **'Monthly Detail'**
  String get monthlyDetail;

  /// No description provided for @startLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startLabel;

  /// No description provided for @endLabel.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endLabel;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @monthJanFull.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanFull;

  /// No description provided for @monthFebFull.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebFull;

  /// No description provided for @monthMarFull.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarFull;

  /// No description provided for @monthAprFull.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthAprFull;

  /// No description provided for @monthMayFull.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMayFull;

  /// No description provided for @monthJunFull.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJunFull;

  /// No description provided for @monthJulFull.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJulFull;

  /// No description provided for @monthAugFull.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugFull;

  /// No description provided for @monthSepFull.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSepFull;

  /// No description provided for @monthOctFull.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctFull;

  /// No description provided for @monthNovFull.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovFull;

  /// No description provided for @monthDecFull.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecFull;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
