// ignore_for_file: avoid_print
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:euphas/config/constants.dart';
import 'package:euphas/pages/both/home.dart';
import 'package:euphas/services/firestore.dart';
import 'package:euphas/ui/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class Quiz extends StatefulWidget {
  final String title;
  final String sub;
  final List<String> database;
  final int trial;
  final String level;
  final List<Map<String, String>> fileList;
  final String? hwId;
  final int doneTimes;

  const Quiz(
      {super.key,
      required this.title,
      required this.sub,
      required this.database,
      required this.trial,
      required this.level,
      required this.fileList,
      required this.hwId,
      required this.doneTimes});

  @override
  State<Quiz> createState() => _Quiz();
}

class _Quiz extends State<Quiz> {
  int order = 0;
  List<String> options = [];
  String answer = '';
  int score = 0;
  bool isRecording = false;
  AudioRecorder recorder = AudioRecorder();
  AudioPlayer audioPlayer = AudioPlayer();
  late String audioPath;
  String? filePath;
  String? currentAudioPath;
  List<bool> listAnswered = [];
  List<String> audioPathList = [];

  @override
  void initState() {
    super.initState();
    initRecorder();
    setOptions();
    isRecording = false;
    listAnswered = [];
    audioPathList = [];
  }

  Future<void> initRecorder() async {
    if (await Permission.microphone.request() != PermissionStatus.granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('麥克風存取遭拒，請至設定允許存取')));
    }
  }

  Future<void> startRecording() async {
    try {
      setState(() {
        isRecording = !isRecording;
      });
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      filePath = '$appDocPath/temp.wav';

      recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: filePath!);
    } catch (e) {
      print('開始錄音報錯：$e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await recorder.stop();
      setState(() {
        isRecording = !isRecording;
      });
      if (path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('請先同意存取麥克風！')));
        }
      } else if (widget.hwId != '') {
        File audioFile = File(path);
        currentAudioPath = '聲音/${currentProfile['name']}/${widget.hwId}/${widget.doneTimes + 1}/$answer.wav';
        await FirebaseStorage.instance.ref().child(currentAudioPath!).putFile(audioFile);
        if (!audioPathList.contains(currentAudioPath)) {
          audioPathList.add(currentAudioPath!);
        }
      }
    } catch (e) {
      print('停止錄音報錯：$e');
    }
  }

  Future<void> playRecording() async {
    try {
      // final url = await Storage().storage.ref().child(currentAudioPath!).getDownloadURL();
      AudioPlayer().play(UrlSource(filePath!));
    } catch (e) {
      print('播放報錯：$e');
    }
  }

  Future<void> setOptions() async {
    options.clear();
    final temp = List<Map<String, dynamic>>.from(widget.fileList);
    answer = widget.fileList[order]['name']!;
    options.add(answer);
    temp.removeWhere((element) => element['name'] == answer);
    temp.shuffle();
    for (int i = 0; i < 3; i++) {
      options.add(temp[i]['name']!);
    }
    options.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leadingWidth: screenWidth * 0.15,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: currentProfile)), (route) => false);
                },
                icon: const Icon(Icons.arrow_back_sharp)),
            IconButton(
                onPressed: () => isRecording ? stopRecording() : startRecording(),
                icon: isRecording ? const Icon(Icons.stop_circle) : const Icon(Icons.mic)),
            Visibility(
              visible: filePath == null || filePath == '' ? false : true,
              child: IconButton(
                  onPressed: () {
                    playRecording();
                  },
                  icon: const Icon(Icons.play_arrow)),
            ),
          ],
        ),
        title: SizedBox(
            width: screenWidth * 0.15,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                LinearProgressIndicator(
                  color: Colors.teal,
                  minHeight: 20.0,
                  value: (order.toDouble() + 1) / widget.trial,
                ),
                Text(
                  '${order + 1}/${widget.trial}',
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            )),
        actions: [
          Center(
            child: Text(
              '$score',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            width: 50,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            widget.fileList.isEmpty
                ? const Loading()
                : Image.network(
                    widget.fileList[order]['url']!,
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),
            GridView.count(
                shrinkWrap: true,
                crossAxisCount: 4,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.03),
                mainAxisSpacing: 50,
                childAspectRatio: 1.7,
                crossAxisSpacing: 50,
                children: List.generate(4, (index) {
                  return ElevatedButton(
                      onPressed: () async {
                        if (listAnswered.length < order + 1 || !listAnswered[order]) {
                          if (options[index] == answer) {
                            setState(() {
                              score++;
                              // isAnswered[index] = true;
                            });
                          }
                          listAnswered.add(true);
                        }
                        await Future.delayed(const Duration(milliseconds: 500));
                        if (order < (widget.trial - 1)) {
                          setState(() {
                            order++;
                            setOptions();
                          });
                        } else if (order == (widget.trial - 1)) {
                          showGradeDialog(score, widget.trial);
                        }
                      },
                      child: Text(
                        options[index],
                        style: const TextStyle(fontSize: 30),
                      ));
                })),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: IconButton(
                      onPressed: () {
                        if (order > 0) {
                          setState(() {
                            order--;
                            setOptions();
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_circle_left_rounded,
                        size: 50,
                      )),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        if (order < (widget.trial - 1)) {
                          setState(() {
                            order++;
                            setOptions();
                            filePath = '';
                          });
                        } else if (order == (widget.trial - 1)) {
                          showGradeDialog(score, widget.trial);
                        }
                      },
                      icon: const Icon(
                        Icons.arrow_circle_right_rounded,
                        size: 50,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showGradeDialog(int score, int trial) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              '成績',
              style: mediumBold,
            ),
            content: Text(
              '$score/$trial (${(score * 100 / trial).toStringAsFixed(2)}%)',
              style: medium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (widget.hwId != null) {
                    FireStoreService().saveGrade(widget.hwId, score, trial, audioPathList);
                  }
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(profile: currentProfile)), (route) => false);
                },
                child: const Text(
                  '回主頁',
                  style: medium,
                ),
              ),
            ],
          );
        });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
