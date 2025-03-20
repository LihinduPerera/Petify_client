import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/auth_service.dart';
import 'package:petify/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  String name = "Loading . . .";
  String email = "";
  String address = "";
  String phone = "";

  UserProvider() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) {
      print("No token found, user not logged in.");
      return;
    }

    try {
      Map<String, dynamic>? userData = await _authService.getCurrentUser();
      if (userData != null) {
        UserModel data = UserModel.fromJson(userData);

        name = data.name;
        email = data.email;
        address = data.address ?? '';
        phone = data.phone ?? '';

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
