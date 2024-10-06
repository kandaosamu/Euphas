import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/models/homework.dart';
import 'package:euphas/services/firestore.dart';
import 'package:euphas/services/storage.dart';
import 'package:euphas/ui/loading.dart';
import 'package:flutter/material.dart';

class TherapistHome extends StatefulWidget {
  const TherapistHome({super.key});

  @override
  State<TherapistHome> createState() => _TherapistHome();
}

class _TherapistHome extends State<TherapistHome> {
  int currentStep = 0;
  String? selectedPatient;
  String? selectedCategory;
  String? selectedSubCategory;
  List<bool>? selectedContent;
  int? selectedTrial;
  String? selectedLevel;
  int selectedTimes = 1;
  bool isLoading = false;

  // final List<String> category = ['命名', '理解', '閱讀', '寫作'];
  final List<String> category = ['理解'];
  List<dynamic> subCategory = [];
  List<String> content = [];
  final List<int> trial = [10, 15, 20];
  List<String> level = [];
  Map theSub = {};

  // 再加一個計數器讓治療師選次數

  @override
  void initState() {
    super.initState();
    FireStoreService().getProfile();
    content.clear();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loading();
    } else if(currentProfile['myPatients'].isEmpty){
      return const Center(child: Text('尚無患者，請先邀請配對再進行作業指派！',style: big,));
    } else {
      return Stepper(
            steps: [
              Step(
                isActive: currentStep == 0,
                title: const Text('選擇學生'),
                content: dropdownButton(
                  selectedPatient,
                  (value) {
                    setState(() {
                      selectedPatient = value;
                      level.clear();
                      content.clear();
                    });
                  },
                  List.generate(currentProfile['myPatients'].length, (index) {
                    final patient = currentProfile['myPatients'][index];
                    return DropdownMenuItem<String>(
                      value: patient,
                      child: Text(patient),
                    );
                  }),
                ),
              ),
              Step(
                  isActive: currentStep == 1,
                  title: const Text('指派作業'),
                  content: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        dropdownButton(selectedCategory, (value) async {
                          selectedCategory = value!;
                          final temp = await FireStoreService().getSubCategory(selectedCategory!);
                          subCategory = temp!.docs.toList();
                          setState(() {});
                        },
                            List.generate(
                                category.length,
                                (index) => DropdownMenuItem(
                                    value: category[index], child: Text(category[index])))),
                        // 子項目
                        dropdownButton(
                            selectedSubCategory,
                            selectedCategory != null
                                ? (newValue) {
                                    selectedSubCategory = newValue!;
                                    theSub = subCategory
                                        .where((element) => element['title'] == newValue)
                                        .first
                                        .data();
                                    level.clear();
                                    content.clear();
                                    for (Map<String, dynamic> lv in theSub['level']) {
                                      level.add(lv['title']!);
                                    }
                                    setState(() {});
                                  }
                                : null,
                            List.generate(subCategory.length, (index) {
                              return DropdownMenuItem(
                                  value: subCategory[index]['title'],
                                  child: Text(subCategory[index]['title']));
                            })),
                        // 難度
                        dropdownButton(
                            selectedLevel,
                            selectedCategory != null && selectedSubCategory != null
                                ? (newValue) async {
                                    selectedLevel = newValue;
                                    await Storage()
                                        .getDataPathList('圖片', selectedLevel!)
                                        .then((value) {
                                      content = value;
                                    });
                                    selectedContent =
                                        List.generate(content.length, (index) => true);
                                    setState(() {});
                                  }
                                : null,
                            List.generate(
                                level.length,
                                (index) => DropdownMenuItem(
                                    value: level[index], child: Text(level[index])))),
                        // 題數
                        dropdownButton(selectedTrial, (value) {
                          setState(() {
                            selectedTrial = value;
                          });
                        },
                            List.generate(
                                trial.length,
                                (index) => DropdownMenuItem(
                                    value: trial[index], child: Text(trial[index].toString())))),
                        const SizedBox(
                          width: 50,
                        ),
                        // 練習次數
                        IconButton(
                            onPressed: () {
                              if (selectedTimes > 1) {
                                setState(() {
                                  selectedTimes--;
                                });
                              }
                            },
                            icon: const Icon(Icons.remove)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Text(
                            selectedTimes.toString(),
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                selectedTimes++;
                              });
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  )),
              Step(
                isActive: currentStep == 2,
                title: const Text('作業細節設定'),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.4,
                      child: SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: content.length,
                            itemBuilder: (context, index) {
                              return CheckboxListTile(
                                  controlAffinity: ListTileControlAffinity.leading,
                                  title: Text(
                                    content[index],
                                    style: const TextStyle(fontSize: 25),
                                  ),
                                  value: selectedContent?[index],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedContent?[index] = value!;
                                    });
                                  });
                            }),
                      ),
                    ),
                  ],
                ),
              )
            ],
            currentStep: currentStep,
            onStepContinue: () async {
              if (currentStep == 0 && selectedPatient != null) {
                setState(() {
                  currentStep++;
                });
              } else if (currentStep == 1 &&
                  selectedCategory != null &&
                  selectedSubCategory != null &&
                  selectedLevel != null &&
                  selectedTrial != null) {
                setState(() {
                  currentStep++;
                });
              } else if (currentStep == 2 && selectedContent!.contains(true)) {
                DocumentReference ref = await firestore.collection('homeworks').add(Homework(
                        therapist: currentProfile['email'],
                        patient: selectedPatient!,
                        category: selectedCategory!,
                        subCategory: selectedSubCategory!,
                        level: selectedLevel!,
                        trial: selectedTrial!,
                        content: content
                            .asMap()
                            .entries
                            .where((entry) => selectedContent![entry.key])
                            .map((entry) => entry.value)
                            .toList(),
                        toDoTimes: selectedTimes,
                        doneTimes: 0)
                    .toMap());
                ref.update({'hwId': ref.id});
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      behavior: SnackBarBehavior.floating, content: Text('發送成功，將刷新頁面')));
                }
                await Future.delayed(const Duration(milliseconds: 1500));

                setState(() {
                  currentStep = 0;
                  selectedPatient = null;
                  selectedCategory = null;
                  selectedSubCategory = null;
                  selectedLevel = null;
                  selectedTrial = null;
                  selectedContent = null;
                  selectedTimes = 1;
                });
              }
            },
            onStepCancel: () {
              if (currentStep != 0) {
                setState(() {
                  currentStep--;
                });
              }
            },
          );
    }
  }
}

Widget dropdownButton(
    dynamic value, void Function(dynamic)? onChanged, List<DropdownMenuItem> items) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey, width: 1)),
    child: DropdownButton(
      hint: const Text('請選擇'),
      value: value,
      onChanged: onChanged,
      items: items,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 42,
      underline: const SizedBox(),
    ),
  );
}
