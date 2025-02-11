import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  String name = "User";
  String email = "";
  String address = "";
  String phone = "";

  UserProvider() {
    loadUserData();
  }

  void loadUserData() {
    _userSubscription?.cancel();
    _userSubscription = DbService().readUserData().listen((snapshot) {
      final UserModel data =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      name = data.name;
      email = data.email;
      address = data.address;
      phone = data.phone;
      notifyListeners();
    });
  }

  void cancelProvider() {
    _userSubscription?.cancel();
  }

  @override
  void dispose() {
    cancelProvider();
    super.dispose();
  }
}
