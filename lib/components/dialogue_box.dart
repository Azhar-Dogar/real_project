
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_project/components/text_field_class.dart';

import 'app_styles.dart';

class DialogueBox extends StatefulWidget {
  TextEditingController textFieldController;
  String title;
  String? Function(String?)? validator;
  String? hint;
  TextInputType? keyboardType;
  void Function()? onPressedCancel;
  void Function()? onPressedSave;
  DialogueBox({Key? key,required this.textFieldController,
    required this.title,
    this.validator,
    this.hint,
    this.keyboardType,
    required this.onPressedCancel,
    required this.onPressedSave}) : super(key: key);

  @override
  State<DialogueBox> createState() => _DialogueBoxState();
}

class _DialogueBoxState extends State<DialogueBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:(AlertDialog(
          titlePadding: const EdgeInsets.only(left: 10, top: 15, bottom: 5),
          contentPadding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          actionsPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            widget.title,
            style: AppStyles.popins(
                style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          ),
          content: TextFieldClass(
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            hintText: widget.hint,
            textFieldController: widget.textFieldController,
          ),
          actions: [
            TextButton(onPressed: widget.onPressedCancel, child: Text("Cancel")),
            TextButton(onPressed: widget.onPressedSave, child: Text("Add"))
          ],
        )
        ));
  }
}
