import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseService? firebaseService;
  double? deviceHeight, deviceWidth;
  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: deviceHeight! * 0.05, horizontal: deviceWidth! * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_profileImage(), _postGridView()],
      ),
    );
  }

  Widget _profileImage() {
    return Container(
      height: deviceHeight! * 0.15,
      width: deviceWidth! * 0.33,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(firebaseService!.currentUser!["image"]))),
    );
  }

  Widget _postGridView() {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: firebaseService!.getPostsForUser(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return GridView.builder(
              itemCount: posts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 2, crossAxisSpacing: 2),
              itemBuilder: ((context, index) {
                Map post = posts[index];
                return Container(
                  decoration: BoxDecoration(
                      image:
                          DecorationImage(image: NetworkImage(post["image"]))),
                );
              }));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    ));
  }
}
