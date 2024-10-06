import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/patient/quiz.dart';
import 'package:euphas/services/storage.dart';
import 'package:euphas/ui/loading.dart';
import 'package:flutter/material.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  bool isLoading = false;
  final firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firestore.collection('homeworks').snapshots(),
        builder: (context, snapshot) {
          final hw = snapshot.data?.docs
              .where((element) => element['doneTimes'] < element['toDoTimes'])
              .where((element) => element['patient'] == currentProfile['email'])
              .toList();
          return !snapshot.hasData
              ? const Center(child: Text('尚無作業',style: big,),)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: hw?.length,
                  itemBuilder: (context, index) {
                    final data = hw?[index];
                    return Column(
                      children: [
                        const SizedBox(height: 10),
                        Card(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1, vertical: screenHeight * 0.01),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Stack(alignment: Alignment.center, children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircularProgressIndicator(
                                        value: data?['doneTimes'] / data?['toDoTimes'],
                                        strokeWidth: 5,
                                      ),
                                    ),
                                    Text(
                                      '${data?['doneTimes']}/${data?['toDoTimes']}',
                                      style: small,
                                    )
                                  ])),
                              Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '\n${data?['category']}：${data?['subCategory']}',
                                        style: mediumBold,
                                      ),
                                      Text(
                                        '難度：${data?['level']}\n題數：${data?['trial']}\n',
                                        style: small,
                                      ),
                                    ],
                                  )),
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    List<String>? content = List.from((data?['content'] as List)
                                        .map((item) => item as String)
                                        .toList());
                                    setState(() {
                                      isLoading = !isLoading;
                                    });
                                    List<Map<String, String>> fileList = await Storage()
                                        .getImageList(data?['level'], content, data?['trial']);

                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Quiz(
                                                  title: data?['category'],
                                                  sub: data?['subCategory'],
                                                  database: content,
                                                  trial: data?['trial'],
                                                  level: data?['level'],
                                                  fileList: fileList,
                                                  hwId: data?['hwId'],
                                                  doneTimes: data?['doneTimes'],
                                                )),
                                        (Route<dynamic> route) => false,
                                      );
                                      isLoading = !isLoading;
                                    }
                                  },
                                  child:
                                      const SizedBox(height: 60, child: Center(child: Text('做作業',style: medium,))),
                                ),
                              ),
                              const Expanded(child: SizedBox.shrink()),
                            ],
                          ),
                        ),
                      ],
                    );
                  });
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
