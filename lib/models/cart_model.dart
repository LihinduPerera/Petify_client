// import 'package:cloud_firestore/cloud_firestore.dart';

// class CartModel {
//   final String productId;
//   int quantity;
//   CartModel({
//     required this.productId,
//     required this.quantity,
//   });

//   // convert json to object model
//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       productId: json["product_id"] ?? "",
//       quantity: json["quantity"] ?? 0,
//     );
//   }

//   // Convert List<QueryDocumentSnapshot> to List<CartModel>
//   static List<CartModel> fromJsonList(List<QueryDocumentSnapshot> list) {
//     return list
//         .map((e) => CartModel.fromJson(e.data() as Map<String, dynamic>))
//         .toList();
//   }
// }

class CartModel {
  String productId;
  int quantity;

  CartModel({
    required this.productId,
    required this.quantity
  });

  factory CartModel.fromJson(Map<String,dynamic>json) {
    return CartModel(
      productId: json["product_id"] ?? "",
      quantity: json["quantity"] ?? 0,
      );
  }
  
  //Convert Model to JSON for sending to the api
  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "quantity": quantity
    };
  }

  static List<CartModel> fromJsonList (List<dynamic> jsonList) {
    return jsonList.map((json) => CartModel.fromJson(json)).toList();
  }
}