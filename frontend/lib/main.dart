import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:io';

import '/page/splash_page.dart';

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
            brightness: lightDynamic.brightness,
            primary: lightDynamic.primary,
            onPrimary: lightDynamic.onPrimary,
            primaryContainer: lightDynamic.primaryContainer,
            onPrimaryContainer: lightDynamic.onPrimaryContainer,
            secondary: lightDynamic.secondary,
            onSecondary: lightDynamic.onSecondary,
            secondaryContainer: lightDynamic.onSecondaryContainer,
            onSecondaryContainer: lightDynamic.onSecondaryContainer,
            tertiary: lightDynamic.tertiary,
            onTertiary: lightDynamic.onTertiary,
            tertiaryContainer: lightDynamic.tertiaryContainer,
            onTertiaryContainer: lightDynamic.onTertiaryContainer,
            error: lightDynamic.error,
            onError: lightDynamic.onError,
            errorContainer: lightDynamic.errorContainer,
            onErrorContainer: lightDynamic.onErrorContainer,
            background: lightDynamic.background,
            onBackground: lightDynamic.onBackground,
            surface: lightDynamic.surface,
            onSurface: lightDynamic.onSurface,
            surfaceVariant: lightDynamic.surfaceVariant,
            onSurfaceVariant: lightDynamic.onSurfaceVariant,
            outline: lightDynamic.outline,
            shadow: lightDynamic.shadow,
            inverseSurface: lightDynamic.inverseSurface,
            onInverseSurface: lightDynamic.onInverseSurface,
            inversePrimary: lightDynamic.inversePrimary,
          );
          darkColorScheme = darkColorScheme.copyWith(
            brightness: darkDynamic.brightness,
            primary: darkDynamic.primary,
            onPrimary: darkDynamic.onPrimary,
            primaryContainer: darkDynamic.primaryContainer,
            onPrimaryContainer: darkDynamic.onPrimaryContainer,
            secondary: darkDynamic.secondary,
            onSecondary: darkDynamic.onSecondary,
            secondaryContainer: darkDynamic.onSecondaryContainer,
            onSecondaryContainer: darkDynamic.onSecondaryContainer,
            tertiary: darkDynamic.tertiary,
            onTertiary: darkDynamic.onTertiary,
            tertiaryContainer: darkDynamic.tertiaryContainer,
            onTertiaryContainer: darkDynamic.onTertiaryContainer,
            error: darkDynamic.error,
            onError: darkDynamic.onError,
            errorContainer: darkDynamic.errorContainer,
            onErrorContainer: darkDynamic.onErrorContainer,
            background: darkDynamic.background,
            onBackground: darkDynamic.onBackground,
            surface: darkDynamic.surface,
            onSurface: darkDynamic.onSurface,
            surfaceVariant: darkDynamic.surfaceVariant,
            onSurfaceVariant: darkDynamic.onSurfaceVariant,
            outline: darkDynamic.outline,
            shadow: darkDynamic.shadow,
            inverseSurface: darkDynamic.inverseSurface,
            onInverseSurface: darkDynamic.onInverseSurface,
            inversePrimary: darkDynamic.inversePrimary,
          );
        }

        // Harmonize the dynamic color schemes' error and onError colors
        // (which are built-in semantic colors).
        colorScheme = colorScheme.harmonized();
        darkColorScheme = darkColorScheme.harmonized();

        /*
          if (Platform.isAndroid) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                systemNavigationBarColor: Theme.of(context).colorScheme.primary,
                systemNavigationBarIconBrightness:
                    Theme.of(context).colorScheme.brightness));
          }*/

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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
