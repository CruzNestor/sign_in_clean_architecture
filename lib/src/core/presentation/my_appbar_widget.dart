import 'package:flutter/material.dart';


class MyAppBar {
  static PreferredSizeWidget hidden(context){
    return PreferredSize(
      preferredSize: const Size.fromHeight(0), // here the desired height
      child: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      )
    );
  }
}