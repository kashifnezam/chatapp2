import 'package:chatapp/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Api {
  static late ChatUser mydata;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getMyData() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        mydata = ChatUser.fromJson(user.data()!);
      } else {
        await createUsers().then((value) => getMyData());
      }
    });
  }

  static Future<void> createUsers() async {
    final chatUser = ChatUser(
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Created by Kashif",
        createdAt: DateTime.now().microsecondsSinceEpoch.toString(),
        course: "MCA",
        lastActive: DateTime.daysPerWeek.toString(),
        isOnline: false,
        id: user.uid,
        email: user.email.toString(),
        pushToken: "");
    return firestore.collection("users").doc(user.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUsers() async {
    await firestore.collection('users').doc(user.uid).update(
      {'name': mydata.name, 'about': mydata.about},
    );
  }
}
