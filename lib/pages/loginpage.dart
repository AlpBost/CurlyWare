import "package:flutter/material.dart";
import "mainpage/mainpage.dart";



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    //burada backend db kontrolu olmalı
    if (username == "admin" && password == "1234") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPageButtons(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A0A23),
       ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/icons/CurlyIcon.jpeg',
                width: 130,
                height: 130, // Yükseklik
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: "Username",
              labelStyle: TextStyle(color: Colors.white)),

            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              style: new TextStyle(color:  Colors.white),
              decoration: const InputDecoration(labelText: "Password",
              labelStyle: TextStyle(color: Colors.white)),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Butonun arka plan rengi
                foregroundColor: Colors.black, // Buton yazı rengi
              ),
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}