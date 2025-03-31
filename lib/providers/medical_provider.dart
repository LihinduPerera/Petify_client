import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/controllers/notification_service.dart';
import 'package:petify/models/medical_model.dart';
import 'package:petify/providers/user_pets_provider.dart';
import 'package:provider/provider.dart';

class MedicalProvider extends ChangeNotifier {
  final DBService dbService = DBService();

  List<MedicalModel> _medicals = [];
  StreamSubscription<List<MedicalModel>>? _medicalsSubscription;
  bool isLoading = true;

  List<MedicalModel> get medicals => _medicals;

  Future<void> initializeMedicals(BuildContext context) async {
    final userPetsProvider = Provider.of<UserPetsProvider>(context, listen: false);
    final userPets = userPetsProvider.userPets;
    
    for (var pet in userPets) {
      fetchMedicals(pet.petId);
    }
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

        _medicals.forEach((medical) async{
          if (medical.isNewMedical == true) {
            NotificationService.showSimpleNotification(
              title: "New Medical Available",
              body: "Your pet have a new medical :${medical.medication}",
              payload: medical.id,
            );

            await updateNotificationFlags(medical.id, false, false);
          }

          if (medical.isNotified == false && medical.date.isAfter(DateTime.now())){
              DateTime scheduleDate = DateTime(medical.date.year, medical.date.month, medical.date.day, 8, 0);
              NotificationService.showScheduleNotification(
                title: "Medical Reminder",
                body: "Don't forget to complete the medical : ${medical.medication}",
                payload: medical.id,
                date: scheduleDate,
              );

              await updateNotificationFlags(medical.id, true, false);
          }
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

  Future<bool> updateNotificationFlags(String medicalId, bool? isNotified, bool? isNewMedical) async {
    try {
      Map<String, dynamic> notificationData = {};

      if (isNotified != null) {
        notificationData['isNotified'] = isNotified;
      }
      if (isNewMedical != null) {
        notificationData['isNewMedical'] = isNewMedical;
      }

      if (notificationData.isEmpty) {
        throw Exception("At least one flag ('isNotified' or 'isNewMedical') must be provided.");
      }

      final response = await dbService.updateNotificationFlags(medicalId, isNotified, isNewMedical);

      if (response) {
        return true;
      } else {
        print('Failed to update notification flags');
        return false;
      }
    } catch (e) {
      print('Error updating notification flags: $e');
      return false;
    }
  }

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
