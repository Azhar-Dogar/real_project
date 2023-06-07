
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'app_styles.dart';
import 'color_class.dart';

class TextFieldClass extends StatelessWidget {
  String? hintText;
  Widget? suffix;
  int? maxLines;
  TextEditingController? textFieldController;
  String? Function(String?)? validator;
  Icon? suffixIcon;
  TextInputType? keyboardType;
  void Function(String)? onChanged;
  TextFieldClass(
      {Key? key,
        this.hintText,
        this.suffix,
        this.maxLines,
        this.textFieldController,
        this.keyboardType,
        this.suffixIcon,
        this.onChanged,
        this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged:onChanged,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white70),
      validator: validator,
      controller: textFieldController,
      maxLines: maxLines,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          fillColor: ColorsClass.textFieldBackground,
          enabled: true,
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: ColorsClass.textFieldBackground, width: 0)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          errorStyle: TextStyle(color: ColorsClass.textRed),
          filled: true,
          suffix: suffix,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                12,
              ),
              borderSide:
              BorderSide(color: ColorsClass.textFieldBackground, width: 0)),
          contentPadding: const EdgeInsets.only(left: 14, top: 5),
          hintText: hintText,
          hintStyle: AppStyles.popins(
              style: TextStyle(
                color: ColorsClass.textFieldHintColor,
              ))),
    );
  }
}
