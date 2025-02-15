import 'package:flutter/foundation.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/trackers_model.dart';

class TrackerProvider with ChangeNotifier{
  final DbService dbService = DbService();
  List<TrackersModel> trackers = [];

  Future<void> fetchTrackers (String petId) async {
    trackers = await dbService.getPetTrackers(petId);
    notifyListeners();
  }

  Future<void> addTrackerLog (String petId , String trackerType, String log , String petName) async {
    await dbService.addTrackerLog(petId, trackerType, log , petName);
    fetchTrackers(petId);
  }

  Future<void> removeTrackerLog (String petId ,String tracker_type , String log) async {
    await dbService.removeTrackerLog(petId, tracker_type, log);
    fetchTrackers(petId);
  }
}