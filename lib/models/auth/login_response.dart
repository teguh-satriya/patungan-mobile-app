class LoginResponse {
  final int userId;
  final String? userName;
  final String? email;
  final String? token;
  final String? refreshToken;
  final DateTime expiresAt;

  LoginResponse({
    required this.userId,
    this.userName,
    this.email,
    this.token,
    this.refreshToken,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userId: json['userId'] ?? 0,
        userName: json['userName'],
        email: json['email'],
        token: json['token'],
        refreshToken: json['refreshToken'],
        expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
      );
}
