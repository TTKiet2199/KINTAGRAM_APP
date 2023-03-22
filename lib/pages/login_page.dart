import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/services/firebase_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? deviceHeight, deviceWidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? email;
  String? password;
  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth! * 0.05),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _titleWidget(),
            _loginForm(),
            _loginButton(),
            _registerPageLink(),
          ],
        )),
      ),
    );
  }

  Widget _titleWidget() {
    return const Text(
      'Kintagram',
      style: TextStyle(
          color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
    );
  }

  Widget _loginForm() {
    return Container(
      height: deviceHeight! * 0.2,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _emailTextField(),
              _passwordTextField(),
            ],
          )),
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Email...'),
      onSaved: ((value) {
        setState(() {
          email = value;
        });
      }),
      validator: (value) {
        bool result = value!.contains(RegExp(
            r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$'));
        return result ? null : 'Please enter a valid email';
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(hintText: 'Password...'),
      onSaved: ((value) {
        setState(() {
          password = value;
        });
      }),
      validator: (value) => value!.length > 6
          ? null
          : 'Please enter a password greater than 6 character.',
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _loginUser,
      minWidth: deviceWidth! * 0.7,
      height: deviceHeight! * 0.06,
      color: Colors.red,
      child: const Text(
        'Login',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: (() => Navigator.pushNamed(context, "register")),
      child: const Text(
        "Don't have a account",
        style: TextStyle(
            color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w200),
      ),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool result = await _firebaseService!
          .loginUsers(email: email!, password: password!);
      // print("ssss$result");
      if (result) {
        Navigator.popAndPushNamed(context, 'home');
      }
    }
  }
}
