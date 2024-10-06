import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  // 獲取題庫類別List
  Future<List<String>> getDataPathList(String dataType, String level) async {
    List<String> database = [];

    final ref = await storage.ref().child('$dataType/$level').listAll();

    for (Reference prefix in ref.prefixes) {
      database.add(prefix.name);
    }

    return database;
  }

  Future<List<Map<String,String>>> getImageList(String level, List<String> selectedContent,int trial) async {
    List<Map<String,String>> imageList = [];

    // 獲取url
    for (int i = 0; i < selectedContent.length; i++) {
      final path = '圖片/$level/${selectedContent[i]}';

      final ref = await storage.ref().child(path).listAll();

      for(var item in ref.items){
        imageList.add({'name':item.name.split('.').first,'url':await item.getDownloadURL()});
      }

    }
    imageList.shuffle();
    return imageList.sublist(0,trial);
  }



}
