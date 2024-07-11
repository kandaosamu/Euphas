// ignore_for_file: avoid_print
import 'package:euphas/constant.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:euphas/sub_pages/home_invitation.dart';
import 'package:euphas/sub_pages/home_message.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final inviteController = TextEditingController();

  int currentPageIndex = 0;
  final navPage = [
    BottomMessage(),
    Center(child: Text('Home')),
    Center(child: Text('Progress')),
  ];
  final drawerPage = [
    Center(child: Text('profile'),),
    DrawerInvitation(),
  ];

  @override
  void initState() {
    super.initState();
    userId = auth.currentUser!.uid;
    firestore.collection('users').doc(userId).get().then((value) {
      userName = value.data()!['name'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(userName),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: currentPageIndex < 3
          ? navPage[currentPageIndex]
          : drawerPage[currentPageIndex - navPage.length],
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(),
              child: Text('選單'),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_rounded),
              title: const Text('個人資料'),
              onTap: () {
                setState(() {
                  currentPageIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.handshake),
              title: const Text('配對邀請'),
              onTap: () {
                setState(() {
                  currentPageIndex = 4;
                });
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex < navPage.length ? currentPageIndex : 0,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.email_rounded), label: 'Message'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.stacked_line_chart_rounded), label: 'Progress'),
        ],
      ),
    );
  }
}
