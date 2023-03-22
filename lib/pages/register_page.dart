import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/services/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? deviceHeight, deviceWidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  String? name, email, password;
  File? image; //dùng File có import dart:io
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _titleWidget(),
                _profileTmageWidget(),
                _registrationForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
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

  Widget _profileTmageWidget() {
    var imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage('https://i.pravatar.cc/150?img=50');
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((result) {
          setState(() {
            image = File(result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: deviceHeight! * 0.25,
        width: deviceWidth! * 0.55,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: imageProvider as ImageProvider)),
      ),
    );
  }

  Widget _registrationForm() {
    return Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            _emailTextField(),
            _passwordTextField(),
          ],
        ));
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: 'Name....'),
      validator: (value) => value!.isNotEmpty ? null : 'Please enter a name',
      onSaved: (value) {
        setState(() {
          name = value;
        });
      },
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

  Widget _registerButton() {
    return MaterialButton(
      onPressed: _registerUser,
      minWidth: deviceWidth! * 0.7,
      height: deviceHeight! * 0.06,
      color: Colors.blue,
      child: const Text(
        'Register',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),
      ),
    );
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate() && image != null) {
      _registerFormKey.currentState!.save();
      bool result = await _firebaseService!.registerUser(
          name: name!, email: email!, password: password!, images: image!);
      // print('ss$result');
      if (result) {
        Navigator.pop(context);
      }
    }
  }
}
