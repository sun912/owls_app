import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:owls_app/pages/analytics_page.dart';
import 'package:owls_app/pages/home_page.dart';
import 'package:owls_app/pages/questions_page.dart';
import 'package:owls_app/pages/settings_page.dart';
import 'package:owls_app/pages/user_page.dart';

var logger = Logger(printer: PrettyPrinter());
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      // initialRoute: '/',
      routes: {
        '/analytics': (context) => const AnalyticsPage(),
        '/settings': (context) => const SettingsPage(),
        '/qna': (context) => const QnAPage(),
        '/info': (context) => const UserInfoPage(),
      },
    );
  }
}
