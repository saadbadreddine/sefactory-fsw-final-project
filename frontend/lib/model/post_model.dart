import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hustle_app/utils/storage.dart';
import 'package:hustle_app/widget/post_card_widget.dart';

class Post {
  int postID;
  int userID;
  int sportID;
  String time;
  String message;
  String lat;
  String long;
  Map<String, dynamic> user;
  Map<String, dynamic> sport;

  Post({
    required this.postID,
    required this.userID,
    required this.sportID,
    required this.time,
    required this.message,
    required this.lat,
    required this.long,
    required this.user,
    required this.sport,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postID: json["ID"] ?? '',
      userID: json["UserID"] ?? '',
      sportID: json["sport_id"] ?? '',
      time: json["time"] ?? '',
      message: json["message"] ?? "",
      lat: json["latitude"] ?? '',
      long: json["longitude"] ?? '',
      user: json["User"],
      sport: json["Sport"],
    );
  }

  Marker toMarker(String firstName, String lastName, String sport, String time,
      String _firebaseID, String imgURL, BuildContext context) {
    Marker marker = Marker(
        markerId: firebaseID == _firebaseID
            ? MarkerId(postID.toString())
            : MarkerId("$firebaseID //& ${postID.toString()}"),
        position: LatLng(double.parse(lat), double.parse(long)),
        infoWindow: const InfoWindow(title: ""),
        icon: firebaseID == _firebaseID
            ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
            : BitmapDescriptor.defaultMarker,
        onTap: firebaseID == _firebaseID
            ? () {}
            : () async {
                return showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return PostCard(
                      context: context,
                      firebaseID: _firebaseID,
                      firstName: firstName,
                      lastName: lastName,
                      time: time,
                      message: message,
                      sport: sport,
                      imageURL: imgURL,
                      postID: postID,
                      isOnMap: true,
                      onDeletedPost: () {},
                      onRequestSent: () {},
                    );
                  },
                );
              });

    return marker;
  }
}

class GetPostsResponse {
  final String message;
  final String error;
  final List data;

  GetPostsResponse(
      {required this.message, required this.error, required this.data});

  factory GetPostsResponse.fromJson(Map<String, dynamic> json) {
    return GetPostsResponse(
        message: json["message"] ?? "",
        data: json["data"] ?? "",
        error: json["error"] ?? "");
  }
}

class PostRequest {
  int sportID;
  String time;
  String message;
  String lat;
  String long;

  PostRequest({
    required this.sportID,
    required this.time,
    required this.message,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'sport_id': sportID,
      'time': time.trim(),
      'message': message.trim(),
      'latitude': lat.trim(),
      'longitude': long.trim(),
    };

    return map;
  }
}

class PostResponse {
  final String message;
  final String error;
  final int postID;

  PostResponse(
      {required this.message, required this.error, required this.postID});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
        message: json["message"] ?? "",
        error: json["error"] ?? "",
        postID: json["pid"] ?? 0);
  }
}

class DeletePostRequest {
  final int postID;

  DeletePostRequest({required this.postID});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'post_id': postID,
    };

    return map;
  }
}

class DeletePostResponse {
  final String message;
  final String error;

  DeletePostResponse({required this.message, required this.error});

  factory DeletePostResponse.fromJson(Map<String, dynamic> json) {
    return DeletePostResponse(
      message: json["message"] ?? "",
      error: json["error"] ?? "",
    );
  }
}
