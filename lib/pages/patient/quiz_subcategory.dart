import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/patient/quiz.dart';
import 'package:euphas/services/quiz_setting_notifier.dart';
import 'package:euphas/services/storage.dart';
import 'package:euphas/ui/loading.dart';
import 'package:euphas/ui/card_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'naming_quiz.dart';

class QuizSubCategory extends StatefulWidget {
  const QuizSubCategory({super.key, required this.category});

  final String category;

  @override
  State<QuizSubCategory> createState() => _QuizSubCategoryState();
}

class _QuizSubCategoryState extends State<QuizSubCategory> {
  List levels = [];
  late List<bool> dataPathSelected;
  int step = 0;
  String? selectedLevel;
  List<String>? dataPath;
  String? dataType;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void settingTrial(QuizSettingNotifier notifier, bool isAdd) {
    int temp = notifier.getValue('trial');
    if (isAdd == true && temp < 20) {
      notifier.setValue('trial', temp + 5);
    } else if (isAdd == false && temp > 5) {
      notifier.setValue('trial', temp - 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('sub_categories')
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          } else if (snapshot.hasData) {
            final subCategories = snapshot.data?.docs;
            return Consumer<QuizSettingNotifier>(
              builder: (context, notifier, child) {
                return Scaffold(
                  appBar: AppBar(title: Text(widget.category), centerTitle: true),
                  body: Stepper(
                    currentStep: step,
                    type: StepperType.horizontal,
                    steps: [
                      Step(
                          isActive: step == 0,
                          title: const Text('第1步: 選擇測驗'),
                          content: GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              childAspectRatio: (screenWidth * 0.3) / (screenHeight * 0.2),
                              mainAxisSpacing: screenHeight * 0.01,
                              crossAxisSpacing: screenWidth * 0.01,
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02, vertical: screenHeight * 0.02),
                              children: List.generate(subCategories!.length, (index) {
                                return CardButton(
                                    title: subCategories[index].data()['title'],
                                    enabled: true,
                                    onPressed: () {
                                      notifier.setValue(
                                          'subCategory', subCategories[index].data()['title']);
                                      dataType = subCategories[index].data()['questionDataType'];
                                      levels = subCategories[index].data()['level'];
                                      setState(() {
                                        step++;
                                      });
                                    });
                              }))),
                      // ------------------------------------------------------------------------
                      Step(
                        isActive: step == 1,
                        title: const Text('第2步: 細節設定'),
                        content: Row(
                          children: [
                            Expanded(
                                flex: 13,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          height: screenHeight * 0.08,
                                          child: Center(
                                            child: ListTile(
                                              leading: const Icon(Icons.numbers),
                                              title: const Text('測驗題數',style: mediumBold),
                                              trailing: SizedBox(
                                                width: screenWidth * 0.08,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Card(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primaryContainer,
                                                      child: IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () {
                                                            settingTrial(notifier, false);
                                                          },
                                                          icon: const Icon(Icons.remove)),
                                                    ),
                                                    Text('${notifier.getValue('trial')}',style: medium),
                                                    Card(
                                                      color: Colors.redAccent,
                                                      child: IconButton(
                                                          padding: EdgeInsets.zero,
                                                          onPressed: () {
                                                            settingTrial(notifier, true);
                                                          },
                                                          icon: const Icon(Icons.add)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Card(
                                        child: SizedBox(
                                          height: screenHeight * 0.08,
                                          child: Center(
                                            child: ListTile(
                                                leading: const Icon(Icons.trending_up),
                                                title: const Text('測驗難度',style: mediumBold),
                                                trailing: SizedBox(
                                                  width: screenWidth * 0.08,
                                                  child: Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        border: Border.all(
                                                            color: Colors.grey, width: 1)),
                                                    child: Center(
                                                      child: DropdownButton(
                                                        underline: const SizedBox.shrink(),
                                                        hint: const Text('請選擇',style: medium),
                                                        value: selectedLevel,
                                                        onChanged: (newValue) async {
                                                          selectedLevel = newValue.toString();
                                                          notifier.setValue('level', newValue);
                                                          dataPath = await Storage()
                                                              .getDataPathList(
                                                              dataType!, newValue.toString());
                                                          dataPathSelected =
                                                              List.filled(dataPath!.length, true);
                                                          notifier.setValue('database', dataPath);
                                                          setState(() {});
                                                        },
                                                        items: List.generate(
                                                          levels.length,
                                                              (index) => DropdownMenuItem(
                                                              value: levels[index]['title'],
                                                              child: Text(
                                                                  'Lv.${index + 1} : ${levels[index]['title']}')),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Card(
                                        child: dataPath == null
                                            ? const Center(child: Text('請先選擇難度！',style: mediumBold,))
                                            : SizedBox(
                                          width: screenWidth * 0.8,
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 20),
                                              const Text('題庫',style: mediumBold),
                                              ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: dataPath?.length,
                                                  itemBuilder: (context, index) {
                                                    return CheckboxListTile(
                                                        title: Text(dataPath![index]),
                                                        value: dataPathSelected[index],
                                                        onChanged: (checked) {
                                                          setState(() {
                                                            dataPathSelected[index] =
                                                            !dataPathSelected[index];
                                                          });
                                                          notifier.setValue(
                                                              'database',
                                                              dataPath!
                                                                  .asMap()
                                                                  .entries
                                                                  .where((e) =>
                                                              dataPathSelected[e.key])
                                                                  .map((e) => e.value)
                                                                  .toList());
                                                        });
                                                  }),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                    onStepTapped: (int index) {
                      if (index < step) {
                        setState(() {
                          step = index;
                        });
                      }
                    },
                    controlsBuilder: (context, controller) => const SizedBox.shrink(),
                  ),
                  floatingActionButton: FloatingActionButton.large(
                    onPressed: () async {
                      setState(() {
                        isLoading = !isLoading;
                      });
                      List<Map<String,String>> fileList = await Storage().getImageList(notifier.quizSetting['level'],
                          notifier.quizSetting['database'], notifier.quizSetting['trial']);
                      if(context.mounted){
                        notifier.quizSetting['subCategory']=='看圖說單字'?
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NamingQuiz(
                                  title: widget.category,
                                  sub: notifier.quizSetting['subCategory'],
                                  database: notifier.quizSetting['database'],
                                  trial: notifier.quizSetting['trial'],
                                  level: notifier.quizSetting['level'],
                                  fileList: fileList,
                                  hwId: '',
                                  doneTimes: 0,
                                )),
                                (route) => false)
                        :Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Quiz(
                                    title: widget.category,
                                    sub: notifier.quizSetting['subCategory'],
                                    database: notifier.quizSetting['database'],
                                    trial: notifier.quizSetting['trial'],
                                    level: notifier.quizSetting['level'],
                                    fileList: fileList,
                                    hwId: '',
                                  doneTimes: 0,
                                )),
                                (route) => false);
                        isLoading = !isLoading;
                      }
                    },
                    child: !isLoading? const Icon(Icons.play_arrow) : const CircularProgressIndicator(),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        });
  }
}