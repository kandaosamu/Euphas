// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  final inviteController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  dynamic currentId = FirebaseAuth.instance.currentUser?.uid;
  String name = '';
  int currentPageIndex = 0;
  final navPage = [
    Center(child: Text('Msg')),
    Center(child: Text('Home')),
    Center(child: Text('Progress')),
  ];
  final drawerPage = [
    Center(child: Text('Profile')),
    Center(child: Text('Invitation')),
  ];

  @override
  void initState() {
    super.initState();
    firestore.collection('users').doc(currentId).get().then((value) {
      name = value.data()!['name'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(name),
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
