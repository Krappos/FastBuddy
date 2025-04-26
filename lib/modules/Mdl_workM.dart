import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/material.dart';

TimeOfDay FastingStart = TimeOfDay.now();
TimeOfDay FastingEnd = TimeOfDay.now();
int day = 0;
int month = 0;

Future<void> deadWork() async {
  final prefs = await SharedPreferences.getInstance();
  await loadPrefs();

  DateTime now = DateTime.now();

  var startTime =
      DateTime(now.year, month, day, FastingStart.hour, FastingStart.minute);
  var endTime =
      DateTime(now.year, month, day, FastingEnd.hour, FastingEnd.minute);

  if (startTime.isBefore(now) || endTime.isBefore(now)) {
    DateTime tomorrow = DateTime(now.year, month, day).add(Duration(days: 1));
    await prefs.setInt('fasting_day', tomorrow.day);
    await prefs.setInt('fasting_month', tomorrow.month);
  }

  print("🕒 Starý čas: $startTime");
  print("📅 Retestovanie: $endTime");
}

Future<void> loadPrefs() async {
  final prefs = await SharedPreferences.getInstance();

//naciatanie premennych zo shared prefs
  final startHour = prefs.getInt('fasting_start_hour');
  final startMinute = prefs.getInt('fasting_start_minute');
  final endHour = prefs.getInt('fasting_end_hour');
  final endMinute = prefs.getInt('fasting_end_minute');
  final dayz = prefs.getInt('fasting_day');
  final monthz = prefs.getInt('fasting_month');

  if (startHour != null && startMinute != null) {
    FastingStart = TimeOfDay(hour: startHour, minute: startMinute);
  }

  if (endHour != null && endMinute != null) {
    FastingEnd = TimeOfDay(hour: endHour, minute: endMinute);
  }
//vypis z shared prefs do konzoly + deklarácia do systému
  if (dayz != null) {
    day = dayz;
  }
  if (monthz != null) {
    month = monthz;
  }
}

Future<void> callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    // Volanie funkcie, ktorá vykoná tvoj task
    await deadWork();
    return Future.value(true);
  });
}

Future<void> setPeriodicTask() async {
  await Workmanager().initialize(callbackDispatcher); // Iniciuje WorkManager

  // Zaregistruje periodickú úlohu
  await Workmanager().registerPeriodicTask(
    'id_unique_task',
    'simpleTask',
    frequency: const Duration(minutes: 15),
    inputData: <String, dynamic>{},
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresBatteryNotLow: true,
      requiresCharging: false,
    ),
  );
}
