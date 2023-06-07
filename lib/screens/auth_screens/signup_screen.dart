
import 'package:flutter/material.dart';

import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../../functions/auth_functions.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        "assets/images/arrow_left.png",
                        width: 50,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Image.asset(
                      "assets/images/splash_logo2.png",
                      width: 90,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Hello!",
                      style: AppStyles.popins(
                          style: TextStyle(
                              fontSize: 40,
                              color: ColorsClass.textRed,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Text("Signup to\nget started",
                      style: AppStyles.popins(
                        style: TextStyle(
                            fontSize: 36,
                            color: ColorsClass.textWhite,
                            fontWeight: FontWeight.w600),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFieldClass(
                                textFieldController: firstNameController,
                                validator: (v) {
                                  if (v!.isEmpty) {
                                    return 'please enter first name';
                                  }
                                },
                                hintText: "First name",
                              ),
                            )),
                        Expanded(
                            child: TextFieldClass(
                              textFieldController: lastNameController,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'please enter last name';
                                }
                              },
                              hintText: "Last name",
                            ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: TextFieldClass(
                      textFieldController: emailController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'please enter email';
                        }
                      },
                      hintText: "Email",
                    ),
                  ),
                  TextFieldClass(
                    keyboardType: TextInputType.number,
                    textFieldController: phoneController,
                    hintText: "Phone",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: TextFieldClass(
                      textFieldController: passwordController,
                      validator: (v) {
                        if (v!.isEmpty) {
                          return 'please enter password';
                        }
                      },
                      hintText: "Password",
                    ),
                  ),
                  TextFieldClass(
                    textFieldController: confirmPasswordController,
                    validator: (v) {
                      if (v!.isEmpty ||
                          passwordController.text !=
                              confirmPasswordController.text) {
                        return 'password and confirm password should be same';
                      }
                    },
                    hintText: "Confirm passwrod",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: ButtonClass(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                              context: context,
                              builder: (context) => LoadingDialogue(content: "Signing In",));
                          await Future.delayed(const Duration(seconds: 3));
                          print("please fill form");
                          googleSignUp(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              emailAddress: emailController.text,
                              password: passwordController.text,
                              phone: phoneController.text,
                              context: context);
                        } else {
                          print("please fill form");
                        }
                      },
                      buttonName: "SignIn",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
