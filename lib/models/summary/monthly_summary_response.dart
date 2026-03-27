class MonthlySummaryResponse {
  final int id;
  final int userId;
  final int year;
  final int month;
  final double startingBalance;
  final double endingBalance;
  final double carriedOver;
  final double totalIncome;
  final double totalExpense;
  final DateTime createdAt;

  MonthlySummaryResponse({
    required this.id,
    required this.userId,
    required this.year,
    required this.month,
    required this.startingBalance,
    required this.endingBalance,
    required this.carriedOver,
    required this.totalIncome,
    required this.totalExpense,
    required this.createdAt,
  });

  factory MonthlySummaryResponse.fromJson(Map<String, dynamic> json) =>
      MonthlySummaryResponse(
        id: json['id'] ?? 0,
        userId: json['userId'] ?? 0,
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        startingBalance: (json['startingBalance'] ?? 0).toDouble(),
        endingBalance: (json['endingBalance'] ?? 0).toDouble(),
        carriedOver: (json['carriedOver'] ?? 0).toDouble(),
        totalIncome: (json['totalIncome'] ?? 0).toDouble(),
        totalExpense: (json['totalExpense'] ?? 0).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      );
}
