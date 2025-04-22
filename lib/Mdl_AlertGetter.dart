import 'package:flutter/material.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'Android_alarm.dart';
 
 // Definovanie premenných
 TimeOfDay? FastingStart;
 TimeOfDay? FastingEnd;
 
 void MetGetStart(BuildContext context, TimeOfDay time) {
   FastingStart = time;
   debugPrint("FastingStart: ${time.format(context)}");
 }
 Future<void> MtdGetInput(BuildContext context, String selected) async {
   try {
     switch (selected) {
       case "20:4":
         FastingEnd = addHoursToTime(FastingStart, 4);
         break;
       case "18:6":
         FastingEnd = addHoursToTime(FastingStart, 6);
         break;
       case "16:8":
         FastingEnd = addHoursToTime(FastingStart, 8);
         break;
     }
 
     if (FastingStart != null && FastingEnd != null) {
       await Shared_Time(context, FastingStart!, FastingEnd!);
     }
     
   } catch (e) {
     debugPrint('Chyba pri spracovaní výberu pôstu: $e');
     rethrow;
   }
 }
 // Uloženie času do SharedPreferences
 Future<void> Shared_Time(BuildContext context, TimeOfDay zaciatok, TimeOfDay koniec) async {
   try {
     final SharedPreferences prefs = await SharedPreferences.getInstance();
 
     await Future.wait([
       prefs.setInt('fasting_start_hour', zaciatok.hour),
       prefs.setInt('fasting_start_minute', zaciatok.minute),
       prefs.setInt('fasting_end_hour', koniec.hour),
       prefs.setInt('fasting_end_minute', koniec.minute),
 
       prefs.setString('fasting_text', "${zaciatok.format(context)} - ${koniec.format(context)}"),
     ]);
 
     // Aktualizácia globálnych premenných
     FastingStart = zaciatok;
     FastingEnd = koniec;
      setupDailyNotification();
   } catch (e) {
     debugPrint('Chyba pri ukladaní času: $e');
     rethrow;
   }
 }
 
 // Získanie hodnoty zo start inputu
 
 
 // Získanie hodnoty z výberu (napr. 16:8, 18:6, 20:4)
 
 // Funkcia na výpočet 
 TimeOfDay addHoursToTime(TimeOfDay? startTime, int hoursToAdd) {
   if (startTime == null) return TimeOfDay(hour: 0, minute: 0);
 
   int newHour = (startTime.hour + hoursToAdd) % 24;
   int newMinute = startTime.minute;
 
   return TimeOfDay(hour: newHour, minute: newMinute);
 }
 
 // Nová funkcia pre získanie uloženého textu pôstu
 Future<String?> getFastingText() async {
   final prefs = await SharedPreferences.getInstance();
   return prefs.getString('fasting_text');
 }