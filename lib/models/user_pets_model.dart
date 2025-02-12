import 'package:cloud_firestore/cloud_firestore.dart';

class UserPetsModel {
  final String petId;
  String petType;
  String petName;
  double petWeight;
  int petAge;
  UserPetsModel(
      {required this.petId,
      required this.petType,
      required this.petName,
      required this.petWeight,
      required this.petAge,
      });

  factory UserPetsModel.fromJson(Map<String, dynamic> json) {
    return UserPetsModel(
      petId: json["pet_id"] ?? "",
      petType: json["pet_type"] ?? "",
      petName: json["pet_name"] ?? "",
      petWeight: json["pet_weight"] ?? 0,
      petAge: json["pet_age"] ?? 1,
    );
  }

  static List<UserPetsModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map((e) => UserPetsModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();
  }
}
