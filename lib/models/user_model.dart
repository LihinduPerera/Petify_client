class UserModel {
  String name, email, address, phone, userId;

  UserModel({
    required this.name,
    required this.address,
    required this.email,
    required this.phone,
    required this.userId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"] ?? "User",
      address: json["address"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      userId: json["user_id"] ?? "",
    );
  }
}
