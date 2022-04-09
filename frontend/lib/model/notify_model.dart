class Notification {
  String firstName;
  String lastName;
  String message;
  String receiverToken;

  Notification(
      {required this.firstName,
      required this.lastName,
      required this.message,
      required this.receiverToken});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'first_name': firstName.trim(),
      'last_name': lastName.trim(),
      'message': message.trim(),
      'receiver_token': receiverToken.trim(),
    };

    return map;
  }
}
