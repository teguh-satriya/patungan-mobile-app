class TransactionNature {
  TransactionNature._();

  static const String income = 'income';
  static const String outcome = 'outcome';

  static const List<String> values = [income, outcome];

  static String label(String nature) =>
      nature == income ? 'Income' : 'Outcome';
}
