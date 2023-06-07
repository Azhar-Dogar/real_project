import 'package:flutter/material.dart';

class ColorsClass {
  static Color skyBlue = const Color(0xff31C6AB);
  static Color yellow = const Color(0xffFFB800);
  static Color textWhite = Colors.white;
  static Color orange = const Color(0xffFF5C00);
  static Color black = Colors.black;
  static Color textRed = const Color(0xffED3237);
  static Color textFieldHintColor = Colors.white54;
  static Color textButtonColor = const Color(0xff01AA45);
  static Gradient buttonGradient =
  const LinearGradient(colors: [Color(0xff01AA45), Color(0xff00702D)]);
  static Color textFieldBackground = const Color.fromRGBO(41, 41, 41, 1);
  static Color green = const Color(0xff01AA45);
  static Color backGroundColor = Colors.black;
  static Color grey = Colors.grey;
  static Color dividerColor = Colors.grey.shade700;
  static Gradient redGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xffED3237),
        Color(0xffAC1B1F),
      ]);
  static Color green1 = const Color(0xff00702D);
  static Color red1 = const Color(0xffAC1B1F);
  static Map<int, Color> color =
  {
    50:const Color.fromRGBO(136,14,79, .1),
    100:const Color.fromRGBO(136,14,79, .2),
    200:const Color.fromRGBO(136,14,79, .3),
    300:const Color.fromRGBO(136,14,79, .4),
    400:const Color.fromRGBO(136,14,79, .5),
    500:const Color.fromRGBO(136,14,79, .6),
    600:const Color.fromRGBO(136,14,79, .7),
    700:const Color.fromRGBO(136,14,79, .8),
    800:const Color.fromRGBO(136,14,79, .9),
    900:const Color.fromRGBO(136,14,79, 1),
  };
}
