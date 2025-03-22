class PromoBannersModel {
  final String title;
  final String image;
  final String category;
  final String id;

  PromoBannersModel({
    required this.title,
    required this.id,
    required this.image,
    required this.category,
  });

  factory PromoBannersModel.fromJson(Map<String, dynamic> json) {
    return PromoBannersModel(
      title: json["title"] ?? "",
      image: json["image"] ?? "",
      category: json["category"] ?? "",
      id: json["id"] ?? "",
    );
  }

  static List<PromoBannersModel> fromJsonList(List<Map<String, dynamic>> list) {
    return list
        .map((json) => PromoBannersModel.fromJson(json))
        .toList();
  }
}
