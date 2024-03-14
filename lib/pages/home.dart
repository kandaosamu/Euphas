import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            FirebaseFirestore.instance.collection('chats/WvUOok7hlsWsM6t0LQYo/msg').doc('FKPjEpof9PXk5MvLxVgK').delete();
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/WvUOok7hlsWsM6t0LQYo/msg')
              .add({'text': 'add new line'});
        },
      ),
    );
  }
}
