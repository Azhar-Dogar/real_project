import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:real_project/screens/auth_screens/signup_screen.dart';

import '../../components/app_styles.dart';
import '../../components/button_class.dart';
import '../../components/color_class.dart';
import '../../components/loading_dialogue.dart';
import '../../components/text_field_class.dart';
import '../../functions/auth_functions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  Connectivity connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getConnectivity();
    subscription =
        connectivity.onConnectivityChanged.listen(updateConnectionState);
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  Future<void> getConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }
    if (mounted) {
      return Future.value(null);
    }
    return updateConnectionState(result);
  }

  Future<void> updateConnectionState(ConnectivityResult result) async {
    setState(() {
      connectivityResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(connectivityResult);
    print("object");
    return Scaffold(
      backgroundColor: Colors.black,
      body: (connectivityResult == ConnectivityResult.none)
          ? const Center(
              child: AlertDialog(
                title: Text("No Connection"),
                content: Text("Your phone has no internet connection"),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Image.asset(
                              "assets/images/splash_logo2.png",
                              width: 90,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Hello again!",
                                style: AppStyles.popins(
                                  style: TextStyle(
                                      fontSize: 38,
                                      color: ColorsClass.textRed,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                          Text(
                            "Welcome\nback",
                            style: AppStyles.popins(
                              style: TextStyle(
                                  fontSize: 34,
                                  color: ColorsClass.textWhite,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 13),
                            child: TextFieldClass(
                              textFieldController: emailController,
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return "Please enter email";
                                }
                              },
                              hintText: "Email",
                            ),
                          ),
                          TextFieldClass(
                            textFieldController: passwordController,
                            validator: (v) {
                              if (v!.isEmpty) {
                                return "Please enter password";
                              }
                            },
                            hintText: "Password",
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: ButtonClass(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => LoadingDialogue(
                                            content: "Signing In",
                                          ));
                                  await Future.delayed(
                                      const Duration(seconds: 3));
                                  googleSignIn(
                                      emailAddress: emailController.text,
                                      password: passwordController.text,
                                      context: context);
                                }
                              },
                              buttonName: "Sign In",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                  onPressed: () {},
                                  child: Text("Forgot Password?",
                                      style: AppStyles.popins(
                                        style: TextStyle(
                                            color: ColorsClass.textRed,
                                            fontSize: 16),
                                      ))),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const SignupScreen(),
                                        ));
                                  },
                                  child: Text("Signup",
                                      style: AppStyles.popins(
                                        style: TextStyle(
                                            color: ColorsClass.textButtonColor,
                                            fontSize: 16),
                                      )))
                            ],
                          )
                        ],
                      ),
                    )),
              ),
            ),
    );
  }
}
