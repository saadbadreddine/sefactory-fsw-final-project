import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/register_model.dart';

class RegisterService {
  Future<RegisterResponse> register(RegisterRequest requestModel) async {
    String uri = dotenv.env['API_URL']! + '/api/register';
    final response = await http.post(Uri.parse(uri),
        body: json.encode(requestModel.toJson()));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegisterResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to sign up.');
    }
  }
}
