class ProductsModel {
  String name;
  String description;
  String image;
  int oldPrice;
  int newPrice;
  String category;
  String id;
  int maxQuantity;

  ProductsModel({
    required this.name,
    required this.description,
    required this.image,
    required this.oldPrice,
    required this.newPrice,
    required this.category,
    required this.id,
    required this.maxQuantity,
  });

  // From JSON to Dart object
  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      name: json["name"] ?? "",
      description: json["description"] ?? "No description",
      image: json["image"] ?? "",
      oldPrice: json["old_price"] ?? 0,
      newPrice: json["new_price"] ?? 0,
      category: json["category"] ?? "",
      maxQuantity: json["quantity"] ?? 0,
      id: json["id"] ?? "",
    );
  }

  // Convert list of products from JSON
  static List<ProductsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProductsModel.fromJson(json)).toList();
  }
}
