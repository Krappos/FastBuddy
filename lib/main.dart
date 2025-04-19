import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'Android_alarm.dart';
import 'HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';

class ContextGlobal {
  static late BuildContext context;
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//povolenie notifikácie na začiatku programu
Future<void> requestNotificationPermission() async {
  final status = await Permission.notification.status;

  if (status.isDenied || status.isRestricted || status.isPermanentlyDenied) {
    await Permission.notification.request();
  }
}
//nevymienať
Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await requestNotificationPermission();
  await AndroidAlarmManager.initialize();
  await setupDailyNotification();

  runApp(const MyApp());

}
//nevymieniať 
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
