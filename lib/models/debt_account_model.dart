class DebtAccountModel {
  String debtName;
  int yourBalance;
  int interestRate;
  int minPayment;
  String debtId;
  DebtAccountModel({
    required this.debtId,
    required this.debtName,
    required this.interestRate,
    required this.yourBalance,
    required this.minPayment,
  });
  static DebtAccountModel fromJson(Map<String, dynamic> Json) =>
      DebtAccountModel(
          debtName: Json["debtName"],
          interestRate: Json["interestRate"],
          yourBalance: Json["debtAmount"],
          minPayment: Json["minPayment"],
          debtId: Json["debtId"]
      );
}
