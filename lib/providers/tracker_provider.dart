import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/trackers_models.dart';

class TrackerProvider with ChangeNotifier{
  final DbService _dbService = DbService();

  //Medication Provider
  List<MedicationsLogModel> _medications = [];
  StreamSubscription<List<MedicationsLogModel>>? _medicationSubscription;
  bool _medicationsAreLoading = false;

  List<MedicationsLogModel> get medications => _medications;
  bool get medicationsAreLoading => _medicationsAreLoading;

  Future<void> fetchMedications (String petId) async {
    try {
      _medicationsAreLoading = true;
      notifyListeners();
      
      await for (var snapshot in _dbService.getMedications(petId)){
        _medications = snapshot;
        _medicationsAreLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error while fetching the medications : $e");
      _medicationsAreLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMedication (MedicationsLogModel medication , String petId) async {
    try {
      await _dbService.addMedications(medication, petId);
      _medications.add(medication);
      notifyListeners();
    } catch (e) {
      print("Error adiing the medications : $e");
    }
  }

  Future<void> deleteMedication (String medicationId , String petId) async {
    try {
      await _dbService.deleteMedication(medicationId, petId);
      _medications.removeWhere((medication) => medication.medicationId == medicationId);
      notifyListeners();
    } catch (e) {
      print("Error deleting the medication : $e");
    }
  }

  //vetVisit Provider
  List<VetVisitLogModel> _vetVisits = [];
  StreamSubscription<List<VetVisitLogModel>>? _vetVisitSubscription;
  bool _vetVisitsAreLoading = false;

  List<VetVisitLogModel> get vetVisits => _vetVisits;
  bool get vetVisitsAreLoading => _vetVisitsAreLoading;

  Future <void> fetchVetVisits (String petId) async {
    try {
      _vetVisitsAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getVetVisits(petId)) {
        _vetVisits = snapshot;
        _vetVisitsAreLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error while fetching the vetVisits : $e");
      _vetVisitsAreLoading = false;
      notifyListeners();
    }
  }

  Future <void> addVetVisit (VetVisitLogModel vetVisit , String petId) async {
    try {
      await _dbService.addVetVisits(vetVisit, petId);
      _vetVisits.add(vetVisit);
      notifyListeners();
    } catch (e) {
      print("Err while adding Visits : $e");
    }
  }

  Future <void> deleteVetVisit (String vetVisitId ,String petId) async {
    try {
      await _dbService.deleteVetVisit(vetVisitId, petId);
      _vetVisits.removeWhere((vetVisit) => vetVisit.vetVisitId == vetVisitId);
      notifyListeners();
    } catch (e) {
      print("Err while deleting vet visits : $e");
    }
  }


  //Activity Provider
  List<ActivityLogModel> _activities = [];
  StreamSubscription<List<ActivityLogModel>>? _activitieSbscription;
  bool _activitiesAreLoading = false;

  List<ActivityLogModel> get activities => _activities;
  bool get activitiesAreLoading => _activitiesAreLoading;

  Future <void> fetchActivities (String petId) async {
    try {
      _activitiesAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getActivities(petId)){
        _activities = snapshot;
        _activitiesAreLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching activities : $e");
      _activitiesAreLoading = false;
      notifyListeners();
    }
  }
  Future <void> addActivity (ActivityLogModel activity , String petId) async {
    try {
      await _dbService.addActivity(activity, petId);
      _activities.add(activity);
      notifyListeners();
    } catch (e) {
      print("Err while addint the Activity : $e");
    }
  }
  Future<void> deleteActivitie (String activityId , String petId) async {
    try {
      await _dbService.deleteActivity(activityId, petId);
      _activities.removeWhere((activitie) => activitie.activityId == activityId);
      notifyListeners();
    } catch (e) {
      print("Err while deleting the activitie : $e");
    }
  }

  //Meal Provider
  List<MealLogModel> _meals = [];
  StreamSubscription<List<MealLogModel>>? _mealSubscription;
  bool _mealsAreLoading = false;

  List<MealLogModel> get meals => _meals;
  bool get mealsAreLoading => _mealsAreLoading;

  Future<void> fetchMeals (String petId) async {
    try {
      _mealsAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getMeals(petId)) {
        _meals = snapshot;
        _mealsAreLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("err while fetching meals : $e");
      _mealsAreLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMeal (MealLogModel meal , String petId) async {
    try {
      await _dbService.addMeal(meal, petId);
      _meals.add(meal);
      notifyListeners();
    } catch (e) {
      print("Err while adding meal : $e");
    }
  }

  Future<void> deleteMeal (String mealId , String petId) async {
    try {
      await _dbService.deleteMeal(mealId, petId);
      _meals.removeWhere((meal) => meal.mealId == mealId);
      notifyListeners();
    } catch (e) {
      print("err while delete meal : $e");
    }
  }
}