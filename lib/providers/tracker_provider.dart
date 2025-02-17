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

  Future<void> fetchMedications () async {
    try {
      _medicationsAreLoading = true;
      notifyListeners();
      
      await for (var snapshot in _dbService.getMedications()){
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

  Future<void> addMedication (MedicationsLogModel medication) async {
    try {
      await _dbService.addMedications(medication,);
      // _medications.add(medication);
      notifyListeners();
    } catch (e) {
      print("Error adiing the medications : $e");
    }
  }

  Future<void> deleteMedication (String medicationId) async {
    try {
      await _dbService.deleteMedication(medicationId);
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

  Future <void> fetchVetVisits () async {
    try {
      _vetVisitsAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getVetVisits()) {
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

  Future <void> addVetVisit (VetVisitLogModel vetVisit) async {
    try {
      await _dbService.addVetVisits(vetVisit);
      // _vetVisits.add(vetVisit);
      notifyListeners();
    } catch (e) {
      print("Err while adding Visits : $e");
    }
  }

  Future <void> deleteVetVisit (String vetVisitId) async {
    try {
      await _dbService.deleteVetVisit(vetVisitId);
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

  Future <void> fetchActivities () async {
    try {
      _activitiesAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getActivities()){
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
  Future <void> addActivity (ActivityLogModel activity) async {
    try {
      await _dbService.addActivity(activity);
      // _activities.add(activity);
      notifyListeners();
    } catch (e) {
      print("Err while addint the Activity : $e");
    }
  }
  Future<void> deleteActivitie (String activityId) async {
    try {
      await _dbService.deleteActivity(activityId);
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

  Future<void> fetchMeals () async {
    try {
      _mealsAreLoading = true;
      notifyListeners();

      await for (var snapshot in _dbService.getMeals()) {
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

  Future<void> addMeal (MealLogModel meal) async {
    try {
      await _dbService.addMeal(meal);
      // _meals.add(meal);
      notifyListeners();
    } catch (e) {
      print("Err while adding meal : $e");
    }
  }

  Future<void> deleteMeal (String mealId) async {
    try {
      await _dbService.deleteMeal(mealId);
      _meals.removeWhere((meal) => meal.mealId == mealId);
      notifyListeners();
    } catch (e) {
      print("err while delete meal : $e");
    }
  }
  void dispose() {
    _medicationSubscription?.cancel();
    _vetVisitSubscription?.cancel();
    _activitieSbscription?.cancel();
    _mealSubscription?.cancel();
    super.dispose();
  }
}