import 'package:workmanager/workmanager.dart';
import 'Android_alarm.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await setupDailyNotification();
    return Future.value(true);
  });
}
