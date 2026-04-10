class CreateTransactionTypeRequest {
  final int userId;
  final String name;
  final String nature; // TransactionNature.income or TransactionNature.outcome
  final String? description;
  final String? icon;

  CreateTransactionTypeRequest({
    required this.userId,
    required this.name,
    required this.nature,
    this.description,
    this.icon,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userId': userId,
      'name': name,
      'nature': nature,
    };
    if (description != null) map['description'] = description;
    if (icon != null) map['icon'] = icon;
    return map;
  }
}
