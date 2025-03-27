import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/user_pets_model.dart';
import 'package:petify/providers/user_provider.dart';

// class UserPetsProvider extends ChangeNotifier {
//   final DBService dbService = DBService();
//   final UserProvider userProvider;

//   List<UserPetsModel> _userPets = [];
//   StreamSubscription<List<UserPetsModel>>? _petsSubscription;
//   bool isLoading = false;

//   UserPetsProvider({required this.userProvider}) {
//     if (userId != "") {
//       fetchUserPets();
//     }
//     userProvider.addListener(_onUserIdChanged);
//   }

//   void _onUserIdChanged() {
//     if (userId != "") {
//       fetchUserPets();
//     }
//   }

//   List<UserPetsModel> get userPets => _userPets;

//   String get userId => userProvider.userId;

//   Future<void> fetchUserPets() async {
//     if (userId != "") {
//       try {
//         isLoading = true;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           notifyListeners();
//         });

//         String userId = this.userId;

//         _petsSubscription = dbService.getUserPets(userId).asBroadcastStream().listen((pets) {
//           _userPets = pets;
//           isLoading = false;
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             notifyListeners();
//           });
//         });
//       } catch (e) {
//         print("Error fetching pets: $e");
//         isLoading = false;
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           notifyListeners();
//         });
//       }
//     }
//   }

//   Future<void> addPet(UserPetsModel pet) async {
//     try {
//       String userId = this.userId;
//       pet.owner = userId;
//       await dbService.addPet(userId, pet);
//       await fetchUserPets();
//     } catch (e) {
//       print("Error adding pet: $e");
//     }
//   }

//   Future<void> updatePet(String petId, UserPetsModel pet) async {
//     try {
//       String userId = this.userId;
//       pet.owner = userId;
//       await dbService.updatePet(petId, pet);
//       await fetchUserPets();
//     } catch (e) {
//       print("Error updating pet: $e");
//     }
//   }

//   Future<void> deletePet(String petId) async {
//     try {
//       await dbService.deletePet(petId);
//       await fetchUserPets();
//     } catch (e) {
//       print("Error deleting pet: $e");
//     }
//   }

//   void cancelFetchingPets() {
//     _petsSubscription?.cancel();
//     _petsSubscription = null;
//   }

//   void cancelProvider() {
//     _petsSubscription?.cancel();
//     _petsSubscription = null;
//     _userPets = [];
//     notifyListeners();
//   }

//   void clearPets() {
//     _userPets = [];
//     notifyListeners();
//   }

//   @override
//   void dispose() {
//     cancelFetchingPets();
//     super.dispose();
//   }
// }

class UserPetsProvider extends ChangeNotifier {
  final DBService dbService = DBService();

  List<UserPetsModel> _userPets = [];
  StreamSubscription<List<UserPetsModel>>? _petsSubscription;

  bool isLoading = false;
  String userId = "";

  List<UserPetsModel> get userPets => _userPets;


  Future<void> fetchUserPets(String newUid) async {
    userId = newUid;
      try {
        isLoading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });

        String userId = this.userId;

        _petsSubscription = dbService.getUserPets(userId).asBroadcastStream().listen((pets) {
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
      String userId = this.userId;
      pet.owner = userId;
      await dbService.addPet(userId, pet);
      await fetchUserPets(userId);
    } catch (e) {
      print("Error adding pet: $e");
    }
  }

  Future<void> updatePet(String petId, UserPetsModel pet) async {
    try {
      String userId = this.userId;
      pet.owner = userId;
      await dbService.updatePet(petId, pet);
      await fetchUserPets(userId);
    } catch (e) {
      print("Error updating pet: $e");
    }
  }

  Future<void> deletePet(String petId) async {
    try {
      await dbService.deletePet(petId);
      await fetchUserPets(userId);
    } catch (e) {
      print("Error deleting pet: $e");
    }
  }

  void cancelFetchingPets() {
    _petsSubscription?.cancel();
    _petsSubscription = null;
  }

  void cancelProvider() {
    _petsSubscription?.cancel();
    _petsSubscription = null;
    _userPets = [];
    notifyListeners();
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
