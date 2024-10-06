import 'package:euphas/config/constants.dart';
import 'package:euphas/services/auth.dart';
import 'package:euphas/ui/input.dart';
import 'package:euphas/ui/snackbar.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.pageController});

  final PageController pageController;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  List<String> role = ['patient', 'therapist'];
  List<bool> roleSelected = [true, false];

  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle),
                  SizedBox(height: screenHeight * 0.05),
                  passwordInput(nameController, '名字', TextInputType.name),
                  SizedBox(height: screenHeight * 0.01),
                  emailInput(emailController, '帳號', TextInputType.emailAddress),
                  SizedBox(height: screenHeight * 0.01),
                  passwordInput(passwordController, '密碼', TextInputType.text),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: Center(child: Text('你是...'))),
                      ToggleButtons(
                        isSelected: roleSelected,
                        onPressed: (int index) {
                          for (int i = 0; i < role.length; i++) {
                            setState(() {
                              roleSelected[i] = index == i;
                            });
                          }
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        constraints:
                        BoxConstraints(minWidth: screenWidth * 0.05, minHeight: screenHeight * 0.03),
                        children: const [Text('患者'), Text('治療師')],
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                if ((formKey.currentState as FormState).validate()) {
                                  dynamic feedback = AuthService().signUp(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      role[roleSelected.indexWhere((element) => element)]);
                                  if (feedback != null && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar(feedback!));
                                  } else if (feedback == null) {
                                    AuthService().signIn(emailController.text, passwordController.text);
                                  }
                                }
                              },
                              child: const Text('註冊'))),
                      SizedBox(width: screenWidth * 0.01),
                      const Text('已有帳號?'),
                      TextButton(
                          onPressed: () {
                            widget.pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
                          },
                          child: const Text('登入'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}