import 'dart:io';
import 'package:hustle_app/utils/storage.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../api/profile_service.dart';
import '../model/user_model.dart';
import '../widget/profile_widget.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final VoidCallback onProfileChanged;

  const EditProfilePage(
      {Key? key, required this.user, required this.onProfileChanged})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final EditProfileRequest _editProfileRequest = EditProfileRequest();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  File? _photo;
  late String downloadURL;
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = true;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
          ),
          leading:
              BackButton(color: Theme.of(context).colorScheme.onBackground),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: ListView(children: [
          ProfileWidget(
            imagePath: widget.user.imageURL,
            onClicked: () async {
              _showPicker(context);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: widget.user.firstName,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'First Name',
                    ),
                    onChanged: (input) => setState(() {
                      widget.user.firstName = input;
                      _editProfileRequest.firstName = input;
                    }),
                    keyboardType: TextInputType.name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    initialValue: widget.user.lastName,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Last Name',
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (input) => setState(() {
                      widget.user.lastName = input;
                      _editProfileRequest.lastName = input;
                    }),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    decoration: InputDecoration(
                      errorMaxLines: 3,
                      icon: const Icon(Icons.lock),
                      labelText: 'Enter New Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,
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
                    onChanged: (input) => _editProfileRequest.password = input,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!RegExp(
                              "^(?=.*[a-z])(?=.*[A-Z])(?=.*)[a-zA-Z](?=.*[0-9]).{8,}")
                          .hasMatch(value)) {
                        return 'Password must be at least 8 characters including 1 uppercase letter and 1 number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: widget.user.aboutMe,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (_editProfileRequest.aboutMe == null) {
                        return null;
                      } else if (value == null || value.isEmpty) {
                        return 'Say something about yourself      (╯°□°)╯︵ ┻━┻ ';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (input) => setState(() {
                      widget.user.aboutMe = input;
                      _editProfileRequest.aboutMe = input;
                    }),
                    minLines: 3,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'About me',
                      icon: const Icon(Icons.person_outline_sharp),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        }

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _formKey.currentState!.save();
                          });
                          ProfileService profileService = ProfileService();
                          profileService
                              .editProfile(jwtToken!, _editProfileRequest)
                              .then((value) async => {
                                    if (_editProfileRequest.firstName == null &&
                                        _editProfileRequest.lastName == null &&
                                        _editProfileRequest.aboutMe == null &&
                                        _editProfileRequest.password == null)
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              duration:
                                                  Duration(milliseconds: 1500),
                                              content: Text(
                                                  'Make a change before saving')),
                                        )
                                      }
                                    else if (value.error!.isEmpty)
                                      {
                                        widget.onProfileChanged(),
                                        setState(() {}),
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              content: Text(value.message)),
                                        )
                                      }
                                    else
                                      {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              duration: const Duration(
                                                  milliseconds: 1500),
                                              content: Text(value.error!)),
                                        )
                                      }
                                  });
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  editAvatarImageMySQL(String imageURL) async {
    _editProfileRequest.imageURL = imageURL;
    ProfileService profileService = ProfileService();
    profileService
        .editProfile(jwtToken!, _editProfileRequest)
        .then((value) async {
      widget.onProfileChanged();
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile()
            .then((value) => editAvatarImageMySQL(widget.user.imageURL));
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = path.basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
      await ref.putFile(_photo!);

      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('files/$fileName')
          .getDownloadURL();

      setState(
        () {
          widget.user.imageURL = downloadURL;
        },
      );

      // Within your widgets:
      // Image.network(downloadURL);

    } catch (e) {
      print('error occured');
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery();
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          );
        });
  }
}
