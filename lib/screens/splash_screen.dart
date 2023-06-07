import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'auth_screens/login_screen.dart';
import '../components/color_class.dart';

// # flutter_native_splash:
//   #   color: "#F5F5F5"
//   #   image: "assets/images/SplashScreen.png"
//   #   android: true
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  navigateToLoginScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            //  FirebaseAuth.instance.currentUser == null
            //       ? const LoginScreen()
            //       :
            builder: (context) => const LoginScreen(),
          ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    navigateToLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
            height: 260,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 22.0, bottom: 10),
                  child: Image.asset(
                    "assets/images/splash_logo2.png",
                    width: 160,
                  ),
                ),
                Text(
                  "Self Employed Budget\n & Expense Tracker",
                  style: TextStyle(color: ColorsClass.textWhite, fontSize: 24),
                )
              ],
            )),
      ),
    );
  }
}
