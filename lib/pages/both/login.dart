import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/both/register.dart';
import 'package:euphas/services/auth.dart';
import 'package:euphas/ui/input.dart';
import 'package:euphas/ui/snackbar.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  PageController pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PageView(
        controller: pageController,
        onPageChanged: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle),
                  SizedBox(height: screenHeight * 0.05),
                  emailInput(emailController, '帳號', TextInputType.emailAddress),
                  SizedBox(height: screenHeight * 0.01),
                  passwordInput(passwordController, '密碼', TextInputType.text),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                if ((formKey.currentState as FormState).validate()) {
                                  dynamic feedback = await AuthService()
                                      .signIn(emailController.text, passwordController.text);
                                  if (feedback != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar(feedback!));
                                  }
                                }
                              },
                              child: const Text('登入'))),
                      SizedBox(width: screenWidth * 0.01),
                      const Text('沒有帳號?'),
                      TextButton(
                          onPressed: () {
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                          },
                          child: const Text('註冊'))
                    ],
                  )
                ],
              ),
            ),
          ),
          RegisterPage(pageController: pageController),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}