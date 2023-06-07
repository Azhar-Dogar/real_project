import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/drop_down_button.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../dashboard_screen.dart';
import '../../functions/auth_functions.dart';

class Signup2Screen extends StatefulWidget {
  const Signup2Screen({Key? key}) : super(key: key);

  @override
  State<Signup2Screen> createState() => _Signup2ScreenState();
}

class _Signup2ScreenState extends State<Signup2Screen> {
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController referalCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              "assets/images/arrow_left.png",
                              width: 50,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: Image.asset(
                          "assets/images/splash_logo2.png",
                          width: 90,
                        ),
                      ),
                      Text("Few",
                          style: AppStyles.popins(
                            style: TextStyle(
                                fontSize: 40,
                                color: ColorsClass.textRed,
                                fontWeight: FontWeight.w600),
                          )),
                      Text(
                        "more details\nto begin",
                        style: TextStyle(
                            fontSize: 36,
                            color: ColorsClass.textWhite,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                      color:
                                      const Color.fromRGBO(41, 41, 41, 1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: DropDownClass(
                                    onChanged: (val) {
                                      setState(() {
                                        dropDownValue = val;
                                      });
                                    },
                                    dropDownValue: dropDownValue,
                                    dropDownColor:
                                    const Color.fromRGBO(41, 41, 41, 1),
                                    dropDownValueColor: ColorsClass.textRed,
                                    hintTextColor: ColorsClass.textRed,
                                    dropDownItems: const [
                                      'Islamabad',
                                      'Lahore'
                                    ],
                                    hintText: "State",
                                    iconColor: ColorsClass.textRed,
                                  )),
                            ),
                            Expanded(
                              child: SizedBox(
                                  child: TextFieldClass(
                                    validator: (v) {
                                      if (v!.isEmpty) {
                                        return;
                                      }
                                    },
                                    textFieldController: zipCodeController,
                                    hintText: "Zip Code",
                                  )),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldClass(
                        textFieldController: cityController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Please enter city Name";
                          }
                        },
                        hintText: "City",
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFieldClass(
                        textFieldController: streetAddressController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "Please enter street address";
                          }
                        },
                        hintText: "Street Address",
                        maxLines: 6,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 34, right: 34),
                            child: Divider(
                              color: ColorsClass.textRed,
                            ),
                          ),
                          Positioned(
                              left: 128,
                              top: 2.5,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: ColorsClass.textWhite,
                              )),
                          Positioned(
                              left: 145,
                              child: CircleAvatar(
                                radius: 7,
                                backgroundColor: ColorsClass.textWhite,
                              )),
                          Positioned(
                              left: 167,
                              top: 2.5,
                              child: CircleAvatar(
                                radius: 5,
                                backgroundColor: ColorsClass.textWhite,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldClass(
                        textFieldController: referalCodeController,
                        hintText: "Referal code (Optional)",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ButtonClass(
                          buttonName: "Start",
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      LoadingDialogue(content: "Signing In",));
                              await Future.delayed(const Duration(seconds: 3));
                              await googleSignUp2(
                                  zipCode: zipCodeController.text,
                                  city: cityController.text,
                                  streetAddress: streetAddressController.text,
                                  referalCode: referalCodeController.text);
                              if(mounted){
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) =>const DashboardScreen()),
                                        (route) => false);}
                            }})
                    ]),
              ),
            ),
          ),
        ));
  }
}
