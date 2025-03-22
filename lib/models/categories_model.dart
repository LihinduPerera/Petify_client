class CategoriesModel {
  String name, image, id;
  int priority;

  CategoriesModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.priority});

  factory CategoriesModel.fromJson(Map<String, dynamic> json, String id) {
    return CategoriesModel(
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      priority: json["priority"] ?? 0,
      id: json["id"] ?? "",
    );
  }

  static List<CategoriesModel> fromJsonList(List<Map<String, dynamic>> jsonList, String id) {
    return jsonList.map((json) => CategoriesModel.fromJson(json, id)).toList();
  }
}
