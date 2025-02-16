// class TrackersModel {
//   String trackerId;
//   String trackerType;
//   List<String> logs;

//   TrackersModel({
//     required this.trackerId,
//     required this.trackerType,
//     required this.logs
//   });

//   //convert firestore data  to model
//   factory TrackersModel.fromJson(Map<String, dynamic> json) {
//     return TrackersModel(
//       trackerId: json['tracker_id'],
//        trackerType: json['tracker_type'],
//         logs: List<String>.from(json['logs'])
//       );
//   }

//   //convert tracker model to json to save in firestore
//   Map<String, dynamic> toJson() {
//     return {
//       'tracker_id': trackerId,
//       'tracker_type': trackerType,
//       'logs' : logs
//     };
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationsLogModel {
  String medicationId;
  String medicationLog;
  Timestamp medicationDate;

  MedicationsLogModel(
      {required this.medicationId,
      required this.medicationLog,
      required this.medicationDate});

  factory MedicationsLogModel.fromJson(Map<String, dynamic> json) {
    return MedicationsLogModel(
        medicationId: json["medication_id"] ?? "",
        medicationLog: json["medication_log"] ?? "",
        medicationDate: json["medication_date"] ?? "");
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
  Timestamp vetVisitDate;

  VetVisitLogModel(
      {required this.vetVisitId,
      required this.vetVisitLog,
      required this.vetVisitDate});

  factory VetVisitLogModel.fromJson(Map<String, dynamic> json) {
    return VetVisitLogModel(
        vetVisitId: json["vetvisit_id"] ?? "",
        vetVisitLog: json["vetvisit_log"] ?? "",
        vetVisitDate: json["vetvisit_date"] ?? "");
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
  Timestamp activityDate;
  Timestamp activityTime;

  ActivityLogModel(
      {required this.activityId,
      required this.activityLog,
      required this.activityDate,
      required this.activityTime});

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
        activityId: json["activity_id"] ?? "",
        activityLog: json["activity_log"] ?? "",
        activityDate: json["activity_date"] ?? "",
        activityTime: json["activity_time"] ?? "");
  }

  static List<ActivityLogModel> fromJsonList (List<QueryDocumentSnapshot>list) {
    return list
      .map((e) => ActivityLogModel.fromJson(e.data() as Map<String,dynamic>))
      .toList();
  }
}

class MealLogModel {
  String mealId;
  String mealLog;
  Timestamp mealTime;

  MealLogModel({
    required this.mealId,
    required this.mealLog,
    required this.mealTime
  });

  factory MealLogModel.fromJson(Map<String,dynamic>json) {
    return MealLogModel(
      mealId: json["meal_id"]?? "",
       mealLog: json["meal_log"]?? "",
        mealTime: json["meal_time"]?? ""
    );
  }

  static List<MealLogModel> fromJsonList(List<QueryDocumentSnapshot>list) {
    return list
      .map((e) => MealLogModel.fromJson(e.data() as Map<String,dynamic>))
      .toList();
  }
}
