import 'package:euphas/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';
import 'home.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?> (
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userId = auth.currentUser!.uid;
            firestore.collection('users').doc(userId).get().then((value) async {
              userProfile = value.data()!;
            });
            return const Home();
          } else {
            return const Login();
          }
        },
      ),
    );
  }
}
