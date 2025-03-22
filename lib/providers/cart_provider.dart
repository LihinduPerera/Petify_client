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

  Future<String> addToCart(CartModel cartModel) async {
    try {
      await dbService.addToCart(userId, cartModel);
      readCartData();
      return "Added to cart successfully";
    } catch (e) {
      return "Error adding to cart";
    }
  }

  void readCartData() {
    isLoading = true;
    notifyListeners();

    dbService
        .getUserCart(userId)
        .listen(
          (cartList) {
            carts = cartList;
            cartUids = carts.map((cart) => cart.productId).toList();

            if (carts.isNotEmpty) {
              readCartProducts(cartUids);
            }

            isLoading = false;
            notifyListeners();
          },
          onError: (e) {
            isLoading = false;
            notifyListeners();
          },
        );
  }

  void readCartProducts(List<String> uids) {
    products.clear();

    for (String productId in uids) {
      dbService
          .getProductById(productId)
          .listen(
            (product) {
              products.add(product);

              addCost(products, carts);
              calculateTotalQuantity();
            },
            onError: (e) {
              print('Error fetching product with ID $productId: $e');
            },
          );
    }
  }

  void addCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    for (int i = 0; i < carts.length; i++) {
      final product = products.firstWhere(
        (prod) => prod.id == carts[i].productId,
      );
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
      return;
    }
  }

  Future<void> decreaseCount(String productId) async {
    try {
      await dbService.decreaseCartQuantity(userId, productId);
      readCartData();
    } catch (e) {
      return;
    }
  }

  @override
  void dispose() {
    userProvider.removeListener(_onUserIdChanged);
    super.dispose();
  }
}
