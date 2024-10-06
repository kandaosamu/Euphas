import 'package:flutter/material.dart';

// 螢幕大小
final screenSize = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
final screenWidth = screenSize.width;
final screenHeight = screenSize.height;

// 字體風格
const big = TextStyle(fontWeight: FontWeight.bold,fontSize: 35);
const medium = TextStyle(fontSize: 25);
const mediumBold =  TextStyle(fontSize: 25,fontWeight: FontWeight.bold);
const small =  TextStyle(fontSize: 20);

Map<String, dynamic> currentProfile = {};