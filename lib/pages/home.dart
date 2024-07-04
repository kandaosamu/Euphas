// ignore_for_file: avoid_print
import 'package:euphas/methods/user_methods.dart';
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
  dynamic name = '';
  int? groupValue = -1;

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection('users').doc(userID).get().then((value){
      print(value.data());
      name = value.data()?['username'];
      setState(() {
      });
    });
    print(name);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title:Text(name),
        actions: [
          IconButton(onPressed: () {
            FirebaseAuth.instance.signOut();
          }, icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/$userID/message')
              .snapshots(),
          builder: (context, snapshot) =>
              ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? const LinearProgressIndicator()
                    : Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    // 這個是for患者的
                    children: [
                      // Text(snapshot.data?.docs[index]['invite']) ??
                      Text(snapshot.data!.docs[index]['msg']),
                      const SizedBox(width: 500,),
                      snapshot.data?.docs[index]['type'] == 'invite'?
                      ElevatedButton(onPressed: (){
                        FirebaseFirestore.instance.collection('users').doc(userID).update({
                          'pair': 'chen'
                        });
                        FirebaseFirestore.instance.collection('users').doc(snapshot.data!.docs[index]['fromWho']).update({
                          'pair':'bao'
                        });
                      }, child: const Text('接受')):Container(),
                      snapshot.data?.docs[index]['type'] == 'invite'?
                      ElevatedButton(onPressed: (){}, child: const Text('拒絕')):Container(),
                    ],
                  )
                ),
              )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          UserMethods().invite(userID,'xieyuchen0430@gmail.com','f94106185@gs.ncku.edu.tw');
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(), child: Text('選單'),),
            ListTile(
              title: const Text('帳號'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

