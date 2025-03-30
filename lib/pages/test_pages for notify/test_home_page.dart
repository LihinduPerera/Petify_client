import 'package:flutter/material.dart';
import 'package:petify/controllers/notification_service.dart';
import 'package:petify/pages/store_page.dart';

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  State<TestHomePage> createState() => _TestHomePageState();
}

class _TestHomePageState extends State<TestHomePage> {
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }

  //to listen to any notification clicked or not
  listenToNotifications() {
    print("Listning to notification");
    NotificationService.onClickNotification.stream.listen((event) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> StorePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Local Notifications"),
      ),
      body: Column(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.notification_add_rounded),
            label: Text("Simple Notification"),
            onPressed: (){
              NotificationService.showSimpleNotification(title: "Sample Notification", body: "This is a Simple Notification", payload: "This is simple data");
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.timer_outlined),
            label: Text("Prioridic Notifications"),
            onPressed: () {
              NotificationService.showPeriodicNotification(title: "Periodic Notification", body: "This is a Periodic notification", payload: "This is periodic data");
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.schedule),
            label: Text("Schedule Notifications"),
            onPressed: () {
              NotificationService.showScheduleNotification(title: "Shedule Notification", body: "This is a test notification", payload: "Notification data");
            },
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.clear_all),
            label: Text("Clear all the notifications"),
            onPressed: () {
              NotificationService.cancelAll();
            },
          ),
        ],
      ),
    );
  }
}