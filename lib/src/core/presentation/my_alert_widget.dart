import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyAlert{
  static void showToast(String message, {Color? backgroundColor}){
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor ?? Colors.black.withOpacity(0.80)
    );
  }
}