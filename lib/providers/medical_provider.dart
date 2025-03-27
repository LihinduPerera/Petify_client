import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/models/user_pets_model.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:provider/provider.dart';

// class MedicalProvider extends ChangeNotifier {
//   final DBService dbService = DBService();
//   final UserPetsProvider userPetsProvider;

//   List<MedicalModel> _medicals = [];
//   StreamSubscription<List<MedicalModel>>? _medicalsSubscription;
//   bool isLoading = false;

//   MedicalProvider({required this.userPetsProvider}) {
//     userPetsProvider.addListener(_onUserPetsChanged);
//     if (userPetsProvider.userPets.isNotEmpty) {
//       initializeMedicals();
//     }
//   }

//   void _onUserPetsChanged() {
//     if (userPetsProvider.userPets.isNotEmpty) {
//       initializeMedicals();
//     } else {
//       _clearMedicals();
//     }
//   }

//   Future <void> initializeMedicals() async {
//     for (var pet in userPetsProvider.userPets) {
//       fetchMedicals(pet.petId);
//     }
//   }

//   void _clearMedicals() {
//     _medicals.clear();
//     if (_medicalsSubscription != null) {
//       _medicalsSubscription?.cancel();
//       _medicalsSubscription = null;
//     }
//     notifyListeners();
//   }

//   List<MedicalModel> get medicals => _medicals;

//   Future<void> fetchMedicals(String petId) async {
//     try {
//       isLoading = true;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         notifyListeners();
//       });

//       _medicalsSubscription = dbService.getMedicals(petId).asBroadcastStream().listen((medicals) {
//         _medicals.addAll(medicals);
//         isLoading = false;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           notifyListeners();
//         });
//       });
//     } catch (e) {
//       print("Error fetching medicals: $e");
//       isLoading = false;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         notifyListeners();
//       });
//     }
//   }

//   void cancelProvider() {
//     _medicalsSubscription?.cancel();
//     _medicalsSubscription = null;
//     _medicals = [];
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     userPetsProvider.removeListener(_onUserPetsChanged);
//     _medicalsSubscription?.cancel();
//     super.dispose();
//   }
// }

class MedicalProvider extends ChangeNotifier {
  final DBService dbService = DBService();

  List<MedicalModel> _medicals = [];
  StreamSubscription<List<MedicalModel>>? _medicalsSubscription;
  bool isLoading = false;

  Future<void> initializeMedicals(BuildContext context) async {
    final userPetsProvider = Provider.of<UserPetsProvider>(context, listen: false);
    final userPets = userPetsProvider.userPets;
    
    for (var pet in userPets) {
      fetchMedicals(pet.petId);
    }
  }

  void _clearMedicals() {
    _medicals.clear();
    if (_medicalsSubscription != null) {
      _medicalsSubscription?.cancel();
      _medicalsSubscription = null;
    }
    notifyListeners();
  }

  Future<void> fetchMedicals(String petId) async {
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _medicalsSubscription = dbService.getMedicals(petId).asBroadcastStream().listen((medicals) {
        _medicals.addAll(medicals);
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      });
    } catch (e) {
      print("Error fetching medicals: $e");
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  List<MedicalModel> get medicals => _medicals;

  void cancelProvider() {
    _medicalsSubscription?.cancel();
    _medicalsSubscription = null;
    _medicals = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _medicalsSubscription?.cancel();
    super.dispose();
  }
}