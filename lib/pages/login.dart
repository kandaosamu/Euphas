// ignore_for_file: use_build_context_synchronously

import 'package:euphas/constant.dart';
import 'package:flutter/material.dart';

import '../methods/user_methods.dart';
import 'register.dart';

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
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      color: const Color.fromRGBO(135, 200, 250, 50))),
              Expanded(
                  child:
                      Container(color: const Color.fromRGBO(25, 25, 112, 40))),
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
                  width: screenWidth * 0.2,
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
                            controller: emailController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              labelText: 'Email',
                              hintText: 'XXX@gmail.com',
                            )),
                        const SizedBox(height: 50,),
                        TextField(
                            controller: passwordController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.key),
                              labelText: '密碼',
                            )),
                        Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {}, child: const Text('忘記密碼？'))),
                        const SizedBox(height: 30,),
                        SizedBox(
                          width: 500,
                          child: ElevatedButton(
                              onPressed: () async {
                                dynamic signInFeedback = await UserMethods()
                                    .signIn(emailController.text,
                                        passwordController.text);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(signInFeedback)));
                              },
                              child: const Text('登入')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('沒有帳號？'),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>Register()));
                                },
                                child: const Text('註冊')),
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
  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}


