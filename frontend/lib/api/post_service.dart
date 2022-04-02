import 'package:http/http.dart' as http;
import 'package:hustle_app/utils/storage.dart';
import 'dart:convert';

import '../model/post_model.dart';

class PostService {
  Future<PostResponse> post(PostRequest requestModel, String? token) async {
    String uri = apiURL + '/api/auth/post';
    final response = await http.post(Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestModel.toJson()));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return PostResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to post.');
    }
  }

  Future<DeletePostResponse> deletePost(
      DeletePostRequest requestModel, String? token) async {
    String uri = apiURL + '/api/auth/remove-post';
    final response = await http.post(Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestModel.toJson()));

    if (response.statusCode == 200 || response.statusCode == 400) {
      return DeletePostResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to delete post.');
    }
  }

  Future<GetPostsResponse> getPosts(String token) async {
    String uri =apiURL + '/api/auth/get-posts';
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 400) {
      return GetPostsResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Failed to get posts.');
    }
  }
}
