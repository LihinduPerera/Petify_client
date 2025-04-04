import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/models/products_model.dart';

class CartProvider extends ChangeNotifier {
  final DBService dbService = DBService();

  StreamSubscription<List<CartModel>>? _cartSubscription;
  StreamSubscription<List<ProductsModel>>? _productSubscription;

  bool isLoading = true;

  List<CartModel> carts = [];
  List<String> cartUids = [];
  List<ProductsModel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;
  String userId = '';

  Future<void> readCartData(String newUid) async {
    userId = newUid;

    if (userId.isEmpty) return;

    isLoading = true;
    notifyListeners();

    _cartSubscription = dbService.getUserCart(userId).listen(
      (cartList) {
        carts = cartList;
        cartUids = carts.map((cart) => cart.productId).toList();

        if (carts.isNotEmpty) {
          readCartProducts(cartUids);
        } else {
          isLoading = false;
          notifyListeners();
        }
      },
      onError: (e) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        notifyListeners();
      },
    );
  }

  // Updated addToCart to work with Stream<void>
  Future<String> addToCart(CartModel cartModel) async {
    try {
      // Call the DBService addToCart method, which now returns a Stream<void>
      await for (var _ in dbService.addToCart(userId, cartModel)) {
        // Once the stream completes, read the updated cart data
        readCartData(userId);
      }
      return "Added to cart successfully";
    } catch (e) {
      return "Error adding to cart";
    }
  }

  void readCartProducts(List<String> uids) {
    if (uids.isEmpty) return;

    isLoading = true;
    notifyListeners();

    _productSubscription?.cancel();
    _productSubscription = dbService.getProductsByIds(uids).listen(
      (productsList) {
        products = productsList;
        addCost(products, carts);
        calculateTotalQuantity();
        isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        isLoading = false;
        notifyListeners();
      },
    );
  }

  void addCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < carts.length; i++) {
        if (i < products.length) {
          totalCost += carts[i].quantity * products[i].newPrice;
        }
      }
      notifyListeners();
    });
  }

  void calculateTotalQuantity() {
    totalQuantity = 0;
    for (int i = 0; i < carts.length; i++) {
      totalQuantity += carts[i].quantity;
    }
    notifyListeners();
  }

  Future<void> deleteItem(String productId) async {
    try {
      await dbService.deleteItemFromCart(userId, productId);
      readCartData(userId);
    } catch (e) {}
  }

  Future<void> decreaseCount(String productId) async {
    try {
      await dbService.decreaseCartQuantity(userId, productId);
      readCartData(userId);
    } catch (e) {}
  }

  Future<void> emptyCart() async {
    try {
      await dbService.emptyCart(userId);
      carts.clear();
      products.clear();
      totalCost = 0;
      totalQuantity = 0;
      isLoading = false;
      notifyListeners();
    } catch (e) {}
  }

  void cancelProvider() {
    _cartSubscription?.cancel();
    _productSubscription?.cancel();
    _cartSubscription = null;
    _productSubscription = null;
    carts = [];
    cartUids = [];
    products = [];
    totalCost = 0;
    totalQuantity = 0;
    userId = "";
    notifyListeners();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}

