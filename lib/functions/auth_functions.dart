import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth_screens/signup_2.dart';
import '../screens/dashboard_screen.dart';
import '../models/signup_2_model.dart';
import '../models/signup_model.dart';
CollectionReference user = FirebaseFirestore.instance.collection("users");

googleSignUp({
  required String emailAddress,
  required String password,
  required BuildContext context,
  required String firstName,
  required String lastName,
  required String phone,
}) async {
  try {
    final credential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    String userId = FirebaseAuth.instance.currentUser!.uid;
    print(userId);
    await user.doc(userId).set(SignupModel(
        lastName: lastName,
        email: emailAddress,
        firstName: firstName,
        phoneNumber: phone)
        .addData());
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Signup2Screen()),
            (route) => false);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      showSnackBar("Please Enter Strong Password", context);
    } else if (e.code == 'email-already-in-use') {
      showSnackBar("Account already exist for that Email", context);
    }
  } catch (e) {
    print(e);
  }
}

showSnackBar(String title, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
}

googleSignUp2(
    {required String zipCode,
      required String city,
      required String streetAddress,
      String? referalCode}) async {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  await user.doc(userId).update(
      Signup2Model(city: city, streetAddress: streetAddress, zipCode: zipCode)
          .addData());
}

googleSignIn(
    {required String emailAddress,
      required String password,
      required BuildContext context}) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
            (route) => false);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      showSnackBar("No user found for that email", context);
    } else if (e.code == 'wrong-password') {
      showSnackBar("Please Enter Valid Password", context);
    }
  }
}
