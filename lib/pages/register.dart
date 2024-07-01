// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../methods/user_methods.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(color: const Color.fromRGBO(135, 200, 250, 50))),
              Expanded(
                  child: Container(color: const Color.fromRGBO(25, 25, 112, 40))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 80),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.98),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(20, 20),
                        blurRadius: 5,
                        spreadRadius: 1),
                  ]),
              child: Center(
                child: SizedBox(
                  width: 500,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.account_circle_rounded,
                          size: 70,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextField(
                            controller: nameController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: '名稱',
                            )),
                        const SizedBox(height: 30,),
                        TextField(
                            controller: emailController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              hintText: 'XXX@gmail.com',
                            )),
                        const SizedBox(height: 30,),
                        TextField(
                            controller: passwordController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: '密碼',
                            )),
                        const SizedBox(height: 50,),
                        SizedBox(
                          width: 500,
                          child: ElevatedButton(
                              onPressed: () async {
                                dynamic signInFeedback = await UserMethods()
                                    .signUp(emailController.text,
                                    passwordController.text,nameController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(signInFeedback)));
                              },
                              child: const Text('註冊')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('已有帳號？'),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('登入')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


