import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/pages/home_page.dart';
import 'package:kintagram_app/pages/login_page.dart';
import 'package:kintagram_app/pages/register_page.dart';
import 'package:kintagram_app/services/firebase_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  GetIt.instance.registerSingleton<FirebaseService>(FirebaseService());
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
      initialRoute: 'login',
      routes: {
        'register': (context) => const RegisterPage(),
        'login': (context) => const LoginPage(),
        'home': (context) => const HomePage(),
      },
    );
  }
}
