import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/providers/user_pets_provider.dart';

class MedicalProvider extends ChangeNotifier {
  final DBService dbService = DBService();
  final UserPetsProvider userPetsProvider;

  Map<String, Stream<List<MedicalModel>>> _medicalsStreams = {};
  bool isLoading = false;

  MedicalProvider({required this.userPetsProvider}) {
    userPetsProvider.addListener(_onUserPetsChanged);
  }

  void _onUserPetsChanged() {
    _medicalsStreams.clear();
    for (var pet in userPetsProvider.userPets) {
      fetchMedicals(pet.petId);
    }
  }

  Stream<List<MedicalModel>> fetchMedicals(String petId) {
    if (!_medicalsStreams.containsKey(petId)) {
      _medicalsStreams[petId] = dbService.getMedicals(petId);
      notifyListeners();
    }
    return _medicalsStreams[petId]!;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
