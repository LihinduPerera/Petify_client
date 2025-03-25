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

  Stream<List<ProductsModel>> getProductsByIds(List<String> productIds) async* {
  try {
    final response = await _dio.get(
      '$baseUrl/products/by_ids',
      queryParameters: {
        'doc_ids': productIds,
      },
    );

    List<ProductsModel> products = (response.data as List)
        .map((item) => ProductsModel.fromJson(item))
        .toList();

    yield products;
  } catch (e) {
    throw Exception('Products not found: $e');
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
          List<Map<String, dynamic>>.from(response.data));
      yield medicals;
    } catch (e) {
      print("Failed to get medicals $e");
    }
  }
}
