import 'package:euphas/services/navi.dart';
import 'package:euphas/services/quiz_setting_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuizSettingNotifier())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euphas',
      theme: FlexColorScheme.light(
        scheme: FlexScheme.aquaBlue,
      ).toTheme.copyWith(
            iconTheme: const IconThemeData(
              size: 40, // 設定 Icon 的大小
            ),
        cardTheme: CardTheme(color: Theme.of(context).secondaryHeaderColor)
          ),
      home: const Navi(),
    );
  }
}
