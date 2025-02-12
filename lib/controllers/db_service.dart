import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/models/products_model.dart';
import 'package:petify/models/user_pets_model.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;

  // USER DATA
  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "email": email,
      };
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .set(data);
    } catch (e) {}
  }

  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .update(extraData);
  }

  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection("shop_promos").snapshots();
  }

  Stream<QuerySnapshot> readBanners() {
    return FirebaseFirestore.instance.collection("shop_banners").snapshots();
  }

  // DISCOUNTS
  Stream<QuerySnapshot> readDiscounts() {
    return FirebaseFirestore.instance
        .collection("shop_coupons")
        .orderBy("discount", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> verifyDiscount({required String code}) {
    return FirebaseFirestore.instance
        .collection("shop_coupons")
        .where("code", isEqualTo: code)
        .get();
  }

  // CATEGORIES
  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  // PRODUCTS
  Stream<QuerySnapshot> readProducts(String category) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }

  Stream<QuerySnapshot> searchProducts(List<String> docIds) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  Future<List<ProductsModel>> searchProductsByName(String query) async {
    if (query.isEmpty) {
      return [];
    }

    var productsSnapshot = await FirebaseFirestore.instance
        .collection('shop_products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return ProductsModel.fromJsonList(productsSnapshot.docs);
  }

  Future reduceQuantity(
      {required String productId, required int quantity}) async {
    await FirebaseFirestore.instance
        .collection("shop_products")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-quantity)});
  }

  // CART
  Stream<QuerySnapshot> readUserCart() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
  }

  Future addToCart({required CartModel cartData}) async {
    try {
      // update
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("cart")
          .doc(cartData.productId)
          .update({
        "product_id": cartData.productId,
        "quantity": FieldValue.increment(1)
      });
    } on FirebaseException catch (e) {
      if (e.code == "not-found") {
        // insert
        await FirebaseFirestore.instance
            .collection("shop_users")
            .doc(user!.uid)
            .collection("cart")
            .doc(cartData.productId)
            .set({"product_id": cartData.productId, "quantity": 1});
      }
    }
  }

  Future deleteItemFromCart({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Future decreaseCount({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-1)});
  }

  // ORDERS
  Future createOrder({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_orders").add(data);
  }

  Future updateOrderStatus(
      {required String docId, required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance
        .collection("shop_orders")
        .doc(docId)
        .update(data);
  }

  Stream<QuerySnapshot> readOrders() {
    return FirebaseFirestore.instance
        .collection("shop_orders")
        .where("user_id", isEqualTo: user!.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }

  //UserPets
  Future addPet(UserPetsModel pet) async {
    try {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("pets")
          .doc(pet.petId)
          .set({
        "pet_id": pet.petId,
        "pet_type": pet.petType,
        "pet_name": pet.petName,
        "pet_weight": pet.petWeight,
        "pet_age": pet.petAge,
      });
    } catch (e) {
      print("Error adding pet: $e");
    }
  }

  Stream<List<UserPetsModel>> getUserPets() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("pets")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) =>
                UserPetsModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future updatePet(UserPetsModel pet) async {
    try {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("pets")
          .doc(pet.petId)
          .update({
        "pet_name": pet.petName,
        "pet_weight": pet.petWeight,
        "pet_type": pet.petType,
        "pet_age": pet.petAge
      });
    } catch (e) {
      print("Error updating pet: $e");
    }
  }

  Future deletePet(String petId) async {
    try {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("pets")
          .doc(petId)
          .delete();
    } catch (e) {
      print("Error deleting pet: $e");
    }
  }
}
