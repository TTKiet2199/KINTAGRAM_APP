import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String USER_COLLECTION = "users";
  String POTS_COLLECTION = "pots";
  Map? currentUser;
  FirebaseService();
  Future<bool> registerUser(
      {required String name,
      required String email,
      required String password,
      required File images // dùng File import dart io
      }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String userID = userCredential.user!.uid;
      String fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(images.path);
      UploadTask task = _storage.ref('image/$userID/$fileName').putFile(images);
      return task.then((snapshot) async {
        String downloadURL = await snapshot.ref.getDownloadURL();
        await _db.collection(USER_COLLECTION).doc(userID).set({
          "name": name,
          "email": email,
          "image": downloadURL,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loginUsers(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        currentUser = await getUserData(uid: userCredential.user!.uid);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(USER_COLLECTION).doc(uid).get();
    // print(_doc.data() as Map);
    return _doc.data() as Map;
  }

  Future<bool> postImage(File image) async {
    try {
      String userId = _auth.currentUser!.uid;
      String fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      UploadTask task = _storage.ref('image/$userId/$fileName').putFile(image);
      return task.then((snapshot) async {
        String downloadURL = await snapshot.ref.getDownloadURL();
        await _db.collection(POTS_COLLECTION).add({
          "userId": userId,
          "timestamp": Timestamp.now(),
          "image": downloadURL,
        });
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> getPostsForUser() {
    String userId = _auth.currentUser!.uid;
    return _db
        .collection(POTS_COLLECTION)
        .where("userId", isEqualTo: userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getLatestPots() {
    return _db
        .collection(POTS_COLLECTION)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}
