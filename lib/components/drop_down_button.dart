import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iconly/iconly.dart';

class DropDownClass extends StatefulWidget {
  List dropDownItems;
  String hintText;
  Color iconColor;
  Color hintTextColor;
  Color dropDownValueColor;
  Color? dropDownColor;
  var dropDownValue;
  void Function(dynamic)? onChanged;
  bool? isExpanded;
  DropDownClass(
      {Key? key,
        this.dropDownColor,
        this.dropDownValue,
        this.onChanged,
        this.isExpanded,
        required this.dropDownValueColor,
        required this.dropDownItems,
        required this.hintText,
        required this.iconColor,
        required this.hintTextColor})
      : super(key: key);

  @override
  State<DropDownClass> createState() => _DropDownClassState();
}

class _DropDownClassState extends State<DropDownClass> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: DropdownButton<dynamic>(
            dropdownColor: widget.dropDownColor,
            value: widget.dropDownValue,
            iconEnabledColor: widget.iconColor,
            icon: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(IconlyLight.arrow_down_2),
            ),
            style: TextStyle(fontSize: 20, color: widget.dropDownValueColor),
            hint: Text(
              widget.hintText,
              style: TextStyle(color: widget.hintTextColor),
            ),
            items: widget.dropDownItems.map((dropDownValue) {
              return DropdownMenuItem(
                value: dropDownValue,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(dropDownValue,style: const TextStyle(fontSize:17),),
                ),
              );
            }).toList(),
            onChanged: widget.onChanged),
      ),
    );
  }
}
