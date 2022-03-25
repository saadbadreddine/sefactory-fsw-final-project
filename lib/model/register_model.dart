class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;
  String dob;
  String gender;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'dob': dob.trim(),
      'gender': gender.trim(),
    };

    return map;
  }
}
