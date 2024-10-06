import 'package:flutter/material.dart';

SnackBar snackBar(String string){
  return SnackBar(content: Center(child: Text(string)),behavior: SnackBarBehavior.floating);
}