class FeedbackModel {
  String id;
  String user;
  String feedback;
  DateTime time;

  FeedbackModel({
    required this.id,
    required this.user,
    required this.feedback,
    required this.time,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json["_id"] ?? "",
      user: json["user"] ?? "",
      feedback: json["feedback"] ?? "",
      time: DateTime.parse(json["time"] ?? DateTime.now().toString()),
    );
  }

  static List<FeedbackModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => FeedbackModel.fromJson(json)).toList();
  }
}