class TransactionModel {
  String? categoryId;
  String? categoryTitle;
  String? subCatId;
  String? subCatTitle;
  String? transactId;
  int? price;
  int? color;
  int? date;
  String? fundId;
  String? fundName;
  int? goalAmount;
  String? debtName;
  String? debtId;
  int? debtBalance;
  List<TransactionModel> doubleTransactions = [];
  TransactionModel(
      { this.categoryId,
        this.debtBalance,
        this.debtName,
        this.date,
        this.transactId,
        this.categoryTitle,
        this.subCatId,
        this.subCatTitle,
        this.color,
        this.price,
        this.fundId,
        this.fundName,
        this.debtId,
        this.goalAmount});

  static TransactionModel fromJson(Map<String, dynamic> Json) =>
      TransactionModel(
          categoryId: Json["categoryId"],
          categoryTitle: Json["categoryTitle"],
          subCatId: Json["subCatId"],
          subCatTitle: Json["subCatTitle"],
          price: Json["price"],
          transactId: Json["transactId"],
          color: Json["categoryColor"],
          date: Json["date"],
          fundId: Json["fundId"],
          fundName: Json["fundName"],
          goalAmount: Json["goalAmount"],
          debtBalance: Json["debtBalance"],
          debtName: Json["debtName"],
          debtId: Json["debtId"]);
  doubleTransac(TransactionModel model){
    doubleTransactions.add(model);
  }
}
