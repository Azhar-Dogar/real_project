import 'package:flutter/material.dart';

import 'app_styles.dart';
import 'color_class.dart';

class LoadingDialogue extends StatefulWidget {
  String content;
  Color? color;
  LoadingDialogue({Key? key,required this.content,this.color}) : super(key: key);

  @override
  State<LoadingDialogue> createState() => _LoadingDialogueState();
}

class _LoadingDialogueState extends State<LoadingDialogue> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AlertDialog(
          backgroundColor: Colors.transparent,
          title: Container(
            child: Center(
              child: CircularProgressIndicator(
                color:(widget.color==null)?ColorsClass.red1:widget.color,
              ),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.content,
                style: AppStyles.popins(
                    style: const TextStyle(
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
