import 'package:euphas/config/constants.dart';
import 'package:euphas/services/firestore.dart';
import 'package:euphas/ui/input.dart';
import 'package:flutter/material.dart';

class InvitationPage extends StatefulWidget {
  const InvitationPage({super.key});

  @override
  State<InvitationPage> createState() => _InvitationPage();
}

class _InvitationPage extends State<InvitationPage> {
  final receiverController = TextEditingController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '請輸入被邀請人的Email',
            style: TextStyle(fontSize: 25),
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: screenWidth * 0.2,
            child: Form(
                key: formKey,
                child: invitationInput(receiverController, 'email', TextInputType.emailAddress)),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                if ((formKey.currentState as FormState).validate()) {
                  FireStoreService()
                      .invite(currentProfile['email'], receiverController.text, context,receiverController);
                }
              },
              child: const Text('發送')),
        ],
      ),
    );
  }
}
