import 'dart:io';
import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/models/message_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

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
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        course: "MCA",
        lastActive: DateTime.daysPerWeek.toString(),
        isOnline: false,
        id: user.uid,
        email: user.email.toString(),
        pushToken: "");
    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
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

  static Future<void> updateProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child("Profile Picture/${user.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: "image/$ext"))
        .then((p0) {
      debugPrint('Data Transefered : ${p0.bytesTransferred / 1024} KB');
    });
    mydata.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': mydata.image,
    });
  }

// ************** For our Chatt Screeeen ************** //

  static String getConversationId(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      ChatUser user) {
    return firestore
        .collection('chat/${getConversationId(user.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    // time as ID
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // message to send
    final MessageChat message = MessageChat(
        msg: msg,
        read: '',
        told: chatUser.id,
        type: Type.text,
        sent: time,
        fromId: user.uid);
    final ref = firestore
        .collection('chat/${getConversationId(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  static String getTime({required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static Future<void> updateRead(MessageChat msgk) async {
    firestore
        .collection('chat/${getConversationId(msgk.fromId)}/messages/')
        .doc(msgk.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    debugPrint("From: ${getConversationId(msgk.sent)}");
    debugPrint("this is Kasif");
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMsg(ChatUser user) {
    return firestore
        .collection('chat/${getConversationId(user.id)}/messages/')
        .snapshots();
  }
}
