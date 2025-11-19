import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  }

  Future<void> initialize() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        developer.log('Notification tapped: ${response.payload}');
      },
    );

    // Request permissions
    await _requestPermissions();

    // Get FCM token and print it
    await _getFCMToken();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      developer.log('Message clicked from background: ${message.notification?.title}');
    });

    developer.log('Notification service initialized');
  }

  Future<void> _requestPermissions() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    developer.log('Notification permissions: ${settings.authorizationStatus}');
  }

  Future<void> _getFCMToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      developer.log('FCM Token: $token');
      print('📱 FCM Token: $token');
    } catch (e) {
      developer.log('Error getting FCM token: $e');
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    developer.log('Foreground message: ${message.notification?.title}');

    // Show local notification
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? 'You have a new message',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'messages_channel',
          'Messages',
          channelDescription: 'Notification channel for messages',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: message.data.toString(),
    );
  }
}
