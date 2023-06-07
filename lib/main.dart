import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_project/screens/splash_screen.dart';
import 'screens/auth_screens/signup_2.dart';
import 'components/color_class.dart';
import 'components/loading_dialogue.dart';
import 'screens/dashboard_screen.dart';
import 'functions/categories_data.dart';
import 'models/user_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => CategoriesData(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: true,
      builder: (context) => MaterialApp(

          useInheritedMediaQuery: true,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch:
            MaterialColor(ColorsClass.red1.value, ColorsClass.color),
          ),
          home:
          //EditProfile()
          (FirebaseAuth.instance.currentUser != null)
              ? ChangeNotifierProvider(
            create: (context) {
              CategoriesData();
            },
            child: Consumer<CategoriesData>(builder:
                (BuildContext context, value, Widget? child) {
              //value.getConnectivity(context);
              return (value.userModel != null)
                  ? (value.userModel?.city == null ||
                  value.userModel?.zipCode == null)
                  ? const Signup2Screen()
                  : const DashboardScreen()
                  : Container(
                  color: Colors.black,
                  child: LoadingDialogue(content: "Signing In"));
            }),
          )
              : const SplashScreen()),
    );
  }
}
