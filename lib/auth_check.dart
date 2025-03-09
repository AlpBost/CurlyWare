import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jjj/pages/loginpage.dart';
import 'package:jjj/pages/messagepage.dart';

class AuthCheck extends StatelessWidget{
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context, snapshot){

            if(snapshot.hasData){
              return MessagePage();
            }
            else{
              return const LoginScreen();
            }
          }),
    );
  }
}