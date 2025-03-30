class MedicalModel {
  final String id;
  String pet;
  DateTime date;
  String medication;
  String notes;
  String status;

  MedicalModel(
      {required this.id,
      required this.pet,
      required this.date,
      required this.medication,
      required this.notes,
      required this.status,});

  factory MedicalModel.fromJson(Map<String, dynamic> json) {
    return MedicalModel(
      id: json["_id"] ?? "",
      pet: json["pet"] ?? "",
      date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
      medication: json["medication"] ?? "",
      notes: json["notes"] ?? "",
      status: json["status"] ?? "",
    );
  }

  static List<MedicalModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => MedicalModel.fromJson(json)).toList();
  }
}
