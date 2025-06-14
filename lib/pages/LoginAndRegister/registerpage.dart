import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jjj/pages/LoginAndRegister/loginpage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // This function creates a new user account
  Future<void> _register() async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration Successful')),
      );

      // Go to login screen after successful sign up
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

    } on FirebaseAuthException catch (e) {
      // Show different messages for different errors
      String message = '';
      if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      } else {
        message = 'Registration failed. ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      // Show error if something else goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email input field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a E-Mail';
                  } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                    return 'Please Enter a Valid E-Mail';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password input field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter a Password';
                  } else if (value.length < 6) {
                    return 'Password should contains at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm password input field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Again',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords are not same ! ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Sign Up button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _register(); // Call register function
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800]!,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              // Button to go back if already have account
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'You already have an account',
                  style: TextStyle(color: Colors.grey[800]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
