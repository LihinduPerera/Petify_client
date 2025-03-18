import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String name = "Loading . . .";
  String email = "";
  String address = "";
  String phone = "";

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      return;
    }

    try {
      Map<String, dynamic>? userData = await _authService.getCurrentUser();
      if (userData != null) {
        UserModel data = UserModel.fromJson(userData);

        name = data.name;
        email = data.email;
        address = data.address;
        phone = data.phone;

        notifyListeners();
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  Future<String> updateUser(
    String newName,
    String newAddress,
    String newPhone,
  ) async {
    String? token = await _secureStorage.read(key: 'access_token');
    if (token == null) {
      return "No token found";
    }

    try {
      String result = await _authService.updateUser(
        newName,
        newAddress,
        newPhone,
      );
      if (result == "User updated successfully!") {
        name = newName;
        address = newAddress;
        phone = newPhone;
        notifyListeners();
        return result;
      } else {
        return "Error updating user: $result";
      }
    } catch (e) {
      return "Error updating user: $e";
    }
  }

  Future<void> cancelProvider() async {
    name = "Loading . . .";
    email = "";
    address = "";
    phone = "";

    await _secureStorage.delete(key: 'access_token');

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
