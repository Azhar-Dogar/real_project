import 'package:flutter/material.dart';

class DebtModel {
  String title;
  String spentMoney;
  String remainingBalance;
  Color inidicatorColor;

  DebtModel(
      {required this.title,
        required this.spentMoney,
        required this.remainingBalance,
        required this.inidicatorColor});
}
