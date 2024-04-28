import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserMethods {

  Future<String?> signIn(String email, String password) async {
    String? eMsg;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('登入錯誤：''$e.code');
      switch (e.code) {
        case 'invalid-email':
          eMsg = '無效電子信箱';
        case 'user-disabled':
          eMsg = '被禁用';
        case 'user-not-found':
          eMsg = '無此帳號，請先註冊';
        case 'wrong-password':
          eMsg = '被禁用';
        case 'invalid-credential':
          eMsg = '帳號或密碼不符/尚未註冊';
      }
    }
    return eMsg;
  }
  Future<String?> signUp(String email, String password) async {
    String? eMsg;
    try {
       await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print('登入錯誤：''$e.code');
      switch (e.code) {
        case 'invalid-email':
          eMsg = '無效電子信箱';
        case 'weak-password':
          eMsg = '帳號或密碼不符/尚未註冊';
        case 'operation-not-allowed':
          eMsg = '無效電子信箱';
        case 'email-already-in-use':
          eMsg = '帳號已註冊';
      }
    }
    return eMsg;
  }
  Future addMsg(Map<String, dynamic> msgMap, String msgID) async{
    return await FirebaseFirestore.instance.collection('chats/WvUOok7hlsWsM6t0LQYo/msg').doc(msgID).set(msgMap);
  }
  Future<Stream<QuerySnapshot>> getMsg() async {
    return await FirebaseFirestore.instance.collection('chats/WvUOok7hlsWsM6t0LQYo/msg').snapshots();
  }
}
