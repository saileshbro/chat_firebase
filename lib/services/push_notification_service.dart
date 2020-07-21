import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final NavigationService _navigationService;
  final AndroidNotificationDetails _androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    Platform.isAndroid
        ? 'np.com.saileshdahal.chat_firebase'
        : 'np.com.saileshdahal.chat_firebase',
    'Fire Chat',
    'Chat application made with flutter and firebase.',
    playSound: true,
    icon: "app_icon",
    channelShowBadge: true,
    enableVibration: true,
    importance: Importance.Max,
    priority: Priority.High,
    color: Colors.blue,
  );
  final AndroidInitializationSettings _initializationSettingsAndroid =
      const AndroidInitializationSettings('app_icon');

  final IOSInitializationSettings _initializationSettingsIOS =
      const IOSInitializationSettings();

  InitializationSettings _initializationSettings;
  final IOSNotificationDetails _iOSPlatformChannelSpecifics =
      const IOSNotificationDetails(
    presentSound: true,
    presentAlert: true,
    presentBadge: true,
  );

  NotificationDetails _platformChannelSpecifics;
  PushNotificationService(this._navigationService) {
    _platformChannelSpecifics = NotificationDetails(
        _androidPlatformChannelSpecifics, _iOSPlatformChannelSpecifics);
    _initializationSettings = InitializationSettings(
        _initializationSettingsAndroid, _initializationSettingsIOS);
    FlutterLocalNotificationsPlugin().initialize(_initializationSettings);
  }

  Future<String> init() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(const IosNotificationSettings());
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _serialiseAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _serialiseAndNavigate(message);
      },
    );
    _fcm.subscribeToTopic("all");
    final String token = await _fcm.getToken();
    print(token);
    return token;
  }

  Future<void> _serialiseAndNavigate(Map<String, dynamic> message) async {}

  Future<void> showNotification(Map<String, dynamic> message) async {
    final mainMessage =
        Platform.isAndroid ? message['notification'] : message['aps']['alert'];
    final String title = mainMessage['title'].toString();
    final String body = mainMessage['body'].toString();

    try {
      await FlutterLocalNotificationsPlugin().show(
        0,
        title,
        body,
        _platformChannelSpecifics,
        payload: json.encode(message),
      );
    } catch (e) {
      print(e);
    }
  }
}
