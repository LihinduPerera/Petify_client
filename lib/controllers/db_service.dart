// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:petify/models/cart_model.dart';
// import 'package:petify/models/products_model.dart';
// import 'package:petify/models/trackers_models.dart';
// import 'package:petify/models/user_pets_model.dart';

// class DbService {
//   User? user = FirebaseAuth.instance.currentUser;

//   // USER DATA
//   Future saveUserData({required String name, required String email}) async {
//     try {
//       Map<String, dynamic> data = {
//         "name": name,
//         "email": email,
//       };
//       await FirebaseFirestore.instance
//           .collection("shop_users")
//           .doc(user!.uid)
//           .set(data);
//     } catch (e) {}
//   }

//   Future updateUserData({required Map<String, dynamic> extraData}) async {
//     await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .update(extraData);
//   }

//   Stream<DocumentSnapshot> readUserData() {
//     return FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .snapshots();
//   }

//   Stream<QuerySnapshot> readPromos() {
//     return FirebaseFirestore.instance.collection("shop_promos").snapshots();
//   }

// Stream<QuerySnapshot> readBanners() {
//   return FirebaseFirestore.instance.collection("shop_banners").snapshots();
// }

//   // DISCOUNTS
//   Stream<QuerySnapshot> readDiscounts() {
//     return FirebaseFirestore.instance
//         .collection("shop_coupons")
//         .orderBy("discount", descending: true)
//         .snapshots();
//   }

//   Future<QuerySnapshot> verifyDiscount({required String code}) {
//     return FirebaseFirestore.instance
//         .collection("shop_coupons")
//         .where("code", isEqualTo: code)
//         .get();
//   }

//   // CATEGORIES
//   Stream<QuerySnapshot> readCategories() {
//     return FirebaseFirestore.instance
//         .collection("shop_categories")
//         .orderBy("priority", descending: true)
//         .snapshots();
//   }

//   // PRODUCTS
// Stream<QuerySnapshot> readProducts(String category) {
//   return FirebaseFirestore.instance
//       .collection("shop_products")
//       .where("category", isEqualTo: category.toLowerCase())
//       .snapshots();
// }

// Stream<QuerySnapshot> searchProducts(List<String> docIds) {
//   return FirebaseFirestore.instance
//       .collection("shop_products")
//       .where(FieldPath.documentId, whereIn: docIds)
//       .snapshots();
// }

// Future<List<ProductsModel>> searchProductsByName(String query) async {
//   if (query.isEmpty) {
//     return [];
//   }

//   var productsSnapshot = await FirebaseFirestore.instance
//       .collection('shop_products')
//       .where('name', isGreaterThanOrEqualTo: query)
//       .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//       .get();

//   return ProductsModel.fromJsonList(productsSnapshot.docs);
// }

// Future reduceQuantity(
//     {required String productId, required int quantity}) async {
//   await FirebaseFirestore.instance
//       .collection("shop_products")
//       .doc(productId)
//       .update({"quantity": FieldValue.increment(-quantity)});
// }

// // CART
// Stream<QuerySnapshot> readUserCart() {
//   return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("cart")
//       .snapshots();
// }

// Future addToCart({required CartModel cartData}) async {
//   try {
//     // update
//     await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("cart")
//         .doc(cartData.productId)
//         .update({
//       "product_id": cartData.productId,
//       "quantity": FieldValue.increment(1)
//     });
//   } on FirebaseException catch (e) {
//     if (e.code == "not-found") {
//       // insert
//       await FirebaseFirestore.instance
//           .collection("shop_users")
//           .doc(user!.uid)
//           .collection("cart")
//           .doc(cartData.productId)
//           .set({"product_id": cartData.productId, "quantity": 1});
//     }
//   }
// }

// Future deleteItemFromCart({required String productId}) async {
//   await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("cart")
//       .doc(productId)
//       .delete();
// }

// Future emptyCart() async {
//   await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("cart")
//       .get()
//       .then((value) {
//     for (DocumentSnapshot ds in value.docs) {
//       ds.reference.delete();
//     }
//   });
// }

// Future decreaseCount({required String productId}) async {
//   await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("cart")
//       .doc(productId)
//       .update({"quantity": FieldValue.increment(-1)});
// }

//   // ORDERS
//   Future createOrder({required Map<String, dynamic> data}) async {
//     await FirebaseFirestore.instance.collection("shop_orders").add(data);
//   }

//   Future updateOrderStatus(
//       {required String docId, required Map<String, dynamic> data}) async {
//     await FirebaseFirestore.instance
//         .collection("shop_orders")
//         .doc(docId)
//         .update(data);
//   }

//   Stream<QuerySnapshot> readOrders() {
//     return FirebaseFirestore.instance
//         .collection("shop_orders")
//         .where("user_id", isEqualTo: user!.uid)
//         .orderBy("created_at", descending: true)
//         .snapshots();
//   }

// //UserPets
// Future addPet(UserPetsModel pet) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("pets")
//         .doc(pet.petId)
//         .set({
//       "pet_id": pet.petId,
//       "pet_type": pet.petType,
//       "pet_name": pet.petName,
//       "pet_weight": pet.petWeight,
//       "pet_age": pet.petAge,
//     });
//   } catch (e) {
//     print("Error adding pet: $e");
//   }
// }

// Stream<List<UserPetsModel>> getUserPets() {
//   return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("pets")
//       .snapshots()
//       .map((querySnapshot) => querySnapshot.docs
//           .map((doc) =>
//               UserPetsModel.fromJson(doc.data() as Map<String, dynamic>))
//           .toList());
// }

// Future updatePet(UserPetsModel pet) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("pets")
//         .doc(pet.petId)
//         .update({
//       "pet_name": pet.petName,
//       "pet_weight": pet.petWeight,
//       "pet_type": pet.petType,
//       "pet_age": pet.petAge
//     });
//   } catch (e) {
//     print("Error updating pet: $e");
//   }
// }

// Future deletePet(String petId) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("pets")
//         .doc(petId)
//         .delete();
//   } catch (e) {
//     print("Error deleting pet: $e");
//   }
// }

//   // Trackers - medications
//   Future addMedications (MedicationsLogModel medication ,) async {
//     try {
//       await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("trackers")
//         .doc("medication_trackers")
//         .collection("medications")
//         .doc(medication.medicationId)
//         .set({
//           "medication_id": medication.medicationId,
//           "medication_log": medication.medicationLog,
//           "medication_date": medication.medicationDate
//         });
//     } catch (e) {
//       print ("Error while adding medications : $e");
//     }
//   }

//   Stream<List<MedicationsLogModel>> getMedications() {
//     return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("medication_trackers")
//       .collection("medications")
//       .snapshots()
//       .map((querySnapShot) => querySnapShot.docs
//         .map((doc) => MedicationsLogModel.fromJson(doc.data() as Map<String,dynamic>))
//         .toList());
//   }

//   Future deleteMedication (String medicationId) async{
//     try {
//       await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("trackers")
//         .doc("medication_trackers")
//         .collection("medications")
//         .doc(medicationId)
//         .delete();
//     } catch (e) {
//       print ("Error deleting the medications : $e");
//     }
//   }

//   // Trackers - vetVisits
//   Future addVetVisits (VetVisitLogModel vetVisit) async {
//     try {
//       await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("trackers")
//         .doc("vetvisit_trackers")
//         .collection("vetvisits")
//         .doc(vetVisit.vetVisitId)
//         .set({
//           "vetvisit_id": vetVisit.vetVisitId,
//           "vetvisit_log": vetVisit.vetVisitLog,
//           "vetvisit_date":vetVisit.vetVisitDate
//         });
//     } catch (e) {
//       print ("Err adding vetVisits : $e");
//     }
//   }

//   Stream<List<VetVisitLogModel>> getVetVisits (){
//     return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("vetvisit_trackers")
//       .collection("vetvisits")
//       .snapshots()
//       .map((querySnapShot) => querySnapShot.docs
//       .map((doc) =>  VetVisitLogModel.fromJson(doc.data() as Map<String,dynamic>))
//       .toList());
//   }

//   Future deleteVetVisit (String vetVisitId) async {
//     try {
//       await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("trackers")
//         .doc("vetvisit_trackers")
//         .collection("vetvisits")
//         .doc(vetVisitId)
//         .delete();
//     } catch (e) {
//       print ("err while deleting vetVisit : $e");
//     }
//   }

//   //trackers -Activity
//   Future addActivity (ActivityLogModel activity) async {
//     try {
//       await FirebaseFirestore.instance
//         .collection("shop_users")
//         .doc(user!.uid)
//         .collection("trackers")
//         .doc("activity_trackers")
//         .collection("activities")
//         .doc(activity.activityId)
//         .set({
//           "activity_id": activity.activityId,
//           "activity_log": activity.activityLog,
//           "activity_date": activity.activityDate,
//         });
//     } catch (e) {
//       print("Err while adding Activity : $e");
//     }
//   }

//   Stream <List<ActivityLogModel>> getActivities () {
//     return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("activity_trackers")
//       .collection("activities")
//       .snapshots()
//       .map((querySnapShot) => querySnapShot.docs
//       .map((doc) => ActivityLogModel.fromJson(doc.data() as Map<String,dynamic>))
//       .toList());
//   }

//   Future deleteActivity (String activityId) async {
//     try {
//       await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("activity_trackers")
//       .collection("activities")
//       .doc(activityId)
//       .delete();
//     } catch (e) {
//       print ("Err while deleting : $e");
//     }
//   }

//   //trackers - meael
//   Future addMeal (MealLogModel meal) async{
//     try {
//       await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("meal_trackers")
//       .collection("meals")
//       .doc(meal.mealId)
//       .set({
//         "meal_id":meal.mealId,
//         "meal_log":meal.mealLog,
//         "meal_time":meal.mealTime
//       });
//     } catch (e) {
//       print ("err while adding meal : $e");
//     }
//   }

//   Stream <List<MealLogModel>> getMeals () {
//     return FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("meal_trackers")
//       .collection("meals")
//       .snapshots()
//       .map((querySnapShot) => querySnapShot.docs
//       .map((doc) => MealLogModel.fromJson(doc.data() as Map <String,dynamic>))
//       .toList());
//   }

//   Future deleteMeal (String mealId) async {
//     try {
//       await FirebaseFirestore.instance
//       .collection("shop_users")
//       .doc(user!.uid)
//       .collection("trackers")
//       .doc("meal_trackers")
//       .collection("meals")
//       .doc(mealId)
//       .delete();
//     }catch (e) {
//       print("err while deleting meal : $e");
//     }
//   }
// }

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:petify/controllers/baseUrl.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/models/categories_model.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/models/products_model.dart';
import 'package:petify/models/promo_banners_model.dart';
import 'package:petify/models/user_pets_model.dart';

class DBService {
  final Dio _dio = Dio();
  final String baseUrl = API_URL;

  // Promo and Banners
  Stream<List<PromoBannersModel>> readPromos() async* {
    try {
      final response = await _dio.get('$baseUrl/promos/');

      List<Map<String, dynamic>> promosJson = List<Map<String, dynamic>>.from(
        response.data,
      );
      List<PromoBannersModel> promos = PromoBannersModel.fromJsonList(
        promosJson,
      );

      yield promos;
    } catch (e) {
      throw Exception('Failed to fetch promos: $e');
    }
  }

  Stream<List<PromoBannersModel>> readBanners() async* {
    try {
      final response = await _dio.get('$baseUrl/banners/');

      List<Map<String, dynamic>> bannersJson = List<Map<String, dynamic>>.from(
        response.data,
      );
      List<PromoBannersModel> banners = PromoBannersModel.fromJsonList(
        bannersJson,
      );

      yield banners;
    } catch (e) {
      throw Exception('Failed to fetch banners: $e');
    }
  }

  // Category
  Stream<List<CategoriesModel>> readCategories() async* {
    try {
      final response = await _dio.get('$baseUrl/categories/');
      List<Map<String, dynamic>> categoriesJson =
          List<Map<String, dynamic>>.from(response.data);

      yield CategoriesModel.fromJsonList(categoriesJson, '');
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  //products

  //readproducts by using categories
  Stream<List<ProductsModel>> readProducts(String category) async* {
    try {
      final response = await _dio.get('$baseUrl/products/category/$category');
      yield ProductsModel.fromJsonList(response.data);
    } catch (e) {
      throw Exception('Failed to fetch products for category: $e');
    }
  }

  Stream<ProductsModel> getProductById(String productId) async* {
    try {
      final response = await _dio.get('$baseUrl/products/$productId');
      yield ProductsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Product not found: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _dio.delete('$baseUrl/products/$productId');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  Future<List<ProductsModel>> searchProductsByName(String query) async {
    try {
      final response = await _dio.get(
        '$baseUrl/products/search/',
        queryParameters: {'query': query},
      );

      return ProductsModel.fromJsonList(response.data);
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<void> reduceProductQuantity(String productId, int quantity) async {
    try {
      await _dio.put(
        '$baseUrl/products/$productId/reduce_quantity/',
        data: {'quantity': quantity},
      );
    } catch (e) {
      throw Exception('Failed to reduce quantity: $e');
    }
  }

  // Cart
  Stream<List<CartModel>> getUserCart(String userId) async* {
    try {
      final response = await _dio.get('$baseUrl/$userId/cart');
      yield CartModel.fromJsonList(response.data);
    } catch (e) {
      yield [];
      throw Exception('Failed to fetch cart: $e');
    }
  }

  Future<void> addToCart(String userId, CartModel cartData) async {
    try {
      await _dio.post('$baseUrl/$userId/cart', data: cartData.toJson());
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> deleteItemFromCart(String userId, String productId) async {
    try {
      await _dio.delete('$baseUrl/$userId/cart/$productId');
    } catch (e) {
      throw Exception('Failed to delete item from cart : $e');
    }
  }

  Future<void> emptyCart(String userId) async {
    try {
      await _dio.delete('$baseUrl/$userId/cart');
    } catch (e) {
      throw Exception('Failed to empty cart : $e');
    }
  }

  Future<void> decreaseCartQuantity(String userId, String productId) async {
    try {
      await _dio.patch('$baseUrl/$userId/cart/$productId/decrease');
    } catch (e) {
      throw Exception('Failed to decrease quantity: $e');
    }
  }

  //pets
  Stream<List<UserPetsModel>> getUserPets(String userId) async* {
    try {
      final response = await _dio.get('$baseUrl/$userId/pets');
      List<UserPetsModel> pets = UserPetsModel.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
      yield pets;
    } catch (e) {
      if (e is DioError && e.response?.statusCode == 404) {
        yield [];
      }
    }
  }

  Future<UserPetsModel> addPet(String userId, UserPetsModel pet) async {
    try {
      final response = await _dio.post(
        '$baseUrl/$userId/pets',
        data: {
          "owner": pet.owner,
          "name": pet.name,
          "species": pet.species,
          "breed": pet.breed,
          "age": pet.age,
          "gender": pet.gender,
          // "dob": pet.dob
        },
      );
      return UserPetsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add pet: $e');
    }
  }

  Future<UserPetsModel> updatePet(String petId, UserPetsModel pet) async {
    try {
      final response = await _dio.put(
        '$baseUrl/pets/$petId',
        data: {
          "owner": pet.owner,
          "name": pet.name,
          "species": pet.species,
          "breed": pet.breed,
          "age": pet.age,
          "gender": pet.gender,
        },
      );
      return UserPetsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update pet: $e');
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await _dio.delete('$baseUrl/pets/$petId');
    } catch (e) {
      throw Exception('Failed to delete pet: $e');
    }
  }

  //get Medicals
  Stream<List<MedicalModel>> getMedicals(String petId) async* {
    try {
      final response = await _dio.get('$baseUrl/$petId/medicals');
      List<MedicalModel> medicals = MedicalModel.fromJsonList(
        List<Map<String,dynamic>>.from(response.data)
      );
      yield medicals;
    } catch (e) {
      print("Failed to get medicals $e");
    }
  }
}
