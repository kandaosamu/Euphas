import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/both/message.dart';
import 'package:euphas/pages/patient/progress.dart';
import 'package:euphas/pages/therapist/progress.dart';
import 'package:euphas/pages/patient/homework.dart';
import 'package:euphas/pages/patient/quiz_category.dart';
import 'package:euphas/pages/therapist/assignment.dart';
import 'package:euphas/pages/therapist/invitation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.profile});

  final Map<String, dynamic> profile;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => BodyNotifier(),
        child: Consumer<BodyNotifier>(
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  '歡迎！ ${widget.profile['name']}',
                  style: mediumBold,
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FirebaseAuth.instance.signOut();
                        });
                      },
                      icon: const Icon(Icons.exit_to_app))
                ],
              ),
              body: IndexedStack(
                index: model.selectedIndex,
                children: widget.profile['role'] == 'patient'
                    ? const [QuizCategory(), HomeworkPage(), MessagePage(), PatientProgress(),]
                    : const [TherapistHome(), InvitationPage(), MessagePage(),TherapistProgress(), ],
              ),
              bottomNavigationBar: NavigationBar(
                selectedIndex: model.selectedIndex,
                onDestinationSelected: (index) {
                  model.selectTab(index);
                },
                destinations: [
                  const NavigationDestination(icon: Icon(Icons.home), label: '主頁'),
                  NavigationDestination(
                      icon: Icon(widget.profile['role'] == 'patient'
                          ? Icons.menu_book_sharp
                          : Icons.person_add),
                      label: widget.profile['role'] == 'patient' ? '作業' : '邀請'),
                  const NavigationDestination(icon: Icon(Icons.message), label: '訊息'),
                  const NavigationDestination(icon: Icon(Icons.assessment), label: '成績'),
                ],
              ),
            );
          },
        ));
  }
}

class BodyNotifier with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
