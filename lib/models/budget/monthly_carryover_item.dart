class MonthlyCarryoverItem {
  final int year;
  final int month;
  final double carriedOver;
  final double startingBalance;
  final double endingBalance;

  MonthlyCarryoverItem({
    required this.year,
    required this.month,
    required this.carriedOver,
    required this.startingBalance,
    required this.endingBalance,
  });

  factory MonthlyCarryoverItem.fromJson(Map<String, dynamic> json) =>
      MonthlyCarryoverItem(
        year: json['year'] ?? 0,
        month: json['month'] ?? 0,
        carriedOver: (json['carriedOver'] ?? 0).toDouble(),
        startingBalance: (json['startingBalance'] ?? 0).toDouble(),
        endingBalance: (json['endingBalance'] ?? 0).toDouble(),
      );
}
