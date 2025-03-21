import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  final DBService _dbService = DBService();
  List<ProductsModel> _products = [];

  List<ProductsModel> get products => _products;

  Future<void> fetchProducts() async {
    try {
      _products = await _dbService.getProducts();
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _dbService.deleteProduct(productId);
      _products.removeWhere((product) => product.id == productId);
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<void> searchProductsByName(String query) async {
    try {
      _products = await _dbService.searchProductsByName(query);
      notifyListeners();
    } catch (e) {
      print('Error searching products: $e');
    }
  }

  Future<void> reduceProductQuantity(String productId, int quantity) async {
    try {
      await _dbService.reduceQuantity(productId, quantity);
      notifyListeners();
    } catch (e) {
      print('Error reducing product quantity: $e');
    }
  }
}
