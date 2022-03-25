import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'login_page.dart';
import '../api/login_service.dart';
import '../utils/storage.dart';

String _tokenString = '';
String _firebaseTokenString = '';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  _getTokenString() async {
    _tokenString = await getTokenFutureString();
    _firebaseTokenString = await getFirebaseTokenFutureString();
  }

  _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    loadEnv();
    _getTokenString().then((value) {
      if (_tokenString == '') {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      } else {
        RefreshTokenService loginService = RefreshTokenService();
        loginService.refresh(_tokenString).then((value) async => {
              if (value.error.isNotEmpty)
                {
                  await storage.deleteAll().then((value) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  }),
                }
              else
                {
                  await storage.write(key: 'jwt', value: value.token).then(
                        mergeEnv(_tokenString, _firebaseTokenString).then(
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Home())),
                        ),
                      ),
                }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
