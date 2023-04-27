//import 'package:chatapp/widgets/chat_user_card.dart';

import 'package:chatapp/models/chat_user.dart';
import 'package:chatapp/widgets/chat_user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth/authentication.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<ChatUser> name = [];
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        centerTitle: true,
        title: const Text("My App"),
        actions: [
          IconButton(
              onPressed: () => {
                    FirebaseAuth.instance.signOut(),
                    GoogleSignIn().signOut(),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AuthScreen(),
                      ),
                    ),
                  },
              icon: const Icon(Icons.search)),
          IconButton(onPressed: () => {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              name =
                  data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
              if (name.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  physics: const BouncingScrollPhysics(),
                  itemCount: name.length,
                  itemBuilder: (context, index) => MyChat(user: name[index]),
                );
              } else {
                return const Center(
                  child: Text(
                    "No Data",
                    style: TextStyle(fontSize: 33),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}