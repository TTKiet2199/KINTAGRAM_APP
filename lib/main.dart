import 'package:flutter/material.dart';
import 'package:kintagram_app/pages/home_page.dart';
import 'package:kintagram_app/pages/login_page.dart';
import 'package:kintagram_app/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kintagram',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      initialRoute: 'home',
      routes: {
        'register': (context) => const RegisterPage(),
        'login': (context) => const LoginPage(),
        'home': (context) => const HomePage(),
      },
    );
  }
}
