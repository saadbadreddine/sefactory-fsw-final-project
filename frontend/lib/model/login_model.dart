class LoginRequest {
  String email;
  String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}

class LoginResponse {
  final String token;
  final String firebaseToken;
  final String error;

  LoginResponse(
      {required this.token, required this.firebaseToken, required this.error});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        token: json["token"] ?? "",
        firebaseToken: json["firebase_token"] ?? "",
        error: json["error"] ?? "");
  }
}

class RefreshTokenResponse {
  final String token;
  final String error;

  RefreshTokenResponse({required this.token, required this.error});

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
        token: json["token"] ?? "", error: json["error"] ?? "");
  }
}
