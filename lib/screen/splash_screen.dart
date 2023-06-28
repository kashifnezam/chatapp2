import 'package:chatapp/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/authentication.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () async {
      await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser == null && context.mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AuthScreen()));
      } else {
        debugPrint("User: ${FirebaseAuth.instance.currentUser}");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
    return const Scaffold(
      body: Center(
        child: Text("Chatting App Developed By Md Kashif Nezam"),
      ),
    );
  }
}
