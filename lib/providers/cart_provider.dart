import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/models/products_model.dart';
import 'package:petify/providers/user_provider.dart';

class CartProvider extends ChangeNotifier {
  final DBService dbService = DBService();
  final UserProvider userProvider;

  bool isLoading = true;
  List<CartModel> carts = [];
  List<String> cartUids = [];
  List<ProductsModel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;

  String get userId => userProvider.userId;

  CartProvider({required this.userProvider}) {
    readCartData();
    userProvider.addListener(_onUserIdChanged);
  }

  void _onUserIdChanged() {
    readCartData();
  }

  Future<void> addToCart(CartModel cartModel) async {
    try {
      await dbService.addToCart(userId, cartModel);
      readCartData();
    } catch (e) {
      print('Error adding item to cart: $e');
    }
  }

  Future<void> readCartData() async {
    isLoading = true;
    notifyListeners();
    try {
      carts = await dbService.getUserCart(userId);
      cartUids = carts.map((cart) => cart.productId).toList();

      if (carts.isNotEmpty) {
        await readCartProducts(cartUids);
      }

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching cart data: $e');
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> readCartProducts(List<String> uids) async {
    try {
      products = await dbService.getProducts();
      addCost(products, carts);
      calculateTotalQuantity();
    } catch (e) {
      print('Error fetching product details: $e');
    }
  }

  void addCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    for (int i = 0; i < carts.length; i++) {
      final product = products.firstWhere((prod) => prod.id == carts[i].productId);
      totalCost += carts[i].quantity * product.newPrice;
    }
    notifyListeners();
  }

  void calculateTotalQuantity() {
    totalQuantity = carts.fold(0, (sum, cart) => sum + cart.quantity);
    notifyListeners();
  }

  Future<void> deleteItem(String productId) async {
    try {
      await dbService.deleteItemFromCart(userId, productId);
      readCartData();
    } catch (e) {
      print('Error deleting item from cart: $e');
    }
  }

  Future<void> decreaseCount(String productId) async {
    try {
      await dbService.decreaseCartQuantity(userId, productId);
      readCartData();
    } catch (e) {
      print('Error decreasing cart quantity: $e');
    }
  }

  @override
  void dispose() {
    userProvider.removeListener(_onUserIdChanged);
    super.dispose();
  }
}
