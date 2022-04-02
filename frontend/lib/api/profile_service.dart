import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hustle_app/utils/storage.dart';

import '../model/user_model.dart';

class ProfileService {
  Future<GetProfileResponse> getProfile(String token) async {
    String uri = apiURL + '/api/auth/user';
    final response = await http.get(Uri.parse(uri), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200 || response.statusCode == 400) {
      return GetProfileResponse.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 401) {
      return GetProfileResponse(message: 'Unauthorized', data: {});
    } else {
      throw Exception('Fetching profile info failed');
    }
  }

  Future<EditProfileResponse> editProfile(
      String token, EditProfileRequest editProfileRequest) async {
    String uri = apiURL + '/api/auth/update-profile';
    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(editProfileRequest.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return EditProfileResponse.fromJson(
        json.decode(response.body),
      );
    } else if (response.statusCode == 401) {
      return EditProfileResponse(message: 'Unauthorized', data: "");
    } else {
      throw Exception('Editing profile info failed');
    }
  }
}
