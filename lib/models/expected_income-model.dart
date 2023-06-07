class ExpectedIncomeModel{
  int amount;
  int date;
  String incomeId;
  ExpectedIncomeModel({required this.amount,required this.date,required this.incomeId});
  static ExpectedIncomeModel fromJson(Map<String,dynamic>Json)=>ExpectedIncomeModel(
      amount: Json["Amount"],
      date: Json["date"],
      incomeId: Json["incomeId"]
  );
}