import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Android_alarm.dart';

// Definovanie premenných
TimeOfDay? FastingStart;
TimeOfDay? FastingEnd;
int FastingType = 0;
TimeOfDay? Date;

void TrySharedTime(BuildContext context) {
  if (FastingStart != null && FastingType != 0) {
    FastingEnd = addHoursToTime(FastingStart, FastingType);
    Shared_Time(context, FastingStart!, FastingEnd!);
  }
}

Future <void> MdlGetType() async{
  try {
    final prefs = await SharedPreferences.getInstance();
    FastingType = prefs.getInt('fasting_type') ?? 0;
    
  } catch (e) {
    print("Chyba pri načítaní typu pôstu");
  }

}
void MetGetStart(BuildContext context, TimeOfDay time) {
  FastingStart = time;
  debugPrint("FastingStart: ${time.format(context)}");
TrySharedTime(context);
  if (FastingStart != null && FastingType != 0) {
    FastingEnd = addHoursToTime(FastingStart, FastingType);
    Shared_Time(context, FastingStart!, FastingEnd!);
  }
}

Future<void> MtdGetInput(BuildContext context, String selected) async {
  try {
    switch (selected) {
      case "20:4":
        FastingType=4;
        break;

      case "18:6":
        FastingType=6;
        break;

      case "16:8":
        FastingType=8;
        break;

    }
    TrySharedTime(context);
  if (FastingStart != null && FastingType != 0) {
      FastingEnd = addHoursToTime(FastingStart, FastingType);
      Shared_Time(context, FastingStart!, FastingEnd!);
    }

  } catch (e) {
    debugPrint('Chyba pri spracovaní výberu pôstu: $e');
    rethrow;
  }
}

Future<void> Shared_Time(BuildContext context, TimeOfDay zaciatok, TimeOfDay koniec) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final date_monts = DateTime.now();
    await Future.wait([
      prefs.setInt('fasting_start_hour', zaciatok.hour),
      prefs.setInt('fasting_start_minute', zaciatok.minute),
      prefs.setInt('fasting_end_hour', koniec.hour),
      prefs.setInt('fasting_end_minute', koniec.minute),
      prefs.setInt('fasting_type', FastingType),
      prefs.setInt('fasting_day', date_monts.day ),
      prefs.setInt('fasting_month', date_monts.month),
      prefs.setString('fasting_text', "${zaciatok.format(context)} - ${koniec.format(context)}"),
    ]);

    FastingStart = zaciatok;
    FastingEnd = koniec;
    
     setupDailyNotification();

  } catch (e) {
    debugPrint('Chyba pri ukladaní času: $e');
    rethrow;
  }
}

TimeOfDay addHoursToTime(TimeOfDay? startTime, int FastingType) {
  if (startTime == null) return TimeOfDay(hour: 0, minute: 0);

  int newHour = (startTime.hour + FastingType) % 24;
  int newMinute = startTime.minute;

  return TimeOfDay(hour: newHour, minute: newMinute);
}