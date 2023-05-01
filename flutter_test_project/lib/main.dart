import 'package:flutter/material.dart';
import 'package:flutter_test_project/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

final themeMode = ValueNotifier(2);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, value, g) {
        return MaterialApp(
          initialRoute: '/',
          darkTheme: ThemeData.light(),
          themeMode: ThemeMode.values.toList()[value as int],
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (ctx) => ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: MyHomePage(title: ""))
          },
        );
      },
      valueListenable: themeMode,
    );
  }
}
