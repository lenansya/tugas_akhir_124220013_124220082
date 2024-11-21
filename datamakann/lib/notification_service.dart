import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inisialisasi notifikasi
  static Future<void> initialize() async {
    // Inisialisasi plugin untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    // Inisialisasi data zona waktu
    tz.initializeTimeZones();
  }

  /// Tampilkan notifikasi segera
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel', // ID channel
      'Default Notifications', // Nama channel
      channelDescription: 'Channel notifikasi untuk keperluan umum',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      print('Error menampilkan notifikasi: $e');
    }
  }

  /// Jadwalkan notifikasi di masa depan
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'scheduled_channel', // ID channel
      'Scheduled Notifications', // Nama channel
      channelDescription: 'Notifikasi untuk pengingat yang dijadwalkan',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        // Menggunakan AndroidScheduleMode.exact atau AndroidScheduleMode.inexact
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print('Error menjadwalkan notifikasi: $e');
    }
  }
}
