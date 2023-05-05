import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/helper/dialogs.dart';
import 'package:chatapp/models/chat_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth/authentication.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.users});
  final ChatUser users;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
                Dialogs.showProgressbar(context),
                FirebaseAuth.instance.signOut().then(
                      (value) => GoogleSignIn().signOut().then(
                        (value) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AuthScreen(),
                            ),
                          );
                        },
                      ),
                    ),
              },
          icon: const Icon(Icons.logout_outlined),
          label: const Text("Logout")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    height: 170,
                    fit: BoxFit.fill,
                    imageUrl: users.image,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: mq.height * 0.15,
                  left: mq.width * 0.25,
                  child: MaterialButton(
                    onPressed: () => {},
                    height: 45,
                    shape: const CircleBorder(),
                    color: Colors.lightBlue,
                    child: const Icon(
                      Icons.camera_enhance_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              users.email,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 33,
            ),
            TextFormField(
              initialValue: users.name,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                hintText: "eg. Kashif Nezam",
                label: Text("Your Name"),
                prefixIcon: Icon(Icons.person, color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              initialValue: users.about,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                hintText: "eg. feeling Happy",
                label: Text("Status"),
                prefixIcon:
                    Icon(Icons.info_outline_rounded, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
