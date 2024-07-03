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
  final chatController = TextEditingController();
  dynamic userID = FirebaseAuth.instance.currentUser?.uid;
  String temporaryID = '';
  String name = '';
  int? groupValue = -1;

  @override
  Widget build(BuildContext context) {
    fetchName();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(name),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/WvUOok7hlsWsM6t0LQYo/msg')
              .snapshots(),
          builder: (context, snapshot) => ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) =>
                    snapshot.connectionState == ConnectionState.waiting
                        ? const LinearProgressIndicator()
                        : Container(
                            padding: const EdgeInsets.all(10),
                            child: Text(snapshot.data?.docs[index]['text']),
                          ),
              )),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(decoration: BoxDecoration(),child: Text('選單'),),
            ListTile(
              title: const Text('帳號'),
              onTap: (){},
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              FirebaseFirestore.instance
                  .collection("chats/WvUOok7hlsWsM6t0LQYo/msg")
                  .add({'text': 'o'}).then((DocumentReference doc) {
                    print('id is ${doc.id}');
                    temporaryID = doc.id;
              });
            },
          ),
          FloatingActionButton(
            child: const Icon(Icons.cancel),
            onPressed: (){
              FirebaseFirestore.instance.doc('chats/WvUOok7hlsWsM6t0LQYo/msg/$temporaryID').delete();
              print('delete $temporaryID');
            },
          ),
          Radio(
            value: 1,
            groupValue: groupValue,
            onChanged: (v){
              setState(() {
                groupValue = v;
              });
            },
          )
        ],
      ),
    );
  }
  fetchName()async{
    DocumentSnapshot data = await FirebaseFirestore.instance.collection('users').doc(userID).get();
    if (data.exists) {
      Map<String, dynamic>? fetchDoc = data.data() as Map<String, dynamic>?;
      name = fetchDoc?['username']+fetchDoc?['type'];
    }
  }
}

