//small library for showing day since date of creation

String daysSince() {
  DateTime targetDate = DateTime(2025, 3, 25);
  DateTime today = DateTime.now();
  Duration difference = today.difference(targetDate);
  return '${difference.inDays}';
}