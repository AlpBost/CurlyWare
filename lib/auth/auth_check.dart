import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jjj/pages/LoginAndRegister/loginpage.dart';
import 'package:jjj/pages/LoginAndRegister/registerpage.dart';

// This widget checks if the user is authenticated or not.
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {

    // Get the current user from Firebase authentication.
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return LoginScreen();
    } else {
      return const Registerpage();
    }
  }
}