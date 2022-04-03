class User {
  String firebaseToken;
  String firstName;
  String lastName;
  String email;
  String aboutMe;
  String imageURL;
  String dob;
  String gender;
  String phoneNumber;

  User({
    required this.firebaseToken,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.aboutMe,
    required this.imageURL,
    required this.dob,
    required this.gender,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        firebaseToken: json["firebase_token"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        email: json["email"] ?? '',
        aboutMe: json["about_me"] ?? "",
        imageURL: json['avatar_url'] ?? "",
        dob: json['dob'] ?? "",
        gender: json['gender'] ?? "",
        phoneNumber: json['phone_number']);
  }
}

class GetProfileResponse {
  Map<String, dynamic> data;
  final String message;

  GetProfileResponse({required this.data, required this.message});

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) {
    return GetProfileResponse(
        data: json["data"] ?? "", message: json["message"] ?? "");
  }
}

class EditProfileResponse {
  final String data;
  final String message;
  final String? error;

  EditProfileResponse({required this.data, required this.message, this.error});

  factory EditProfileResponse.fromJson(Map<String, dynamic> json) {
    return EditProfileResponse(
        data: json["data"] ?? "",
        message: json["message"] ?? "",
        error: json["error"] ?? "");
  }
}

class EditProfileRequest {
  String? firstName;
  String? lastName;
  String? password;
  String? email;
  String? aboutMe;
  String? imageURL;
  String? firebaseToken;

  EditProfileRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.aboutMe,
    this.imageURL,
    this.firebaseToken,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'first_name': firstName,
      'last_name': lastName,
      'password': password,
      'email': email,
      'about_me': aboutMe,
      'avatar_url': imageURL,
      'firebase_token': firebaseToken
    };

    return map;
  }
}
