import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/pages/feed_page.dart';
import 'package:kintagram_app/pages/profile_page.dart';
import 'package:kintagram_app/services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService? firebaseService;
  int currentPage = 0;
  final List<Widget> pages = [
    const FeedPage(),
    const ProfilePage(),
  ];
  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kintagram',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: GestureDetector(
              onTap: () async {
                await firebaseService!.logOut();
                Navigator.popAndPushNamed(context, 'login');
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: pages[currentPage],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: currentPage,
        onTap: (index) {
          setState(() {
            currentPage = index;
          });
        },
        items: const [
          BottomNavigationBarItem(label: 'Feed', icon: Icon(Icons.feed)),
          BottomNavigationBarItem(
              label: 'Profile', icon: Icon(Icons.account_box)),
        ]);
  }

  void _postImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File image = File(result!.files.first.path!);
    firebaseService!.postImage(image);
  }
}
