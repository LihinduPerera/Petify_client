class MedicalModel {
  final String id;
  String pet;
  DateTime date;
  String medication;
  String notes;
  String status;
  bool? isNotified;
  bool? isNewMedical;

  MedicalModel(
      {required this.id,
      required this.pet,
      required this.date,
      required this.medication,
      required this.notes,
      required this.status,
      required this.isNotified,
      required this.isNewMedical});

  factory MedicalModel.fromJson(Map<String, dynamic> json) {
    return MedicalModel(
      id: json["_id"] ?? "",
      pet: json["pet"] ?? "",
      date: json["date"] != null ? DateTime.parse(json["date"]) : DateTime.now(),
      medication: json["medication"] ?? "",
      notes: json["notes"] ?? "",
      status: json["status"] ?? "",
      isNotified: json["isNotified"] ?? true,
      isNewMedical: json["isNewMedical"] ?? false,
    );
  }

  static List<MedicalModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => MedicalModel.fromJson(json)).toList();
  }
}
