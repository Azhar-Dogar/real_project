import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/app_styles.dart';
import '../components/color_class.dart';
import '../functions/categories_data.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xff292929),
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
              "Profile",
              style: AppStyles.popins(
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w500)),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) {
          CategoriesData();
        },
        child: Consumer<CategoriesData>(
            builder: (BuildContext context, value, Widget? child) {
              return Column(children: [
                Container(
                    color: const Color(0xff292929),
                    child: Image.asset("assets/images/profile.png")),
                userInfo(value),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.09,
                            height: MediaQuery.of(context).size.height * 0.040,
                            decoration: BoxDecoration(
                                color: ColorsClass.green,
                                borderRadius: BorderRadius.circular(12)),
                            child: const Icon(
                              Icons.edit,
                              size: 28,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Edit Profile",
                              style: AppStyles.popins(
                                  style: TextStyle(
                                      color: ColorsClass.green, fontSize: 16)),
                            ),
                          )
                        ],
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.grey.shade700,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Your Referal Code",
                        style:
                        AppStyles.popins(style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20.0,right: 20,top: 14),
                  child: DottedBorder(
                    radius: const Radius.circular(10),
                    dashPattern: const [10, 10, 10, 10],
                    borderType: BorderType.RRect,
                    strokeWidth: 2,
                    color: Colors.grey.shade800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "AA34XX6",
                          style: AppStyles.popins(
                              style: TextStyle(color: ColorsClass.textRed,fontSize: 36)),
                        )
                      ],
                    ),
                  ),
                ),

              ]);
            }),
      ),
    );
  }

  Widget userInfo(value) {
    return Column(
      children: [
        Text(
          "${value.userModel!.firstName} ${value.userModel!.lastName}",
          style: AppStyles.popins(
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w600)),
        ),
        Text(
          value.userModel!.email,
          style: AppStyles.popins(
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
        Text(
          value.userModel!.phoneNumber,
          style: AppStyles.popins(
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
        Text(
          value.userModel!.streetAddress,
          style: AppStyles.popins(
              style: const TextStyle(
                color: Colors.white,
              )),
        ),
      ],
    );
  }
}
