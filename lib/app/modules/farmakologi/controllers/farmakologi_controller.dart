import 'package:alarm/alarm.dart';
import 'package:get/get.dart';

class FarmakologiController extends GetxController {
  //TODO: Implement FarmakologiController
  DateTime? selectedTime;
  RxBool isLoading = false.obs;

  void setAlarm(DateTime dateTime) {
    isLoading.value = true;
    selectedTime = dateTime;
    AlarmSettings(
      id: 42,
      dateTime: dateTime,
      assetAudioPath: 'assets/alarm.mp3',
      loopAudio: true,
      vibrate: true,
      volume: 0.8,
      fadeDuration: 3.0,
      notificationTitle: 'This is the title',
      notificationBody: 'This is the body',
      // enableNotificationOnKill: Platform.isIOS,
    );
    isLoading.value = false;
  }
}
