import 'package:flutter/material.dart';

class AppConsts {
  static const String logoPath = 'lib/assets/logo.png';

  static const primaryColor = Color.fromRGBO(45, 77, 50, 1);
  static const polor = Color.fromARGB(255,37, 63, 40);
  static const secondaryColor = Color(0xFFFFD700);
  
  
  // Calendar Text Styles
  static TextStyle titleTextStyle = TextStyle(
                    color: AppConsts.secondaryColor,
                    fontWeight: FontWeight.bold,
                  );
  static TextStyle secondTitleTextStyle = TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  );
                  
  static TextStyle bodyTextStyle = TextStyle(
                    color: AppConsts.secondaryColor,
                    fontWeight: FontWeight.bold,
                  );
  static TextStyle trailingTextStyle = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  );

}