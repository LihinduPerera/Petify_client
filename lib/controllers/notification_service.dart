import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  //on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  //show simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final notificationEnabled = prefs.getBool('notificationsEnabled') ?? true;

    if(!notificationEnabled) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  //show periodic notificarion fro regular intervals
  static Future showPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final notificationEnabled = prefs.getBool('notificationsEnabled') ?? true;

    if(!notificationEnabled) return;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 1', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        5, title, body, RepeatInterval.everyMinute, notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle);
  }

  //to shedule a local Notification
  static Future showScheduleNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime date,
  }) async {

    final prefs = await SharedPreferences.getInstance();
    final notificationEnabled = prefs.getBool('notificationsEnabled') ?? true;

    if(!notificationEnabled) return;

    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        2,
        title,
        body,
        tz.TZDateTime.from(date, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'channel 3', 'your channel name',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload);
  }

  //Cancel the notifications
  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
