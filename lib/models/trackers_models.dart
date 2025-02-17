import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationsLogModel {
  String medicationId;
  String medicationLog;
  DateTime medicationDate;

  MedicationsLogModel(
      {required this.medicationId,
      required this.medicationLog,
      required this.medicationDate});

  factory MedicationsLogModel.fromJson(Map<String, dynamic> json) {
    return MedicationsLogModel(
      medicationId: json["medication_id"] ?? "",
      medicationLog: json["medication_log"] ?? "",
      medicationDate: (json["medication_date"] is Timestamp)
          ? (json["medication_date"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static List<MedicationsLogModel> fromJsonList(
      List<QueryDocumentSnapshot> list) {
    return list
        .map((e) =>
            MedicationsLogModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}

class VetVisitLogModel {
  String vetVisitId;
  String vetVisitLog;
  DateTime vetVisitDate;

  VetVisitLogModel(
      {required this.vetVisitId,
      required this.vetVisitLog,
      required this.vetVisitDate});

  factory VetVisitLogModel.fromJson(Map<String, dynamic> json) {
    return VetVisitLogModel(
      vetVisitId: json["vetvisit_id"] ?? "",
      vetVisitLog: json["vetvisit_log"] ?? "",
      vetVisitDate: (json["vetvisit_date"] is Timestamp)
          ? (json["vetvisit_date"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static List<VetVisitLogModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => VetVisitLogModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}

class ActivityLogModel {
  String activityId;
  String activityLog;
  DateTime activityDate;

  ActivityLogModel(
      {required this.activityId,
      required this.activityLog,
      required this.activityDate});

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      activityId: json["activity_id"] ?? "",
      activityLog: json["activity_log"] ?? "",
      activityDate: (json["activity_date"] is Timestamp)
          ? (json["activity_date"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static List<ActivityLogModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => ActivityLogModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}

class MealLogModel {
  String mealId;
  String mealLog;
  DateTime mealTime;

  MealLogModel({
    required this.mealId,
    required this.mealLog,
    required this.mealTime,
  });

  factory MealLogModel.fromJson(Map<String, dynamic> json) {
    return MealLogModel(
      mealId: json["meal_id"] ?? "",
      mealLog: json["meal_log"] ?? "",
      mealTime: (json["meal_time"] is Timestamp)
          ? (json["meal_time"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  static List<MealLogModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => MealLogModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
