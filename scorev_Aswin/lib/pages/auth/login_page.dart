import 'package:flutter/material.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_auth_helper/firebaseauthhelper.dart';
import 'package:score/pages/auth/forgot_password.dart';
import 'package:score/pages/home_page.dart';
import 'package:score/pages/signup_page.dart';
import 'package:score/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: wh,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Text
              const Text(
                'Welcome ! ',
                style: TextStyle(
                  color: Color.fromARGB(255, 15, 66, 107),
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              // Username TextField
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: bl),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bl),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bl),
                  ),
                ),
                style: const TextStyle(color: bl),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your firstname';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Password TextField
              TextFormField(
                controller: password,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: bl),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bl),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: bl),
                  ),
                ),
                style: const TextStyle(color: bl),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  } else if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: bl, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color.fromARGB(255, 15, 66, 107),
                    foregroundColor: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () async {
                  bool login = await FirebaseAuthHelper.instance
                      .login(email.text, password.text, context);

                  if (login) {
                    Routes.instance.push(HomePage(), context);
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 20.0),

              // Sign Up Button
              TextButton(
                onPressed: () {
                  // Navigate to Sign Up page

                  Routes.instance.push(SignUpPage(), context);
                },
                style: stew,
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 20.0),

              // Forgot Password Button
              TextButton(
                onPressed: () {
                  // Navigate to Forgot Password page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: wh,
                  foregroundColor: bl,
                ),
                child: const Text('Forgot Password?',style: TextStyle(color: Color.fromARGB(255, 15, 66, 107)),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
