import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  int notificationID = 0;
  InitializationSettings initializationSettings =
      const InitializationSettings();

  final StreamController<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      StreamController<ReceivedNotification>.broadcast();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._() {
    init();
  }

  init() {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecific();
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          sound: true,
          badge: true,
          alert: false,
        );
  }

  initializePlatformSpecific() async {
    _configureLocalTimezone();

    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/todo');

    DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings(
            defaultPresentAlert: true,
            defaultPresentBadge: true,
            defaultPresentSound: false,
            onDidReceiveLocalNotification: (id, title, body, payload) {
              ReceivedNotification receivedNotification = ReceivedNotification(
                  id: id, title: title, body: body, payload: payload);
              didReceiveLocalNotificationSubject.add(receivedNotification);
            });

    initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    WidgetsFlutterBinding.ensureInitialized();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceiveLocalNotificationSubject.stream.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }


  Future<void> showScheduleNotification(
    {
    DateTimeComponents? dateTimeComponents,
      required int remind,
      required int year,
      required int month,
      required int day,
      required int hour,
      required int minutes,
    required String title,
    required String body,
  }) async {
    // DateTime scheduleNotificationDateTime =
    //     DateTime.now().add(Duration(seconds: minutes));

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      "com.example.local_notifications",
      "Local Notification",
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    DarwinNotificationDetails iOSNotificationDetails =
        const DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iOSNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationID++,
      title,
      body,
      _convertTime(year: year,month: month,day: day,hour: hour,minutes: minutes).subtract(Duration(minutes: remind)),
      notificationDetails,
      payload: 'Payload Test',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: dateTimeComponents,
    );
  }


  TZDateTime _convertTime({
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minutes,
  }) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(tz.local, year, month, day, hour, minutes);

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(getLocation(timeZone));
  }
}

NotificationService notificationService = NotificationService._();

class ReceivedNotification {
  final int? id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}
