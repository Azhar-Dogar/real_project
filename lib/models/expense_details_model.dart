class ExpenseDetailsModel{
  String? id;
  int totalPrice;
  int? color;
  String? expenseTitle;
  ExpenseDetailsModel({
    this.expenseTitle,
    this.id,
    required this.color,
    required this.totalPrice
  });
}