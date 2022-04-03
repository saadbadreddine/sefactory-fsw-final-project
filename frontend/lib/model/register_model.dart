class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;
  String dob;
  String gender;
  String phoneNumber;

  RegisterRequest(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.dob,
      required this.gender,
      required this.phoneNumber});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'dob': dob.trim(),
      'gender': gender.trim(),
      'phone_number': phoneNumber.trim(),
    };

    return map;
  }
}

class RegisterResponse {
  final String message;
  final String error;

  RegisterResponse({required this.message, required this.error});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
        message: json["message"] ?? "", error: json["error"] ?? "");
  }
}
