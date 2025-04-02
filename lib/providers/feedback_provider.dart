import 'dart:async';

import 'package:flutter/material.dart';
import 'package:petify/controllers/db_service.dart';
import 'package:petify/models/feedback_model.dart';

class FeedbackProvider extends ChangeNotifier{
  final DBService dbService = DBService();

  List<FeedbackModel> _feedbacks = [];
  StreamSubscription<List<FeedbackModel>>? _feedbacksSubscription;

  bool isLoading = true;
  String userId = "";

  List<FeedbackModel> get feedbacks => _feedbacks;

  Future<void> fetchFeedbacks(String newUid) async {
    userId = newUid;
    try {
      isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _feedbacksSubscription =
          dbService.getFeedbacks(userId).asBroadcastStream().listen((feedbacks) {
        _feedbacks = feedbacks;

        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          isLoading = false;
          notifyListeners();
        });
      });
    } catch (e) {
      print("Error fetching feedbacks: $e");
      isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> addFeedback(FeedbackModel feedback) async {
    try {
      feedback.user = userId;
      await dbService.addFeedback(userId, feedback);
      await fetchFeedbacks(userId);
    } catch (e) {
      print("Error adding feedback: $e");
    }
  }

  Future<void> deleteFeedback(String feedbackId) async {
    try {
      await dbService.deleteFeedback(feedbackId);
      await fetchFeedbacks(userId);
    } catch (e) {
      print("Error deleting feedback: $e");
    }
  }

  void removeFeedbackFromTheListForBetterLoadings(int index) {
    _feedbacks.removeAt(index);
    notifyListeners();
  }

  void cancelProvider() {
    _feedbacksSubscription?.cancel();
    _feedbacksSubscription = null;
    _feedbacks = [];
    userId = "";
    notifyListeners();
  }
}