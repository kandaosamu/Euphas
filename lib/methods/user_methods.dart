import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:euphas/models/profile.dart';
import 'package:euphas/models/invitation.dart';

class UserMethods {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  Future<String?> signIn(String email, String password) async {
    String? feedback;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          feedback = '無效電子信箱';
        case 'user-disabled':
          feedback = '此帳戶已被禁用';
        case 'user-not-found':
          feedback = '無此帳號，請先註冊';
        case 'wrong-password':
          feedback = '密碼錯誤';
        case 'invalid-credential':
          feedback = '帳號或密碼不符/尚未註冊';
      }
    }
    return feedback;
  }

  Future<String?> signUp(String email, String password, String name,
      String userType) async {
    String? feedback;
    Profile profile = Profile(
        name: name,
        email: email,
        password: password,
        userType: userType,
        pairs: 'N/A');

    try {
      dynamic signUpResult;
      signUpResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firestore
          .collection('users')
          .doc(signUpResult.user.uid)
          .set(profile.toMap());
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          feedback = '無效電子信箱';
        case 'weak-password':
          feedback = '密碼強度不足';
        case 'operation-not-allowed':
          feedback = '無效電子信箱';
        case 'email-already-in-use':
          feedback = '帳號已註冊';
      }
    }
    return feedback;
  }

  Future invite(String senderId, String senderName,String receiverId,
      String receiverEmail) async {
    Invitation invitation = Invitation(
        senderId:senderId,
        senderName: senderName,
        receiverId: receiverId,
        receiverEmail: receiverEmail,
        message: senderName);
    await firestore
        .collection('users')
        .where('email', isEqualTo: receiverEmail)
        .get()
        .then((value) {
      firestore
          .collection('users')
          .doc(value.docs[0].id)
          .collection('invitation')
          .add(invitation.toMap());
    });
  }
}
