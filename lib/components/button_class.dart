import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'app_styles.dart';
import 'color_class.dart';

class ButtonClass extends StatelessWidget {
  Function() onPressed;
  String buttonName;

  ButtonClass({Key? key, required this.onPressed, required this.buttonName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: ColorsClass.buttonGradient),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: TextButton(
            onPressed: onPressed,
            child: Text(
              buttonName,
              style: AppStyles.popins(
                  style: TextStyle(
                      color: ColorsClass.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w500)),
            )));
  }
}
