import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jjj/pages/LoginAndRegister/registerpage.dart';
import '../../auth/auth_service.dart';
import '../mainpage/mainpagebuttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // We use these to get user's email and password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // This function tries to login the user
  void _login(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.signInWithEmailPassword(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      // If login is okay, go to main page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPageButtons()),
      );
    } catch (e) {
      // If there is an error, show it
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Error!"),
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[600]!,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon
            Image.asset(
              'assets/icons/CurlyIcon.jpeg',
              width: 130,
              height: 130,
            ),
            const SizedBox(height: 20),
            // Email input
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            // Password input
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.white),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            // Login button
            ElevatedButton(
              onPressed: () => _login(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text("Login"),
            ),
            const SizedBox(height: 10),
            // Go to Sign Up page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Registerpage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700]!,
                foregroundColor: Colors.white,
              ),
              child: const Text("Sign Up"),
            )
          ],
        ),
      ),
    );
  }
}
