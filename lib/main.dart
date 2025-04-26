import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';
import 'modules/Mdl_workM.dart';
import 'Android_alarm.dart';
import 'HomeScreen.dart';

class ContextGlobal {
  static late BuildContext context;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher); // Iniciuje WorkManager
  await setPeriodicTask(); // Zavoláš svoju funkciu na nastavenie periodickej úlohy
  await requestNotificationPermission();
  await AndroidAlarmManager.initialize();
  await setupDailyNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        ContextGlobal.context = context;
        return child!;
      },
      home: const Homescreen(),
    );
  }
}
