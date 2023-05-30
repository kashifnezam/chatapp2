import 'dart:io';
import 'package:chatapp/screen/auth/api.dart';
import 'package:chatapp/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../helper/dialogs.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    Future<UserCredential?> signInWithGoogle() async {
      try {
        await InternetAddress.lookup("google.com");
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        // Once signed in, return the UserCredential
        return await Api.auth.signInWithCredential(credential);
      } catch (e) {
        debugPrint("Internet Not Availabe: $e");
      }
      // ignore: use_build_context_synchronously
      Dialogs.showMsgbar(context, "Something is Fishy");
      return null;
    }

    signGoogle() {
      Dialogs.showProgressbar(context);
      signInWithGoogle().then(
        (user) async {
          Navigator.pop(context);
          if (user != null) {
            debugPrint("User: ${user.user}");
            if (!(await Api.userExists())) {
              Api.createUsers();
            }
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          }
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Kashif App"),
        ),
        body: Stack(
          children: [
            Positioned(
              left: mq.width * 0.16,
              top: mq.height * 0.16,
              width: mq.width * 0.7,
              
              child: Image.asset('static/images/chat.png'),
            ),
            Positioned(
              left: mq.width * 0.06,
              top: mq.height * 0.66,
              width: mq.width * 0.88,
              height: mq.height * 0.05,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue[200],
                  shape: const StadiumBorder(),
                ),
                onPressed: () => {signGoogle()},
                icon: Image.asset(
                  'static/images/search.png',
                  height: mq.height * 0.035,
                ),
                label: const Text(
                  "Signin with Gmail",
                  style: TextStyle(fontSize: 19, color: Colors.black),
                ),
              ),
            ),
          ],
        ));
  }
}
