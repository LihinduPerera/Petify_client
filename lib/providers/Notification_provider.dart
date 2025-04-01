import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider extends ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationEnabled => _notificationsEnabled;

  Future<void> toggleNotifications(bool value) async  {
    _notificationsEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> loadNotificationState() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    notifyListeners();
  }
}