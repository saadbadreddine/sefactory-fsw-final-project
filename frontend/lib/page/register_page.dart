import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/auth_service.dart';
import '../model/register_model.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  late bool _isObscure;

  late RegisterRequest registerRequest;

  TextEditingController dateCtl = TextEditingController();

  Future _selectDate() async {
    DateTime? date = DateTime(1900);

    date = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1930),
      lastDate: DateTime(2005),
    );

    return date;
  }

  @override
  void initState() {
    super.initState();
    registerRequest = RegisterRequest(
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        dob: '',
        gender: '');
    _isObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: const Text('Sign up')),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  kBottomNavigationBarHeight,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'First Name',
                            ),
                            keyboardType: TextInputType.name,
                            onSaved: (input) =>
                                registerRequest.firstName = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String pattern = r'^[a-zA-Z]+$';
                              RegExp regex = RegExp(pattern);
                              if (value == null ||
                                  value.isEmpty ||
                                  !regex.hasMatch(value)) {
                                return 'Enter a valid name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              labelText: 'Last Name',
                            ),
                            keyboardType: TextInputType.name,
                            onSaved: (input) =>
                                registerRequest.lastName = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String pattern = r'^[a-zA-Z]+$';
                              RegExp regex = RegExp(pattern);
                              if (value == null ||
                                  value.isEmpty ||
                                  !regex.hasMatch(value)) {
                                return 'Enter a valid name';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (input) => registerRequest.email = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String pattern =
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                              RegExp regex = RegExp(pattern);
                              if (value == null ||
                                  value.isEmpty ||
                                  !regex.hasMatch(value)) {
                                return 'Enter a valid email address';
                              } else {
                                return null;
                              }
                            },
                          ),
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
                            onSaved: (input) =>
                                registerRequest.password = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          TextFormField(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectDate().then(
                                (value) {
                                  if (value != null) {
                                    //print(date.toIso8601String());
                                    registerRequest.dob = value.toString();
                                    dateCtl.text =
                                        DateFormat('dd-MM-yyyy').format(value);
                                  }
                                },
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your date of birth';
                              }
                              return null;
                            },
                            onSaved: (input) => registerRequest.dob = input!,
                            controller: dateCtl,
                            enableInteractiveSelection: false,
                            decoration: const InputDecoration(
                                labelText: "Date of birth",
                                hintText: "Ex. Insert your dob",
                                icon: Icon(Icons.calendar_month)),
                            maxLines: 1,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: _myRadioButton(
                                    title: "Male",
                                    value: 0,
                                    onChanged: (newValue) {
                                      setState(() => _groupValue = newValue!);
                                      registerRequest.gender = 'male';
                                    }),
                              ),
                              Expanded(
                                flex: 1,
                                child: _myRadioButton(
                                    title: "Female",
                                    value: 1,
                                    onChanged: (newValue) {
                                      setState(() => _groupValue = newValue!);
                                      registerRequest.gender = 'female';
                                    }),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _myRadioButton(
                                    title: "Other",
                                    value: 2,
                                    onChanged: (newValue) {
                                      setState(() => _groupValue = newValue!);
                                      registerRequest.gender = 'other';
                                    }),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 70.0),
                            child: SizedBox(
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
                                    RegisterService registerService =
                                        RegisterService();
                                    registerService
                                        .register(registerRequest)
                                        .then((value) async => {
                                              if (value.error.isNotEmpty)
                                                {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        content:
                                                            Text(value.error)),
                                                  )
                                                }
                                              else
                                                {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    1500),
                                                        content: Text(
                                                            value.message)),
                                                  )
                                                }
                                            });
                                  }
                                },
                                child: const Text('Sign up'),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

int _groupValue = -1;
Widget _myRadioButton(
    {required String title,
    required int value,
    required Function(int?) onChanged}) {
  return RadioListTile(
    value: value,
    groupValue: _groupValue,
    onChanged: onChanged,
    title: Text(title),
  );
}