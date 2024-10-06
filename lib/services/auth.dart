import 'package:euphas/services/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final auth = FirebaseAuth.instance;

  // 登入
  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return '無效電子信箱';
        case 'user-disabled':
          return '此帳戶已被禁用';
        case 'user-not-found':
          return '無此帳號，請先註冊';
        case 'wrong-password':
          return '密碼錯誤';
        case 'invalid-credential':
          return '帳號或密碼不符/尚未註冊';
      }
    }
    return null;
  }

  // 註冊
  Future<String?> signUp(String name, String email, String password,String role) async {
    try{
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      FireStoreService().addProfile(auth.currentUser!.uid, name, email, password, role);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          return '無效電子信箱';
        case 'weak-password':
          return '密碼強度不足';
        case 'operation-not-allowed':
          return '請換另一帳號';
        case 'email-already-in-use':
          return '密碼錯誤';
      }
    }
    return null;
  }
}