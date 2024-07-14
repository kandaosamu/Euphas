import 'package:flutter/material.dart';
import 'package:euphas/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NavMessage extends StatefulWidget {
  const NavMessage({super.key});

  @override
  State<NavMessage> createState() => _BottomMessage();
}

class _BottomMessage extends State<NavMessage> {
  @override
  Widget build(context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users/$userId/invitation')
            .snapshots(),
        builder: (context, snapshot) => ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) => snapshot.data?.docs == null?
              const Center(child: Text('No Message'),) : Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(snapshot.data?.docs[index]['message']),
                          const SizedBox(
                            width: 500,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                try {
                                  firestore
                                      .collection('users')
                                      .doc(userId)
                                      .update({
                                    'pairs': snapshot.data?.docs[index]
                                        ['senderName']
                                  });
                                  firestore
                                      .collection('users')
                                      .doc(snapshot.data!.docs[index]
                                          ['senderId'])
                                      .update({'pairs': userName});
                                } finally {
                                  firestore.runTransaction((transaction) async {
                                    transaction.delete(
                                        snapshot.data!.docs[index].reference);
                                  });
                                  firestore
                                      .collection('users/$userId/invitation')
                                      .doc()
                                      .delete();
                                }
                              },
                              child: const Text('接受')),
                          ElevatedButton(
                              onPressed: () {}, child: const Text('拒絕'))
                        ],
                      )),
            ));
  }
}
