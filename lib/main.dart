import 'package:flutter/material.dart';
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
      title: 'Kintagram',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      initialRoute: 'login',
      routes: {
        'register': (context) => RegisterPage(),
        'login': (context) => LoginPage(),
      },
    );
  }
}
