import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hustle_app/page/map_page.dart';

import '/page/test_env_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future createDocument() async {
    final refMessage = FirebaseFirestore.instance
        .collection('chats')
        .doc('6dVs6GsoaXiJIzN7ybRU')
        .collection('messages')
        .doc();
    await refMessage.set(
        {'message': 'Testin dis', 'user_id': dotenv.env['FIREBASE_TOKEN']});

    final refConnection = FirebaseFirestore.instance.collection('chats').doc();
    await refConnection.set({
      'sender_id': dotenv.env['FIREBASE_TOKEN'],
      'receiver_id': '',
      'is_accepted': false,
    });
  }

  int index = 0;
  final screens = [
    const MapPage(),
    const TestEnv(),
    const TestEnv(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
              indicatorColor: Theme.of(context).colorScheme.primary),
          child: NavigationBar(
            selectedIndex: index,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            animationDuration: const Duration(seconds: 1),
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
            destinations: [
              NavigationDestination(
                icon: Icon(
                  Icons.map_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27.0,
                ),
                selectedIcon: const Icon(Icons.map),
                label: 'Map',
                tooltip: "",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.post_add_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27.0,
                ),
                selectedIcon: const Icon(Icons.post_add),
                label: 'Posts',
                tooltip: "",
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.sentiment_neutral_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27.0,
                  ),
                  selectedIcon: const Icon(Icons.sentiment_neutral),
                  label: 'Chat',
                  tooltip: ""),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        //width: 70.0,
        //height: 70.0,
        child: FloatingActionButton(
          onPressed: () {
            createDocument();
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.create, /*size: 30*/
          ),
        ),
      ),
    );
  }
}
