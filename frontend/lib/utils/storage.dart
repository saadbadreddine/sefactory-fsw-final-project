import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

const apiURL = "https://ec2-52-87-248-51.compute-1.amazonaws.com:8080";
String? jwtToken;
String? firebaseToken;
String? email;
UserCredential? userCredential;
String? firstName;
String? lastName;
String? phoneNumber;
String? imgURL;

Future deleteStorage() async {
  await storage.deleteAll();
}

getToken() async {
  String token = await storage.read(key: 'jwt') ?? '';

  return token;
}

getEmail() async {
  String token = await storage.read(key: 'email') ?? '';

  return token;
}

getfirebaseToken() async {
  String firebaseToken = await storage.read(key: 'firebase_token') ?? '';

  return firebaseToken;
}
