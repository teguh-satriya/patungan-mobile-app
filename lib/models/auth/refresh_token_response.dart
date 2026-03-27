class RefreshTokenResponse {
  final String? accessToken;
  final String? refreshToken;
  final DateTime expiresAt;

  RefreshTokenResponse({this.accessToken, this.refreshToken, required this.expiresAt});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      RefreshTokenResponse(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
      );
}
