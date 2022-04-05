import 'package:flutter/material.dart';

import '../page/profile_page.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: IconButton(
            icon: const Icon(Icons.person_outline, size: 34),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
          ),
        ),
      ],
    );
  }
}
