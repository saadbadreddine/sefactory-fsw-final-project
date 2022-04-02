import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'home_page.dart';
import 'login_page.dart';
import '../api/auth_service.dart';
import '../utils/storage.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String _tokenString = '';
  String _firebaseID = '';

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _getTokenString().then((value) {
      if (_tokenString == '') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        RefreshTokenService loginService = RefreshTokenService();
        loginService.refresh(_tokenString).then((value) async => {
              if (value.error == 'Unauthorized')
                {
                  await storage.deleteAll().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  }),
                }
              else if (value.token != '')
                {
                  await storage.write(key: 'jwt', value: value.token),
                  jwtToken = value.token,
                  firebaseID = _firebaseID,
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home())),
                }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.onSurface)));
  }

  _getTokenString() async {
    _tokenString = await getToken();
    _firebaseID = await getFirebaseID();
  }

  _initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    String? token = await messaging.getToken(
      vapidKey: "BGpdLRs......",
    );
    print('User granted permission: ${settings.authorizationStatus}');
    print(token);
  }
}
