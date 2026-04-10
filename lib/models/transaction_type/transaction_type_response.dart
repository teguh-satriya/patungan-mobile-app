class TransactionTypeResponse {
  final int id;
  final String? name;
  final String? icon;
  final String? nature;
  final String? description;
  final int userId;

  TransactionTypeResponse({
    required this.id,
    this.name,
    this.icon,
    this.nature,
    this.description,
    required this.userId,
  });

  factory TransactionTypeResponse.fromJson(Map<String, dynamic> json) =>
      TransactionTypeResponse(
        id: json['id'] ?? 0,
        name: json['name']?.toString(),
        icon: json['icon']?.toString(),
        nature: json['nature'] is int
            ? (json['nature'] == 0 ? 'income' : 'outcome')
            : json['nature']?.toString(),
        description: json['description']?.toString(),
        userId: json['userId'] ?? 0,
      );
}
