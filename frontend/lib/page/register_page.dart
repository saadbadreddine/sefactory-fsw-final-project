import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? selectedValue;
  List<String> items = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    registerRequest = RegisterRequest(
        email: '',
        password: '',
        firstName: '',
        lastName: '',
        dob: '',
        gender: '',
        phoneNumber: '');
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
                              icon: Icon(Icons.phone),
                              labelText: 'Phone Number',
                            ),
                            keyboardType: TextInputType.phone,
                            onSaved: (input) =>
                                registerRequest.phoneNumber = input!,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              String pattern = r'(^(?:[+0]9)?[0-9]{10,13}$)';
                              RegExp regex = RegExp(pattern);
                              if (value == null ||
                                  value.isEmpty ||
                                  !regex.hasMatch(value)) {
                                return 'Enter a valid phone number';
                              } else {
                                return null;
                              }
                            },
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]')),
                            ],
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
                                    dateCtl.text = DateFormat('dd - MM - yyyy')
                                        .format(value);
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
                                labelText: "Date Of Birth",
                                hintText: "Ex. Insert your dob",
                                icon: Icon(Icons.calendar_month)),
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).hintColor,
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              DropdownButton2(
                                isExpanded: true,
                                hint: Row(
                                  children: const [
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Select Gender',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                value: selectedValue,
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value as String;
                                    if (selectedValue == "Male") {
                                      registerRequest.gender = "male";
                                    } else if (selectedValue == "Female") {
                                      registerRequest.gender = "female";
                                    } else if (selectedValue == "Other") {
                                      registerRequest.gender = "other";
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_outlined,
                                ),
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.secondary,
                                iconDisabledColor:
                                    Theme.of(context).disabledColor,
                                buttonHeight: 75,
                                buttonWidth: 310,
                                buttonPadding:
                                    const EdgeInsets.only(left: 0, right: 0),
                                itemHeight: 40,
                                itemPadding:
                                    const EdgeInsets.only(left: 30, right: 14),
                                dropdownMaxHeight: 200,
                                dropdownWidth: 200,
                                dropdownPadding: null,
                                dropdownElevation: 8,
                                buttonDecoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor),
                                scrollbarRadius: const Radius.circular(40),
                                scrollbarThickness: 6,
                                scrollbarAlwaysShow: true,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 0, 50),
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
