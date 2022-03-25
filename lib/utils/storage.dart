import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

loadEnv() async {
  await dotenv.load(fileName: "assets/.env");
}

mergeEnv(String jwtToken, String firebaseToken) async {
  await dotenv.load(
      fileName: "assets/.env",
      mergeWith: {'JWT_TOKEN': jwtToken, 'FIREBASE_TOKEN': firebaseToken});
}
