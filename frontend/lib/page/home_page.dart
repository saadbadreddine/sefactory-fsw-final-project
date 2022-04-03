import 'package:flutter/material.dart';
import 'package:hustle_app/page/test_env_page.dart';

import '/page/posts_page.dart';
import '/page/requests_page.dart';
import '/page/map_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  final screens = [
    const MapPage(),
    const PostsPage(),
    const RequestsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
                selectedIcon: Icon(
                  Icons.map,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: 'Map',
                tooltip: "",
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.campaign_outlined,
                  color: Theme.of(context).colorScheme.primary,
                  size: 27.0,
                ),
                selectedIcon: Icon(
                  Icons.campaign,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                label: 'Posts',
                tooltip: "",
              ),
              NavigationDestination(
                  icon: Icon(
                    Icons.sentiment_neutral_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 27.0,
                  ),
                  selectedIcon: Icon(
                    Icons.sentiment_neutral,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  label: 'Requests',
                  tooltip: ""),
            ],
          ),
        ),
      ),
    );
  }
}
