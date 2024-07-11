import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final screenSize = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
final screenWidth = screenSize.width;
final screenHeight = screenSize.height;

String userId = FirebaseAuth.instance.currentUser!.uid;
String userName = '';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;