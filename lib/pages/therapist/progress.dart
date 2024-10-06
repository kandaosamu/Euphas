import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/services/storage.dart';
import 'package:euphas/ui/loading.dart';
import 'package:flutter/material.dart';

class TherapistProgress extends StatefulWidget {
  const TherapistProgress({super.key});

  @override
  State<TherapistProgress> createState() => _TherapistProgress();
}

class _TherapistProgress extends State<TherapistProgress> {
  final firestore = FirebaseFirestore.instance;
  List? hwIdList;
  List? audioPathList;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('users').where('email', whereIn: currentProfile['myPatients']).snapshots(),
        builder: (context, patientsSnapshot) {
          final patients = patientsSnapshot.data?.docs.map((e) => e.data()).toList();
          if (patientsSnapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (!patientsSnapshot.hasData || patients == null) {
            return const Center(child: Text('尚無患者', style: big));
          } else {
            return StreamBuilder(
                stream: firestore
                    .collection('homeworks')
                    .where('patient', whereIn: currentProfile['myPatients'])
                    .where('therapist', isEqualTo: currentProfile['email'])
                    .snapshots(),
                builder: (context, hwSnapshot) {
                  final hws = hwSnapshot.data?.docs.map((e) => e.data()).toList();
                  if (hwSnapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  } else if (!hwSnapshot.hasData || hws == null) {
                    return const Center(child: Text('尚無患者的作業', style: big));
                  } else {
                    return StreamBuilder(
                        stream: firestore.collection('grades').where('homeworkId', whereIn: hws.map((e) => e['hwId']).toList()).snapshots(),
                        builder: (context, gradeSnapshot) {
                          final grades = gradeSnapshot.data?.docs.map((e) => e.data()).toList();
                          if (gradeSnapshot.connectionState == ConnectionState.waiting) {
                            return const Loading();
                          } else if (!gradeSnapshot.hasData || grades == null) {
                            return const Center(child: Text('尚無作業成績', style: big));
                          } else {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: ListView.builder(
                                      itemCount: patients.length,
                                      padding: const EdgeInsets.all(25),
                                      itemBuilder: (context, index) {
                                        final hwOfThePatient = hws.where((hw) => hw['patient'] == patients[index]['email']).toList();
                                        return Card(
                                          margin: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${patients[index]['name']}',
                                                style: mediumBold,
                                              ),
                                              const Divider(
                                                thickness: 5,
                                              ),
                                              hwOfThePatient.isEmpty
                                                  ? const Center(child: Text('該患者尚無作業'))
                                                  // : Center(child: Text('${hwOfThePatient}'))
                                                  : ListView.separated(
                                                      physics: const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount: hwOfThePatient.length,
                                                      itemBuilder: (context, hwOrder) {
                                                        final gradeOfHw =
                                                            grades.where((grade) => grade['homeworkId'] == hwOfThePatient[hwOrder]['hwId']).toList();
                                                        return Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Expanded(
                                                                child: Center(
                                                                  child: Text('${hwOfThePatient[hwOrder]['category']}'
                                                                      '/${hwOfThePatient[hwOrder]['subCategory']}'
                                                                      '/${hwOfThePatient[hwOrder]['level']}'
                                                                      '/${hwOfThePatient[hwOrder]['trial']}題',style: medium,),
                                                                )),
                                                            Expanded(
                                                                child: ListView.builder(
                                                                  physics: const NeverScrollableScrollPhysics(),
                                                                  shrinkWrap: true,
                                                                    itemCount: hwOfThePatient[hwOrder]['toDoTimes'],
                                                                    itemBuilder: (context, toDoTime) {
                                                                      if (gradeOfHw.isEmpty || gradeOfHw.length < (toDoTime + 1)) {
                                                                        return TextButton(onPressed: null, child: Text('第${toDoTime + 1}次： X', style: medium));
                                                                      } else {
                                                                        return TextButton(
                                                                          onPressed: gradeOfHw[toDoTime]['audioPathList'].isEmpty
                                                                              ? null
                                                                              : () {
                                                                                  setState(() {
                                                                                    audioPathList = gradeOfHw[toDoTime]['audioPathList'];
                                                                                  });
                                                                                },
                                                                          child: Text(
                                                                            '${gradeOfHw[toDoTime]['audioPathList'].isEmpty ? '' : '🎧'}第${toDoTime + 1}'
                                                                                '次： 成績 ${gradeOfHw[toDoTime]['grade']} ',
                                                                            style: medium,
                                                                          ),
                                                                        );
                                                                      }
                                                                    })),
                                                          ],
                                                        );
                                                      },
                                                      separatorBuilder: (BuildContext context, int index) {
                                                        return const Padding(
                                                          padding: EdgeInsets.all(20.0),
                                                          child: Divider(),
                                                        );
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
        });
  }
}
