import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionProvider extends ChangeNotifier{
  bool _isConnectedToInternet = false;
  bool get isConnectedToInternet => _isConnectedToInternet;

  StreamSubscription? _internetStreamSubscription;

  InternetConnectionProvider() {
    _internetStreamSubscription = InternetConnection().onStatusChange.listen((event) {
      switch (event) {
        case InternetStatus.connected :
        _isConnectedToInternet = true;
        break;

        case InternetStatus.disconnected :
        _isConnectedToInternet = false;
        break;
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _internetStreamSubscription?.cancel();
    super.dispose();
  }
}