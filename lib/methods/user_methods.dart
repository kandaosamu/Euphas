// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserMethods {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<String?> signIn(String email, String password) async {
    String? eMsg;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('登入錯誤：' '$e.code');
      switch (e.code) {
        case 'invalid-email':
          eMsg = '無效電子信箱';
        case 'user-disabled':
          eMsg = '此帳戶已被禁用';
        case 'user-not-found':
          eMsg = '無此帳號，請先註冊';
        case 'wrong-password':
          eMsg = '密碼錯誤';
        case 'invalid-credential':
          eMsg = '帳號或密碼不符/尚未註冊';
      }
    }
    return eMsg;
  }

  Future<String?> signUp(
      String email, String password, String username, String type) async {
    String? eMsg;
    try {
      dynamic signUpResult;
      signUpResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firestore.collection('users').doc(signUpResult.user.uid).set({
        'username': username,
        'email': email,
        'type': type,
        'pair' : 'N/A',
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('登入錯誤：' '$e.code');
      switch (e.code) {
        case 'invalid-email':
          eMsg = '無效電子信箱';
        case 'weak-password':
          eMsg = '密碼強度不足';
        case 'operation-not-allowed':
          eMsg = '無效電子信箱';
        case 'email-already-in-use':
          eMsg = '帳號已註冊';
      }
    }
    return eMsg;
  }

  Future invite(
      String senderID, String senderType, String receiverEmail) async {
    await firestore
        .collection('users')
        .where('email', isEqualTo: receiverEmail).get().then((value){
          Map<String, dynamic> map = value.docs[0].data();
          String username = map['username'];
          print(value.docs[0].id);
          firestore.collection('users').doc(value.docs[0].id).collection('message').add(
            {
              'msg':'來自$username治療師的配對邀請',
              'fromWho':senderID,
              'type':'invite',
            }
          );
    });

  }

  Future addMsg(Map<String, dynamic> msgMap, String msgID) async {
    return firestore
        .collection('chats/WvUOok7hlsWsM6t0LQYo/msg')
        .doc(msgID)
        .set(msgMap);
  }

  Future<Stream<QuerySnapshot>> getMsg() async {
    return firestore.collection('chats/WvUOok7hlsWsM6t0LQYo/msg').snapshots();
  }
}
