import 'package:flutter/material.dart';
import 'package:euphas/constant.dart';

class NavHome extends StatefulWidget {
  const NavHome({super.key});

  @override
  State<NavHome> createState() => _NavHome();
}

class _NavHome extends State<NavHome> {
  ValueNotifier userTypeNotifier = ValueNotifier(
      userProfile['userType']);

  @override
  void initState() {
    super.initState();
    _getUserProfile();
  }

  Future<void> _getUserProfile() async {
    String userId = auth.currentUser!.uid;
    var document = await firestore.collection('users').doc(userId).get();
    setState(() {
      userProfile = document.data()!;
      userTypeNotifier.value = userProfile['userType'];
  });}

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: userTypeNotifier, builder: (context,userType,child){
      if (userType == 'therapist') {
        return ElevatedButton(onPressed: (){
          userTypeNotifier.value = 'patient';
        }, child: const Text('切換至患者端'));
      } else if (userType == 'patient') {
        return ElevatedButton(onPressed: (){
          userTypeNotifier.value = 'therapist';
        }, child: const Text('切換至治療師端'));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}