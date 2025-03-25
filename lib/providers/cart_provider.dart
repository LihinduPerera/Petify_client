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
    isLoading = true;
    notifyListeners();
    try {
      await dbService.addToCart(userId, cartModel);
      readCartData();
      isLoading = false;
      notifyListeners();
      return "Added to cart successfully";
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return "Error adding to cart";
    }
  }

  void readCartData() async {
    if (userId != "") {
      isLoading = true;
      notifyListeners();

      await dbService.getUserCart(userId).listen(
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
          notifyListeners();
        },
      );
    }
  }

  void readCartProducts(List<String> uids) async {
    isLoading = true;
    notifyListeners();
    
    products.clear();

    for (String productId in uids) {
      await dbService.getProductById(productId).listen(
        (product) {
          products.add(product);
          addCost(products, carts);
          calculateTotalQuantity();
        },
        onError: (e) {
          isLoading = false;
          notifyListeners();
          print('Error fetching product with ID $productId: $e');
        },
      );
    }

    isLoading = false;
    notifyListeners();
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
    isLoading = true;
    notifyListeners();
    try {
      await dbService.deleteItemFromCart(userId, productId);
      readCartData();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> decreaseCount(String productId) async {
    isLoading = true;
    notifyListeners();
    try {
      await dbService.decreaseCartQuantity(userId, productId);
      readCartData();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> emptyCart() async {
    isLoading = true;
    notifyListeners();
    try {
      await dbService.emptyCart(userId);
      carts.clear();
      products.clear();
      totalCost = 0;
      totalQuantity = 0;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      print("Error emptying the cart: $e");
    }
  }

  @override
  void dispose() {
    userProvider.removeListener(_onUserIdChanged);
    super.dispose();
  }
}
