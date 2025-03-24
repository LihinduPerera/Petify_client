class UserPetsModel {
  final String petId;
  String owner;
  String name;
  String species;
  String breed;
  int age;
  String gender;

  UserPetsModel({
     required this.petId,
    required this.owner,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
  });

  factory UserPetsModel.fromJson(Map<String, dynamic> json) {
    return UserPetsModel(
      petId: json["_id"] ?? "",
      owner: json["owner"] ?? "",
      name: json["name"] ?? "",
      species: json["species"] ?? "",
      breed: json["breed"] ?? "",
      age: json["age"] ?? 0,
      gender: json["gender"] ?? "",
    );
  }

  static List<UserPetsModel> fromJsonList(List<Map<String, dynamic>> jsonList) {
    return jsonList.map((json) => UserPetsModel.fromJson(json)).toList();
  }
}