import 'package:flutter/material.dart';
import 'package:euphas/methods/user_methods.dart';
import 'package:euphas/constant.dart';
class DrawerInvitation extends StatefulWidget {
  const DrawerInvitation({super.key});

  @override
  State<DrawerInvitation> createState() => _DrawerInvitation();
}

class _DrawerInvitation extends State<DrawerInvitation> {
  final receiverController = TextEditingController();

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('請輸入被邀請人的Email'),
          const SizedBox(height: 30,),
          SizedBox(
            width: screenWidth * 0.2,
            child: TextField(
              controller: receiverController,
            ),
          ),
          const SizedBox(height: 30,),

          ElevatedButton(
              onPressed: () {
                UserMethods().invite(userId, userName, receiverController.text);
              },
              child: const Text('發送')),
        ],
      ),
    );
  }
}
