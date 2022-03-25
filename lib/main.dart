import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme colorScheme = const ColorScheme.light();
        ColorScheme darkColorScheme = const ColorScheme.dark();

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the dynamic primary color.
          colorScheme = colorScheme.copyWith(
            primary: lightDynamic.primary,
          );
          darkColorScheme = darkColorScheme.copyWith(
            primary: darkDynamic.primary,
          );
          /*
          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).colorScheme.primary,
                systemNavigationBarIconBrightness:
                    Theme.of(context).colorScheme.brightness));
          }*/
        }

        // Harmonize the dynamic color schemes' error and onError colors
        // (which are built-in semantic colors).
        colorScheme = colorScheme.harmonized();
        darkColorScheme = darkColorScheme.harmonized();

        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          home: const Splash(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
