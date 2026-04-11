
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
    static String get baseUrl {
        final isDev = dotenv.env['DEVELOPMENT_MODE'] == 'true';
        return isDev
                ? dotenv.env['API_BASE_URL'] ?? ''
                : dotenv.env['API_BASE_URL_PROD'] ?? '';
    }

  // Auth
  static const String register = '/api/Auth/register';
  static const String login = '/api/Auth/login';
  static const String refreshToken = '/api/Auth/refresh-token';
  static const String revokeToken = '/api/Auth/revoke-token';

  // Budget
  static String budgetOverview(int userId, int year, int month) =>
      '/api/Budget/overview/$userId/$year/$month';
  static String spendingByType(int userId, int year, int month) =>
      '/api/Budget/spending-by-type/$userId/$year/$month';
  static String projectedBalance(int userId, int year, int month) =>
      '/api/Budget/projected-balance/$userId/$year/$month';
  static String carryoverHistory(
          int userId, int fromYear, int fromMonth, int toYear, int toMonth) =>
      '/api/Budget/carryover-history/$userId?fromYear=$fromYear&fromMonth=$fromMonth&toYear=$toYear&toMonth=$toMonth';

  // Monthly Summary
  static String monthlySummary(int userId, int year, int month) =>
      '/api/MonthlySummary/$userId/$year/$month';
  static String yearlySummary(int userId, int year) =>
      '/api/MonthlySummary/yearly/$userId/$year';
  static String recalculateSummary(int userId, int year, int month) =>
      '/api/MonthlySummary/recalculate/$userId/$year/$month';
  static String carryoverSummary(int userId, int year, int month) =>
      '/api/MonthlySummary/carryover/$userId/$year/$month';

  // Reports
  static String cashflow(int userId, int year, int month) =>
      '/api/Report/cashflow/$userId/$year/$month';
  static String incomeExpenseComparison(
          int userId, int startYear, int startMonth, int endYear, int endMonth) =>
      '/api/Report/income-expense-comparison/$userId?startYear=$startYear&startMonth=$startMonth&endYear=$endYear&endMonth=$endMonth';
  static String trendAnalysis(int userId) =>
      '/api/Report/trend-analysis/$userId';

  // Transaction Types
  static const String transactionType = '/api/TransactionType';
  static String transactionTypeByUser(int userId) =>
      '/api/TransactionType/user/$userId';
  static String transactionTypeById(int id) => '/api/TransactionType/$id';

  // Transactions
  static const String transaction = '/api/Transaction';
  static String transactionById(int id) => '/api/Transaction/$id';
  static String monthlyTransactions(int userId, int year, int month) =>
      '/api/Transaction/monthly/$userId/$year/$month';
  static String transactionsByType(int userId, int typeId) =>
      '/api/Transaction/by-type/$userId/$typeId';
  static String incomeTransactions(int userId, int year, int month) =>
      '/api/Transaction/income/$userId/$year/$month';
  static String expenseTransactions(int userId, int year, int month) =>
      '/api/Transaction/expense/$userId/$year/$month';
}
