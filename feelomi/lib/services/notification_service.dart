import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initNotifications() async {
    if (_isInitialized) return;

    // Configuration Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuration iOS
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

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Demander les permissions
    await _requestPermissions();

    _isInitialized = true;
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      if (status.isDenied) {
        debugPrint('Permissions de notification refusées');
      }
    } else if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    debugPrint('Notification tappée avec payload: $payload');
    
    // Ici vous pouvez gérer la navigation vers différents écrans
    // selon le type de notification
  }

  // Notification immédiate
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
  }) async {
    if (!_isInitialized) await initNotifications();

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'feelomi_channel',
      'FEELOMI Notifications',
      channelDescription: 'Notifications pour l\'application FEELOMI',
      importance: _mapImportance(importance),
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  // Notification programmée
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationImportance importance = NotificationImportance.defaultImportance,
  }) async {
    if (!_isInitialized) await initNotifications();

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'feelomi_scheduled_channel',
      'FEELOMI Rappels',
      channelDescription: 'Rappels programmés pour FEELOMI',
      importance: _mapImportance(importance),
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.schedule(
      id,
      title,
      body,
      scheduledDate,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Notification de rappel quotidien
  Future<void> scheduleDailyReminderNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_isInitialized) await initNotifications();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'feelomi_daily_channel',
      'FEELOMI Rappels Quotidiens',
      channelDescription: 'Rappels quotidiens pour enregistrer vos émotions',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.daily,
      platformChannelSpecifics,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Rappel intelligent basé sur l'activité
  Future<void> scheduleReminder({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch % 100000;
    
    await scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: payload,
      importance: NotificationImportance.high,
    );
  }

  // Notifications de bien-être personnalisées
  Future<void> sendWellbeingNotification({
    required String emotionType,
    required int intensity,
  }) async {
    String title;
    String body;

    if (intensity > 7) {
      // Intensité élevée
      switch (emotionType.toLowerCase()) {
        case 'anxiety':
        case 'stressed':
          title = 'Moment de respiration';
          body = 'Prenez 5 minutes pour respirer profondément';
          break;
        case 'sadness':
          title = 'Prenez soin de vous';
          body = 'Vous méritez de la bienveillance aujourd\'hui';
          break;
        case 'anger':
          title = 'Pause apaisante';
          body = 'Accordez-vous un moment de calme';
          break;
        default:
          title = 'Moment de réflexion';
          body = 'Comment pouvez-vous vous sentir mieux ?';
      }
    } else {
      // Intensité normale
      title = 'Comment allez-vous ?';
      body = 'N\'oubliez pas d\'enregistrer vos émotions aujourd\'hui';
    }

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
      importance: NotificationImportance.high,
    );
  }

  // Notifications d'encouragement
  Future<void> sendEncouragementNotification() async {
    final encouragements = [
      'Vous faites du bon travail, continuez comme ça !',
      'Chaque jour est une nouvelle opportunité, vous êtes capable !',
      'Prenez un moment pour vous, vous le méritez !',
      'Rappelez-vous que vous êtes fort et résilient !',
      'Vous êtes une source d’inspiration, continuez à avancer !',
        ];

    final randomIndex = DateTime.now().millisecondsSinceEpoch % encouragements.length;
    final message = encouragements[randomIndex];

    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: 'Encouragement du jour',
      body: message,
      importance: NotificationImportance.high,
    );
  }
}