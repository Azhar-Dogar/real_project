class SubCategoryModel {
  String categoryId;
  String subCatTitle;
  String subCatId;

  SubCategoryModel(
      {required this.categoryId,
        required this.subCatTitle,
        required this.subCatId});

  static SubCategoryModel fromJson(Map<String, dynamic> Json) =>
      SubCategoryModel(
          subCatTitle: Json["Sub title"],
          categoryId: Json["Category Id"],
          subCatId: Json["subCatId"]);
}
