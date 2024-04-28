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
  String temporaryID = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            // FirebaseFirestore.instance.collection('chats/WvUOok7hlsWsM6t0LQYo/msg').doc().delete();
            setState(() {});
          },
        ),
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
        ],
      ),
    );
  }
}

