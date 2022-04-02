import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import '../model/login_model.dart';
import '../api/auth_service.dart';
import '../utils/storage.dart';
import 'home_page.dart';
import 'register_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  static const String assetName = 'assets/images/hustle.svg';
  final _formKey = GlobalKey<FormState>();
  late LoginRequest loginRequest;
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    loginRequest = LoginRequest(email: '', password: '');
    _isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    final Widget svg = SvgPicture.asset(
      assetName,
      semanticsLabel: 'Hustle Logo',
      color: Theme.of(context).colorScheme.onSurface,
    );
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                kBottomNavigationBarHeight +
                kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 280, child: svg),
                const SizedBox(height: 45),
                Form(
                  key: _formKey,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 330),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => loginRequest.email = input!,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            RegExp regex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (value == null ||
                                value.isEmpty ||
                                !regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            errorMaxLines: 3,
                            icon: const Icon(Icons.lock),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _isObscure,
                          onSaved: (input) => loginRequest.password = input!,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (!RegExp(
                                    "^(?=.*[a-z])(?=.*[A-Z])(?=.*)[a-zA-Z](?=.*[0-9]).{8,}")
                                .hasMatch(value)) {
                              return 'Password must be at least 8 characters including 1 uppercase letter and 1 number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => Colors.transparent),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Register()));
                          },
                          child: const Text("Don't have an account? Sign up."),
                        ),
                        SizedBox(
                          width: 130,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _formKey.currentState!.save();
                                });
                                LoginService loginService = LoginService();
                                loginService
                                    .login(loginRequest)
                                    .then((value) async => {
                                          if (value.token.isNotEmpty)
                                            {
                                              await storage.write(
                                                  key: 'jwt',
                                                  value: value.token),
                                              await storage.write(
                                                  key: 'firebase_id',
                                                  value: value.firebaseID),
                                              jwtToken = value.token,
                                              firebaseID = value.firebaseID,
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Home()),
                                              ),
                                            }
                                          else
                                            {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    duration: const Duration(
                                                        milliseconds: 1500),
                                                    content: Text(value.error)),
                                              )
                                            }
                                        });
                              }
                            },
                            child: const Text('Sign in'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}