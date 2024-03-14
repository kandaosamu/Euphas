import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../methods/user_methods.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.lock,
                size: 100,
              ),
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 50,
              ),

              TextField(
                controller: passwordController,
                obscureText: false,
                decoration: const InputDecoration(
                  hintText: '密碼',
                  border: OutlineInputBorder(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '忘記密碼？',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // dynamic eMsg = await UserMethods().signIn(emailController.text,passwordController.text);
                    dynamic eMsg = await UserMethods().signUp(emailController.text,passwordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(behavior: SnackBarBehavior.floating, content:Text(eMsg)));
                  },
                  child: const Text('登入')),
            ],
          ),
        ),
      ),
    );
  }
}

