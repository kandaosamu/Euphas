import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/services/firestore.dart';
import 'package:euphas/services/storage.dart';
import 'package:euphas/ui/loading.dart';
import 'package:flutter/material.dart';

class PatientProgress extends StatefulWidget {
  const PatientProgress({super.key});

  @override
  State<PatientProgress> createState() => _PatientProgressState();
}

class _PatientProgressState extends State<PatientProgress> {
  final firestore = FirebaseFirestore.instance;
  List? audioPathList;

  @override
  void initState() {
    super.initState();
    FireStoreService().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('homeworks').where('patient', isEqualTo: currentProfile['email']).snapshots(),
        builder: (context, hwSnapshot) {
          if (!hwSnapshot.hasData) {
            return const Center(child: Text('尚無作業', style: big));
          } else {
            final hwList = hwSnapshot.data?.docs.map((e) => e.data()).toList();
            return StreamBuilder(
                stream: firestore.collection('grades').where('homeworkId', whereIn: hwList?.map((e) => e['hwId']).toList()).snapshots(),
                builder: (context, gradeSnapshot) {
                  if (gradeSnapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else if (!gradeSnapshot.hasData) {
                    return const Center(child: Text('尚無作業成績', style: big));
                  } else {
                    final gradeList = gradeSnapshot.data?.docs.map((e) => e.data()).toList();
                    return Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: ListView.builder(
                              itemCount: hwList!.length,
                              padding: const EdgeInsets.all(25),
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Text("${hwList[index]['category']}：${hwList[index]['subCategory']}", style: mediumBold),
                                      Text('難度：${hwList[index]['level']} 題數：${hwList[index]['trial']}', style: medium),
                                      const Divider(thickness: 5),
                                      ListView.builder(
                                        padding: const EdgeInsets.all(25),
                                        physics: const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: hwList[index]['toDoTimes'],
                                        itemBuilder: (context, order) {
                                          final gradeOfHw = gradeList?.where((g) => g['homeworkId'] == hwList[index]['hwId']).toList();
                                          if (gradeOfHw == null || gradeOfHw.isEmpty || gradeOfHw.length < (order + 1)) {
                                            return TextButton(onPressed: null, child: Text('第${order + 1}次： X', style: medium));
                                          } else {
                                            return TextButton(
                                              onPressed: gradeOfHw[order]['audioPathList'].isEmpty
                                                  ? null
                                                  : () {
                                                      setState(() {
                                                        audioPathList = gradeOfHw[order]['audioPathList'];
                                                      });
                                                    },
                                              child: Text(
                                                '🎧 第${order + 1}次： 成績 ${gradeOfHw[order]['grade']} ',
                                                style: medium,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        const VerticalDivider(thickness: 5),
                        Expanded(
                          flex: 2,
                          child: audioPathList == null || audioPathList == []
                              ? const Center(
                                  child: Text(
                                  '無音檔',
                                  style: mediumBold,
                                ))
                              : ListView.builder(
                                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 25),
                                  shrinkWrap: true,
                                  itemCount: audioPathList?.length,
                                  itemBuilder: (context, index4) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              final url = await Storage().storage.ref().child(audioPathList?[index4]).getDownloadURL();
                                              AudioPlayer().play(UrlSource(url));
                                            },
                                            child: Text(
                                              audioPathList?[index4].split('/').last.split('.').first,
                                              style: mediumBold,
                                            )),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    );
                  }
                });
          }
        });
  }
}
