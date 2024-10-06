import 'package:flutter/material.dart';

class QuizSettingNotifier extends ChangeNotifier {
  final Map<String, dynamic> _quizSetting = {
    'subCategory':'',
    'trial':10,
    'level': '',
    'database':[],
  };

  Map<String, dynamic> get quizSetting => _quizSetting;

  // 取得特定 key 的值
  dynamic getValue(String key) {
    return _quizSetting[key];
  }

  // 設定特定 key 的值
  dynamic setValue(String key, dynamic value) {
    _quizSetting[key]=value;
    notifyListeners();
  }

  // 移除特定 key 的值
  void removeValue(String key) {
    if (_quizSetting.containsKey(key)) {
      _quizSetting.remove(key);
      notifyListeners(); // 當 key 被移除時，通知監聽者
    }
  }
}
