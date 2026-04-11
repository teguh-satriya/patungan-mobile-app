// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Patungan';

  @override
  String get tagline => 'Track your finances together';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get required => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get noData => 'No data';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get language => 'Language';

  @override
  String get email => 'Email';

  @override
  String get emailInvalid => 'Enter a valid email';

  @override
  String get password => 'Password';

  @override
  String get passwordMin => 'Min 6 characters';

  @override
  String get username => 'Username';

  @override
  String get loginButton => 'Login';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get noAccount => 'Don\'t have an account? Register';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerButton => 'Register';

  @override
  String get registerSuccess => 'Registration successful! Please login.';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get navHome => 'Home';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navTypes => 'Types';

  @override
  String welcomeBack(String name) {
    return 'Welcome back, $name!';
  }

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get projectedEndBalance => 'Projected End Balance';

  @override
  String get carriedOver => 'Carried Over';

  @override
  String get transactions => 'Transactions';

  @override
  String get summaryTitle => 'Summary';

  @override
  String thisMonth(String month, int year) {
    return 'This Month — $month $year';
  }

  @override
  String yearAllMonths(int year) {
    return 'Year $year — All Months';
  }

  @override
  String get startingBalance => 'Starting Balance';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get totalExpense => 'Total Expense';

  @override
  String get carryOverButton => 'Carry Over to Next Month';

  @override
  String get carryOverTitle => 'Carry Over';

  @override
  String carryOverContent(String month, int year) {
    return 'Carry over the ending balance of $month $year to next month?';
  }

  @override
  String get carriedOverSuccess => 'Carried over successfully';

  @override
  String get budgetTitle => 'Budget';

  @override
  String overviewHeader(String month, int year) {
    return 'Overview – $month/$year';
  }

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get transactionsTitle => 'Transactions';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get editTransaction => 'Edit Transaction';

  @override
  String get deleteTransaction => 'Delete Transaction';

  @override
  String get transactionType => 'Transaction Type';

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes';

  @override
  String get selectType => 'Please select a transaction type';

  @override
  String get done => 'Done';

  @override
  String get typesTitle => 'Transaction Types';

  @override
  String get newType => 'New Type';

  @override
  String get editType => 'Edit Type';

  @override
  String get deleteType => 'Delete Transaction Type';

  @override
  String deleteTypeConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get thisType => 'this type';

  @override
  String get noTypesYet => 'No transaction types yet';

  @override
  String get typeDeleted => 'Transaction type deleted';

  @override
  String get reportsTitle => 'Reports';

  @override
  String get tabCashFlow => 'Cash Flow';

  @override
  String get tabComparison => 'Comparison';

  @override
  String get tabTrend => 'Trend';

  @override
  String get tabCarryover => 'Carryover';

  @override
  String get cashFlowSummary => 'Cash Flow Summary';

  @override
  String get openingBalance => 'Opening Balance';

  @override
  String get netCashFlow => 'Net Cash Flow';

  @override
  String get closingBalance => 'Closing Balance';

  @override
  String get incomeBreakdown => 'Income Breakdown';

  @override
  String get incomeVsExpenseChart => 'Income vs Expense';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get show => 'Show';

  @override
  String get selectDateRangePrompt => 'Select a date range and tap Show';

  @override
  String get overallComparison => 'Overall Comparison';

  @override
  String get netAmount => 'Net Amount';

  @override
  String get monthlyBreakdown => 'Monthly Breakdown';

  @override
  String get incomeVsExpensePerMonth => 'Income vs Expense per Month';

  @override
  String trendAnalysis(int months) {
    return 'Trend Analysis ($months months)';
  }

  @override
  String get avgIncome => 'Avg Income';

  @override
  String get avgExpense => 'Avg Expense';

  @override
  String get avgNet => 'Avg Net';

  @override
  String get trendDirection => 'Trend Direction';

  @override
  String get balanceHistory => 'Balance History';

  @override
  String get monthlyTrends => 'Monthly Trends';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get name => 'Name';

  @override
  String get update => 'Update';

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get nature => 'Nature';

  @override
  String get iconOptional => 'Icon (optional)';

  @override
  String get noTransactionsYet => 'No transactions yet';

  @override
  String get dateLabel => 'Date';

  @override
  String get error => 'Error';

  @override
  String get carryoverSummary => 'Carryover Summary';

  @override
  String get totalCarriedOver => 'Total Carried Over';

  @override
  String get avgCarryover => 'Average Carryover';

  @override
  String get monthlyDetail => 'Monthly Detail';

  @override
  String get startLabel => 'Start';

  @override
  String get endLabel => 'End';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get monthJanFull => 'January';

  @override
  String get monthFebFull => 'February';

  @override
  String get monthMarFull => 'March';

  @override
  String get monthAprFull => 'April';

  @override
  String get monthMayFull => 'May';

  @override
  String get monthJunFull => 'June';

  @override
  String get monthJulFull => 'July';

  @override
  String get monthAugFull => 'August';

  @override
  String get monthSepFull => 'September';

  @override
  String get monthOctFull => 'October';

  @override
  String get monthNovFull => 'November';

  @override
  String get monthDecFull => 'December';
}
