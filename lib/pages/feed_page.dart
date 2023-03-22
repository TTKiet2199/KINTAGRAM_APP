import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kintagram_app/services/firebase_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
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
      height: deviceHeight!,
      width: deviceHeight!,
      child: _postListView(),
    );
  }

  Widget _postListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseService!.getLatestPots(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          List posts = snapshot.data!.docs.map((e) => e.data()).toList();
          print(posts);
          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              Map post = posts[index];
              return Container(
                height: deviceHeight! * 0.30,
                margin: EdgeInsets.symmetric(
                    vertical: deviceHeight! * 0.01,
                    horizontal: deviceWidth! * 0.05),
                decoration: BoxDecoration(
                    image: DecorationImage(image: NetworkImage(post["image"]))),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
