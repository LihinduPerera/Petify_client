import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/user_pets_model.dart';

class UserPetsProvider extends ChangeNotifier {
  final DbService dbService = DbService();
  List<UserPetsModel> _userPets = [];
  StreamSubscription<List<UserPetsModel>>? _petsSubscription;
  bool isLoading = false;

  List<UserPetsModel> get userPets => _userPets;

  Future<void> fetchUserPets() async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _petsSubscription = dbService.getUserPets().listen((pets) {
        _userPets = pets;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      });
    } catch (e) {
      print("Error fetching pets: $e");
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> addPet(UserPetsModel pet) async {
    try {
      await dbService.addPet(pet);
      await fetchUserPets();
    } catch (e) {
      print("Error adding pet: $e");
    }
  }

  Future<void> updatePet(UserPetsModel pet) async {
    try {
      await dbService.updatePet(pet);
      await fetchUserPets();
    } catch (e) {
      print("Error updating pet: $e");
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await dbService.deletePet(petId);
      await fetchUserPets();
    } catch (e) {
      print("Error deleting pet: $e");
    }
  }

  void cancelFetchingPets() {
    _petsSubscription?.cancel();
    _petsSubscription = null;
    print("Pet fetch operation has been canceled.");
  }

  void clearPets() {
    _userPets = [];
    notifyListeners();
  }

  @override
  void dispose() {
    cancelFetchingPets();
    super.dispose();
  }
}
