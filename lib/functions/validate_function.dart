import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category_model.dart';

getCategories() async {
  List allCategories = [];
  FirebaseFirestore.instance
      .collection("categories")
      .snapshots()
      .listen((event) {
    for (var element in event.docs) {
      allCategories.add(CategoryModel.fromJson(element.data()));
      print(allCategories[0].title);
    }
  });
  return allCategories;
}
