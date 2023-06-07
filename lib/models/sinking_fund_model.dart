class SinkingModel {
  String title;
  int goalAmount;
  String duration;
  double monthlyDeposit;
  int startDate;
  int dueDate;
  String fundId;
  int paid;
  SinkingModel(
      {required this.title,
        required this.paid,
        required this.duration,
        required this.monthlyDeposit,
        required this.goalAmount,
        required this.startDate,
        required this.fundId,
        required this.dueDate});
  static SinkingModel fromJson(Map<String, dynamic> Json) => SinkingModel(
      title: Json["fundName"],
      duration: Json["duration"],
      monthlyDeposit: Json["monthlyDeposit"],
      goalAmount: Json["fundAmount"],
      startDate: Json["startDate"],
      dueDate: Json["dueDate"],
      fundId: Json['fundId'],
      paid: Json["paid"]);
}
