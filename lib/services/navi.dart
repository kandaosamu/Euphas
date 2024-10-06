import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/both/home.dart';
import 'package:euphas/pages/both/login.dart';
import 'package:euphas/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../ui/loading.dart';

class Navi extends StatefulWidget {
  const Navi({super.key});

  @override
  State<Navi> createState() => _NaviState();
}

class _NaviState extends State<Navi> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (stream.hasData) {
            return FutureBuilder(
                future: FireStoreService().getProfile(),
                builder: (context, future) {
                  if (stream.connectionState == ConnectionState.waiting || future.data == null) {
                    return const Loading();
                  } else if (future.hasData) {
                    currentProfile = future.data!;
                    return Home(profile: future.data!);
                  } else {
                    return Scaffold(body: Center(child: Text(future.error.toString())));
                  }
                });
          } else {
            return const LoginPage();
          }
        });
  }
}
