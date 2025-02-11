import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/cart_model.dart';
import 'package:petify/models/products_model.dart';

class CartProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot>? _cartSubscription;
  StreamSubscription<QuerySnapshot>? _productSubscription;

  bool isLoading = true;

  List<CartModel> carts = [];
  List<String> cartUids = [];
  List<ProductsModel> products = [];
  int totalCost = 0;
  int totalQuantity = 0;

  CartProvider() {
    readCartData();
  }

  void addToCart(CartModel cartModel) {
    DbService().addToCart(cartData: cartModel);
    notifyListeners();
  }

  void readCartData() {
    isLoading = true;
    _cartSubscription?.cancel();
    _cartSubscription = DbService().readUserCart().listen((snapshot) {
      List<CartModel> cartsData = CartModel.fromJsonList(snapshot.docs);

      carts = cartsData;

      cartUids = [];
      for (int i = 0; i < carts.length; i++) {
        cartUids.add(carts[i].productId);
      }
      if (carts.isNotEmpty) {
        readCartProducts(cartUids);
      }
      isLoading = false;
      notifyListeners();
    });
  }

  void readCartProducts(List<String> uids) {
    _productSubscription?.cancel();
    _productSubscription = DbService().searchProducts(uids).listen((snapshot) {
      List<ProductsModel> productsData =
          ProductsModel.fromJsonList(snapshot.docs);
      products = productsData;
      isLoading = false;
      addCost(products, carts);
      calculateTotalQuantity();
      notifyListeners();
    });
  }

  void addCost(List<ProductsModel> products, List<CartModel> carts) {
    totalCost = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < carts.length; i++) {
        totalCost += carts[i].quantity * products[i].new_price;
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

  void deleteItem(String productId) {
    DbService().deleteItemFromCart(productId: productId);
    readCartData();
    notifyListeners();
  }

  void decreaseCount(String productId) async {
    await DbService().decreaseCount(productId: productId);
    notifyListeners();
  }

  void cancelProvider() {
    _cartSubscription?.cancel();
    _productSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
