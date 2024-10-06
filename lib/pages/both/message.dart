import 'package:euphas/config/constants.dart';
import 'package:euphas/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePage();
}

class _MessagePage extends State<MessagePage> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .where('receiver', isEqualTo: currentProfile['email'])
            .snapshots(),
        builder: (context, snapshot) => !snapshot.hasData || snapshot.data!.docs.isEmpty
            ? const Center(child: Text('無訊息',style: big))
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.01,
                    ),
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                          snapshot.data?.docs[index]['type'] == 'invitation' ? '配對邀請' : '配對成功！',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 30)),
                      subtitle: Text(
                        '來自 ${snapshot.data?.docs[index]['sender']}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          if (snapshot.data?.docs[index]['type'] == 'invitation') {
                            final data = snapshot.data?.docs[index];
                            FireStoreService().acceptInvitation(data);
                          } else {
                            firestore
                                .collection('messages')
                                .doc(snapshot.data?.docs[index].id)
                                .delete();
                          }
                        },
                        child: Text(
                          snapshot.data?.docs[index]['type'] == 'invitation' ? '接受' : '已讀',
                          style: const TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  );
                }));
  }
}
