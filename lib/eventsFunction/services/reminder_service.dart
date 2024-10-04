/* import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/event_model.dart';

class ReminderService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> scheduleReminder(Event event) async {
    final DateTime eventDate = DateTime.parse(event.date);
    final DateTime dayBefore = eventDate.subtract(const Duration(days: 1));

    await _scheduleNotification(
      id: event.id.hashCode,
      title: 'Event Tomorrow: ${event.name}',
      body: 'Don\'t forget about ${event.name} tomorrow at ${event.time}!',
      scheduledDate: dayBefore,
    );

    await _scheduleNotification(
      id: event.id.hashCode + 1,
      title: 'Event Today: ${event.name}',
      body: '${event.name} is today at ${event.time}!',
      scheduledDate: eventDate,
    );
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'event_reminders',
          'Event Reminders',
          channelDescription: 'Notifications for mall events',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelReminder(String eventId) async {
    await _notifications.cancel(eventId.hashCode);
    await _notifications.cancel(eventId.hashCode + 1);
  }
}
 */