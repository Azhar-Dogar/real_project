class CategoryModel {
  String title;
  String? id;

  CategoryModel({required this.title, this.id});

  static CategoryModel fromJson(Map<String, dynamic> Json) => CategoryModel(
    title: Json["Title"],
    id: Json["id"],
  );
}
