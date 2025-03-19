import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jjj/pages/LoginAndRegister/loginpage.dart';
import 'package:jjj/chat/messagepage.dart';

class AuthCheck extends StatelessWidget{
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder:(context, snapshot){

            if(snapshot.hasData){
              return LoginScreen();
            }
            else{
              return const LoginScreen();
            }
          }),
    );
  }
}