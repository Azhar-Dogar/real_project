
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../components/app_styles.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
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
              "Weekly Schedule",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
  }
}
