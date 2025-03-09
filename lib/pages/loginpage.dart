import "package:flutter/material.dart";
import "package:jjj/auth_service.dart";
import "mainpage/mainpage.dart";



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) async{
    final authService = AuthService();

    try{
      await authService.signInWithEmailPassword(
          _usernameController.text, _passwordController.text);
    } catch (e){
      showDialog(
          context: context,
          builder: (context) =>AlertDialog(
        title: Text(e.toString()),
      ));
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
              labelStyle: TextStyle(color: Colors.white),
              hintText: "abc@gmail.com")
              ,

            ),
            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              style: new TextStyle(color:  Colors.white),
              decoration: const InputDecoration(labelText: "Password",
              labelStyle: TextStyle(color: Colors.white),
              hintText: "*******",
              hintStyle: TextStyle(color: Colors.grey)),
              obscureText: true,

            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => _login(context),//Tuşa basıldığında logini verir
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