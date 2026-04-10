class RegistrationRequest {
  final String? userName;
  final String? email;
  final String? password;
  final String? googleId;

  RegistrationRequest({this.userName, this.email, this.password, this.googleId});

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'userName': userName,
      'email': email,
      'password': password,
    };
    if (googleId != null) map['googleId'] = googleId;
    return map;
  }
}
