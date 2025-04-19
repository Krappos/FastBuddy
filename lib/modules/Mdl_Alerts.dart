import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(''); 

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

@pragma('vm:entry-point')
Future<void> showFastingNotification() async {
  const AndroidNotificationDetails androidDetails =AndroidNotificationDetails(
  'test_channel_id', 
  'Test Channel', 
  channelDescription: 'Testovacie notifikácie pre aplikáciu',
  importance: Importance.max, 
  priority: Priority.max,
);

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    'Od teraz nežereš!',
    'Od teraz nežereš!',
    details,
  );
}

@pragma('vm:entry-point')
Future<void> showFastingNotification1() async {
  const AndroidNotificationDetails androidDetails =AndroidNotificationDetails(
  'test_channel_id1',
  'Test Channel1',   
  channelDescription: 'Testovacie notifikácie pre aplikáciu',
  importance: Importance.max,
  priority: Priority.max,  
);

  const NotificationDetails details = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    1,
    'Od teraz žereš!',
    'neBudeš hladný',
    details,
  );
}
