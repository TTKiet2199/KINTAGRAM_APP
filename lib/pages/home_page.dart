import 'package:flutter/material.dart';
import 'package:kintagram_app/pages/feed_page.dart';
import 'package:kintagram_app/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  final List<Widget> pages = [
    const FeedPage(),
    const ProfilePage(),
  ];
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
            onTap: () {},
            child: const Icon(Icons.add_a_photo),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: GestureDetector(
              onTap: () {},
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
}
