import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/products_model.dart';

class ProductsProvider with ChangeNotifier {
  final DBService _dbService = DBService();
  List<ProductsModel> _products = [];

  List<ProductsModel> get products => _products;

  Future<void> searchProductsByName(String query) async {
    try {
      _products = await _dbService.searchProductsByName(query);
      notifyListeners();
    } catch (e) {
      print('Error searching products: $e');
    }
  }
}
