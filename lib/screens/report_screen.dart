
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../components/app_styles.dart';
import '../components/button_class.dart';
import '../components/color_class.dart';
import '../components/text_field_class.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool checkValue = false;
  bool checkValue2 = true;
  bool checkValue3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                "assets/images/arrow_left.png",
                width: 30,
              )),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 22.0),
          child: Container(
            height: 60,
            child: Text(
              "Reports",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.grey.shade700,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Text(
                    "Enter an email address where you want\nautomated reports to go.yours or your\naccountants its your choice",
                    style: AppStyles.popins(
                        style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/reports_pic.png",
                      height: 200,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 20, left: 15, right: 15),
                  child: TextFieldClass(
                    hintText: "Email Address",
                  ),
                ),
                Divider(
                  color: Colors.grey.shade700,
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: Text(
                    "Choose how often your reports are send,SEBET\nwill wait for two weeks after a period end,then\nreports are automated generated and\nemailed",
                    style: AppStyles.popins(
                        style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 38.0),
                  child: Column(
                    children: [
                      checkBox("MONTHLY", checkValue, onChanged: (v) {
                        setState(() {
                          checkValue = v!;
                        });
                        print(checkValue);
                      }),
                      checkBox("QUARTERLY", checkValue2, onChanged: (v) {
                        setState(() {
                          checkValue2 = v!;
                        });
                        print(checkValue2);
                      }),
                      checkBox("ANNUALLY", checkValue3, onChanged: (v) {
                        setState(() {
                          checkValue3 = v!;
                        });
                        print(checkValue3);
                      }),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: ButtonClass(onPressed: () {}, buttonName: "Save"),
            )
          ],
        ),
      ),
    );
  }

  Widget checkBox(String title, bool value, {void Function(bool?)? onChanged}) {
    return Row(
      children: [
        Checkbox(
            side: BorderSide(color: ColorsClass.green),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            value: value,
            checkColor: ColorsClass.black,
            activeColor: ColorsClass.green,
            onChanged: onChanged),
        Text(
          title,
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
