class MileageModel{
  double distance;
  int startTime;
  int endTime;
  MileageModel({
    required this.startTime,
    required this.distance,
    required this.endTime
  });
  static MileageModel fromJson(Map<String,dynamic>Json)=>MileageModel(
      startTime: Json["startTime"],
      distance: Json["distance"],
      endTime: Json["endTime"]);
}