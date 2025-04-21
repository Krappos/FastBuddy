import 'package:flutter/material.dart';
import 'modules/Mdl_Alerts.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContextGlobal {
  static late BuildContext context;
}


TimeOfDay FastingStart = TimeOfDay.now();
TimeOfDay FastingEnd = TimeOfDay.now();


Future<void> setupDailyNotification() async {

  await _loadFastingTimes();

  final now = DateTime.now();

  var startTime = DateTime(now.year, now.month, now.day, FastingStart.hour, FastingStart.minute);
  var endTime = DateTime(now.year, now.month, now.day, FastingEnd.hour, FastingEnd.minute);

  // Zabezpečiť, že notifikácie sú v budúcnosti
  if (startTime.isBefore(now)) {
    startTime = startTime.add(const Duration(days: 1));
  }

  if (endTime.isBefore(now)) {
    endTime = endTime.add(const Duration(days: 1));
  }

  // Zrušenie existujúcich alarmov
  await AndroidAlarmManager.cancel(1);
  await AndroidAlarmManager.cancel(2);

  // Nastavenie alarmov na presný čas
  await AndroidAlarmManager.oneShotAt(
    startTime,
    1,
    showFastingNotification1,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );

  await AndroidAlarmManager.oneShotAt(
    endTime,
    2,
    showFastingNotification,
    exact: true,
    wakeup: true,
    rescheduleOnReboot: true,
  );

  debugPrint('🔔 Alarms set for: Start - ${startTime.toString()}, End - ${endTime.toString()}');
}

Future<void> updateFastingTimes(TimeOfDay newStart, TimeOfDay newEnd) async {
  final prefs = await SharedPreferences.getInstance();
  
  // Uloženie nových časov do SharedPreferences
  await prefs.setInt('fasting_start_hour', newStart.hour);
  await prefs.setInt('fasting_start_minute', newStart.minute);
  await prefs.setInt('fasting_end_hour', newEnd.hour);
  await prefs.setInt('fasting_end_minute', newEnd.minute);
  
  // Aktualizácia lokálnych premenných
  FastingStart = newStart;
  FastingEnd = newEnd;
  
  // Hneď po nastavení nových časov znovu nastavíme notifikácie
  await setupDailyNotification();

  debugPrint('🕒 Nové časy pôstu nastavené: Start - ${FastingStart.format(ContextGlobal.context)}, End - ${FastingEnd.format(ContextGlobal.context)}');
}

//len deklaruje začiatok a koniec casovania
Future<void> _loadFastingTimes() async {
  final prefs = await SharedPreferences.getInstance();

  final startHour = prefs.getInt('fasting_start_hour');
  final startMinute = prefs.getInt('fasting_start_minute');
  final endHour = prefs.getInt('fasting_end_hour');
  final endMinute = prefs.getInt('fasting_end_minute');

  if (startHour != null && startMinute != null) {
    FastingStart = TimeOfDay(hour: startHour, minute: startMinute);
  }

  if (endHour != null && endMinute != null) {
    FastingEnd = TimeOfDay(hour: endHour, minute: endMinute);
  }

  //print(FastingStart);
  //print(FastingEnd);
}