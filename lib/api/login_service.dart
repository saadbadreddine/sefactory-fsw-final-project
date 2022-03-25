import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/login_model.dart';
import '../page/login_page.dart';

class LoginService {
  Future<LoginResponse> login(LoginRequest requestModel) async {
    String uri = 'https://192.168.1.4:4000/api/login';
    final response = await http.post(Uri.parse(uri),
        body: json.encode(requestModel.toJson()));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to login.');
    }
  }
}

class RefreshTokenService {
  Future<RefreshTokenResponse> refresh(String token) async {
    String uri = 'https://192.168.1.4:4000/api/auth/refresh';
    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RefreshTokenResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Unauthorized');
    }
  }
}
