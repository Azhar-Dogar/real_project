class PublicCategoryModel {
  int color;
  String id;
  String? name;

  PublicCategoryModel(
      {required this.color, required this.id,this.name});

  static PublicCategoryModel fromJson(Map<String, dynamic> Json) =>
      PublicCategoryModel(
          name: Json["name"], id: Json["id"], color: Json["color"]);
}
