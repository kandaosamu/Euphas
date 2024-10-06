import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/models/grade.dart';
import 'package:euphas/models/message.dart';
import 'package:euphas/models/profile.dart';
import 'package:euphas/services/auth.dart';
import 'package:flutter/material.dart';

class FireStoreService {
  final firestore = FirebaseFirestore.instance;

  // 獲取用戶資料
  Future<Map<String, dynamic>?> getProfile() async {
    Map<String, dynamic>? profile;
    await firestore
        .collection('users')
        .doc(AuthService().auth.currentUser?.uid)
        .get()
        .then((value) {
      profile = value.data();
    });
    return profile;
  }

  // 新增用戶資料
  Future<void> addProfile(
      String uid, String name, String email, String password, String role) async {
    await firestore.collection('users').doc(uid).set(
        Profile(name: name, email: email, password: password, role: role, headshotURL: '').toMap());
    firestore
        .collection('users')
        .doc(uid)
        .set(role == 'patient' ? {'myTherapist': ''} : {'myPatients': []}, SetOptions(merge: true));
  }

  // 獲取測驗類別
  Future<List<Map<String, dynamic>>?> getCategory() async {
    List<Map<String, dynamic>>? categories;
    await firestore.collection('categories').get().then((value) {
      categories = value.docs.map((e) => e.data()).toList();
    });
    return categories;
  }

  // 獲得測驗子類
  Future<QuerySnapshot<Map<String, dynamic>>?> getSubCategory(String category) async {
    QuerySnapshot<Map<String, dynamic>>? subCategories;
    subCategories =
        await firestore.collection('sub_categories').where('category', isEqualTo: category).get();
    return subCategories;
  }

  Future<void> saveGrade(String? hwId, int score, int trial, List<String> audioPathList) async {
    await firestore.collection('grades').add(Grade(
            patient: currentProfile['name'],
            homeworkId: hwId ?? '',
            grade: '${(score * 100 / trial).toStringAsFixed(2)}%',
            details: '',
            finishTime: '${DateTime.now()}',
            myTherapist: currentProfile['myTherapist'],
            audioPathList: audioPathList)
        .toMap());
    DocumentReference ref = firestore.collection('homeworks').doc(hwId);
    ref.get().then((value) {
      if (value['doneTimes'] < value['toDoTimes']) {
        ref.update({'doneTimes': (value['doneTimes'] + 1)});
      }
    });
  }

  Future invite(String sender, String receiver, BuildContext context, TextEditingController controller) async {
    Message invitation = Message(sender: sender, receiver: receiver, type: 'invitation');
    firestore
        .collection('messages')
        .where('sender', isEqualTo: sender)
        .where('receiver', isEqualTo: receiver)
        .where('type', isEqualTo: 'invitation')
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        dynamic feedback = await firestore.collection('messages').add(invitation.toMap());
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(feedback is DocumentReference ? '發送成功！' : feedback),
              behavior: SnackBarBehavior.floating));
          controller.clear();
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('已有邀請，請勿重複寄送'), behavior: SnackBarBehavior.floating));
        }
      }
    });
  }

  Future acceptInvitation(QueryDocumentSnapshot<Map<String, dynamic>>? data) async {
    firestore.collection('users').where('email', isEqualTo: data?['sender']).get().then((value) {
      firestore.collection('users').doc(value.docs.first.id).update({
        'myPatients': FieldValue.arrayUnion([data?['receiver']])
      });
    });

    firestore
        .collection('users')
        .doc(AuthService().auth.currentUser!.uid)
        .update({'myTherapist': data?['sender']});
    currentProfile = (await FireStoreService().getProfile())!;

    firestore.collection('messages').add(
        Message(sender: data?['receiver'], receiver: data?['sender'], type: 'notification')
            .toMap());

    firestore.collection('messages').doc(data!.id).delete();
  }
}
