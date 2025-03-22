class CartModel {
  String userId;
  String productId;
  int quantity;

  CartModel({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json["user_id"] ?? "",
      productId: json["product_id"] ?? "",
      quantity: json["quantity"] ?? 0,
    );
  }

  //Convert Model to JSON for sending to the api
  Map<String, dynamic> toJson() {
    return {"user_id": userId, "product_id": productId, "quantity": quantity};
  }

  static List<CartModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => CartModel.fromJson(json)).toList();
  }
}
