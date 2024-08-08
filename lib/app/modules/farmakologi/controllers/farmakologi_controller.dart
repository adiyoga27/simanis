import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simanis/app/modules/farmakologi/views/edit_alarm.dart';
import 'package:simanis/app/modules/farmakologi/views/ring.dart';

class FarmakologiController extends GetxController {
    late List<AlarmSettings> alarms;

  static StreamSubscription<AlarmSettings>? subscription;

@override
  void onInit() {
    super.onInit();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
    }
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);

  }



 void loadAlarms() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await  Get.to(ExampleAlarmRingScreen(alarmSettings: alarmSettings,));
    
    
    // Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(
    //     builder: (context) =>
    //         ExampleAlarmRingScreen(alarmSettings: alarmSettings),
    //   ),
    // );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(AlarmSettings? settings) async {
    
  final res = await Get.bottomSheet<bool?>(
    FractionallySizedBox(
      heightFactor: 0.75,
      child: ExampleAlarmEditScreen(alarmSettings: settings),
    ),
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
