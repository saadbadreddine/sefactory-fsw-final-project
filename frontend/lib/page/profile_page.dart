import 'package:hustle_app/page/edit_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:hustle_app/utils/storage.dart';

import '../api/profile_service.dart';
import '../model/user_model.dart';
import '../widget/profile_widget.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = User(
        aboutMe: ' ',
        email: ' ',
        firebaseID: ' ',
        firstName: ' ',
        lastName: ' ',
        imageURL: ' ',
        dob: ' ',
        gender: '  ');
    getProfileInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Profile',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            leading:
                BackButton(color: Theme.of(context).colorScheme.onBackground),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.background),
                    side: MaterialStateProperty.all(
                      const BorderSide(style: BorderStyle.none),
                    ),
                    elevation: MaterialStateProperty.all(0),
                    overlayColor:
                        MaterialStateProperty.all(Theme.of(context).hoverColor),
                  ),
                  onPressed: () {
                    //exit(0);
                    deleteStorage().then((value) => Navigator.of(context)
                        .pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const Login()),
                            (Route<dynamic> route) => false));
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Theme.of(context).errorColor,
                  ),
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                ),
              ),
            ]),
        body: ListView(physics: const BouncingScrollPhysics(), children: [
          ProfileWidget(
            imagePath: user.imageURL,
            onClicked: () async {
              //_showPicker(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditProfilePage(
                            user: user,
                            onProfileChanged: () => setState(() {}),
                          )));
            },
            isEdit: true,
          ),
          const SizedBox(height: 65),
          buildName(user),
          const SizedBox(height: 33),
          buildAbout(user)
        ]));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            "${user.firstName} ${user.lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Gender:  ' +
                  user.gender[0].toUpperCase() +
                  user.gender.substring(1),
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 3),
            Text(
              'Dob: ' + user.dob,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 30),
            Column(
              children: [
                const Text(
                  'About me:',
                  style: TextStyle(
                    fontSize: 20,
                    height: 1.4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  user.aboutMe,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.4),
                )
              ],
            ),
          ],
        ),
      );

  getProfileInfo() async {
    ProfileService profileService;
    profileService = ProfileService();
    profileService.getProfile(jwtToken!).then((value) {
      setState(() {
        user = User.fromJson(value.data);
      });
    });
  }
}
